/**
 * Document state.
 */

export type Scalar = string | number | boolean
export type Value = Scalar | string[] | Node | Node[]

export interface Node {
  _id: string
  [key: string]: Value | undefined
}

export interface Doc {
  schemaHash: string
  entries: Node[]
}

let counter = 0
export function newId(prefix = 'n'): string {
  counter += 1
  return `${prefix}${counter}`
}

export function newNode(initial: Record<string, Value> = {}): Node {
  return { _id: newId(), ...initial }
}

export function emptyDoc(schemaHash: string): Doc {
  return { schemaHash, entries: [newNode({ Ability: '' })] }
}

export function isInternalKey(key: string): boolean {
  return key.startsWith('_')
}

export function configKeys(node: Node): string[] {
  return Object.keys(node).filter((k) => !isInternalKey(k))
}

// --------------------------------------------------------------------------- //
// Immutable updates
// --------------------------------------------------------------------------- //

export type Path = (string | number)[]

function cloneAt(value: Value | undefined): Value | undefined {
  if (Array.isArray(value)) return [...value] as Value
  if (value && typeof value === 'object') return { ...(value as Node) }
  return value
}

export function setAtPath(doc: Doc, path: Path, value: Value | undefined): Doc {
  if (path.length === 0) return doc

  const entries = [...doc.entries]
  const [entryIndex, ...rest] = path

  if (typeof entryIndex !== 'number') return doc
  const entry = entries[entryIndex]
  if (!entry) return doc

  if (rest.length === 0) {
    if (value === undefined) entries.splice(entryIndex, 1)
    else entries[entryIndex] = value as Node
    return { ...doc, entries }
  }

  entries[entryIndex] = setIn(entry, rest, value) as Node
  return { ...doc, entries }
}

/**
 * The container a path step needs to descend into, created when absent.
 */
function containerFor(existing: Value | undefined, nextStep: string | number | undefined): Value {
  if (existing !== undefined) return cloneAt(existing) as Value
  return typeof nextStep === 'number' ? ([] as unknown as Value) : ({} as unknown as Value)
}

function setIn(container: Value, path: Path, value: Value | undefined): Value {
  const [head, ...rest] = path
  if (head === undefined) return value as Value

  if (typeof head === 'number') {
    const list = [...(container as Node[])]
    if (rest.length === 0) {
      if (value === undefined) list.splice(head, 1)
      else list[head] = value as Node
    } else {
      list[head] = setIn(containerFor(list[head], rest[0]), rest, value) as Node
    }
    return list as Value
  }

  const node = { ...(container as Node) }
  if (rest.length === 0) {
    if (value === undefined) delete node[head]
    else node[head] = value
  } else {
    node[head] = setIn(containerFor(node[head], rest[0]), rest, value)
  }
  return node as Value
}

export function getAtPath(doc: Doc, path: Path): Value | undefined {
  let current: Value | undefined = doc.entries as unknown as Value
  for (const step of path) {
    if (current === undefined) return undefined
    current =
      typeof step === 'number'
        ? (current as Node[])[step]
        : (current as Node)[step]
  }
  return current
}
