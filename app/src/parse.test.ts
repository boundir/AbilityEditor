import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { describe, expect, it } from 'vitest'

import { emit, emitEntry } from './emit'
import { parseConfig } from './parse'
import { buildIndices } from './schema'
import type { Schema } from './types'
import { newNode, type Node } from './state'

const schema = JSON.parse(
  readFileSync(resolve(import.meta.dirname, '..', '..', 'docs', 'schema.json'), 'utf-8'),
) as Schema
const indices = buildIndices(schema)

function strip(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(strip)
  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value as Node)
        .filter(([key]) => !key.startsWith('_'))
        .map(([key, item]) => [key, strip(item)]),
    )
  }
  return value
}

describe('parseConfig', () => {
  it('reads a documented example back into entries', () => {
    const source = `
[AbilityEditor.X2DLCInfo_AbilityEditor]

+AbilityEdits=( \\\\
    Ability=SwordSlice, \\\\
    CostMode=eACEM_Merge, \\\\
    Costs=( \\\\
        ( \\\\
            Class="X2AbilityCost_ActionPoints", \\\\
            Mode=eACEM_Merge, \\\\
            SetNumPoints=true, \\\\
            NumPoints=1, \\\\
            SetConsumeAllPoints=true, \\\\
            ConsumeAllPoints=false \\\\
        ) \\\\
    ) \\\\
)
`
    const { doc, problems } = parseConfig(source, indices)

    expect(problems.filter((p) => p.severity === 'error')).toEqual([])
    expect(doc?.entries).toHaveLength(1)

    const entry = doc!.entries[0]!
    expect(entry['Ability']).toBe('SwordSlice')
    expect(entry['CostMode']).toBe('eACEM_Merge')

    const costs = entry['Costs'] as Node[]
    expect(costs).toHaveLength(1)
    expect(costs[0]!['Class']).toBe('X2AbilityCost_ActionPoints')
    expect(costs[0]!['NumPoints']).toBe(1)
    expect(costs[0]!['ConsumeAllPoints']).toBe(false)
  })

  it('does not carry Set guards into state', () => {
    const { doc } = parseConfig('+AbilityEdits=(Ability=X, SetHostility=true, Hostility=eHostility_Neutral)', indices)
    const entry = doc!.entries[0]!
    expect(entry['Hostility']).toBe('eHostility_Neutral')
    expect(entry).not.toHaveProperty('SetHostility')
  })

  it('reads several entries', () => {
    const source = `
+AbilityEdits=(Ability=A)
+AbilityEdits=(Ability=B)
`
    expect(parseConfig(source, indices).doc?.entries.map((e) => e['Ability'])).toEqual(['A', 'B'])
  })

  it('reads name arrays', () => {
    const { doc } = parseConfig(
      '+AbilityEdits=(Ability=X, AdditionalAbilities=(Blademaster, Bladestorm), AdditionalAbilitiesMode=eNAEM_Merge)',
      indices,
    )
    expect(doc!.entries[0]!['AdditionalAbilities']).toEqual(['Blademaster', 'Bladestorm'])
  })

  it('reads a single nested struct', () => {
    const { doc } = parseConfig(
      '+AbilityEdits=(Ability=X, Cooldown=(Class="X2AbilityCooldown", SetNumTurns=true, NumTurns=5))',
      indices,
    )
    const cooldown = doc!.entries[0]!['Cooldown'] as Node
    expect(cooldown['Class']).toBe('X2AbilityCooldown')
    expect(cooldown['NumTurns']).toBe(5)
  })

  it('tolerates a single backslash continuation', () => {
    const source = '+AbilityEdits=( \\\n    Ability=X \\\n)'
    expect(parseConfig(source, indices).doc?.entries[0]?.['Ability']).toBe('X')
  })

  it('ignores comments', () => {
    const source = '; a comment\n+AbilityEdits=(Ability=X) ; trailing\n'
    const { doc, problems } = parseConfig(source, indices)
    expect(doc?.entries[0]?.['Ability']).toBe('X')
    expect(problems.filter((p) => p.severity === 'error')).toEqual([])
  })
})

describe('linting an existing config', () => {
  it('reports a misspelled key, which the game drops without logging', () => {
    const { problems } = parseConfig('+AbilityEdits=(Ability=X, Hostilty=eHostility_Neutral)', indices)
    const issue = problems.find((p) => p.title.includes('Hostilty'))
    expect(issue?.severity).toBe('error')
  })

  it('reports a value written without its Set guard', () => {
    const { problems, doc } = parseConfig('+AbilityEdits=(Ability=X, Hostility=eHostility_Neutral)', indices)
    const issue = problems.find((p) => p.title === 'Hostility was being ignored')
    expect(issue?.severity).toBe('warning')
    expect(doc!.entries[0]!['Hostility']).toBe('eHostility_Neutral')
  })

  it('drops a value whose guard is explicitly false', () => {
    const { problems, doc } = parseConfig(
      '+AbilityEdits=(Ability=X, SetHostility=false, Hostility=eHostility_Neutral)',
      indices,
    )
    expect(doc!.entries[0]).not.toHaveProperty('Hostility')
    expect(problems.some((p) => p.title.includes('SetHostility=false'))).toBe(true)
  })

  it('reports a guard with no value beside it', () => {
    const { problems, doc } = parseConfig('+AbilityEdits=(Ability=X, SetTriggerChance=true)', indices)
    expect(problems.some((p) => p.title.includes('with no TriggerChance'))).toBe(true)
    expect(doc!.entries[0]!['TriggerChance']).toBe(0)
  })

  it('flags a bare AbilityEdits= that would wipe every other mod’s entries', () => {
    const { problems } = parseConfig('AbilityEdits=(Ability=X)', indices)
    const issue = problems.find((p) => p.title.includes('without a leading +'))
    expect(issue?.severity).toBe('error')
  })

  it('says so when there is nothing to read', () => {
    const { doc, problems } = parseConfig('[SomeSection]\nFoo=Bar', indices)
    expect(doc).toBeNull()
    expect(problems[0]?.title).toBe('No +AbilityEdits entries found')
  })
})

describe('round trip', () => {
  const cases: Node[] = [
    newNode({ Ability: 'SwordSlice' }),
    newNode({
      Ability: 'SwordSlice',
      CostMode: 'eACEM_Merge',
      Costs: [
        newNode({ Class: 'X2AbilityCost_ActionPoints', Mode: 'eACEM_Merge', NumPoints: 1, ConsumeAllPoints: false }),
        newNode({ Class: 'X2AbilityCost_Charges', Mode: 'eACEM_Merge', NumCharges: 2 }),
      ],
    }),
    newNode({
      Ability: 'CombatProtocol',
      Effects: [
        newNode({
          Class: 'X2Effect_ApplyWeaponDamage',
          Slot: 'eAES_Target',
          Mode: 'eAEM_Merge',
          WeaponDamageValue: newNode({ Damage: 3, Spread: 0 }),
        }),
      ],
      TargetConditions: [
        newNode({ Class: 'X2Condition_UnitProperty', Mode: 'eAEM_Merge', ExcludeOrganic: true }),
      ],
    }),
    newNode({
      Ability: 'SomeConeAbility',
      MultiTargetStyle: newNode({ ConeEndDiameter: 20, ConeLength: 28.5 }),
      AdditionalAbilities: ['Blademaster'],
      AdditionalAbilitiesMode: 'eNAEM_Merge',
    }),
  ]

  it.each(cases.map((entry, index) => [index, entry] as const))(
    'parse(emit(entry)) === entry  [case %i]',
    (_index, entry) => {
      const text = emitEntry(entry, indices)
      const { doc, problems } = parseConfig(text, indices)

      expect(problems.filter((p) => p.severity === 'error')).toEqual([])
      expect(strip(doc!.entries[0]!)).toEqual(strip(entry))
    },
  )

  it('is stable over a second pass', () => {
    const doc = { schemaHash: schema.sourceHash, entries: cases }
    const once = emit(doc, indices)
    const reparsed = parseConfig(once, indices).doc!
    expect(emit(reparsed, indices)).toBe(once)
  })
})
