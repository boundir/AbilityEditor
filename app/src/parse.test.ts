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

describe('reporting what cannot be mapped', () => {
  const errors = (source: string) =>
    parseConfig(source, indices).problems.filter((p) => p.severity === 'error').map((p) => p.title)

  it('reports a scalar where a struct literal is expected', () => {
    const titles = errors(
      '+AbilityEdits=(Ability=X, TargetConditions=((Class="X2Condition_UnitProperty", Mode=eAEM_Merge, SetCheckAmmoData=true, CheckAmmoData=5)))',
    )
    expect(titles).toContain('CheckAmmoData has the wrong shape')
  })

  it('reports plain values inside an array of structs', () => {
    const { doc, problems } = parseConfig(
      '+AbilityEdits=(Ability=X, TargetConditions=((Class="X2Condition_UnitProperty", Mode=eAEM_Merge, HourChecksMode=eNAEM_Merge, HourChecks=(1, (CheckType=eCheck_Exact, Value=2)))))',
      indices,
    )
    expect(problems.map((p) => p.title)).toContain('HourChecks item is not a CheckConfig')
    const condition = (doc!.entries[0]!['TargetConditions'] as Node[])[0]!
    expect(condition['HourChecks']).toHaveLength(1)
  })

  it('reports a struct literal where a plain list is expected', () => {
    expect(errors('+AbilityEdits=(Ability=X, AdditionalAbilitiesMode=eNAEM_Merge, AdditionalAbilities=((Foo=1)))')).toContain(
      'AdditionalAbilities item is not a name',
    )
  })

  it('reports a list where a scalar is expected', () => {
    expect(errors('+AbilityEdits=(Ability=X, SetTriggerChance=true, TriggerChance=(1, 2))')).toContain(
      'TriggerChance has the wrong shape',
    )
  })

  it('reports a value that is not a number', () => {
    const { doc, problems } = parseConfig('+AbilityEdits=(Ability=X, SetTriggerChance=true, TriggerChance=abc)', indices)
    expect(problems.map((p) => p.title)).toContain('TriggerChance is not a number')
    expect(doc!.entries[0]!['TriggerChance']).toBe(0)
  })

  it('reports a backslash-escaped quote instead of truncating silently', () => {
    const { problems } = parseConfig(
      '+AbilityEdits=(Ability=X, SetFriendlyName=true, FriendlyName="Say \\"hi\\"")',
      indices,
    )
    expect(problems.map((p) => p.title)).toContain('Backslash before a quote')
  })

  it('reports text the game would stop reading at', () => {
    const { doc, problems } = parseConfig(
      '+AbilityEdits=(Ability=X, Cooldown=(SetNumTurns=true, NumTurns=3) SetIsPassive=true, IsPassive=true)',
      indices,
    )
    expect(problems.some((p) => p.title.startsWith('Unexpected text: SetIsPassive'))).toBe(true)
    expect((doc!.entries[0]!['Cooldown'] as Node)['NumTurns']).toBe(3)
  })

  it('reports a key without a value', () => {
    expect(errors('+AbilityEdits=(Ability=X, Hostility, SetIsPassive=true, IsPassive=true)')).toContain('Hostility has no value')
  })

  it('reads an empty literal as an empty struct', () => {
    const { doc } = parseConfig(
      '+AbilityEdits=(Ability=X, TargetConditions=((Class="X2Condition_UnitProperty", Mode=eAEM_Merge, SetCheckAmmoData=true, CheckAmmoData=())))',
      indices,
    )
    const condition = (doc!.entries[0]!['TargetConditions'] as Node[])[0]!
    expect(strip(condition['CheckAmmoData'])).toEqual({})
  })
})

describe('round trip', () => {
  const cases: Node[] = [
    newNode({
      Ability: 'X',
      TargetConditions: [
        newNode({
          Class: 'X2Condition_UnitProperty',
          Mode: 'eAEM_Merge',
          CheckAmmoData: newNode({ CheckType: 'eCheck_Exact', Value: 1 }),
          HourChecksMode: 'eNAEM_Merge',
          HourChecks: [newNode({ CheckType: 'eCheck_Exact', Value: 2 }), newNode({ CheckType: 'eCheck_LessThan', Value: 5 })],
          AllowedBiomesMode: 'eNAEM_Merge',
          AllowedBiomes: ['Arid', 'Temperate Forest'],
        }),
      ],
    }),
    newNode({
      Ability: 'X',
      Effects: [
        newNode({
          Class: 'X2Effect_TemplarFocus',
          Mode: 'eAEM_Merge',
          FocusLevelsMode: 'eNAEM_Merge',
          FocusLevels: [
            newNode({
              StatChanges: [newNode({ StatType: 'eStat_Offense', StatAmount: 10.5, ModOp: 'MODOP_Addition' })],
              ArmorMitigation: 1,
            }),
          ],
        }),
      ],
    }),
    newNode({
      Ability: 'X',
      Effects: [
        newNode({
          Class: 'X2Effect_ToHitModifier',
          Mode: 'eAEM_Merge',
          Index: 1,
          EffectHitModifiers: [
            newNode({
              MatchToHit: 'X2AbilityToHitCalc_StandardAim',
              Modifier: newNode({ ModType: 'eHit_Success', Value: 10, Reason: 'Tuned' }),
              bApplyToMelee: true,
              AbilitiesAppliedTo: ['SwordSlice', 'Rend'],
            }),
          ],
        }),
      ],
    }),
    newNode({ Ability: 'SwordSlice' }),
    newNode({ Ability: 'SwordSlice_Heavy', Create: true, CloneFrom: 'SwordSlice', Preset: 'eACP_Standard' }),
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
