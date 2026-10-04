/**
 * Shape of docs/schema.json.
 */

export type FieldKind = 'scalar' | 'namearray' | 'nested'

export interface EditorField {
  config: string
  type: string
  kind: FieldKind
  gameField: string | null
  origin: 'base' | 'derived'
  inheritedFrom: string | null
  description: string
  guard?: string
  modeField?: string
  modeEnum?: string
  replaceOnly?: boolean
}

export interface NotEditable {
  name: string
  reason: string
}

export interface Editor {
  class: string
  extends: string | null
  gameClass: string
  catchAll: boolean
  abstract?: boolean
  fields: EditorField[]
  notEditable?: NotEditable[]
  bridge?: string
  package?: string
  priority?: number
  registration?: string
  overrides?: string
}

export interface BridgeRequirements {
  mods: string[]
  dlc: string[]
}

export interface BridgeEditorRef {
  family: string
  class: string
  gameClass: string
  package: string
}

export interface Bridge {
  name: string
  displayName: string
  repo: string
  requires: BridgeRequirements
  sourceHash: string
  generatedFrom: string
  stale: boolean
  editorCount: number
  editors: BridgeEditorRef[]
}

export interface Family {
  name: string
  configKey: string
  editStruct: string
  wired: boolean
  dispatchOrder: string[]
  intro: string
  editors: Editor[]
}

export interface StructField {
  name: string
  type: string
  kind: 'plain' | 'guard' | 'optionalScalar' | 'mode' | 'modedArray' | 'nested' | 'plainArray'
  description: string
  guard?: string
  modeField?: string
  modeEnum?: string
}

export interface Struct {
  name: string
  fields: StructField[]
}

export interface EnumValue {
  name: string
  description: string
}

export interface SchemaEnum {
  name: string
  values: EnumValue[]
}

export interface TemplateField {
  config: string
  type: string
  kind: 'scalar' | 'namearray'
  gameField: string | null
  description: string
  guard?: string
  modeField?: string
  modeEnum?: string
  replaceOnly?: boolean
}

export interface Schema {
  $comment: string
  sourceHash: string
  enums: SchemaEnum[]
  structs: Struct[]
  template: {
    fields: TemplateField[]
    notEditable: NotEditable[]
  }
  bridges?: Bridge[]
  families: Family[]
  warnings: string[]
}
