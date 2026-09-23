import type { Indices, StructField } from './schema'
import { configKeys, type Doc, type Node, type Value } from './state'

/**
 * Renders a document as `+AbilityEdits` entries.
 */

const INDENT = '    '
const CONT = ' \\\\'
const ROOT_STRUCT = 'AbilityEdit'
const ROOT_KEY = 'AbilityEdits'
export const SECTION = '[AbilityEditor.X2DLCInfo_AbilityEditor]'

export function isBareName(value: string): boolean {
  return /^[A-Za-z_][A-Za-z0-9_]*$/.test(value)
}

export function hasUnrepresentableChars(value: string): boolean {
  return /["(),\r\n]/.test(value)
}

function formatScalar(value: Value, type: string): string {
  if (typeof value === 'boolean') {
    return value ? 'true' : 'false'
  }

  if (typeof value === 'number') {
    if (type === 'float') {
      return Number.isInteger(value) ? value.toFixed(1) : String(value)
    }
    return String(value)
  }

  const text = String(value)
  return type === 'string' ? `"${text}"` : text
}

function emittableFields(indices: Indices, structName: string): StructField[] {
  return indices.structByName.get(structName)?.fields.filter((f) => f.kind !== 'guard') ?? []
}

export function nestedStructName(type: string): string | null {
  const match = /^array<(\w+)>$/.exec(type)
  if (match?.[1]) return /Edit$/.test(match[1]) ? match[1] : null
  return /Edit$/.test(type) ? type : null
}

function emitGroups(node: Node, structName: string, indices: Indices, depth: number): string[][] {
  const pad = INDENT.repeat(depth)
  const groups: string[][] = []
  const present = new Set(configKeys(node))

  for (const field of emittableFields(indices, structName)) {
    if (!present.has(field.name)) continue
    const value = node[field.name]
    if (value === undefined) continue

    const childStruct = nestedStructName(field.type)
    const isArrayType = field.type.startsWith('array<')

    if (childStruct && isArrayType && Array.isArray(value)) {
      const children = value as Node[]
      if (children.length === 0) continue

      const lines: string[] = [`${pad}${field.name}=(`]
      children.forEach((child, index) => {
        const body = flatten(emitGroups(child, childStruct, indices, depth + 2))
        lines.push(`${pad}${INDENT}(`)
        lines.push(...body)
        lines.push(`${pad}${INDENT})${index < children.length - 1 ? ',' : ''}`)
      })
      lines.push(`${pad})`)
      groups.push(lines)
      continue
    }

    // A single nested struct.
    if (childStruct && !isArrayType && value && typeof value === 'object' && !Array.isArray(value)) {
      const body = flatten(emitGroups(value as Node, childStruct, indices, depth + 1))
      if (body.length === 0) continue
      groups.push([`${pad}${field.name}=(`, ...body, `${pad})`])
      continue
    }

    // A name or string array.
    if (Array.isArray(value)) {
      const items = value as string[]
      if (items.length === 0) continue
      groups.push([`${pad}${field.name}=(${items.join(', ')})`])
      continue
    }

    // A scalar. A guarded one emits `SetX=true` immediately before the value.
    if (field.guard) groups.push([`${pad}${field.guard}=true`])
    groups.push([`${pad}${field.name}=${formatScalar(value, field.type)}`])
  }

  return groups
}

function flatten(groups: string[][]): string[] {
  const out: string[] = []
  groups.forEach((group, groupIndex) => {
    const isLastGroup = groupIndex === groups.length - 1
    group.forEach((line, lineIndex) => {
      const isLastLine = lineIndex === group.length - 1
      out.push(isLastLine && !isLastGroup ? `${line},` : line)
    })
  })
  return out
}

export function emitEntry(entry: Node, indices: Indices): string {
  const body = flatten(emitGroups(entry, ROOT_STRUCT, indices, 1))
  if (body.length === 0) return `+${ROOT_KEY}=()`

  const lines = [`+${ROOT_KEY}=(`, ...body, ')']
  return lines.map((line, index) => (index < lines.length - 1 ? line + CONT : line)).join('\n')
}

export interface EmitOptions {
  includeSection?: boolean
}

export function emit(doc: Doc, indices: Indices, options: EmitOptions = {}): string {
  const body = doc.entries.map((entry) => emitEntry(entry, indices)).join('\n\n')
  return options.includeSection === false ? body : `${SECTION}\n\n${body}\n`
}
