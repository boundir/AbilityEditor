import { nestedStructName } from './emit'
import type { Indices, StructField } from './schema'
import { newNode, type Doc, type Node, type Value } from './state'

/**
 * Reads `+AbilityEdits` entries back out of an .ini.
 */

export interface ParseProblem {
  severity: 'error' | 'warning'
  line: number
  title: string
  detail: string
}

export interface ParseResult {
  doc: Doc | null
  problems: ParseProblem[]
  entryCount: number
}

// --------------------------------------------------------------------------- //
// Tokenising
// --------------------------------------------------------------------------- //

interface Raw {
  pairs: { key: string; value: RawValue; line: number }[]
}

type RawValue =
  | { kind: 'scalar'; text: string; quoted: boolean; line: number }
  | { kind: 'list'; items: RawValue[]; line: number }
  | { kind: 'block'; raw: Raw; line: number }

function flatten(source: string): { text: string; lineAt: number[] } {
  const out: string[] = []
  const lineAt: number[] = []
  const lines = source.split(/\r?\n/)

  lines.forEach((line, index) => {
    let text = line.replace(/\s*\\+\s*$/, ' ')

    let inQuote = false
    for (let i = 0; i < text.length; i += 1) {
      const ch = text[i]
      if (ch === '"') inQuote = !inQuote
      else if (ch === ';' && !inQuote) {
        text = text.slice(0, i)
        break
      }
    }

    for (const ch of text) {
      out.push(ch)
      lineAt.push(index + 1)
    }
    out.push(' ')
    lineAt.push(index + 1)
  })

  return { text: out.join(''), lineAt }
}

class Cursor {
  constructor(
    readonly text: string,
    readonly lineAt: number[],
    public pos = 0,
  ) {}

  get line(): number {
    return this.lineAt[Math.min(this.pos, this.lineAt.length - 1)] ?? 1
  }

  skipSpace(): void {
    while (this.pos < this.text.length && /\s/.test(this.text[this.pos] ?? '')) this.pos += 1
  }

  peek(): string {
    return this.text[this.pos] ?? ''
  }

  eat(ch: string): boolean {
    this.skipSpace()
    if (this.peek() === ch) {
      this.pos += 1
      return true
    }
    return false
  }
}

function readToken(cursor: Cursor): { text: string; quoted: boolean } {
  cursor.skipSpace()

  if (cursor.peek() === '"') {
    cursor.pos += 1
    let text = ''
    while (cursor.pos < cursor.text.length && cursor.peek() !== '"') {
      text += cursor.peek()
      cursor.pos += 1
    }
    cursor.pos += 1
    return { text, quoted: true }
  }

  let text = ''
  while (cursor.pos < cursor.text.length && !/[,()=]/.test(cursor.peek())) {
    text += cursor.peek()
    cursor.pos += 1
  }
  return { text: text.trim(), quoted: false }
}

function readParenValue(cursor: Cursor): RawValue {
  const line = cursor.line
  cursor.skipSpace()

  // Empty.
  if (cursor.eat(')')) return { kind: 'list', items: [], line }

  // An array of structs: the first thing inside is another paren.
  if (cursor.peek() === '(') {
    const items: RawValue[] = []
    do {
      cursor.skipSpace()
      if (cursor.peek() !== '(') break
      cursor.pos += 1
      items.push(readParenValue(cursor))
    } while (cursor.eat(','))
    cursor.eat(')')
    return { kind: 'list', items, line }
  }

  const save = cursor.pos
  const first = readToken(cursor)
  cursor.skipSpace()
  const isBlock = cursor.peek() === '='
  cursor.pos = save

  if (isBlock) {
    const raw = readPairs(cursor, ')')
    cursor.eat(')')
    return { kind: 'block', raw, line }
  }

  // A plain value list, e.g. (Blademaster, Bladestorm).
  const items: RawValue[] = []
  if (first.text !== '' || cursor.peek() !== ')') {
    do {
      const token = readToken(cursor)
      items.push({ kind: 'scalar', text: token.text, quoted: token.quoted, line: cursor.line })
    } while (cursor.eat(','))
  }
  cursor.eat(')')
  return { kind: 'list', items, line }
}

function readValue(cursor: Cursor): RawValue {
  cursor.skipSpace()
  if (cursor.eat('(')) return readParenValue(cursor)
  const line = cursor.line
  const token = readToken(cursor)
  return { kind: 'scalar', text: token.text, quoted: token.quoted, line }
}

function readPairs(cursor: Cursor, stop: string): Raw {
  const pairs: Raw['pairs'] = []

  for (;;) {
    cursor.skipSpace()
    if (cursor.pos >= cursor.text.length || cursor.peek() === stop) break

    const line = cursor.line
    const key = readToken(cursor)
    if (key.text === '') {
      cursor.pos += 1
      continue
    }
    if (!cursor.eat('=')) continue

    pairs.push({ key: key.text, value: readValue(cursor), line })
    if (!cursor.eat(',')) break
  }

  return { pairs }
}

// --------------------------------------------------------------------------- //
// Mapping onto the schema
// --------------------------------------------------------------------------- //

function scalarValue(raw: Extract<RawValue, { kind: 'scalar' }>, type: string): Value {
  const text = raw.text
  if (type === 'bool') return text.toLowerCase() === 'true'
  if (type === 'int') {
    const parsed = Number.parseInt(text, 10)
    return Number.isNaN(parsed) ? text : parsed
  }
  if (type === 'float') {
    const parsed = Number.parseFloat(text)
    return Number.isNaN(parsed) ? text : parsed
  }
  return text
}

function zeroFor(type: string): Value {
  if (type === 'bool') return false
  if (type === 'int' || type === 'float') return 0
  return ''
}

interface Ctx {
  indices: Indices
  problems: ParseProblem[]
}

function fieldsOf(ctx: Ctx, structName: string): Map<string, StructField> {
  const fields = ctx.indices.structByName.get(structName)?.fields ?? []
  return new Map(fields.map((f) => [f.name.toLowerCase(), f]))
}

function buildNode(ctx: Ctx, raw: Raw, structName: string, where: string): Node {
  const node = newNode()
  const byName = fieldsOf(ctx, structName)
  const seenGuards = new Map<string, { value: boolean; line: number }>()

  for (const pair of raw.pairs) {
    const field = byName.get(pair.key.toLowerCase())

    if (!field && /^set./i.test(pair.key)) {
      const target = byName.get(pair.key.slice(3).toLowerCase())
      if (target) {
        const on =
          pair.value.kind === 'scalar' && pair.value.text.toLowerCase() !== 'false'
        seenGuards.set(target.name, { value: on, line: pair.line })
        continue
      }
    }

    if (!field) {
      ctx.problems.push({
        severity: 'error',
        line: pair.line,
        title: `Unknown key ${pair.key}`,
        detail: `${where} has no field called ${pair.key}. The game's .ini parser drops unknown keys without logging anything, so this has been doing nothing. It is not carried into the output below.`,
      })
      continue
    }

    if (field.kind === 'guard') continue

    const childStruct = nestedStructName(field.type)
    const isArrayType = field.type.startsWith('array<')

    if (childStruct && isArrayType) {
      const items = pair.value.kind === 'list' ? pair.value.items : []
      node[field.name] = items
        .filter((item): item is Extract<RawValue, { kind: 'block' }> => item.kind === 'block')
        .map((item) => buildNode(ctx, item.raw, childStruct, childStruct))
      continue
    }

    if (childStruct) {
      if (pair.value.kind === 'block') {
        node[field.name] = buildNode(ctx, pair.value.raw, childStruct, childStruct)
      }
      continue
    }

    if (isArrayType) {
      const items = pair.value.kind === 'list' ? pair.value.items : [pair.value]
      node[field.name] = items
        .filter((item): item is Extract<RawValue, { kind: 'scalar' }> => item.kind === 'scalar')
        .map((item) => item.text)
        .filter((text) => text !== '')
      continue
    }

    if (pair.value.kind === 'scalar') {
      node[field.name] = scalarValue(pair.value, field.type)
    }
  }

  reconcileGuards(ctx, node, byName, seenGuards, where)
  return node
}

/**
 * Cross-checks `SetX` guards against the values beside them.
 */
function reconcileGuards(
  ctx: Ctx,
  node: Node,
  byName: Map<string, StructField>,
  guards: Map<string, { value: boolean; line: number }>,
  where: string,
): void {
  for (const field of byName.values()) {
    if (!field.guard) continue

    const guard = guards.get(field.name)
    const hasValue = node[field.name] !== undefined

    if (hasValue && !guard) {
      ctx.problems.push({
        severity: 'warning',
        line: 0,
        title: `${field.name} was being ignored`,
        detail: `${where} sets ${field.name} without ${field.guard}=true, so the mod skipped it. The output below adds the guard, which is almost certainly what was intended.`,
      })
      continue
    }

    if (guard && !guard.value && hasValue) {
      delete node[field.name]
      ctx.problems.push({
        severity: 'warning',
        line: guard.line,
        title: `${field.guard}=false, so ${field.name} is dropped`,
        detail: 'The guard is explicitly off, so the value beside it never applied.',
      })
      continue
    }

    if (guard?.value && !hasValue) {
      node[field.name] = zeroFor(field.type)
      ctx.problems.push({
        severity: 'warning',
        line: guard.line,
        title: `${field.guard}=true with no ${field.name}`,
        detail: `The guard is on but no value was given, so the mod applied the default for a ${field.type}. Set it explicitly if that was not intended.`,
      })
    }
  }
}

// --------------------------------------------------------------------------- //
// Entry point
// --------------------------------------------------------------------------- //

const ENTRY = /\+?\s*AbilityEdits\s*=/gi

export function parseConfig(source: string, indices: Indices): ParseResult {
  const ctx: Ctx = { indices, problems: [] }
  const { text, lineAt } = flatten(source)

  const entries: Node[] = []
  ENTRY.lastIndex = 0

  for (;;) {
    const match = ENTRY.exec(text)
    if (!match) break

    const line = lineAt[match.index] ?? 1

    if (!text.slice(match.index, match.index + match[0].length).trimStart().startsWith('+')) {
      ctx.problems.push({
        severity: 'error',
        line,
        title: 'AbilityEdits= without a leading +',
        detail:
          'Without the +, this replaces the entire list of edits rather than adding to it, discarding every entry from this and any other mod. Write +AbilityEdits=.',
      })
    }

    const cursor = new Cursor(text, lineAt, match.index + match[0].length)
    if (!cursor.eat('(')) continue

    const value = readParenValue(cursor)
    if (value.kind !== 'block') {
      ctx.problems.push({
        severity: 'error',
        line,
        title: 'Entry is empty or malformed',
        detail: 'Expected +AbilityEdits=( Ability=..., ... ).',
      })
      continue
    }

    entries.push(buildNode(ctx, value.raw, 'AbilityEdit', 'An +AbilityEdits entry'))
    ENTRY.lastIndex = cursor.pos
  }

  if (entries.length === 0) {
    ctx.problems.push({
      severity: 'error',
      line: 1,
      title: 'No +AbilityEdits entries found',
      detail:
        'Paste the entries themselves, with or without the [AbilityEditor.X2DLCInfo_AbilityEditor] header. The legacy 1.x +Abilities format is not read here.',
    })
    return { doc: null, problems: ctx.problems, entryCount: 0 }
  }

  return {
    doc: { schemaHash: indices.schema.sourceHash, entries },
    problems: ctx.problems,
    entryCount: entries.length,
  }
}
