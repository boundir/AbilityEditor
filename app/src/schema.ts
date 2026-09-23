import type { Editor, EditorField, Family, Schema, SchemaEnum, Struct, TemplateField } from './types'

export type * from './types'

/**
 * Loading and indexing docs/schema.json.
 */

const DB_NAME = 'ae-config-builder'
const STORE = 'schema'
const CACHE_KEY = 'latest'

export function schemaUrlFrom(baseHref: string): string {
  return new URL('../schema.json', baseHref).href
}

export function defaultSchemaUrl(): string {
  return schemaUrlFrom(document.baseURI)
}

export interface Indices {
  schema: Schema
  familyByName: Map<string, Family>
  editorsByFamily: Map<string, Editor[]>
  editorByGameClass: Map<string, Editor>
  fieldsByEditor: Map<string, Map<string, EditorField>>
  catchAllByFamily: Map<string, Editor>
  structByName: Map<string, Struct>
  enumByName: Map<string, SchemaEnum>
  templateByConfig: Map<string, TemplateField>
  familyByStruct: Map<string, Family>
}

export function buildIndices(schema: Schema): Indices {
  const familyByName = new Map<string, Family>()
  const editorsByFamily = new Map<string, Editor[]>()
  const editorByGameClass = new Map<string, Editor>()
  const fieldsByEditor = new Map<string, Map<string, EditorField>>()
  const catchAllByFamily = new Map<string, Editor>()
  const familyByStruct = new Map<string, Family>()

  for (const family of schema.families) {
    familyByName.set(family.name, family)
    familyByStruct.set(family.editStruct, family)

    const byClass = new Map(family.editors.map((e) => [e.class, e]))
    const ordered = family.dispatchOrder
      .map((cls) => byClass.get(cls))
      .filter((e): e is Editor => e !== undefined)
    editorsByFamily.set(family.name, ordered)

    for (const editor of family.editors) {
      if (editor.catchAll) {
        catchAllByFamily.set(family.name, editor)
      } else if (editor.gameClass) {
        editorByGameClass.set(editor.gameClass, editor)
      }
      fieldsByEditor.set(editor.class, new Map(editor.fields.map((f) => [f.config, f])))
    }
  }

  return {
    schema,
    familyByName,
    editorsByFamily,
    editorByGameClass,
    fieldsByEditor,
    catchAllByFamily,
    structByName: new Map(schema.structs.map((s) => [s.name, s])),
    enumByName: new Map(schema.enums.map((e) => [e.name, e])),
    templateByConfig: new Map(schema.template.fields.map((f) => [f.config, f])),
    familyByStruct,
  }
}

export function resolveEditor(
  indices: Indices,
  familyName: string,
  className: string,
): { editor: Editor | undefined; viaCatchAll: boolean } {
  const bare = className.includes('.') ? className.slice(className.lastIndexOf('.') + 1) : className
  const exact = indices.editorByGameClass.get(bare)

  if (exact) {
    const family = indices.familyByName.get(familyName)
    if (family?.editors.some((e) => e.class === exact.class)) {
      return { editor: exact, viaCatchAll: false }
    }
  }
  return { editor: indices.catchAllByFamily.get(familyName), viaCatchAll: true }
}

export interface FieldGroup {
  source: string | null
  label: string
  fields: EditorField[]
}

export function groupFields(editor: Editor): FieldGroup[] {
  const own: EditorField[] = []
  const inherited = new Map<string, EditorField[]>()

  for (const field of editor.fields) {
    if (field.inheritedFrom) {
      const bucket = inherited.get(field.inheritedFrom)
      if (bucket) bucket.push(field)
      else inherited.set(field.inheritedFrom, [field])
    } else {
      own.push(field)
    }
  }

  const groups: FieldGroup[] = []
  if (own.length > 0) {
    groups.push({ source: null, label: `${editor.gameClass || editor.class} fields`, fields: own })
  }
  for (const [source, fields] of inherited) {
    groups.push({ source, label: `Shared — from ${source}`, fields })
  }
  return groups
}

// --------------------------------------------------------------------------- //
// Fetch + cache
// --------------------------------------------------------------------------- //

function openDb(): Promise<IDBDatabase | null> {
  return new Promise((resolve) => {
    if (!('indexedDB' in globalThis)) return resolve(null)
    let request: IDBOpenDBRequest
    try {
      request = indexedDB.open(DB_NAME, 1)
    } catch {
      return resolve(null)
    }
    request.onupgradeneeded = () => {
      if (!request.result.objectStoreNames.contains(STORE)) request.result.createObjectStore(STORE)
    }
    request.onsuccess = () => resolve(request.result)
    request.onerror = () => resolve(null)
  })
}

async function readCache(): Promise<Schema | null> {
  const db = await openDb()
  if (!db) return null
  return new Promise((resolve) => {
    try {
      const request = db.transaction(STORE, 'readonly').objectStore(STORE).get(CACHE_KEY)
      request.onsuccess = () => resolve((request.result as Schema | undefined) ?? null)
      request.onerror = () => resolve(null)
    } catch {
      resolve(null)
    }
  })
}

async function writeCache(schema: Schema): Promise<void> {
  const db = await openDb()
  if (!db) return
  try {
    db.transaction(STORE, 'readwrite').objectStore(STORE).put(schema, CACHE_KEY)
  } catch {
  }
}

export interface LoadResult {
  schema: Schema
  fromCache: boolean
}

export async function loadSchema(url: string = defaultSchemaUrl()): Promise<LoadResult> {
  try {
    const response = await fetch(url, { cache: 'no-cache' })
    if (!response.ok) throw new Error(`${response.status} ${response.statusText}`)

    const schema = (await response.json()) as Schema
    if (!schema.families || !schema.sourceHash) {
      throw new Error('That file does not look like an Ability Editor schema.')
    }
    void writeCache(schema)
    return { schema, fromCache: false }
  } catch (error) {
    const cached = await readCache()
    if (cached) return { schema: cached, fromCache: true }
    throw new Error(
      `Could not load the schema from ${url}. ${error instanceof Error ? error.message : String(error)}`,
    )
  }
}
