import { hasUnrepresentableChars, isBareName, nestedStructName } from './emit'
import type { Indices } from './schema'
import { bridgeOf, bridgeRequirements, qualifiedClassName, resolveEditor } from './schema'
import { configKeys, type Doc, type Node, type Path } from './state'

/**
 * Config validation.
 */

export type Severity = 'error' | 'warning'

export interface Issue {
  severity: Severity
  path: Path
  title: string
  detail: string
}

interface EntryContext {
  blank: boolean
}

/** Array families */
const ARRAY_FAMILY_KEYS = new Set(['Costs', 'Effects', 'Triggers'])

const CONDITION_KEYS = new Set([
  'ShooterConditions',
  'TargetConditions',
  'MultiTargetConditions',
  'ApplyDamageModConditions',
  'LethalDamageConditions',
  'ToHitConditions',
])

/** Single-object slots */
const SINGLE_OBJECT_KEYS = new Set([
  'Cooldown',
  'Charges',
  'ToHitCalc',
  'ToHitOwnerOnMissCalc',
  'TargetStyle',
  'MultiTargetStyle',
])

function familyForKey(indices: Indices, key: string, structName: string): string | undefined {
  if (CONDITION_KEYS.has(key)) return 'Conditions'
  const struct = indices.structByName.get(structName)
  const field = struct?.fields.find((f) => f.name === key)
  if (!field) return undefined
  const child = nestedStructName(field.type)
  return child ? indices.familyByStruct.get(child)?.name : undefined
}

function entryContext(entry: Node): EntryContext {
  const cloneFrom = entry['CloneFrom']
  const hasClone = typeof cloneFrom === 'string' && cloneFrom.trim() !== ''
  return { blank: entry['Create'] === true && !hasClone }
}

export function validate(doc: Doc, indices: Indices): Issue[] {
  const issues: Issue[] = []

  doc.entries.forEach((entry, index) => {
    const context = entryContext(entry)
    validateNode(entry, 'AbilityEdit', [index], indices, issues, context)

    const ability = entry['Ability']
    if (typeof ability !== 'string' || ability.trim() === '') {
      issues.push({
        severity: 'error',
        path: [index],
        title: 'Ability is required',
        detail: 'Every entry needs the template name of the ability it edits or creates, e.g. SwordSlice.',
      })
    } else if (!isBareName(ability)) {
      issues.push({
        severity: 'error',
        path: [index],
        title: `"${ability}" is not a valid ability name`,
        detail:
          'Ability is a name, so it must be a bare token: letters, digits and underscores, not starting with a digit.',
      })
    }

    checkCreation(entry, index, context, issues)
  })

  return issues
}

function checkCreation(entry: Node, index: number, context: EntryContext, issues: Issue[]): void {
  const creating = entry['Create'] === true
  const cloneFrom = entry['CloneFrom']
  const hasClone = typeof cloneFrom === 'string' && cloneFrom.trim() !== ''
  const preset = entry['Preset']
  const hasPreset = typeof preset === 'string' && preset !== ''

  if (hasClone && !isBareName(cloneFrom)) {
    issues.push({
      severity: 'error',
      path: [index, 'CloneFrom'],
      title: `"${cloneFrom}" is not a valid ability name`,
      detail: 'CloneFrom is a template name: letters, digits and underscores, not starting with a digit.',
    })
  }

  if (hasClone && cloneFrom === entry['Ability']) {
    issues.push({
      severity: 'error',
      path: [index, 'CloneFrom'],
      title: 'CloneFrom names the ability itself',
      detail: 'A new ability cannot be a copy of itself. Name the existing ability to copy.',
    })
  }

  if (!creating && (hasClone || hasPreset)) {
    issues.push({
      severity: 'warning',
      path: [index, hasClone ? 'CloneFrom' : 'Preset'],
      title: `${hasClone ? 'CloneFrom' : 'Preset'} does nothing without Create=true`,
      detail: 'Both only apply when the entry creates the ability. Set Create=true, or remove them.',
    })
  }

  if (creating && hasClone && hasPreset) {
    issues.push({
      severity: 'warning',
      path: [index, 'Preset'],
      title: 'Preset is ignored when CloneFrom is set',
      detail: 'A copy takes its game-state and visualization functions from the source. Preset only shapes a blank ability.',
    })
  }

  if (!context.blank || preset === 'eACP_Passive') return

  for (const key of ['TargetStyle', 'ToHitCalc'] as const) {
    const slot = entry[key]
    const cls = slot && typeof slot === 'object' && !Array.isArray(slot) ? (slot as Node)['Class'] : undefined
    const hasClass = typeof cls === 'string' && cls.trim() !== ''
    if (!hasClass) {
      issues.push({
        severity: 'error',
        path: slot ? [index, key] : [index],
        title: `${key} is required for a new ability`,
        detail: `A blank ability has no ${key}. Add ${key}=(Class="...") - the game refuses to validate an ability without a target style, and one without a to-hit calc fails when activated. The eACP_Passive preset installs both.`,
      })
    }
  }

  const triggers = entry['Triggers']
  if (!Array.isArray(triggers) || triggers.length === 0) {
    issues.push({
      severity: 'error',
      path: [index],
      title: 'Triggers are required for a new ability',
      detail: 'A blank ability has no triggers, and the game refuses to validate one without any. Add Triggers=((Class="X2AbilityTrigger_PlayerInput", Mode=eAEM_Merge)) or another trigger. The eACP_Passive preset installs one.',
    })
  }
}

function validateNode(
  node: Node,
  structName: string,
  path: Path,
  indices: Indices,
  issues: Issue[],
  context: EntryContext,
): void {
  const struct = indices.structByName.get(structName)
  if (!struct) return

  const keys = configKeys(node)

  for (const key of keys) {
    const field = struct.fields.find((f) => f.name === key)
    if (!field) continue
    const value = node[key]
    if (value === undefined) continue

    if (typeof value === 'string' && field.type === 'string' && hasUnrepresentableChars(value)) {
      issues.push({
        severity: 'error',
        path: [...path, key],
        title: `${key} contains a character this format cannot represent`,
        detail:
          'The .ini dialect has no escaping, so a value containing " ( ) , or a newline cannot be written.',
      })
    }

    if (typeof value === 'string' && field.type === 'name' && value !== '' && !isBareName(value)) {
      issues.push({
        severity: 'error',
        path: [...path, key],
        title: `${key} must be a bare name`,
        detail: 'Letters, digits and underscores only, not starting with a digit.',
      })
    }

    const childStruct = nestedStructName(field.type)

    if (childStruct && Array.isArray(value) && field.type.startsWith('array<')) {
      const children = value as Node[]
      checkArrayModes(node, key, children, path, indices, issues, context)
      checkDuplicateClasses(key, children, path, issues)

      children.forEach((child, childIndex) => {
        const childPath = [...path, key, childIndex]
        validateNode(child, childStruct, childPath, indices, issues, context)
        checkClassResolution(child, key, structName, childPath, indices, issues)
      })
      continue
    }

    // A single nested struct.
    if (childStruct && value && typeof value === 'object' && !Array.isArray(value)) {
      const child = value as Node
      const childPath = [...path, key]
      validateNode(child, childStruct, childPath, indices, issues, context)

      if (SINGLE_OBJECT_KEYS.has(key)) checkSingleObjectSlot(child, key, childPath, issues, context)
      continue
    }

    if (Array.isArray(value) && field.modeField && !keys.includes(field.modeField) && !context.blank) {
      issues.push({
        severity: 'warning',
        path: [...path, key],
        title: `${key} will replace the ability's existing list`,
        detail: `${field.modeField} defaults to the first enum value, which is a Replace. Set it to Merge to add to the existing values instead.`,
      })
    }

    if (value === 'eNAEM_AddOnly') {
      issues.push({
        severity: 'warning',
        path: [...path, key],
        title: `${key}=eNAEM_AddOnly does not append`,
        detail:
          'For name arrays, AddOnly writes your values only when the target array is currently empty. To add without removing, use eNAEM_Merge.',
      })
    }
  }

  checkRemoveCharges(node, structName, path, keys, issues)
}

function checkArrayModes(
  parent: Node,
  key: string,
  children: Node[],
  path: Path,
  indices: Indices,
  issues: Issue[],
  context: EntryContext,
): void {
  const family = familyForKey(indices, key, 'AbilityEdit')

  if (key === 'Costs' && parent['CostMode'] === undefined && children.length > 0 && !context.blank) {
    issues.push({
      severity: 'error',
      path: [...path, key],
      title: 'CostMode is not set, so every existing cost will be deleted',
      detail:
        'Omitting CostMode defaults it to eACEM_ReplaceAll, which clears the ability’s entire cost list and keeps only what is listed here. Set CostMode=eACEM_Merge unless that is genuinely what you want.',
    })
  }

  const missingMode = children.filter((child) => child['Mode'] === undefined)
  if (missingMode.length === 0) {
    return
  }

  // On a blank ability a single Replace has nothing to clear; several entries still fight each other.
  if (children.length === 1 && context.blank) {
    return
  }

  const severity: Severity = children.length > 1 ? 'error' : 'warning'
  issues.push({
    severity,
    path: [...path, key],
    title:
      children.length > 1
        ? `${missingMode.length} of ${children.length} ${key} entries have no Mode — only the last will survive`
        : `${key} entry has no Mode, so the existing list will be cleared`,
    detail:
      children.length > 1
        ? 'Mode defaults to a Replace, and each entry re-clears the array before adding itself. Set Mode on every entry, normally to Merge.'
        : `Mode defaults to the first enum value, which clears the ${family ?? key} array before adding this entry. Set it to Merge to edit in place instead.`,
  })
}

function checkDuplicateClasses(key: string, children: Node[], path: Path, issues: Issue[]): void {
  const seen = new Map<string, number>()

  children.forEach((child, index) => {
    const cls = child['Class']
    if (typeof cls !== 'string' || cls === '') return
    // Effects are additionally keyed by slot.
    const slot = typeof child['Slot'] === 'string' ? child['Slot'] : ''
    const composite = `${cls}\u0000${slot}`

    const first = seen.get(composite)
    if (first !== undefined) {
      issues.push({
        severity: 'error',
        path: [...path, key, index],
        title: `Two ${key} entries target ${cls}`,
        detail:
          'Entries are matched by exact class equality, so the second edits whatever the first just created rather than a separate object. Merge them into one entry.',
      })
    } else {
      seen.set(composite, index)
    }
  })
}

function checkClassResolution(
  child: Node,
  key: string,
  parentStruct: string,
  path: Path,
  indices: Indices,
  issues: Issue[],
): void {
  const cls = child['Class']
  const family = familyForKey(indices, key, parentStruct)

  if (typeof cls !== 'string' || cls.trim() === '') {
    if (ARRAY_FAMILY_KEYS.has(key) || CONDITION_KEYS.has(key)) {
      issues.push({
        severity: 'error',
        path: [...path, 'Class'],
        title: 'Class is empty',
        detail:
          'Without a class there is nothing to match against, so the entry falls back to the family base class and adds a useless object.',
      })
    }
    return
  }

  if (!family) return
  const { editor, viaCatchAll, qualifiedMismatch } = resolveEditor(indices, family, cls)

  if (editor && qualifiedMismatch) {
    issues.push({
      severity: 'error',
      path: [...path, 'Class'],
      title: `${cls} must be package-qualified`,
      detail: `${editor.gameClass} lives in the ${editor.package} package. A bare name is looked up in XComGame and never matches, so this entry would add a useless object. Write Class="${qualifiedClassName(editor)}".`,
    })
    return
  }

  const bridge = bridgeOf(indices, editor)
  if (bridge && !viaCatchAll) {
    const fallback = editor?.extends ? ` and the entry falls back to ${editor.extends}` : ''
    issues.push({
      severity: 'warning',
      path: [...path, 'Class'],
      title: `${cls} needs the ${bridge.displayName} bridge mod`,
      detail: `This class is only editable with ${bridgeRequirements(bridge)} installed. Without them the ${editor?.gameClass}-specific fields are skipped${fallback}.`,
    })
    return
  }

  if (!viaCatchAll) return

  const catchAll = indices.catchAllByFamily.get(family)
  const sharedCount = catchAll?.fields.length ?? 0

  issues.push({
    severity: 'warning',
    path: [...path, 'Class'],
    title: `No dedicated editor for ${cls}`,
    detail:
      sharedCount === 0
        ? `Nothing in the ${family} family will apply to it: the shared field set is empty, so only Class and Mode do anything.`
        : `Only the ${sharedCount} shared ${family} fields will apply. Class-specific fields will be ignored.`,
  })
}

function checkSingleObjectSlot(
  child: Node,
  key: string,
  path: Path,
  issues: Issue[],
  context: EntryContext,
): void {
  const cls = child['Class']
  const hasClass = typeof cls === 'string' && cls.trim() !== ''
  const otherKeys = configKeys(child).filter((k) => k !== 'Class')

  if (!hasClass && otherKeys.length > 0) {
    if (context.blank) {
      issues.push({
        severity: 'error',
        path,
        title: `${key} needs a Class on a new ability`,
        detail: `A blank ability has no ${key} to edit, so without a Class this block does nothing. Name the Class to create one.`,
      })
      return
    }

    issues.push({
      severity: 'warning',
      path,
      title: `${key} edits whatever is already there`,
      detail: `With no Class this edits the ability’s existing ${key} in place — and does nothing at all, silently, if the ability has none. Name a Class to create one.`,
    })
    return
  }

  if (hasClass && otherKeys.length > 0 && !context.blank) {
    issues.push({
      severity: 'warning',
      path,
      title: `${key} may be replaced rather than edited`,
      detail: `If the ability’s current ${key} is not exactly ${String(cls)}, it is replaced by a fresh instance — and every field you have not set here reverts to that class’s defaults, not the ability’s old values.`,
    })
  }
}

function checkRemoveCharges(
  node: Node,
  structName: string,
  path: Path,
  keys: string[],
  issues: Issue[],
): void {
  if (structName !== 'ChargesEdit') return
  if (node['RemoveCharges'] !== true) return

  const others = keys.filter((k) => k !== 'RemoveCharges')
  if (others.length === 0) return

  issues.push({
    severity: 'warning',
    path,
    title: 'RemoveCharges ignores the rest of this block',
    detail: `RemoveCharges=true removes the charges object and returns immediately, so ${others.join(', ')} will have no effect.`,
  })
}
