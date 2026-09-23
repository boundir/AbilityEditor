import { useMemo, useState } from 'react'

import { nestedStructName } from '../emit'
import type { Editor, Indices, StructField } from '../schema'
import { groupFields, resolveEditor } from '../schema'
import { newNode, type Node, type Path, type Value } from '../state'

import { Field, type EditorField } from './Field'

interface Props {
  node: Node
  structName: string
  path: Path
  indices: Indices
  onChange: (path: Path, value: Value | undefined) => void
  filter: string
}

function structToField(field: StructField): EditorField {
  return {
    config: field.name,
    type: field.type,
    description: field.description,
    guard: field.guard,
    modeField: field.modeField,
    modeEnum: field.modeEnum,
  }
}

/**
 * Mode fields that a nested block renders in its own header.
 */
function modesOwnedByNestedBlocks(indices: Indices, structName: string): Set<string> {
  const fields = indices.structByName.get(structName)?.fields ?? []
  const owned = new Set<string>()
  for (const field of fields) {
    if (field.modeField && nestedStructName(field.type)) owned.add(field.modeField)
  }
  return owned
}

function plainStructFields(indices: Indices, structName: string): StructField[] {
  const owned = modesOwnedByNestedBlocks(indices, structName)
  return (indices.structByName.get(structName)?.fields ?? []).filter(
    (f) => f.kind !== 'guard' && !nestedStructName(f.type) && !owned.has(f.name),
  )
}

function nestedStructFields(indices: Indices, structName: string): StructField[] {
  return (indices.structByName.get(structName)?.fields ?? []).filter((f) =>
    nestedStructName(f.type),
  )
}

function matches(filter: string, field: { config: string; description: string }): boolean {
  if (!filter) return true
  const needle = filter.toLowerCase()
  return (
    field.config.toLowerCase().includes(needle) ||
    field.description.toLowerCase().includes(needle)
  )
}

export function NodeEditor({ node, structName, path, indices, onChange, filter }: Props) {
  const family = indices.familyByStruct.get(structName)
  const className = typeof node['Class'] === 'string' ? node['Class'] : ''

  const resolved = useMemo(
    () => (family ? resolveEditor(indices, family.name, className) : undefined),
    [family, indices, className],
  )

  return (
    <div className="node">
      {family && (
        <ClassPicker
          family={family.name}
          indices={indices}
          value={className}
          resolved={resolved?.editor}
          viaCatchAll={resolved?.viaCatchAll ?? false}
          onChange={(next) => onChange([...path, 'Class'], next || undefined)}
        />
      )}

      <StructuralFields
        node={node}
        structName={structName}
        path={path}
        indices={indices}
        onChange={onChange}
        filter={filter}
      />

      {resolved?.editor ? (
        <EditorFields
          editor={resolved.editor}
          node={node}
          path={path}
          indices={indices}
          onChange={onChange}
          filter={filter}
        />
      ) : (
        !family && (
          <PlainFields
            node={node}
            structName={structName}
            path={path}
            indices={indices}
            onChange={onChange}
            filter={filter}
          />
        )
      )}

      <NestedBlocks
        node={node}
        structName={structName}
        path={path}
        indices={indices}
        onChange={onChange}
        filter={filter}
      />
    </div>
  )
}

function StructuralFields({ node, structName, path, indices, onChange, filter }: Props) {
  const family = indices.familyByStruct.get(structName)
  if (!family) return null

  const structural = plainStructFields(indices, structName).filter(
    (f) => f.kind === 'plain' && f.name !== 'Class',
  )
  const visible = structural.map(structToField).filter((f) => matches(filter, f))
  if (visible.length === 0) return null

  return (
    <div className="fields fields--structural">
      {visible.map((field) => (
        <Field
          key={field.config}
          field={field}
          value={node[field.config]}
          indices={indices}
          onChange={(value) => onChange([...path, field.config], value)}
        />
      ))}
    </div>
  )
}

interface EditorFieldsProps {
  editor: Editor
  node: Node
  path: Path
  indices: Indices
  onChange: (path: Path, value: Value | undefined) => void
  filter: string
}

function EditorFields({ editor, node, path, indices, onChange, filter }: EditorFieldsProps) {
  const groups = useMemo(() => groupFields(editor), [editor])

  if (groups.length === 0) {
    return (
      <p className="empty">
        No editable fields for this class — only the structural keys above apply.
      </p>
    )
  }

  return (
    <>
      {groups.map((group) => (
        <FieldGroup
          key={group.source ?? '__own'}
          label={group.label}
          fields={group.fields.filter((f) => matches(filter, f))}
          openByDefault={group.source === null || filter !== ''}
          node={node}
          path={path}
          indices={indices}
          onChange={onChange}
        />
      ))}
    </>
  )
}

interface GroupProps {
  label: string
  fields: EditorField[]
  openByDefault: boolean
  node: Node
  path: Path
  indices: Indices
  onChange: (path: Path, value: Value | undefined) => void
}

function FieldGroup({
  label,
  fields,
  openByDefault,
  node,
  path,
  indices,
  onChange,
}: GroupProps) {
  const setCount = fields.filter((f) => node[f.config] !== undefined).length
  if (fields.length === 0) return null

  return (
    <details className="group" open={openByDefault || setCount > 0}>
      <summary>
        {label} <span className="group__count">{fields.length}</span>
        {setCount > 0 && <span className="group__set">{setCount} set</span>}
      </summary>
      <div className="fields">
        {fields.map((field) => (
          <Field
            key={field.config}
            field={field}
            value={node[field.config]}
            indices={indices}
            onChange={(value) => onChange([...path, field.config], value)}
          />
        ))}
      </div>
    </details>
  )
}

function PlainFields({ node, structName, path, indices, onChange, filter }: Props) {
  const fields = plainStructFields(indices, structName)
    .map(structToField)
    .filter((f) => matches(filter, f))
  if (fields.length === 0) return null

  return (
    <div className="fields">
      {fields.map((field) => (
        <Field
          key={field.config}
          field={field}
          value={node[field.config]}
          indices={indices}
          onChange={(value) => onChange([...path, field.config], value)}
        />
      ))}
    </div>
  )
}

function NestedBlocks({ node, structName, path, indices, onChange, filter }: Props) {
  const nested = nestedStructFields(indices, structName)
  if (nested.length === 0) return null

  return (
    <>
      {nested.map((field) => {
        const childStruct = nestedStructName(field.type)
        if (!childStruct) return null
        const isArray = field.type.startsWith('array<')
        const value = node[field.name]

        const modeField = field.modeField
          ? indices.structByName
              .get(structName)
              ?.fields.find((f) => f.name === field.modeField)
          : undefined

        return isArray ? (
          <NestedArray
            key={field.name}
            label={field.name}
            childStruct={childStruct}
            description={field.description}
            items={Array.isArray(value) ? (value as Node[]) : []}
            path={[...path, field.name]}
            parentPath={path}
            mode={modeField ? { field: structToField(modeField), value: node[modeField.name] } : undefined}
            indices={indices}
            onChange={onChange}
            filter={filter}
          />
        ) : (
          <NestedSingle
            key={field.name}
            label={field.name}
            childStruct={childStruct}
            description={field.description}
            value={value as Node | undefined}
            path={[...path, field.name]}
            indices={indices}
            onChange={onChange}
            filter={filter}
          />
        )
      })}
    </>
  )
}

interface NestedProps {
  label: string
  childStruct: string
  description: string
  path: Path
  indices: Indices
  onChange: (path: Path, value: Value | undefined) => void
  filter: string
}

function NestedArray({
  label,
  childStruct,
  description,
  items,
  path,
  parentPath,
  mode,
  indices,
  onChange,
  filter,
}: NestedProps & {
  items: Node[]
  parentPath: Path
  mode?: { field: EditorField; value: Value | undefined }
}) {
  const [open, setOpen] = useState(items.length > 0)

  return (
    <details className="nested" open={open} onToggle={(e) => setOpen(e.currentTarget.open)}>
      <summary>
        {label} <span className="group__count">{items.length}</span>
        {mode && mode.value === undefined && items.length > 0 && (
          <span className="nested__alert" title={`${mode.field.config} is not set`}>
            mode unset
          </span>
        )}
      </summary>
      {description && <p className="nested__desc">{description}</p>}

      {mode && (
        <div className="nested__mode">
          <Field
            field={mode.field}
            value={mode.value}
            indices={indices}
            onChange={(value) => onChange([...parentPath, mode.field.config], value)}
          />
        </div>
      )}

      {items.map((item, index) => (
        <div className="card" key={item._id}>
          <div className="card__bar">
            <span className="card__title">
              {label}[{index}]
            </span>
            <button
              type="button"
              onClick={() => onChange([...path, index], undefined)}
              aria-label={`Remove ${label} entry ${index + 1}`}
            >
              Remove
            </button>
          </div>
          <NodeEditor
            node={item}
            structName={childStruct}
            path={[...path, index]}
            indices={indices}
            onChange={onChange}
            filter={filter}
          />
        </div>
      ))}

      <button
        type="button"
        className="add"
        onClick={() => onChange([...path, items.length], newNode())}
      >
        + Add {childStruct.replace(/Edit$/, '')}
      </button>
    </details>
  )
}

function NestedSingle({
  label,
  childStruct,
  description,
  value,
  path,
  indices,
  onChange,
  filter,
}: NestedProps & { value: Node | undefined }) {
  if (!value) {
    return (
      <button type="button" className="add add--single" onClick={() => onChange(path, newNode())}>
        + Add {label}
      </button>
    )
  }

  return (
    <details className="nested" open>
      <summary>
        {label}
        <button
          type="button"
          className="nested__remove"
          onClick={(event) => {
            event.preventDefault()
            onChange(path, undefined)
          }}
        >
          Remove
        </button>
      </summary>
      {description && <p className="nested__desc">{description}</p>}
      <div className="card">
        <NodeEditor
          node={value}
          structName={childStruct}
          path={path}
          indices={indices}
          onChange={onChange}
          filter={filter}
        />
      </div>
    </details>
  )
}

interface ClassPickerProps {
  family: string
  indices: Indices
  value: string
  resolved: Editor | undefined
  viaCatchAll: boolean
  onChange: (value: string) => void
}

function ClassPicker({ family, indices, value, resolved, viaCatchAll, onChange }: ClassPickerProps) {
  const editors = indices.editorsByFamily.get(family) ?? []
  const options = [
    ...editors.filter((e) => !e.catchAll && e.gameClass && !e.abstract),
    ...editors.filter((e) => !e.catchAll && e.gameClass && e.abstract),
  ]
  const listId = `classes-${family}`
  const isAbstract = resolved?.abstract === true && !viaCatchAll

  return (
    <div className="classpicker">
      <label>
        <span>Class</span>
        <input
          list={listId}
          value={value}
          placeholder={`e.g. ${options[0]?.gameClass ?? 'X2Effect_Persistent'}`}
          onChange={(event) => onChange(event.target.value)}
        />
      </label>
      <datalist id={listId}>
        {options.map((editor) => (
          <option
            key={editor.class}
            value={editor.gameClass}
            label={editor.abstract ? 'abstract — cannot be named' : undefined}
          />
        ))}
      </datalist>

      {isAbstract && (
        <p className="classpicker__note">
          <strong>{value}</strong> is abstract, so no ability has one. Entries are matched by exact
          class, so this will never match — name one of the concrete classes that derive from it.
        </p>
      )}

      {value !== '' && viaCatchAll && (
        <p className="classpicker__note">
          No dedicated editor — only the {resolved?.fields.length ?? 0} shared {family} fields
          apply.
        </p>
      )}
    </div>
  )
}
