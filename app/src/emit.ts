import { elementType, isArrayType, isEditStruct, structOf, type Indices, type StructField } from './schema'
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

function formatScalarList(items: string[], type: string): string {
  return `(${items.map((item) => formatScalar(item, elementType(type))).join(', ')})`
}

function emittableFields(indices: Indices, structName: string): StructField[] {
  return indices.structByName.get(structName)?.fields.filter((f) => f.kind !== 'guard') ?? []
}

/**
 * A game struct as a one-line literal: `(CheckType=eCheck_Exact, Value=1)`.
 * Game structs have no guards and no modes, so nothing needs its own line.
 */
export function formatStructLiteral(node: Node, structName: string, indices: Indices): string {
  const parts: string[] = []
  for (const field of emittableFields(indices, structName)) {
    const value = node[field.name]
    if (value === undefined) continue

    const child = structOf(indices, field.type)
    if (child && isArrayType(field.type) && Array.isArray(value)) {
      const children = value as Node[]
      parts.push(`${field.name}=(${children.map((c) => formatStructLiteral(c, child.name, indices)).join(', ')})`)
    } else if (child && !Array.isArray(value) && value && typeof value === 'object') {
      parts.push(`${field.name}=${formatStructLiteral(value as Node, child.name, indices)}`)
    } else if (Array.isArray(value)) {
      parts.push(`${field.name}=${formatScalarList(value as string[], field.type)}`)
    } else {
      parts.push(`${field.name}=${formatScalar(value, field.type)}`)
    }
  }
  return `(${parts.join(', ')})`
}

function emitGroups(node: Node, structName: string, indices: Indices, depth: number): string[][] {
  const pad = INDENT.repeat(depth)
  const groups: string[][] = []
  const present = new Set(configKeys(node))

  for (const field of emittableFields(indices, structName)) {
    if (!present.has(field.name)) continue
    const value = node[field.name]
    if (value === undefined) continue

    const child = structOf(indices, field.type)
    const isArray = isArrayType(field.type)

    // Game structs are compact literals; edit structs get a line per key.
    if (child && !isEditStruct(child)) {
      if (isArray && Array.isArray(value)) {
        const children = value as Node[]
        if (children.length === 0) continue
        const literal = children.map((c) => formatStructLiteral(c, child.name, indices)).join(', ')
        groups.push([`${pad}${field.name}=(${literal})`])
      } else if (value && typeof value === 'object' && !Array.isArray(value)) {
        if (field.guard) groups.push([`${pad}${field.guard}=true`])
        groups.push([`${pad}${field.name}=${formatStructLiteral(value as Node, child.name, indices)}`])
      }
      continue
    }

    if (child && isArray && Array.isArray(value)) {
      const children = value as Node[]
      if (children.length === 0) continue

      const lines: string[] = [`${pad}${field.name}=(`]
      children.forEach((item, index) => {
        const body = flatten(emitGroups(item, child.name, indices, depth + 2))
        lines.push(`${pad}${INDENT}(`)
        lines.push(...body)
        lines.push(`${pad}${INDENT})${index < children.length - 1 ? ',' : ''}`)
      })
      lines.push(`${pad})`)
      groups.push(lines)
      continue
    }

    // A single nested edit struct.
    if (child && !isArray && value && typeof value === 'object' && !Array.isArray(value)) {
      const body = flatten(emitGroups(value as Node, child.name, indices, depth + 1))
      if (body.length === 0) continue
      groups.push([`${pad}${field.name}=(`, ...body, `${pad})`])
      continue
    }

    // A name or string array.
    if (Array.isArray(value)) {
      const items = value as string[]
      if (items.length === 0) continue
      groups.push([`${pad}${field.name}=${formatScalarList(items, field.type)}`])
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
