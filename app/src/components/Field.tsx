import type { Indices, SchemaEnum } from '../schema'
import type { Value } from '../state'

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

function enumFor(indices: Indices, type: string): SchemaEnum | undefined {
  return indices.enumByName.get(type)
}

function defaultFor(field: EditorField, indices: Indices): Value {
  const enumDef = enumFor(indices, field.type)
  if (enumDef) return enumDef.values[0]?.name ?? ''
  switch (field.type) {
    case 'bool':
      return true
    case 'int':
    case 'float':
      return 0
    default:
      return field.type.startsWith('array<') ? [] : ''
  }
}

export function Field({ field, value, indices, onChange }: Props) {
  const enabled = value !== undefined
  const enumDef = enumFor(indices, field.type)
  const isArray = field.type.startsWith('array<')

  return (
    <div className={`field${enabled ? ' field--on' : ''}`}>
      <label className="field__toggle">
        <input
          type="checkbox"
          checked={enabled}
          onChange={(event) =>
            onChange(event.target.checked ? defaultFor(field, indices) : undefined)
          }
        />
        <code>{field.config}</code>
      </label>

      <div className="field__control">
        {enabled && (
          <FieldInput
            field={field}
            value={value}
            enumDef={enumDef}
            isArray={isArray}
            onChange={onChange}
          />
        )}
      </div>

      <div className="field__meta">
        <span className="field__type">{field.type}</span>
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
  field: EditorField
  value: Value | undefined
  enumDef: SchemaEnum | undefined
  isArray: boolean
  onChange: (value: Value | undefined) => void
}

function FieldInput({ field, value, enumDef, isArray, onChange }: InputProps) {
  if (isArray) {
    const items = Array.isArray(value) ? (value as string[]) : []
    return <ChipList items={items} onChange={(next) => onChange(next)} />
  }

  if (enumDef) {
    return (
      <select value={String(value ?? '')} onChange={(event) => onChange(event.target.value)}>
        {enumDef.values.map((option, index) => (
          <option key={option.name} value={option.name}>
            {option.name}
            {index === 0 ? '  (default)' : ''}
          </option>
        ))}
      </select>
    )
  }

  if (field.type === 'bool') {
    return (
      <select
        value={value === true ? 'true' : 'false'}
        onChange={(event) => onChange(event.target.value === 'true')}
      >
        <option value="true">true</option>
        <option value="false">false</option>
      </select>
    )
  }

  if (field.type === 'int' || field.type === 'float') {
    return (
      <input
        type="number"
        step={field.type === 'float' ? 'any' : 1}
        value={typeof value === 'number' ? value : ''}
        onChange={(event) => {
          const raw = event.target.value
          if (raw === '') return onChange(0)
          const parsed = field.type === 'int' ? Number.parseInt(raw, 10) : Number.parseFloat(raw)
          onChange(Number.isNaN(parsed) ? 0 : parsed)
        }}
      />
    )
  }

  return (
    <input
      type="text"
      value={typeof value === 'string' ? value : ''}
      placeholder={field.type === 'name' ? 'BareName' : ''}
      onChange={(event) => onChange(event.target.value)}
    />
  )
}

function ChipList({ items, onChange }: { items: string[]; onChange: (next: string[]) => void }) {
  return (
    <div className="chips">
      {items.map((item, index) => (
        <span className="chip" key={`${item}-${index}`}>
          <input
            value={item}
            onChange={(event) => {
              const next = [...items]
              next[index] = event.target.value
              onChange(next)
            }}
          />
          <button
            type="button"
            aria-label={`Remove ${item}`}
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
