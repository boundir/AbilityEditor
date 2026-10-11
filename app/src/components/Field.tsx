import { useState } from 'react'

import { enumOf, isArrayType, structOf, type Indices, type SchemaEnum, type Struct, type StructField } from '../schema'
import { newNode, type Node, type Value } from '../state'

export interface EditorField {
  config: string
  type: string
  description: string
  gameField?: string | null
  guard?: string
  modeField?: string
  modeEnum?: string
  replaceOnly?: boolean
}

interface Props {
  field: EditorField
  value: Value | undefined
  indices: Indices
  onChange: (value: Value | undefined) => void
}

export function defaultFor(type: string, indices: Indices): Value {
  if (isArrayType(type)) {
    return []
  }
  if (structOf(indices, type)) {
    return newNode()
  }
  const enumDef = enumOf(indices, type)
  if (enumDef) return enumDef.values[0]?.name ?? ''
  switch (type) {
    case 'bool':
      return true
    case 'int':
    case 'float':
      return 0
    default:
      return ''
  }
}

export function Field({ field, value, indices, onChange }: Props) {
  const enabled = value !== undefined
  const struct = structOf(indices, field.type)

  return (
    <div className={`field${enabled ? ' field--on' : ''}`}>
      <label className="field__toggle">
        <input
          type="checkbox"
          checked={enabled}
          onChange={(event) =>
            onChange(event.target.checked ? defaultFor(field.type, indices) : undefined)
          }
        />
        <code>{field.config}</code>
      </label>

      <div className="field__control">
        {enabled && (
          <FieldInput
            name={field.config}
            type={field.type}
            value={value}
            indices={indices}
            onChange={onChange}
          />
        )}
      </div>

      <div className="field__meta">
        <span className="field__type" title={struct?.definedIn ? `${struct.name} from ${struct.definedIn}` : undefined}>
          {field.type}
        </span>
        {field.gameField && <span className="field__game">→ {field.gameField}</span>}
      </div>

      <p className="field__desc">
        {field.description || (
          <span className="field__desc--derived">
            {field.gameField ? `Sets ${field.gameField}.` : 'No description yet.'}
          </span>
        )}
      </p>
    </div>
  )
}

interface InputProps {
  name: string
  type: string
  value: Value | undefined
  indices: Indices
  onChange: (value: Value | undefined) => void
}

/**
 * One control for a typed value: a struct becomes a sub-form, an array of structs a list of them.
 */
function FieldInput({ name, type, value, indices, onChange }: InputProps) {
  const struct = structOf(indices, type)
  const enumDef = enumOf(indices, type)

  if (struct && isArrayType(type)) {
    const items = Array.isArray(value) ? (value as Node[]) : []
    return <StructList struct={struct} items={items} indices={indices} onChange={onChange} />
  }

  if (struct) {
    const node = value && typeof value === 'object' && !Array.isArray(value) ? (value as Node) : newNode()
    return <StructForm struct={struct} node={node} indices={indices} onChange={onChange} />
  }

  if (isArrayType(type)) {
    const items = Array.isArray(value) ? (value as string[]) : []
    return <ChipList name={name} items={items} onChange={(next) => onChange(next)} />
  }

  if (enumDef) {
    return (
      <EnumSelect
        name={name}
        enumDef={enumDef}
        value={typeof value === 'string' ? value : ''}
        onChange={(next) => onChange(next)}
      />
    )
  }

  if (type === 'bool') {
    return (
      <select
        aria-label={name}
        value={value === true ? 'true' : 'false'}
        onChange={(event) => onChange(event.target.value === 'true')}
      >
        <option value="true">true</option>
        <option value="false">false</option>
      </select>
    )
  }

  if (type === 'int' || type === 'float') {
    return (
      <input
        type="number"
        aria-label={name}
        step={type === 'float' ? 'any' : 1}
        value={typeof value === 'number' ? value : ''}
        onChange={(event) => {
          const raw = event.target.value
          if (raw === '') {
            return onChange(0)
          }
          const parsed = type === 'int' ? Number.parseInt(raw, 10) : Number.parseFloat(raw)
          onChange(Number.isNaN(parsed) ? 0 : parsed)
        }}
      />
    )
  }

  return (
    <input
      type="text"
      aria-label={name}
      value={typeof value === 'string' ? value : ''}
      placeholder={type === 'name' ? 'BareName' : ''}
      onChange={(event) => onChange(event.target.value)}
    />
  )
}

const CUSTOM = '\u0000custom'

/**
 * A dropdown of the enum's values. A value the schema does not know (from a mod, or a
 * typo in pasted config) is kept and shown as such, with a text box to change it.
 */
function EnumSelect({
  name,
  enumDef,
  value,
  onChange,
}: {
  name: string
  enumDef: SchemaEnum
  value: string
  onChange: (value: string) => void
}) {
  const known = enumDef.values.some((v) => v.name === value)
  const [custom, setCustom] = useState(!known)
  const showCustom = custom || !known

  return (
    <div className="enum">
      <select
        aria-label={name}
        className={showCustom ? 'enum--custom' : undefined}
        value={showCustom ? CUSTOM : value}
        onChange={(event) => {
          if (event.target.value === CUSTOM) {
            setCustom(true)
            return
          }
          setCustom(false)
          onChange(event.target.value)
        }}
      >
        {enumDef.values.map((option, index) => (
          <option key={option.name} value={option.name} title={option.description || undefined}>
            {option.name}
            {index === 0 ? '  (default)' : ''}
          </option>
        ))}
        <option value={CUSTOM}>other (modded value)…</option>
      </select>
      {showCustom && (
        <input
          type="text"
          aria-label={`${name} custom value`}
          className="enum__custom"
          value={value}
          placeholder={`e${enumDef.name.replace(/^E/, '')}_...`}
          onChange={(event) => onChange(event.target.value)}
        />
      )}
      {!known && value !== '' && (
        <span className="enum__note">not in {enumDef.name}</span>
      )}
    </div>
  )
}

/**
 * A game struct, one row per field. Every field is always present: game structs have no
 * guards, so a sub-form field left alone is simply written with its default.
 */
function StructForm({
  struct,
  node,
  indices,
  onChange,
}: {
  struct: Struct
  node: Node
  indices: Indices
  onChange: (value: Value) => void
}) {
  const set = (field: StructField, value: Value | undefined) => {
    const next: Node = { ...node }
    if (value === undefined) {
      delete next[field.name]
    } else {
      next[field.name] = value
    }
    onChange(next)
  }

  return (
    <div className="struct">
      {struct.fields.map((field) => {
        const value = node[field.name]
        const on = value !== undefined
        return (
          <div className={`struct__row${on ? ' struct__row--on' : ''}`} key={field.name}>
            <label className="struct__label">
              <input
                type="checkbox"
                checked={on}
                onChange={(event) =>
                  set(field, event.target.checked ? defaultFor(field.type, indices) : undefined)
                }
              />
              <code>{field.name}</code>
              <span className="field__type">{field.type}</span>
            </label>
            <div className="struct__control">
              {on && (
                <FieldInput
                  name={`${struct.name}.${field.name}`}
                  type={field.type}
                  value={value}
                  indices={indices}
                  onChange={(next) => set(field, next)}
                />
              )}
            </div>
            {field.description && on && <p className="struct__desc">{field.description}</p>}
          </div>
        )
      })}
    </div>
  )
}

function StructList({
  struct,
  items,
  indices,
  onChange,
}: {
  struct: Struct
  items: Node[]
  indices: Indices
  onChange: (value: Value) => void
}) {
  return (
    <div className="structlist">
      {items.map((item, index) => (
        <div className="structlist__item" key={item._id}>
          <div className="card__bar">
            <span className="card__title">
              {struct.name}[{index}]
            </span>
            <button
              type="button"
              aria-label={`Remove ${struct.name} ${index + 1}`}
              onClick={() => onChange(items.filter((_, i) => i !== index))}
            >
              Remove
            </button>
          </div>
          <StructForm
            struct={struct}
            node={item}
            indices={indices}
            onChange={(next) => {
              const copy = [...items]
              copy[index] = next as Node
              onChange(copy)
            }}
          />
        </div>
      ))}
      <button type="button" className="chip__add" onClick={() => onChange([...items, newNode()])}>
        + add {struct.name}
      </button>
    </div>
  )
}

function ChipList({ name, items, onChange }: { name: string; items: string[]; onChange: (next: string[]) => void }) {
  return (
    <div className="chips">
      {items.map((item, index) => (
        // Keyed by position, not content, so the input keeps focus while its text changes.
        <span className="chip" key={index}>
          <input
            aria-label={`${name} item ${index + 1}`}
            value={item}
            onChange={(event) => {
              const next = [...items]
              next[index] = event.target.value
              onChange(next)
            }}
          />
          <button
            type="button"
            aria-label={`Remove ${name} item ${index + 1}`}
            onClick={() => onChange(items.filter((_, i) => i !== index))}
          >
            ×
          </button>
        </span>
      ))}
      <button type="button" className="chip__add" onClick={() => onChange([...items, ''])}>
        + add
      </button>
    </div>
  )
}
