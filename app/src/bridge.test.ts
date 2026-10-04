import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { describe, expect, it } from 'vitest'

import { emitEntry } from './emit'
import { parseConfig } from './parse'
import { buildIndices, qualifiedClassName, resolveEditor } from './schema'
import { newNode, type Doc, type Node } from './state'
import type { Bridge, Editor, Schema } from './types'
import { validate } from './validate'

const schema = JSON.parse(
  readFileSync(resolve(import.meta.dirname, '..', '..', 'docs', 'schema.json'), 'utf-8'),
) as Schema

const BRIDGE: Bridge = {
  name: 'AbilityEditorSynthetic',
  displayName: 'Ability Editor: Synthetic',
  repo: '',
  requires: { mods: ['AbilityEditor'], dlc: ['Synthetic DLC'] },
  sourceHash: 'x',
  generatedFrom: schema.sourceHash,
  stale: false,
  editorCount: 2,
  editors: [],
}

function withSyntheticBridge(base: Schema): Schema {
  const clone = JSON.parse(JSON.stringify(base)) as Schema
  const effects = clone.families.find((f) => f.name === 'Effects')!
  const persistent = effects.editors.find((e) => e.class === 'X2AbilityEffectsEditor_Persistent')!

  const ownField = {
    config: 'NumTurns',
    type: 'int',
    kind: 'scalar' as const,
    gameField: 'NumTurns',
    origin: 'derived' as const,
    inheritedFrom: null,
    description: '',
    guard: 'SetNumTurns',
  }
  const fresh: Editor = {
    class: 'X2AbilityEffectsEditor_DLC_9Thing',
    extends: 'X2AbilityEffectsEditor_Persistent',
    gameClass: 'X2Effect_DLC_9Thing',
    catchAll: false,
    abstract: false,
    fields: [ownField, ...persistent.fields.map((f) => ({ ...f, inheritedFrom: f.inheritedFrom ?? persistent.class }))],
    bridge: BRIDGE.name,
    package: 'DLC_9',
    priority: 10,
    registration: 'ExtraEffectsEditors',
  }
  const override: Editor = {
    class: 'X2AbilityEffectsEditor_DLC_9Persistent',
    extends: 'X2AbilityEffectsEditor_Persistent',
    gameClass: 'X2Effect_Persistent',
    catchAll: false,
    abstract: false,
    fields: persistent.fields,
    bridge: BRIDGE.name,
    package: 'DLC_9',
    priority: 5,
    registration: 'ExtraEffectsEditors',
    overrides: persistent.class,
  }

  effects.editors.push(fresh, override)
  effects.dispatchOrder = [fresh.class, override.class, ...effects.dispatchOrder]
  clone.bridges = [
    {
      ...BRIDGE,
      editors: [fresh, override].map((e) => ({
        family: 'Effects',
        class: e.class,
        gameClass: e.gameClass,
        package: e.package!,
      })),
    },
  ]
  return clone
}

const synthetic = withSyntheticBridge(schema)
const indices = buildIndices(synthetic)

function docOf(...entries: Node[]): Doc {
  return { schemaHash: synthetic.sourceHash, entries }
}

function titles(doc: Doc): string[] {
  return validate(doc, indices).map((i) => i.title)
}

describe('indices with a bridge', () => {
  it('keeps bridge editors in the family list, ahead of the built-ins', () => {
    const effects = indices.editorsByFamily.get('Effects')!
    expect(effects[0]?.class).toBe('X2AbilityEffectsEditor_DLC_9Thing')
    expect(effects.some((e) => e.class === 'X2AbilityEffectsEditor_Persistent')).toBe(true)
  })

  it('indexes the bridge under its qualified name', () => {
    expect(indices.editorByQualifiedClass.get('DLC_9.X2Effect_DLC_9Thing')?.bridge).toBe(BRIDGE.name)
    expect(indices.bridgeByName.get(BRIDGE.name)?.displayName).toBe('Ability Editor: Synthetic')
  })

  it('lets the built-in keep the bare key when a bridge overrides it', () => {
    expect(indices.editorByGameClass.get('X2Effect_Persistent')?.class).toBe(
      'X2AbilityEffectsEditor_Persistent',
    )
    expect(indices.editorByQualifiedClass.get('DLC_9.X2Effect_Persistent')?.class).toBe(
      'X2AbilityEffectsEditor_DLC_9Persistent',
    )
  })

  it('writes qualified names only for editors with a package', () => {
    expect(qualifiedClassName(indices.editorByQualifiedClass.get('DLC_9.X2Effect_DLC_9Thing')!)).toBe(
      'DLC_9.X2Effect_DLC_9Thing',
    )
    expect(qualifiedClassName(indices.editorByGameClass.get('X2Effect_Persistent')!)).toBe(
      'X2Effect_Persistent',
    )
  })
})

describe('resolveEditor with a bridge', () => {
  it('resolves the qualified name without the catch-all', () => {
    const r = resolveEditor(indices, 'Effects', 'DLC_9.X2Effect_DLC_9Thing')
    expect(r.viaCatchAll).toBe(false)
    expect(r.qualifiedMismatch).toBe(false)
    expect(r.editor?.class).toBe('X2AbilityEffectsEditor_DLC_9Thing')
  })

  it('resolves the bare name but reports the missing package', () => {
    const r = resolveEditor(indices, 'Effects', 'X2Effect_DLC_9Thing')
    expect(r.editor?.class).toBe('X2AbilityEffectsEditor_DLC_9Thing')
    expect(r.viaCatchAll).toBe(false)
    expect(r.qualifiedMismatch).toBe(true)
  })

  it('treats a wrong package as a mismatch too', () => {
    const r = resolveEditor(indices, 'Effects', 'XComGame.X2Effect_DLC_9Thing')
    expect(r.editor?.class).toBe('X2AbilityEffectsEditor_DLC_9Thing')
    expect(r.qualifiedMismatch).toBe(true)
  })

  it('prefers the built-in for a bare name a bridge also overrides', () => {
    const r = resolveEditor(indices, 'Effects', 'X2Effect_Persistent')
    expect(r.editor?.class).toBe('X2AbilityEffectsEditor_Persistent')
    expect(r.qualifiedMismatch).toBe(false)
  })

  it('reaches the override through its qualified name', () => {
    const r = resolveEditor(indices, 'Effects', 'DLC_9.X2Effect_Persistent')
    expect(r.editor?.class).toBe('X2AbilityEffectsEditor_DLC_9Persistent')
  })

  it('does not resolve a bridge editor from another family', () => {
    const r = resolveEditor(indices, 'Conditions', 'DLC_9.X2Effect_DLC_9Thing')
    expect(r.viaCatchAll).toBe(true)
  })
})

describe('validation with a bridge', () => {
  const entry = (cls: string) =>
    newNode({
      Ability: 'FreezingLash',
      Effects: [newNode({ Class: cls, Slot: 'eAES_Target', Mode: 'eAEM_Merge', NumTurns: 3 })],
    })

  it('warns that a qualified bridge class needs the bridge mod', () => {
    const doc = docOf(entry('DLC_9.X2Effect_DLC_9Thing'))
    const issues = validate(doc, indices)
    const issue = issues.find((i) => i.title.includes('needs the Ability Editor: Synthetic bridge mod'))
    expect(issue?.severity).toBe('warning')
    expect(issue?.detail).toContain('Synthetic DLC')
    expect(issue?.detail).toContain('X2AbilityEffectsEditor_Persistent')
    expect(issues.filter((i) => i.severity === 'error')).toEqual([])
  })

  it('rejects the bare name of a bridge class', () => {
    const doc = docOf(entry('X2Effect_DLC_9Thing'))
    const issue = validate(doc, indices).find((i) => i.title === 'X2Effect_DLC_9Thing must be package-qualified')
    expect(issue?.severity).toBe('error')
    expect(issue?.detail).toContain('Class="DLC_9.X2Effect_DLC_9Thing"')
  })

  it('leaves a built-in class alone even when a bridge overrides it', () => {
    expect(titles(docOf(entry('X2Effect_Persistent')))).toEqual([])
  })
})

describe('emit and parse with a bridge', () => {
  it('round-trips a qualified class', () => {
    const entry = newNode({
      Ability: 'FreezingLash',
      Effects: [
        newNode({ Class: 'DLC_9.X2Effect_DLC_9Thing', Slot: 'eAES_Target', Mode: 'eAEM_Merge', NumTurns: 3 }),
      ],
    })
    const text = emitEntry(entry, indices)
    expect(text).toContain('Class="DLC_9.X2Effect_DLC_9Thing"')

    const { doc, problems } = parseConfig(text, indices)
    expect(problems.filter((p) => p.severity === 'error')).toEqual([])
    const effects = doc!.entries[0]!['Effects'] as Node[]
    expect(effects[0]!['Class']).toBe('DLC_9.X2Effect_DLC_9Thing')
    expect(effects[0]!['NumTurns']).toBe(3)
  })
})

describe('published bridges', () => {
  const real = buildIndices(schema)

  it.each((schema.bridges ?? []).flatMap((b) => b.editors.map((e) => [b.name, e] as const)))(
    'resolves every editor of %s by its qualified name',
    (_bridge, ref) => {
      const r = resolveEditor(real, ref.family, `${ref.package}.${ref.gameClass}`)
      expect(r.viaCatchAll).toBe(false)
      expect(r.qualifiedMismatch).toBe(false)
      expect(r.editor?.class).toBe(ref.class)
    },
  )

  it('lists every published bridge editor in its family dispatch order', () => {
    for (const bridge of schema.bridges ?? []) {
      for (const ref of bridge.editors) {
        const family = schema.families.find((f) => f.name === ref.family)!
        expect(family.dispatchOrder).toContain(ref.class)
      }
    }
  })
})
