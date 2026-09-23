import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { describe, expect, it } from 'vitest'

import { emitEntry } from './emit'
import { buildIndices } from './schema'
import type { Schema } from './types'
import { newNode } from './state'

const schema = JSON.parse(
  readFileSync(resolve(import.meta.dirname, '..', '..', 'docs', 'schema.json'), 'utf-8'),
) as Schema
const indices = buildIndices(schema)

describe('emitEntry', () => {
  it('writes the guard immediately before its value', () => {
    const entry = newNode({
      Ability: 'SwordSlice',
      CostMode: 'eACEM_Merge',
      Costs: [newNode({ Class: 'X2AbilityCost_ActionPoints', Mode: 'eACEM_Merge', NumPoints: 1 })],
    })

    expect(emitEntry(entry, indices)).toBe(
      [
        '+AbilityEdits=( \\\\',
        '    Ability=SwordSlice, \\\\',
        '    CostMode=eACEM_Merge, \\\\',
        '    Costs=( \\\\',
        '        ( \\\\',
        '            Class="X2AbilityCost_ActionPoints", \\\\',
        '            Mode=eACEM_Merge, \\\\',
        '            SetNumPoints=true, \\\\',
        '            NumPoints=1 \\\\',
        '        ) \\\\',
        '    ) \\\\',
        ')',
      ].join('\n'),
    )
  })

  it('separates array elements with a comma after the closing paren', () => {
    const entry = newNode({
      Ability: 'SwordSlice',
      Costs: [
        newNode({ Class: 'X2AbilityCost_ActionPoints', NumPoints: 1 }),
        newNode({ Class: 'X2AbilityCost_Charges', NumCharges: 2 }),
      ],
    })

    const out = emitEntry(entry, indices)
    expect(out).toContain('        ), \\\\')
    expect(out).toContain('        ) \\\\\n    ) \\\\')
  })

  it('quotes strings, leaves names bare', () => {
    const entry = newNode({
      Ability: 'CombatProtocol',
      Effects: [newNode({ Class: 'X2Effect_ApplyWeaponDamage', Slot: 'eAES_Target' })],
    })

    const out = emitEntry(entry, indices)
    expect(out).toContain('Class="X2Effect_ApplyWeaponDamage"')
    expect(out).toContain('Ability=CombatProtocol')
    expect(out).toContain('Slot=eAES_Target')
  })

  it('forces a decimal point on floats', () => {
    const entry = newNode({
      Ability: 'SomeConeAbility',
      MultiTargetStyle: newNode({ ConeEndDiameter: 20, ConeLength: 28.5 }),
    })

    const out = emitEntry(entry, indices)
    expect(out).toContain('ConeEndDiameter=20.0')
    expect(out).toContain('ConeLength=28.5')
  })

  it('renders name arrays as a bare parenthesised list', () => {
    const entry = newNode({
      Ability: 'SwordSlice',
      AdditionalAbilities: ['Blademaster', 'Bladestorm'],
      AdditionalAbilitiesMode: 'eNAEM_Merge',
    })

    const out = emitEntry(entry, indices)
    expect(out).toContain('AdditionalAbilities=(Blademaster, Bladestorm)')
    expect(out).toContain('AdditionalAbilitiesMode=eNAEM_Merge')
  })

  it('nests a single struct without wrapping it in array parens', () => {
    const entry = newNode({
      Ability: 'AidProtocol',
      Cooldown: newNode({ Class: 'XComGame.X2AbilityCooldown_PerPlayerType', NumTurns: 9 }),
    })

    const out = emitEntry(entry, indices)
    expect(out).toContain('    Cooldown=( \\\\')
    expect(out).toContain('        Class="XComGame.X2AbilityCooldown_PerPlayerType", \\\\')
    expect(out).not.toContain('        ( \\\\')
  })

  it('emits keys in schema order, not insertion order', () => {
    const scrambled = newNode({ Costs: [newNode({ Class: 'X2AbilityCost_Ammo' })], Ability: 'X' })
    const out = emitEntry(scrambled, indices)
    expect(out.indexOf('Ability=X')).toBeLessThan(out.indexOf('Costs=('))
  })

  it('omits empty arrays and empty nested structs entirely', () => {
    const entry = newNode({ Ability: 'X', Costs: [], Cooldown: newNode({}) })
    expect(emitEntry(entry, indices)).toBe('+AbilityEdits=( \\\\\n    Ability=X \\\\\n)')
  })

  it('never emits internal bookkeeping keys', () => {
    expect(emitEntry(newNode({ Ability: 'X' }), indices)).not.toContain('_id')
  })

  it('ends every line but the last with the continuation marker', () => {
    const lines = emitEntry(newNode({ Ability: 'X' }), indices).split('\n')
    for (const line of lines.slice(0, -1)) expect(line.endsWith(' \\\\')).toBe(true)
    expect(lines.at(-1)).toBe(')')
  })
})
