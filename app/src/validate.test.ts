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

describe('enum values', () => {
  const condition = (extra: Record<string, unknown>) =>
    docOf(newNode({ Ability: 'X', TargetConditions: [newNode({ Class: 'X2Condition_UnitProperty', Mode: 'eAEM_Merge', ...extra })] }))

  it('rejects a value that is not in a mod enum', () => {
    const doc = docOf(newNode({ Ability: 'X', CostMode: 'nonsense', Costs: [newNode({ Class: 'X2AbilityCost_Ammo', Mode: 'eACEM_Merge' })] }))
    expect(titles(doc)).toContain('nonsense is not a value of EAbilityCostEditMode')
  })

  it('rejects a value that is not in a game enum', () => {
    const issue = validate(docOf(newNode({ Ability: 'X', Hostility: 'eHostility_Bogus' })), indices).find((i) =>
      i.title.includes('EAbilityHostility'),
    )
    expect(issue?.severity).toBe('error')
    expect(issue?.detail).toContain('eHostility_Neutral')
  })

  it('checks enums inside game structs', () => {
    expect(titles(condition({ CheckAmmoData: newNode({ CheckType: 'eCheck_Sometimes', Value: 1 }) }))).toContain(
      'eCheck_Sometimes is not a value of EValueCheck',
    )
    expect(titles(condition({ CheckAmmoData: newNode({ CheckType: 'eCheck_Exact', Value: 1 }) }))).toEqual([])
  })

  it('accepts every known value', () => {
    expect(titles(docOf(newNode({ Ability: 'X', Hostility: 'eHostility_Neutral' })))).toEqual([])
  })
})

describe('array items', () => {
  const names = (items: string[]) => docOf(newNode({ Ability: 'X', AdditionalAbilitiesMode: 'eNAEM_Merge', AdditionalAbilities: items }))

  it('rejects an empty item', () => {
    expect(titles(names(['Blademaster', '']))).toContain('AdditionalAbilities has an empty item')
  })

  it('rejects a name item that is not a bare name', () => {
    expect(titles(names(['Bad Name']))).toContain('AdditionalAbilities item "Bad Name" is not a bare name')
  })

  it('rejects a string item the format cannot write', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        TargetConditions: [
          newNode({ Class: 'X2Condition_Biome', Mode: 'eAEM_Merge', AllowedBiomesMode: 'eNAEM_Merge', AllowedBiomes: ['Arid', 'Say "no"'] }),
        ],
      }),
    )
    expect(titles(doc)).toContain('AllowedBiomes item contains a character this format cannot represent')
  })

  it('accepts a string item with spaces', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        TargetConditions: [
          newNode({ Class: 'X2Condition_Biome', Mode: 'eAEM_Merge', AllowedBiomesMode: 'eNAEM_Merge', AllowedBiomes: ['Temperate Forest'] }),
        ],
      }),
    )
    expect(titles(doc).filter((t) => t.includes('AllowedBiomes'))).toEqual([])
  })
})

describe('arrays governed by a parent mode', () => {
  it('does not ask AdditionalCooldowns entries for a Mode they do not have', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Cooldown: newNode({
          Class: 'X2AbilityCooldown',
          AdditionalCooldownMode: 'eACEM_Merge',
          AdditionalCooldowns: [newNode({ AbilityName: 'A', NumTurns: 1 }), newNode({ AbilityName: 'B', NumTurns: 2 })],
        }),
      }),
    )
    expect(titles(doc).some((t) => t.includes('no Mode'))).toBe(false)
  })

  it('reports the parent mode default instead', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Cooldown: newNode({ Class: 'X2AbilityCooldown', AdditionalCooldowns: [newNode({ AbilityName: 'A', NumTurns: 1 })] }),
      }),
    )
    const issue = validate(doc, indices).find((i) => i.title === 'AdditionalCooldowns will replace the existing list')
    expect(issue?.severity).toBe('warning')
    expect(issue?.detail).toContain('AdditionalCooldownMode')
    expect(issue?.detail).toContain('eACEM_Replace')
  })

  it('does the same for BonusCharges and StatChange', () => {
    const charges = docOf(newNode({ Ability: 'X', Charges: newNode({ Class: 'X2AbilityCharges', BonusCharges: [newNode({ AbilityName: 'A', NumCharges: 1 })] }) }))
    expect(titles(charges)).toContain('BonusCharges will replace the existing list')

    const effects = docOf(
      newNode({
        Ability: 'X',
        Effects: [newNode({ Class: 'X2Effect_PersistentStatChange', Mode: 'eAEM_Merge', StatChange: [newNode({ StatType: 'eStat_Offense', StatAmount: 5 })] })],
      }),
    )
    expect(titles(effects)).toContain('StatChange will replace the existing list')
    expect(titles(effects).some((t) => t.includes('no Mode'))).toBe(false)
  })

  it('leaves AbilityEventListenerEdits alone, which edit in place by EventID', () => {
    const doc = docOf(
      newNode({ Ability: 'X', AbilityEventListenerEdits: [newNode({ EventID: 'A', Priority: 1 }), newNode({ EventID: 'B', Priority: 2 })] }),
    )
    expect(titles(doc)).toEqual([])
  })

  it('still reports a Costs entry without its own Mode', () => {
    const doc = docOf(newNode({ Ability: 'X', CostMode: 'eACEM_Merge', Costs: [newNode({ Class: 'X2AbilityCost_Ammo' })] }))
    expect(titles(doc)).toContain('Costs entry has no Mode, so the existing list will be cleared')
  })
})

describe('selectors', () => {
  const effects = (...entries: Node[]) => docOf(newNode({ Ability: 'X', Effects: entries }))

  it('warns that a selector is ignored under an explicit ReplaceAll', () => {
    const doc = effects(newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_ReplaceAll', Index: 1 }))
    const issue = validate(doc, indices).find((i) => i.title === 'Index=1 is ignored under eAEM_ReplaceAll')
    expect(issue?.severity).toBe('warning')
  })

  it('warns when the selector is ignored because Mode defaulted to ReplaceAll', () => {
    const doc = docOf(
      newNode({ Ability: 'X', CostMode: 'eACEM_Merge', Costs: [newNode({ Class: 'X2AbilityCost_Ammo', Index: 2 })] }),
    )
    const issue = validate(doc, indices).find((i) => i.title === 'Index=2 is ignored under eACEM_ReplaceAll')
    expect(issue?.detail).toContain('Mode is not set')
  })

  it('says the name wins when Index and a Match field are both set', () => {
    const doc = effects(newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_Merge', Index: 1, MatchEffectName: 'Burning' }))
    const issue = validate(doc, indices).find((i) => i.title === 'MatchEffectName takes precedence over Index')
    expect(issue?.severity).toBe('info')
  })

  it('is quiet for a selector under Merge or Remove', () => {
    expect(titles(effects(newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_Merge', Index: 1 })))).toEqual([])
    const triggers = docOf(newNode({ Ability: 'X', Triggers: [newNode({ Class: 'X2AbilityTrigger_EventListener', Mode: 'eAEM_Remove', MatchEventID: 'UnitMoveFinished' })] }))
    expect(titles(triggers)).toEqual([])
  })

  it('treats entries with different selectors as different targets', () => {
    const doc = effects(
      newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_Merge', Index: 0 }),
      newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_Merge', Index: 1 }),
    )
    expect(titles(doc).some((t) => t.includes('Two Effects entries'))).toBe(false)
  })
})

describe('duplicate effects', () => {
  it('treats a missing Slot as eAES_Target', () => {
    const doc = docOf(
      newNode({
        Ability: 'X',
        Effects: [
          newNode({ Class: 'X2Effect_Persistent', Mode: 'eAEM_Merge' }),
          newNode({ Class: 'X2Effect_Persistent', Slot: 'eAES_Target', Mode: 'eAEM_Merge' }),
        ],
      }),
    )
    expect(titles(doc)).toContain('Two Effects entries target X2Effect_Persistent')
  })
})

describe('creating an ability', () => {
  const blank = { Ability: 'SnapShot', Create: true }

  it('requires TargetStyle, ToHitCalc and Triggers on a blank ability', () => {
    const found = titles(docOf(newNode(blank)))
    expect(found).toContain('TargetStyle is required for a new ability')
    expect(found).toContain('ToHitCalc is required for a new ability')
    expect(found).toContain('Triggers are required for a new ability')
  })

  it('is satisfied once the three are given a Class', () => {
    const entry = newNode({
      ...blank,
      TargetStyle: newNode({ Class: 'X2AbilityTarget_Single' }),
      ToHitCalc: newNode({ Class: 'X2AbilityToHitCalc_StandardAim' }),
      Triggers: [newNode({ Class: 'X2AbilityTrigger_PlayerInput', Mode: 'eAEM_Merge' })],
    })
    const found = titles(docOf(entry))
    expect(found).not.toContain('TargetStyle is required for a new ability')
    expect(found).not.toContain('ToHitCalc is required for a new ability')
    expect(found).not.toContain('Triggers are required for a new ability')
  })

  it('does not require them for the passive preset, which installs its own', () => {
    expect(titles(docOf(newNode({ ...blank, Preset: 'eACP_Passive' })))).toEqual([])
  })

  it('does not require them for a copy, which has its source\u2019s', () => {
    expect(titles(docOf(newNode({ ...blank, CloneFrom: 'SwordSlice' })))).toEqual([])
  })

  it('flags a slot block without a Class as an error on a blank ability', () => {
    const entry = newNode({ ...blank, TargetStyle: newNode({ OnlyIncludeTargetsInsideWeaponRange: true }) })
    expect(titles(docOf(entry))).toContain('TargetStyle needs a Class on a new ability')
  })

  it('drops the destructive-default warnings on a blank ability', () => {
    const entry = newNode({
      ...blank,
      Preset: 'eACP_Passive',
      Costs: [newNode({ Class: 'X2AbilityCost_ActionPoints', NumPoints: 1 })],
      AdditionalAbilities: ['Blademaster'],
    })
    const found = titles(docOf(entry))
    expect(found).not.toContain('CostMode is not set, so every existing cost will be deleted')
    expect(found).not.toContain('Costs entry has no Mode, so the existing list will be cleared')
    expect(found).not.toContain("AdditionalAbilities will replace the ability's existing list")
  })

  it('keeps the destructive-default warnings on a copy', () => {
    const entry = newNode({
      ...blank,
      CloneFrom: 'SwordSlice',
      Costs: [newNode({ Class: 'X2AbilityCost_ActionPoints', NumPoints: 1 })],
    })
    expect(titles(docOf(entry))).toContain('CostMode is not set, so every existing cost will be deleted')
  })

  it('still rejects several mode-less entries on a blank ability', () => {
    const entry = newNode({
      ...blank,
      Preset: 'eACP_Passive',
      Effects: [
        newNode({ Class: 'X2Effect_Persistent', Slot: 'eAES_Target' }),
        newNode({ Class: 'X2Effect_ApplyWeaponDamage', Slot: 'eAES_Target' }),
      ],
    })
    expect(titles(docOf(entry))).toContain('2 of 2 Effects entries have no Mode \u2014 only the last will survive')
  })

  it('checks CloneFrom is a bare name and not the ability itself', () => {
    expect(titles(docOf(newNode({ ...blank, CloneFrom: 'Sword Slice' })))).toContain(
      '"Sword Slice" is not a valid ability name',
    )
    expect(titles(docOf(newNode({ ...blank, CloneFrom: 'SnapShot' })))).toContain('CloneFrom names the ability itself')
  })

  it('warns when CloneFrom or Preset appear without Create, or Preset with CloneFrom', () => {
    expect(titles(docOf(newNode({ Ability: 'SnapShot', CloneFrom: 'SwordSlice' })))).toContain(
      'CloneFrom does nothing without Create=true',
    )
    expect(titles(docOf(newNode({ Ability: 'SnapShot', Preset: 'eACP_Passive' })))).toContain(
      'Preset does nothing without Create=true',
    )
    expect(titles(docOf(newNode({ ...blank, CloneFrom: 'SwordSlice', Preset: 'eACP_Passive' })))).toContain(
      'Preset is ignored when CloneFrom is set',
    )
  })
})
