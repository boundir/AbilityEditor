import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { describe, expect, it } from 'vitest'

import { buildIndices } from './schema'
import type { Schema } from './types'
import { newNode, type Doc, type Node } from './state'
import { validate } from './validate'

/**
 * Runs against the real docs/schema.json.
 */

const schema = JSON.parse(
  readFileSync(resolve(import.meta.dirname, '..', '..', 'docs', 'schema.json'), 'utf-8'),
) as Schema
const indices = buildIndices(schema)

function docOf(...entries: Node[]): Doc {
  return { schemaHash: schema.sourceHash, entries }
}

function titles(doc: Doc): string[] {
  return validate(doc, indices).map((i) => i.title)
}

describe('the schema this app is built against', () => {
  it('has the nine families the UI expects', () => {
    expect(schema.families).toHaveLength(9)
  })

  it('gives every family a catch-all, so an unknown class always resolves', () => {
    for (const family of schema.families) {
      expect(family.editors.some((e) => e.catchAll)).toBe(true)
    }
  })

  it('still has an empty shared field set for Conditions', () => {
    const conditions = indices.catchAllByFamily.get('Conditions')
    expect(conditions?.fields).toHaveLength(0)
  })
})

describe('required fields', () => {
  it('flags a missing Ability', () => {
    expect(titles(docOf(newNode({ Ability: '' })))).toContain('Ability is required')
  })

  it('flags an Ability that is not a bare name', () => {
    expect(titles(docOf(newNode({ Ability: 'Sword Slice' })))).toContain(
      '"Sword Slice" is not a valid ability name',
    )
  })

  it('accepts a well-formed entry without complaint', () => {
    expect(titles(docOf(newNode({ Ability: 'SwordSlice' })))).toEqual([])
  })
})

describe('destructive mode defaults', () => {
  it('treats Costs without CostMode as an error, not a warning', () => {
    const doc = docOf(
      newNode({
        Ability: 'SwordSlice',
        Costs: [newNode({ Class: 'X2AbilityCost_ActionPoints', Mode: 'eACEM_Merge' })],
      }),
    )
    const issue = validate(doc, indices).find((i) =>
      i.title.startsWith('CostMode is not set'),
    )
    expect(issue?.severity).toBe('error')
  })

  it('escalates when several entries each default to Replace', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        CostMode: 'eACEM_Merge',
        Costs: [
          newNode({ Class: 'X2AbilityCost_ActionPoints' }),
          newNode({ Class: 'X2AbilityCost_Ammo' }),
        ],
      }),
    )
    const issue = validate(doc, indices).find((i) => i.title.includes('only the last will survive'))
    expect(issue?.severity).toBe('error')
  })

  it('warns once when a single entry omits its Mode', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        CostMode: 'eACEM_Merge',
        Costs: [newNode({ Class: 'X2AbilityCost_Ammo' })],
      }),
    )
    const issue = validate(doc, indices).find((i) => i.title.includes('no Mode'))
    expect(issue?.severity).toBe('warning')
  })

  it('warns that eNAEM_AddOnly does not append', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        AdditionalAbilities: ['Blademaster'],
        AdditionalAbilitiesMode: 'eNAEM_AddOnly',
      }),
    )
    expect(titles(doc)).toContain('AdditionalAbilitiesMode=eNAEM_AddOnly does not append')
  })
})

describe('class matching', () => {
  it('rejects two entries targeting the same class and slot', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        CostMode: 'eACEM_Merge',
        Costs: [
          newNode({ Class: 'X2AbilityCost_Ammo', Mode: 'eACEM_Merge' }),
          newNode({ Class: 'X2AbilityCost_Ammo', Mode: 'eACEM_Merge' }),
        ],
      }),
    )
    const issue = validate(doc, indices).find((i) => i.title.includes('Two Costs entries'))
    expect(issue?.severity).toBe('error')
  })

  it('allows the same effect class in two different slots', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Effects: [
          newNode({ Class: 'X2Effect_Persistent', Slot: 'eAES_Target', Mode: 'eAEM_Merge' }),
          newNode({ Class: 'X2Effect_Persistent', Slot: 'eAES_Shooter', Mode: 'eAEM_Merge' }),
        ],
      }),
    )
    expect(titles(doc).some((t) => t.includes('Two Effects entries'))).toBe(false)
  })

  it('rejects an empty Class in an array family', () => {
    const doc = docOf(
      newNode({ Ability: 'X', CostMode: 'eACEM_Merge', Costs: [newNode({ Mode: 'eACEM_Merge' })] }),
    )
    expect(titles(doc)).toContain('Class is empty')
  })

  it('warns when a class has no dedicated editor', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        CostMode: 'eACEM_Merge',
        Costs: [newNode({ Class: 'MyMod.X2AbilityCost_Morale', Mode: 'eACEM_Merge' })],
      }),
    )
    expect(titles(doc)).toContain('No dedicated editor for MyMod.X2AbilityCost_Morale')
  })

  it('resolves a package-qualified name to its bare class', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        CostMode: 'eACEM_Merge',
        Costs: [newNode({ Class: 'XComGame.X2AbilityCost_Ammo', Mode: 'eACEM_Merge' })],
      }),
    )
    expect(titles(doc).some((t) => t.startsWith('No dedicated editor'))).toBe(false)
  })
})

describe('single-object slots', () => {
  it('warns that omitting Class edits in place and may be a silent no-op', () => {
    const doc = docOf(newNode({ Ability: 'X', Cooldown: newNode({ NumTurns: 3 }) }))
    expect(titles(doc)).toContain('Cooldown edits whatever is already there')
  })

  it('warns that naming a different Class resets unset fields', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Cooldown: newNode({ Class: 'X2AbilityCooldown_PerPlayerType', NumTurns: 9 }),
      }),
    )
    expect(titles(doc)).toContain('Cooldown may be replaced rather than edited')
  })
})

describe('unrepresentable values', () => {
  it('rejects a string containing characters the format cannot escape', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Effects: [
          newNode({
            Class: 'X2Effect_Persistent',
            Mode: 'eAEM_Merge',
            FriendlyName: 'He said "no", loudly',
          }),
        ],
      }),
    )
    const issue = validate(doc, indices).find((i) => i.title.includes('cannot represent'))
    expect(issue?.severity).toBe('error')
  })
})
