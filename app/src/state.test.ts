import { describe, expect, it } from 'vitest'

import { emptyDoc, newNode, setAtPath, type Doc, type Node } from './state'

function doc(entry: Node): Doc {
  return { schemaHash: 'test', entries: [entry] }
}

describe('setAtPath', () => {
  it('creates a missing array when adding its first element', () => {
    const before = doc(newNode({ Ability: 'X' }))
    const after = setAtPath(before, [0, 'Effects', 0], newNode({ Class: 'X2Effect_Persistent' }))

    const effects = after.entries[0]?.['Effects'] as Node[] | undefined
    expect(effects).toHaveLength(1)
    expect(effects?.[0]?.['Class']).toBe('X2Effect_Persistent')
  })

  it('appends to an array that already exists', () => {
    const before = doc(newNode({ Ability: 'X', Costs: [newNode({ Class: 'A' })] }))
    const after = setAtPath(before, [0, 'Costs', 1], newNode({ Class: 'B' }))

    const costs = after.entries[0]?.['Costs'] as Node[]
    expect(costs.map((c) => c['Class'])).toEqual(['A', 'B'])
  })

  it('creates missing containers several levels deep', () => {
    const before = doc(newNode({ Ability: 'X', Effects: [newNode({ Class: 'E' })] }))
    const after = setAtPath(
      before,
      [0, 'Effects', 0, 'TargetConditions', 0],
      newNode({ Class: 'X2Condition_UnitProperty' }),
    )

    const effects = after.entries[0]?.['Effects'] as Node[]
    const conditions = effects[0]?.['TargetConditions'] as Node[] | undefined
    expect(conditions).toHaveLength(1)
    expect(conditions?.[0]?.['Class']).toBe('X2Condition_UnitProperty')
  })

  it('creates a missing object for a single nested slot', () => {
    const before = doc(newNode({ Ability: 'X' }))
    const after = setAtPath(before, [0, 'Cooldown', 'NumTurns'], 5)

    expect((after.entries[0]?.['Cooldown'] as Node)['NumTurns']).toBe(5)
  })

  it('removes an array element without disturbing its siblings', () => {
    const before = doc(
      newNode({ Ability: 'X', Costs: [newNode({ Class: 'A' }), newNode({ Class: 'B' })] }),
    )
    const after = setAtPath(before, [0, 'Costs', 0], undefined)

    expect((after.entries[0]?.['Costs'] as Node[]).map((c) => c['Class'])).toEqual(['B'])
  })

  it('removes a key when set to undefined', () => {
    const before = doc(newNode({ Ability: 'X', Hostility: 'eHostility_Offensive' }))
    const after = setAtPath(before, [0, 'Hostility'], undefined)

    expect(after.entries[0]).not.toHaveProperty('Hostility')
  })

  it('does not mutate the document it was given', () => {
    const before = doc(newNode({ Ability: 'X' }))
    const snapshot = JSON.stringify(before)
    setAtPath(before, [0, 'Effects', 0], newNode({ Class: 'E' }))

    expect(JSON.stringify(before)).toBe(snapshot)
  })

  it('leaves an unknown entry index alone rather than throwing', () => {
    const before = emptyDoc('test')
    expect(setAtPath(before, [9, 'Ability'], 'X')).toBe(before)
  })
})
