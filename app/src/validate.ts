import { hasUnrepresentableChars, isBareName } from './emit'
import type { Indices, StructField } from './schema'
import {
  bridgeOf,
  bridgeRequirements,
  elementType,
  enumOf,
  isArrayType,
  qualifiedClassName,
  resolveEditor,
  structOf,
} from './schema'
import { configKeys, type Doc, type Node, type Path } from './state'

/**
 * Config validation.
 */

export type Severity = 'error' | 'warning' | 'info'

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

/** Selector fields that pick which object of a class an array entry edits. */
const MATCH_KEYS = ['MatchEffectName', 'MatchEventID'] as const

function familyForKey(indices: Indices, key: string, structName: string): string | undefined {
  if (CONDITION_KEYS.has(key)) {
    return 'Conditions'
  }
  const struct = indices.structByName.get(structName)
  const field = struct?.fields.find((f) => f.name === key)
  if (!field) {
    return undefined
  }
  const child = structOf(indices, field.type)
  return child ? indices.familyByStruct.get(child.name)?.name : undefined
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

  if (!context.blank || preset === 'eACP_Passive') {
    return
  }

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
  if (!struct) {
    return
  }

  const keys = configKeys(node)

  for (const key of keys) {
    const field = struct.fields.find((f) => f.name === key)
    if (!field) {
      continue
    }
    const value = node[key]
    if (value === undefined) {
      continue
    }

    const fieldPath = [...path, key]
    const child = structOf(indices, field.type)
    const isArray = isArrayType(field.type)

    if (child && isArray && Array.isArray(value)) {
      const children = value as Node[]
      checkArrayModes(node, key, field, child.name, children, path, indices, issues, context)
      checkDuplicateClasses(key, children, path, indices, issues)

      children.forEach((item, childIndex) => {
        const childPath = [...fieldPath, childIndex]
        validateNode(item, child.name, childPath, indices, issues, context)
        checkClassResolution(item, key, structName, childPath, indices, issues)
        checkSelectors(item, child.name, childPath, indices, issues)
      })
      continue
    }

    // A single nested struct.
    if (child && value && typeof value === 'object' && !Array.isArray(value)) {
      validateNode(value as Node, child.name, fieldPath, indices, issues, context)

      if (SINGLE_OBJECT_KEYS.has(key)) {
        checkSingleObjectSlot(value as Node, key, fieldPath, issues, context)
      }
      continue
    }

    if (Array.isArray(value)) {
      checkArrayItems(key, field, value as string[], fieldPath, issues)

      if (field.modeField && !keys.includes(field.modeField) && !context.blank) {
        issues.push({
          severity: 'warning',
          path: fieldPath,
          title: `${key} will replace the ability's existing list`,
          detail: `${field.modeField} defaults to the first enum value, which is a Replace. Set it to Merge to add to the existing values instead.`,
        })
      }
      continue
    }

    checkScalar(key, field, value, fieldPath, indices, issues)
  }

  checkRemoveCharges(node, structName, path, keys, issues)
}

function checkScalar(
  key: string,
  field: StructField,
  value: Node | string | number | boolean,
  path: Path,
  indices: Indices,
  issues: Issue[],
): void {
  if (typeof value === 'string' && field.type === 'string' && hasUnrepresentableChars(value)) {
    issues.push({
      severity: 'error',
      path,
      title: `${key} contains a character this format cannot represent`,
      detail:
        'The .ini dialect has no escaping, so a value containing " ( ) , or a newline cannot be written.',
    })
  }

  if (typeof value === 'string' && field.type === 'name' && value !== '' && !isBareName(value)) {
    issues.push({
      severity: 'error',
      path,
      title: `${key} must be a bare name`,
      detail: 'Letters, digits and underscores only, not starting with a digit.',
    })
  }

  const enumDef = enumOf(indices, field.type)
  if (enumDef && typeof value === 'string' && !enumDef.values.some((v) => v.name === value)) {
    const origin = enumDef.source === 'game' ? `the game's ${enumDef.name}` : enumDef.name
    issues.push({
      severity: 'error',
      path,
      title: `${value || '(empty)'} is not a value of ${enumDef.name}`,
      detail: `${key} must be one of ${origin}: ${enumDef.values.map((v) => v.name).join(', ')}. The game reads an unknown enum name as the first value.`,
    })
  }

  if (value === 'eNAEM_AddOnly') {
    issues.push({
      severity: 'warning',
      path,
      title: `${key}=eNAEM_AddOnly does not append`,
      detail:
        'For name arrays, AddOnly writes your values only when the target array is currently empty. To add without removing, use eNAEM_Merge.',
    })
  }
}

function checkArrayItems(key: string, field: StructField, items: string[], path: Path, issues: Issue[]): void {
  const element = elementType(field.type)

  items.forEach((item, index) => {
    const itemPath = [...path, index]
    if (item === '') {
      issues.push({
        severity: 'error',
        path: itemPath,
        title: `${key} has an empty item`,
        detail: `Item ${index + 1} is blank. It would be written as an empty element, which the game reads as None. Fill it in or remove it.`,
      })
      return
    }
    if (element === 'name' && !isBareName(item)) {
      issues.push({
        severity: 'error',
        path: itemPath,
        title: `${key} item "${item}" is not a bare name`,
        detail: 'Letters, digits and underscores only, not starting with a digit.',
      })
    }
    if (element === 'string' && hasUnrepresentableChars(item)) {
      issues.push({
        severity: 'error',
        path: itemPath,
        title: `${key} item contains a character this format cannot represent`,
        detail: 'The .ini dialect has no escaping, so an item containing " ( ) , or a newline cannot be written.',
      })
    }
  })
}

function checkArrayModes(
  parent: Node,
  key: string,
  field: StructField,
  childStruct: string,
  children: Node[],
  path: Path,
  indices: Indices,
  issues: Issue[],
  context: EntryContext,
): void {
  if (children.length === 0) {
    return
  }
  const family = familyForKey(indices, key, 'AbilityEdit')

  if (key === 'Costs' && parent['CostMode'] === undefined && !context.blank) {
    issues.push({
      severity: 'error',
      path: [...path, key],
      title: 'CostMode is not set, so every existing cost will be deleted',
      detail:
        'Omitting CostMode defaults it to eACEM_ReplaceAll, which clears the ability’s entire cost list and keeps only what is listed here. Set CostMode=eACEM_Merge unless that is genuinely what you want.',
    })
  } else if (field.modeField && parent[field.modeField] === undefined && !context.blank) {
    // Arrays governed by a mode on the parent (AdditionalCooldowns, BonusCharges, StatChange...).
    const modeEnum = field.modeEnum ? indices.enumByName.get(field.modeEnum) : undefined
    const first = modeEnum?.values[0]?.name ?? 'the first enum value'
    issues.push({
      severity: 'warning',
      path: [...path, key],
      title: `${key} will replace the existing list`,
      detail: `${field.modeField} is not set, so it defaults to ${first}, which clears the existing ${key} before applying yours. Set it to Merge to update entries in place.`,
    })
  }

  // Only entries that carry their own Mode can default to a Replace.
  const childHasMode = indices.structByName.get(childStruct)?.fields.some((f) => f.name === 'Mode') ?? false
  if (!childHasMode) return

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

function checkDuplicateClasses(key: string, children: Node[], path: Path, indices: Indices, issues: Issue[]): void {
  const seen = new Map<string, number>()
  // An effect entry without a Slot edits the default slot, so it collides with one that names it.
  const defaultSlot = indices.enumByName.get('EAbilityEffectSlot')?.values[0]?.name ?? ''

  children.forEach((child, index) => {
    const cls = child['Class']
    if (typeof cls !== 'string' || cls === '') {
      return
    }
    // Effects are additionally keyed by slot, and every array by its selector.
    const slot = typeof child['Slot'] === 'string' ? child['Slot'] : defaultSlot
    const match = MATCH_KEYS.map((k) => child[k]).find((v) => typeof v === 'string' && v !== '')
    const selector = match !== undefined ? `name:${String(match)}` : `index:${String(child['Index'] ?? 0)}`
    const composite = `${cls}\u0000${slot}\u0000${selector}`

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

/**
 * Index / Match* pick which object of the class an entry edits.
 */
function checkSelectors(child: Node, structName: string, path: Path, indices: Indices, issues: Issue[]): void {
  const struct = indices.structByName.get(structName)
  const modeField = struct?.fields.find((f) => f.name === 'Mode')
  if (!struct || !modeField) {
    return
  }

  const index = child['Index']
  const hasIndex = typeof index === 'number'
  const matchKey = MATCH_KEYS.find((k) => typeof child[k] === 'string' && child[k] !== '')
  if (!hasIndex && !matchKey) {
    return
  }

  const modeEnum = indices.enumByName.get(modeField.type)
  const mode = typeof child['Mode'] === 'string' ? child['Mode'] : modeEnum?.values[0]?.name ?? ''
  const selectors = [hasIndex ? `Index=${index}` : null, matchKey ? `${matchKey}=${String(child[matchKey])}` : null]
    .filter((s): s is string => s !== null)
    .join(' and ')

  if (/ReplaceAll$/.test(mode)) {
    issues.push({
      severity: 'warning',
      path,
      title: `${selectors} ${hasIndex && matchKey ? 'are' : 'is'} ignored under ${mode}`,
      detail: `${child['Mode'] === undefined ? `Mode is not set, so it defaults to ${mode}. ` : ''}A ReplaceAll clears the whole array and adds this entry, so there is nothing to select. Use Merge or Remove to target one object.`,
    })
  }

  if (hasIndex && matchKey) {
    issues.push({
      severity: 'info',
      path,
      title: `${matchKey} takes precedence over Index`,
      detail: `When ${matchKey} is non-empty the entry is selected by that name and Index=${index} is ignored.`,
    })
  }
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

  if (!viaCatchAll) {
    return
  }

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
  if (structName !== 'ChargesEdit') {
    return
  }
  if (node['RemoveCharges'] !== true) {
    return
  }

  const others = keys.filter((k) => k !== 'RemoveCharges')
  if (others.length === 0) {
    return
  }

  issues.push({
    severity: 'warning',
    path,
    title: 'RemoveCharges ignores the rest of this block',
    detail: `RemoveCharges=true removes the charges object and returns immediately, so ${others.join(', ')} will have no effect.`,
  })
}
