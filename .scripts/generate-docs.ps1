#Requires -Version 5.1
<#
.SYNOPSIS
    Regenerates the AbilityEditor 2.0 API documentation from the UnrealScript sources.

.DESCRIPTION
    Parses AbilityEditor\Src\AbilityEditor\Classes\*.uc and writes:
      - docs/schema.json              machine-readable API description
      - README.md generated blocks    between <!-- BEGIN:GENERATED x --> markers

.PARAMETER SchemaOnly
    Write docs/schema.json only and leave README.md untouched.

.PARAMETER CheckOnly
    Write nothing and exit 1 when README.md or docs/schema.json are stale.

.PARAMETER PrintSourceHash
    Print the hash of the .uc sources and exit.

.PARAMETER SdkPath
    XCOM 2 SDK root, defaulting to the 'xcom.highlander.sdkroot' VS Code setting.
    Without it the abstract / non-editable / dispatch-order enrichment is skipped.

.EXAMPLE
    .\.scripts\generate-docs.ps1 -CheckOnly
#>
[CmdletBinding()]
param(
    [switch] $SchemaOnly,
    [switch] $CheckOnly,
    [switch] $PrintSourceHash,
    [string] $SdkPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Status messages go to the information stream; -InformationAction still wins when passed.
if (-not $PSBoundParameters.ContainsKey('InformationAction')) { $InformationPreference = 'Continue' }

$RepoRoot   = Split-Path -Parent $PSScriptRoot
$ClassesDir = Join-Path $RepoRoot 'AbilityEditor\Src\AbilityEditor\Classes'
$ReadmePath = Join-Path $RepoRoot 'README.md'
$DocsDir    = Join-Path $RepoRoot 'docs'
$SchemaPath = Join-Path $DocsDir 'schema.json'

$DataStructuresFile = Join-Path $ClassesDir 'AE_DataStructures.uc'
$DlcInfoFile        = Join-Path $ClassesDir 'X2DLCInfo_AbilityEditor.uc'

# Line separator used throughout the markdown rendering.
$nl = "`n"

#region Generic helpers

function Get-SourceHash {
    param([string] $Path)

    $files = @(Get-ChildItem -LiteralPath $Path -Filter '*.uc' -File | Sort-Object Name)
    $text = ($files | ForEach-Object { [System.IO.File]::ReadAllText($_.FullName) }) -join "`n"
    $text = $text -replace "`r`n", "`n" -replace "`r", "`n"

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($text))
    }
    finally {
        $sha256.Dispose()
    }
    return [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()
}

function Read-TextFile {
    param([string] $Path)

    return [System.IO.File]::ReadAllLines($Path)
}

function ConvertTo-CommentFreeText {
    param([string] $Text)

    return (($Text -split "`n" | ForEach-Object { $_ -replace '//.*$', '' }) -join "`n")
}

# Splits a .uc file into function name -> body lines.
function Get-FunctionBlockMap {
    param([string[]] $Lines)

    $blocks = @{}
    $current = $null
    $buffer = [System.Collections.Generic.List[string]]::new()

    foreach ($line in $Lines) {
        if ($line -match '^\s*(?:static\s+)?(?:event|function)\s+(?:[\w<>]+\s+)?(\w+)\s*\(') {
            if ($null -ne $current) { $blocks[$current] = $buffer.ToArray() }
            $current = $Matches[1]
            $buffer = [System.Collections.Generic.List[string]]::new()
        }
        if ($null -ne $current) { $buffer.Add($line) }
    }
    if ($null -ne $current) { $blocks[$current] = $buffer.ToArray() }

    return $blocks
}

# Maps variable names to edit-struct types, from parameters and local declarations.
function Get-VarTypeMap {
    param(
        [string] $Text,
        [string[]] $StructNames
    )

    $map = @{}
    $joined = $StructNames -join '|'

    $paramPattern = '[\s\(,](' + $joined + ')\s+(\w+)\s*[,\);]'
    foreach ($m in [regex]::Matches($Text, $paramPattern)) {
        $map[$m.Groups[2].Value] = $m.Groups[1].Value
    }

    $localPattern = '(?m)^\s*(?:local\s+)?(' + $joined + ')\s+(\w+)\s*[,\);]?\s*$'
    foreach ($m in [regex]::Matches($Text, $localPattern)) {
        $map[$m.Groups[2].Value] = $m.Groups[1].Value
    }

    return $map
}

# 'Template.AbilityCosts[i].Field' -> 'AbilityCosts[].Field'
function Get-GameFieldFromTarget {
    param([string] $Target)

    $normalized = $Target -replace '\[\w+\]', '[]'
    $dot = $normalized.IndexOf('.')
    if ($dot -ge 0) { return $normalized.Substring($dot + 1) }
    return $normalized
}

# Extracts what a function body actually writes: Set-guarded scalars and name-array edits.
function Get-EditAction {
    param(
        [string[]] $BodyLines,
        [hashtable] $VarMap
    )

    $records = [System.Collections.Generic.List[object]]::new()

    for ($i = 0; $i -lt $BodyLines.Count; $i++) {
        $line = $BodyLines[$i]

        # if (Edit.SetFoo) { Template.Foo = Edit.Foo; }
        if ($line -match 'if\s*\((\w+)\.Set(\w+)\)') {
            $guardVar = $Matches[1]
            $field = $Matches[2]
            if (-not $VarMap.ContainsKey($guardVar)) { continue }

            $gameField = $null
            for ($j = $i + 1; $j -lt [Math]::Min($i + 20, $BodyLines.Count); $j++) {
                $inner = $BodyLines[$j]
                if ($inner -match ('^\s*([\w\.\[\]]+)\s*=\s*' + [regex]::Escape($guardVar) + '\.' + [regex]::Escape($field) + '\s*;')) {
                    $gameField = Get-GameFieldFromTarget $Matches[1]
                    break
                }
                if ($j -gt $i + 1 -and $inner -match '^\s*if\s*\(') { break }
            }

            $records.Add(@{ Kind = 'scalar'; Struct = $VarMap[$guardVar]; Config = $field; GameField = $gameField })
            continue
        }

        # ApplyNameArrayEdit(..., Template.Foo, Edit.Foo, Edit.FooMode, ...)
        if ($line -match 'Apply(Name|EffectReason)ArrayEdit\s*\(') {
            $callArgs = [System.Collections.Generic.List[string]]::new()
            for ($j = $i + 1; $j -lt [Math]::Min($i + 10, $BodyLines.Count); $j++) {
                $arg = $BodyLines[$j].Trim().TrimEnd(',')
                if ($arg -match '^\);?$') { break }
                $callArgs.Add(($arg -replace '\);?$', ''))
            }
            if ($callArgs.Count -ge 5) {
                $gameField = Get-GameFieldFromTarget $callArgs[2]
                if ($callArgs[3] -match '^(\w+)\.(\w+)$' -and $VarMap.ContainsKey($Matches[1])) {
                    $records.Add(@{ Kind = 'namearray'; Struct = $VarMap[$Matches[1]]; Config = $Matches[2]; GameField = $gameField; ReplaceOnly = $false })
                }
            }
            continue
        }

        # if (Edit.Foo.Length > 0) { ... } - moded when a FooMode is consulted, replace-only otherwise.
        if ($line -match 'if\s*\((\w+)\.(\w+)\.Length\s*>\s*0\)') {
            $guardVar = $Matches[1]
            $field = $Matches[2]
            if (-not $VarMap.ContainsKey($guardVar)) { continue }

            $hasMode = $false
            for ($j = $i + 1; $j -lt [Math]::Min($i + 4, $BodyLines.Count); $j++) {
                if ($BodyLines[$j] -match ('\.' + [regex]::Escape($field) + 'Mode\s*==')) { $hasMode = $true; break }
            }

            $gameField = $null
            for ($j = $i + 1; $j -lt [Math]::Min($i + 10, $BodyLines.Count); $j++) {
                if ($BodyLines[$j] -match ('^\s*([\w\.\[\]]+)\s*=\s*' + [regex]::Escape($guardVar) + '\.' + [regex]::Escape($field) + '\s*;')) {
                    $gameField = Get-GameFieldFromTarget $Matches[1]
                    break
                }
            }

            if (-not $hasMode -and $null -eq $gameField) { continue }
            $records.Add(@{ Kind = 'namearray'; Struct = $VarMap[$guardVar]; Config = $field; GameField = $gameField; ReplaceOnly = (-not $hasMode) })
            continue
        }
    }

    return $records
}

#endregion

if ($PrintSourceHash) {
    Write-Output (Get-SourceHash $ClassesDir)
    exit 0
}

#region Curated content the parser cannot infer from code

$Curated = @{

    Families = @(
        @{ Name = 'Costs';    ConfigKey = 'Costs';    Struct = 'CostEdit';     Root = 'X2AbilityCostEditor';     Registry = 'CostEditors';     HelperApply = 'ApplyCostEdit'
           Intro = 'Edits the `AbilityCosts` array of the template. Costs are edited **in place** when a cost of the given `Class` already exists; otherwise behaviour depends on the modes below. Fields you do not `Set` keep their current value.' }
        @{ Name = 'Cooldown'; ConfigKey = 'Cooldown'; Struct = 'CooldownEdit'; Root = 'X2AbilityCooldownEditor'; Registry = 'CooldownEditors'; HelperApply = 'ApplyCooldownEdit'
           Intro = 'Edits the template''s `AbilityCooldown`. With `Class` **omitted**, the existing cooldown is edited **in place** (no-op if the ability has none). With `Class` set, the existing cooldown is edited in place when it is already exactly that class; otherwise it is **replaced** by a new instance - any field you do not `Set` then takes the class''s default value.' }
        @{ Name = 'Charges';  ConfigKey = 'Charges';  Struct = 'ChargesEdit';  Root = 'X2AbilityChargesEditor';  Registry = 'ChargesEditors';  HelperApply = 'ApplyChargesEdit'
           Intro = 'Edits the template''s `AbilityCharges`. With `Class` **omitted**, the existing charges object is edited **in place** (no-op if the ability has none). With `Class` set, the existing object is edited in place when it is already exactly that class; otherwise it is **replaced** by a new instance - any field you do not `Set` then takes the class''s default value. `RemoveCharges=true` removes the charges object entirely.' }
        @{ Name = 'Effects';  ConfigKey = 'Effects';  Struct = 'EffectEdit';   Root = 'X2AbilityEffectsEditor';  Registry = 'EffectsEditors';  HelperApply = 'ApplyEffectEdit'
           Intro = 'Edits the effect arrays of the template. `Slot` selects which array is edited (see `EAbilityEffectSlot`). Within the selected array the effect of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`.' }
        @{ Name = 'Conditions'; ConfigKey = ''; Struct = 'ConditionEdit'; Root = 'X2AbilityConditionEditor'; Registry = 'ConditionEditors'; HelperApply = 'ApplyConditionEdits'
           Intro = 'Conditions can be edited in seven places: the template-level arrays (`ShooterConditions`, `TargetConditions`, `MultiTargetConditions` directly inside an `AbilityEdit`) and, inside an `Effects` entry, the effect''s own `TargetConditions` plus the class-specific `ApplyDamageModConditions`, `LethalDamageConditions` and `ToHitConditions`. All take an array of `ConditionEdit` entries. Within the targeted array, the condition of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`.' }
        @{ Name = 'ToHitCalc'; ConfigKey = 'ToHitCalc'; Struct = 'ToHitCalcEdit'; Root = 'X2AbilityToHitCalcEditor'; Registry = 'ToHitCalcEditors'; HelperApply = 'ApplyToHitCalcEdit'
           Intro = 'Edits the template''s to-hit calculation. Two slots exist: `ToHitCalc` (`Template.AbilityToHitCalc`) and `ToHitOwnerOnMissCalc` (`Template.AbilityToHitOwnerOnMissCalc`), both taking a `ToHitCalcEdit` block. With `Class` **omitted**, the existing calc is edited **in place**; with `Class` set, the existing calc is edited in place when it is already exactly that class, otherwise it is **replaced** by a new instance (unset fields then take class defaults). Classes without a dedicated editor below (e.g. `X2AbilityToHitCalc_StandardMelee`, `X2AbilityToHitCalc_DeadEye`) are still valid `Class` values - they get the fields of their nearest listed ancestor.' }
        @{ Name = 'TargetStyle'; ConfigKey = 'TargetStyle'; Struct = 'TargetStyleEdit'; Root = 'X2AbilityTargetStyleEditor'; Registry = 'TargetStyleEditors'; HelperApply = 'ApplyTargetStyleEdit'
           Intro = 'Edits `Template.AbilityTargetStyle` (how the ability picks its primary target). Same in-place/replace semantics as `ToHitCalc`. Field-less styles (`X2AbilityTarget_Self`, `X2AbilityTarget_Path`, ...) are valid `Class` values for swapping the style.' }
        @{ Name = 'MultiTargetStyle'; ConfigKey = 'MultiTargetStyle'; Struct = 'MultiTargetStyleEdit'; Root = 'X2AbilityMultiTargetStyleEditor'; Registry = 'MultiTargetStyleEditors'; HelperApply = 'ApplyMultiTargetStyleEdit'
           Intro = 'Edits the template''s multi-target styles. Two slots exist: `MultiTargetStyle` (`Template.AbilityMultiTargetStyle`) and `PassiveAOEStyle` (`Template.AbilityPassiveAOEStyle`), both taking a `MultiTargetStyleEdit` block. Same in-place/replace semantics as `ToHitCalc`.' }
        @{ Name = 'Triggers'; ConfigKey = 'Triggers'; Struct = 'TriggerEdit'; Root = 'X2AbilityTriggerEditor'; Registry = 'TriggerEditors'; HelperApply = 'ApplyTriggerEdits'
           Intro = 'Edits the `AbilityTriggers` array of the template. The trigger of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`. **Caveat:** adding a *new* `X2AbilityTrigger_EventListener` from config is rarely useful - its `ListenerData.EventFn` delegate can only be assigned in code and stays `none`. Editing an existing listener trigger preserves its `EventFn`. `X2AbilityTrigger_OnAbilityActivated` is handled by the EventListener editor (its `MatchAbilityActivated` field is protected and cannot be set). See also `AbilityEventListenerEdits` in the template fields for the separate `Template.AbilityEventListeners` array.' }
    )

    StructuralFieldNotes = @{
        'AbilityEdit.Ability'              = 'Required. Template name of the ability to edit (e.g. `SwordSlice`).'
        'CostEdit.Class'                   = 'Cost class to target/instantiate, e.g. `X2AbilityCost_ActionPoints`. Bare names are auto-prefixed with `XComGame.`; empty falls back to `X2AbilityCost`.'
        'CostEdit.Mode'                    = 'Per-entry edit mode (`EAbilityCostEditMode`). Defaults to the enum''s first value, which clears the existing list.'
        'CooldownEdit.Class'               = 'Optional. Omitted = edit the existing cooldown in place. Set = target/instantiate that class, e.g. `X2AbilityCooldown_PerPlayerType`. Bare names are auto-prefixed with `XComGame.`.'
        'ChargesEdit.Class'                = 'Optional. Omitted = edit the existing charges object in place. Set = target/instantiate that class, e.g. `X2AbilityCharges_GremlinHeal`. Bare names are auto-prefixed with `XComGame.`.'
        'ChargesEdit.RemoveCharges'        = 'Set to true to remove the ability''s charges object entirely. No `Class` needed; the other fields of the block are ignored.'
        'ToHitCalcEdit.Class'              = 'Optional. Omitted = edit the existing calc in place. Set = target/instantiate that class, e.g. `X2AbilityToHitCalc_StandardAim`. Bare names are auto-prefixed with `XComGame.`.'
        'ToHitCalcEdit.HitModifiers'       = '**Replace-only**: when non-empty, replaces the calc''s always-on `HitModifiers` array entirely (`ShotModifierInfo`: `ModType`, `Value`, `Reason`).'
        'ToHitCalcEdit.CustomProperties'   = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'TargetStyleEdit.Class'            = 'Optional. Omitted = edit the existing style in place. Set = target/instantiate that class, e.g. `X2AbilityTarget_Cursor`. Bare names are auto-prefixed with `XComGame.`.'
        'TargetStyleEdit.CustomProperties' = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'MultiTargetStyleEdit.Class'       = 'Optional. Omitted = edit the existing style in place. Set = target/instantiate that class, e.g. `X2AbilityMultiTarget_Radius`. Bare names are auto-prefixed with `XComGame.`.'
        'MultiTargetStyleEdit.CustomProperties' = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'TriggerEdit.Class'                = 'Trigger class to target/instantiate, e.g. `X2AbilityTrigger_UnitPostBeginPlay`. Bare names are auto-prefixed with `XComGame.`.'
        'TriggerEdit.Mode'                 = 'Per-entry edit mode (`EArrayEditMode`). Defaults to the enum''s first value, which clears the existing array.'
        'TriggerEdit.CustomProperties'     = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'EffectEdit.EffectHitModifiers'    = '**Replace-only**: when non-empty, replaces `X2Effect_ToHitModifier.Modifiers` entirely (`EffectHitModifier` entries, incl. `MatchToHit` class ref via qualified name).'
        'EffectEdit.CustomProperties'      = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'ConditionEdit.CustomProperties'   = 'Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors.'
        'AbilityEventListenerEdit.EventID' = 'Matches the existing `Template.AbilityEventListeners` entry to edit. Entries cannot be added (their `EventFn` delegate is code-only).'
        'EffectEdit.Class'                 = 'Effect class to target/instantiate, e.g. `X2Effect_ApplyWeaponDamage`. Bare names are auto-prefixed with `XComGame.`; empty falls back to `X2Effect`.'
        'EffectEdit.Slot'                  = 'Which effect array to edit (`EAbilityEffectSlot`): `eAES_Target`, `eAES_MultiTarget` or `eAES_Shooter`.'
        'EffectEdit.Mode'                  = 'Per-entry edit mode (`EArrayEditMode`). Defaults to the enum''s first value, which clears the existing array.'
        'ConditionEdit.Class'              = 'Condition class to target/instantiate, e.g. `X2Condition_UnitProperty`. Bare names are auto-prefixed with `XComGame.`.'
        'ConditionEdit.Mode'               = 'Per-entry edit mode (`EArrayEditMode`). Defaults to the enum''s first value, which clears the existing array.'
        'AdditionalCooldownEdit.AbilityName'   = 'Ability whose cooldown entry is added/updated in `AditionalAbilityCooldowns`.'
        'AdditionalCooldownEdit.ApplyCooldownType' = '`AdditionalCooldown_ApplyLarger` or `AdditionalCooldown_ApplySmaller`. Applied when non-empty.'
        'BonusChargeEdit.AbilityName'      = 'Ability that grants the bonus charges.'
    }

    NestedGameFields = @{
        'CooldownEdit.AdditionalCooldowns' = 'AditionalAbilityCooldowns'
        'ChargesEdit.BonusCharges'         = 'BonusCharges'
        'EffectEdit.StatChange'            = 'm_aStatChanges'
        'EffectEdit.WeaponDamageValue'     = 'EffectDamageValue'
        'EffectEdit.TargetConditions'      = 'TargetConditions'
    }

    NestedLinks = @{
        'ConditionEdit' = '[Conditions](#conditions)'
    }

    EnumSemantics = @{
        'ENameArrayEditMode' = @{
            'eNAEM_Replace' = 'Replace the whole target array with the provided values. (Default)'
            'eNAEM_Merge'   = 'Append each provided value that is not already present.'
            'eNAEM_AddOnly' = 'Set the provided values **only if the target array is currently empty**; otherwise do nothing. It does not append.'
            'eNAEM_Remove'  = 'Remove each provided value from the target array.'
        }
        'EAbilityCostEditMode' = @{
            'eACEM_ReplaceAll' = 'As `CostMode`: clear **all** existing costs before applying the entries. As per-entry `Mode`: edit in place if a cost of that class exists, otherwise skip (unless `CostMode=eACEM_ReplaceAll`, in which case a new cost is added). (Default)'
            'eACEM_Merge'      = 'Edit the existing cost of that class in place; if none exists, instantiate and add it.'
            'eACEM_AddOnly'    = 'Same as `eACEM_Merge`: edit in place if present, otherwise add.'
            'eACEM_Remove'     = 'Remove the cost of that class from the ability.'
        }
        'EArrayEditMode' = @{
            'eAEM_ReplaceAll' = 'Clear the whole target array, then add this effect/condition. (Default)'
            'eAEM_Merge'      = 'Edit the existing effect/condition of that class in place; if none exists, instantiate and add it.'
            'eAEM_AddOnly'    = 'Same as `eAEM_Merge`: edit in place if present, otherwise add.'
            'eAEM_Remove'     = 'Remove the first effect/condition of that class from the target array.'
        }
        'EChargesBonusMode' = @{
            'eCBM_Replace' = 'Clear existing `BonusCharges` entries before applying yours. (Default)'
            'eCBM_Merge'   = 'Update the entry for each `AbilityName` if present, otherwise add it.'
        }
        'EAdditionalCooldownEditMode' = @{
            'eACEM_Replace' = 'Clear existing `AditionalAbilityCooldowns` entries before applying yours. (Default)'
            'eACEM_Merge'   = 'Update the entry for each `AbilityName` if present, otherwise add it.'
        }
        'EStatChangeMode' = @{
            'eSCM_Replace' = 'Clear existing stat changes (`m_aStatChanges`) before applying yours. (Default)'
            'eSCM_Merge'   = 'Update the entry for each `StatType` if present, otherwise add it.'
        }
        'EAbilityEffectSlot' = @{
            'eAES_Target'      = 'Edit `AbilityTargetEffects` (effects applied to the primary target). (Default)'
            'eAES_MultiTarget' = 'Edit `AbilityMultiTargetEffects`.'
            'eAES_Shooter'     = 'Edit `AbilityShooterEffects` (effects applied to the shooter).'
        }
    }

    KnownIssues = @()
}

# Mode fields whose target array cannot be derived from the name alone.
$NestedModeAlias = @{
    'AdditionalCooldownMode' = 'AdditionalCooldowns'
    'CostMode'               = 'Costs'
    'TargetConditionsMode'   = 'TargetConditionClasses'
}

#endregion

#region 1. Parse AE_DataStructures.uc (enums + structs)

$Enums       = [System.Collections.Generic.List[object]]::new()
$Structs     = @{}
$StructOrder = [System.Collections.Generic.List[string]]::new()

$mode = ''
$blockName = ''
$currentEnum = $null
$comment = [System.Collections.Generic.List[string]]::new()

foreach ($line in (Read-TextFile $DataStructuresFile)) {
    $trim = $line.Trim()

    if ($mode -eq '') {
        if ($trim -match '^enum\s+(\w+)$') {
            $mode = 'enum'
            $currentEnum = @{ Name = $Matches[1]; Values = [System.Collections.Generic.List[string]]::new() }
            $Enums.Add($currentEnum)
        }
        elseif ($trim -match '^struct\s+(\w+)$') {
            $mode = 'struct'
            $blockName = $Matches[1]
            $Structs[$blockName] = [System.Collections.Generic.List[object]]::new()
            $StructOrder.Add($blockName)
            $comment.Clear()
        }
        continue
    }

    if ($trim -match '^};') { $mode = ''; continue }
    if ($trim -eq '{') { continue }

    if ($mode -eq 'enum') {
        if ($trim -match '^(\w+),?$') { $currentEnum.Values.Add($Matches[1]) }
        continue
    }

    # struct body: line comments above a var declaration become its description
    if ($trim -match '^//\s?(.*)$') { $comment.Add($Matches[1]); continue }
    if ($trim -eq '') { $comment.Clear(); continue }
    if ($trim -match '^var\s+([\w<>]+)\s+(\w+);') {
        $Structs[$blockName].Add(@{
            Name        = $Matches[2]
            Type        = $Matches[1]
            Description = ($comment -join ' ')
        })
        $comment.Clear()
    }
}

$StructNames = $StructOrder.ToArray()

# Classify struct fields: guard / optionalScalar / mode / nested / modedArray / plainArray / plain.
foreach ($structName in $StructOrder) {
    $fields = $Structs[$structName]
    $names = @($fields | ForEach-Object { $_.Name })

    $modeTargets = @{}
    foreach ($f in $fields) {
        if ($f.Name -match '^(\w+)Mode$') {
            $base = $Matches[1]
            $target = $null
            if ($NestedModeAlias.ContainsKey($f.Name)) { $target = $NestedModeAlias[$f.Name] }
            elseif ($names -contains $base)            { $target = $base }
            elseif ($names -contains ($base + 's'))    { $target = $base + 's' }
            if ($null -ne $target) { $modeTargets[$f.Name] = $target }
        }
    }

    $modeFieldNames = @($modeTargets.Keys)
    $arrayToMode = @{}
    foreach ($k in $modeFieldNames) { $arrayToMode[$modeTargets[$k]] = $k }

    foreach ($f in $fields) {
        $f.Kind = 'plain'
        $f.Guard = $null
        $f.ModeField = $null
        $f.ModeEnum = $null
        $f.Consumed = $false

        if ($f.Name -match '^Set(\w+)$' -and $f.Type -eq 'bool' -and $names -contains $Matches[1]) {
            $f.Kind = 'guard'
            continue
        }
        if ($names -contains ('Set' + $f.Name)) {
            $f.Kind = 'optionalScalar'
            $f.Guard = 'Set' + $f.Name
            continue
        }
        if ($modeFieldNames -contains $f.Name) {
            $f.Kind = 'mode'
            continue
        }

        $isStructArray = $f.Type -match '^array<(\w+)>$' -and $StructNames -contains $Matches[1]
        if ($isStructArray -or ($StructNames -contains $f.Type)) {
            $f.Kind = 'nested'
            if ($arrayToMode.ContainsKey($f.Name)) {
                $f.ModeField = $arrayToMode[$f.Name]
                $f.ModeEnum = ($fields | Where-Object { $_.Name -eq $f.ModeField }).Type
            }
            continue
        }

        if ($f.Type -match '^array<') {
            if ($arrayToMode.ContainsKey($f.Name)) {
                $f.Kind = 'modedArray'
                $f.ModeField = $arrayToMode[$f.Name]
                $f.ModeEnum = ($fields | Where-Object { $_.Name -eq $f.ModeField }).Type
            }
            else {
                $f.Kind = 'plainArray'
            }
            continue
        }
    }
}

#endregion

#region 2. Parse X2DLCInfo_AbilityEditor.uc (registries, wiring, template-level fields)

$dlcLines = Read-TextFile $DlcInfoFile
$dlcText = $dlcLines -join "`n"

$Registries = @{}
foreach ($m in [regex]::Matches($dlcText, "(?m)^\s*(\w+Editors)\((\d+)\)\s*=\s*class'(\w+)'")) {
    $reg = $m.Groups[1].Value
    if (-not $Registries.ContainsKey($reg)) { $Registries[$reg] = [System.Collections.Generic.List[object]]::new() }
    $Registries[$reg].Add(@{ Index = [int]$m.Groups[2].Value; Class = $m.Groups[3].Value })
}
foreach ($reg in @($Registries.Keys)) {
    $Registries[$reg] = @($Registries[$reg] | Sort-Object { $_.Index } | ForEach-Object { $_.Class })
}

$dlcBlocks = Get-FunctionBlockMap $dlcLines
$dlcVarMap = Get-VarTypeMap $dlcText $StructNames

$TemplateFields = @()
$templateEditorFile = Join-Path $ClassesDir 'X2AbilityTemplateEditor.uc'
if (Test-Path $templateEditorFile) {
    $teLines = Read-TextFile $templateEditorFile
    $teBlocks = Get-FunctionBlockMap $teLines
    $teVarMap = Get-VarTypeMap ($teLines -join "`n") $StructNames
    if ($teBlocks.ContainsKey('ApplyTemplateEdit')) {
        $TemplateFields = @(Get-EditAction $teBlocks['ApplyTemplateEdit'] $teVarMap | Where-Object { $_.Struct -eq 'AbilityEdit' })
    }
}
elseif ($dlcBlocks.ContainsKey('ApplyAbilityEdit')) {
    $TemplateFields = @(Get-EditAction $dlcBlocks['ApplyAbilityEdit'] $dlcVarMap | Where-Object { $_.Struct -eq 'AbilityEdit' })
}

$applyBody = ''
if ($dlcBlocks.ContainsKey('ApplyAbilityEdit')) {
    $applyBody = $dlcBlocks['ApplyAbilityEdit'] -join "`n"
}
$applyBodyCode = ($applyBody -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"

#endregion

#region 3. Parse editor classes

$EditorFiles = Get-ChildItem -LiteralPath $ClassesDir -Filter 'X2Ability*Editor*.uc' -File |
    Where-Object { $_.Name -notmatch '_Helper\.uc$' -and $_.Name -notmatch '^X2AbilityEditor_' }

$Editors = @{}   # class name -> record
foreach ($file in $EditorFiles) {
    $lines = Read-TextFile $file.FullName
    $text = $lines -join "`n"

    if ($text -notmatch '(?m)^class\s+(\w+)\s+extends\s+([\w\.]+)') { continue }
    $className = $Matches[1]
    $extends = $Matches[2] -replace '^.*\.', ''

    $blocks = Get-FunctionBlockMap $lines
    $varMap = Get-VarTypeMap $text $StructNames

    $gameClass = $null
    $catchAll = $false
    if ($blocks.ContainsKey('CanEdit')) {
        $canEditBody = $blocks['CanEdit'] -join "`n"
        if ($canEditBody -match "IsA\('(\w+)'\)") {
            $gameClass = $Matches[1]
        }
        elseif ($canEditBody -match '(?m)^\s*return\s+true\s*;') {
            $catchAll = $true
        }
    }

    $functions = @{}
    foreach ($fnName in $blocks.Keys) {
        $functions[$fnName] = @(Get-EditAction $blocks[$fnName] $varMap)
    }

    $Editors[$className] = @{
        Class     = $className
        Extends   = $extends
        GameClass = $gameClass
        CatchAll  = $catchAll
        Blocks    = $blocks
        VarMap    = $varMap
        Functions = $functions
        Text      = $text
        File      = $file.Name
    }
}

#endregion

#region 4. Resolve families: dispatch order, wiring, effective fields per editor

function Get-ExtendsChain {
    param([string] $ClassName)

    $chain = [System.Collections.Generic.List[string]]::new()
    $cur = $ClassName
    while ($null -ne $cur -and $Editors.ContainsKey($cur)) {
        $chain.Add($cur)
        $cur = $Editors[$cur].Extends
    }
    return $chain.ToArray()
}

# Classes that actually contribute to $FnName: walks up the chain while each one calls super.
function Get-DefinerChain {
    param(
        [string] $ClassName,
        [string] $FnName
    )

    $result = [System.Collections.Generic.List[string]]::new()
    $chain = Get-ExtendsChain $ClassName
    $idx = 0

    while ($idx -lt $chain.Count) {
        $definer = $null
        for (; $idx -lt $chain.Count; $idx++) {
            $ed = $Editors[$chain[$idx]]
            if ($ed.Blocks.ContainsKey($FnName) -and ($ed.Blocks[$FnName] -join "`n") -match '\{') {
                $definer = $chain[$idx]
                break
            }
        }
        if ($null -eq $definer) { break }

        $result.Add($definer)
        if (($Editors[$definer].Blocks[$FnName] -join "`n") -notmatch ('super\.' + $FnName)) { break }
        $idx++
    }

    return $result.ToArray()
}

$Warnings = [System.Collections.Generic.List[string]]::new()
$FamilyModels = [System.Collections.Generic.List[object]]::new()

foreach ($fam in $Curated.Families) {
    $structName = $fam.Struct
    $structFields = $Structs[$structName]

    $registry = @()
    if ($Registries.ContainsKey($fam.Registry)) {
        $registry = $Registries[$fam.Registry]
    }
    else {
        $Warnings.Add("Registry $($fam.Registry) not found in X2DLCInfo_AbilityEditor.uc")
    }

    $wired = $applyBodyCode -match ($fam.HelperApply + '\s*\(')
    $nestedFields = @($structFields | Where-Object { $_.Kind -eq 'nested' })

    $editorModels = [System.Collections.Generic.List[object]]::new()
    foreach ($cls in $registry) {
        if (-not $Editors.ContainsKey($cls)) {
            $Warnings.Add("Registered editor $cls has no parsed source file")
            continue
        }
        $ed = $Editors[$cls]

        $fields = [System.Collections.Generic.List[object]]::new()
        foreach ($pair in @(@('ApplyBaseEdit', 'base'), @('ApplyDerivedEdit', 'derived'))) {
            $fn = $pair[0]
            $origin = $pair[1]

            foreach ($definer in (Get-DefinerChain $cls $fn)) {
                $srcEd = $Editors[$definer]
                $inheritedFrom = $null
                if ($definer -ne $cls) { $inheritedFrom = $definer }

                foreach ($rec in $srcEd.Functions[$fn]) {
                    if ($rec.Struct -ne $structName) { continue }
                    if ($fields | Where-Object { $_.config -eq $rec.Config }) { continue }

                    $structField = $structFields | Where-Object { $_.Name -eq $rec.Config }
                    $type = ''
                    $desc = ''
                    if ($structField) {
                        $structField.Consumed = $true
                        $type = $structField.Type
                        $desc = $structField.Description
                    }

                    $entry = [ordered]@{
                        config        = $rec.Config
                        type          = $type
                        kind          = $rec.Kind
                        gameField     = $rec.GameField
                        origin        = $origin
                        inheritedFrom = $inheritedFrom
                        description   = $desc
                    }
                    if ($rec.Kind -eq 'scalar') {
                        $entry.guard = 'Set' + $rec.Config
                    }
                    if ($rec.Kind -eq 'namearray') {
                        if ($rec.ReplaceOnly) {
                            $entry.replaceOnly = $true
                        }
                        else {
                            $entry.modeField = $rec.Config + 'Mode'
                            if ($structField -and $structField.ModeField) { $entry.modeField = $structField.ModeField }
                            if ($structField -and $structField.ModeEnum)  { $entry.modeEnum = $structField.ModeEnum }

                            $modeStructField = $structFields | Where-Object { $_.Name -eq $entry.modeField }
                            if ($modeStructField) { $modeStructField.Consumed = $true }
                        }
                    }
                    $fields.Add($entry)
                }

                # nested struct arrays referenced in this function body
                $body = $srcEd.Blocks[$fn] -join "`n"
                foreach ($nf in $nestedFields) {
                    if ($body -notmatch ('\.' + [regex]::Escape($nf.Name) + '\b')) { continue }
                    if ($fields | Where-Object { $_.config -eq $nf.Name }) { continue }

                    $nf.Consumed = $true
                    $gameField = $null
                    $key = "$structName.$($nf.Name)"
                    if ($Curated.NestedGameFields.ContainsKey($key)) { $gameField = $Curated.NestedGameFields[$key] }

                    $entry = [ordered]@{
                        config        = $nf.Name
                        type          = $nf.Type
                        kind          = 'nested'
                        gameField     = $gameField
                        origin        = $origin
                        inheritedFrom = $inheritedFrom
                        description   = $nf.Description
                    }
                    if ($nf.ModeField) {
                        $entry.modeField = $nf.ModeField
                        $entry.modeEnum = $nf.ModeEnum

                        $modeStructField = $structFields | Where-Object { $_.Name -eq $nf.ModeField }
                        if ($modeStructField) { $modeStructField.Consumed = $true }
                    }
                    $fields.Add($entry)
                }
            }
        }

        $editorModels.Add([ordered]@{
            class     = $cls
            extends   = $ed.Extends
            gameClass = $ed.GameClass
            catchAll  = $ed.CatchAll
            fields    = $fields.ToArray()
        })
    }

    $FamilyModels.Add([ordered]@{
        name          = $fam.Name
        configKey     = $fam.ConfigKey
        editStruct    = $structName
        wired         = [bool]$wired
        dispatchOrder = $registry
        intro         = $fam.Intro
        editors       = $editorModels.ToArray()
    })

    if (-not $wired) {
        $Warnings.Add("Family '$($fam.Name)' is NOT wired: ApplyAbilityEdit does not call $($fam.HelperApply). Its config entries are currently ignored.")
    }
}

#endregion

#region 4b. SDK enrichment: abstract badges, non-editable field lists, dispatch-order validation

if (-not $SdkPath) {
    $vsSettings = Join-Path $env:APPDATA 'Code\User\settings.json'
    if (Test-Path $vsSettings) {
        try { $SdkPath = (Get-Content $vsSettings -Raw | ConvertFrom-Json).'xcom.highlander.sdkroot' }
        catch { Write-Verbose "Could not read 'xcom.highlander.sdkroot' from $vsSettings." }
    }
}

$SdkClassesDir = $null
if ($SdkPath -and (Test-Path (Join-Path $SdkPath 'Development\Src\XComGame\Classes'))) {
    $SdkClassesDir = Join-Path $SdkPath 'Development\Src\XComGame\Classes'
}
else {
    Write-Information 'SDK not found - skipping abstract/non-editable/dispatch-order enrichment (pass -SdkPath to enable).'
}

$SdkCache = @{}

# Reads a game class from the SDK: parent, abstract flag, and why each var is not config-editable.
function Get-SdkClassInfo {
    param([string] $GameClass)

    if ($SdkCache.ContainsKey($GameClass)) { return $SdkCache[$GameClass] }

    $result = $null
    $file = Join-Path $SdkClassesDir "$GameClass.uc"
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText($file)
        $text = [regex]::Replace($text, '/\*.*?\*/', '', 'Singleline')

        $extends = $null
        $abstract = $false
        $vars = [System.Collections.Generic.List[object]]::new()
        $depth = 0
        $inDefaults = $false

        foreach ($raw in ($text -split "`r?`n")) {
            $line = ($raw -replace '//.*$', '').Trim()

            if ($null -eq $extends -and $line -match '^class\s+\w+\s+extends\s+([\w\.]+)') {
                $extends = $Matches[1] -replace '^.*\.', ''
                if ($line -match '\babstract\b') { $abstract = $true }
            }
            if ($line -match '^defaultproperties') { $inDefaults = $true }
            if ($inDefaults) { continue }
            if ($line -match '^struct\s') { $depth++; continue }
            if ($depth -gt 0) {
                if ($line -match '^};') { $depth-- }
                continue
            }
            if ($line -notmatch '^var(\(\w*\))?\s+(.*)$') { continue }

            $rest = $Matches[2].Trim()
            $reason = $null
            if ($rest -match '^(config|globalconfig)\b')                        { $reason = 'config &mdash; tune it in the game''s own ini' }
            elseif ($rest -match '^localized\b')                                { $reason = 'localized &mdash; use .int localization files' }
            elseif ($rest -match '^(private|privatewrite|protected|protectedwrite)\b') { $reason = 'private/protected' }
            elseif ($rest -match '^deprecated\b')                               { $reason = 'deprecated' }
            elseif ($rest -match '^(transient|duplicatetransient)\b')           { $reason = 'transient' }
            elseif ($rest -match 'delegate<')                                   { $reason = 'delegate &mdash; code-only' }

            # strip neutral modifiers to reach the type token
            $declaration = $rest -replace '^(init|instanced|editinline\w*|noimport|repnotify|const|editconst|native(\(\w+\))?)\s+', ''
            if ($declaration -notmatch '^(array<\s*[\w\.]+\s*>|class(<[\w\.]+>)?|[\w\.<>]+)\s+(\w+(?:\s*,\s*\w+)*)\s*[;\[]') { continue }

            $typeTok = $Matches[1]
            $varNames = $Matches[3] -split '\s*,\s*'
            if ($null -eq $reason) {
                if ($typeTok -match '^class') {
                    $reason = 'class reference'
                }
                elseif ($typeTok -match '^array<\s*([\w\.]+)\s*>$') {
                    $inner = $Matches[1] -replace '^.*\.', ''
                    if ($inner -ne 'name') { $reason = "array of ``$inner``" }
                }
                elseif ($typeTok -notin 'bool', 'int', 'float', 'name', 'string' -and $typeTok -notmatch '^E\w+$' -and $typeTok -notmatch 'Deferral|Filter') {
                    # not a primitive and doesn't look like an enum: struct or object ref
                    $reason = "type ``$typeTok``"
                }
            }

            foreach ($v in $varNames) {
                $vars.Add(@{ Name = $v; Type = $typeTok; Reason = $reason })
            }
        }

        $result = @{ Extends = $extends; Abstract = $abstract; Vars = $vars.ToArray() }
    }

    $SdkCache[$GameClass] = $result
    return $result
}

function Get-SdkAncestor {
    param([string] $GameClass)

    $ancestors = [System.Collections.Generic.List[string]]::new()
    $cur = $GameClass
    for ($d = 0; $d -lt 20; $d++) {
        $info = Get-SdkClassInfo $cur
        if ($null -eq $info -or -not $info.Extends) { break }
        $ancestors.Add($info.Extends)
        $cur = $info.Extends
    }
    return $ancestors.ToArray()
}

$TemplateNotEditable = @()
if ($SdkClassesDir) {
    # Everything on X2AbilityTemplate that is neither a covered scalar nor handled by a family.
    $tmplInfo = Get-SdkClassInfo 'X2AbilityTemplate'
    if ($tmplInfo) {
        $tmplCovered = @($TemplateFields | Where-Object { $_.GameField } | ForEach-Object { ($_.GameField -split '[\.\[]')[0] })
        $tmplCovered += @('AbilityCosts', 'AbilityCooldown', 'AbilityCharges', 'AbilityToHitCalc', 'AbilityToHitOwnerOnMissCalc',
            'AbilityTargetStyle', 'AbilityMultiTargetStyle', 'AbilityTriggers', 'AbilityEventListeners',
            'AbilityShooterConditions', 'AbilityTargetConditions', 'AbilityMultiTargetConditions',
            'AbilityTargetEffects', 'AbilityMultiTargetEffects', 'AbilityShooterEffects')

        $TemplateNotEditable = @($tmplInfo.Vars | Where-Object { $_.Name -notin $tmplCovered } | ForEach-Object {
            $reason = $_.Reason
            if ($null -eq $reason) { $reason = 'not covered (deliberate core-set choice)' }
            [ordered]@{ name = $_.Name; reason = $reason }
        })
    }

    foreach ($famModel in $FamilyModels) {
        $concrete = @($famModel.editors | Where-Object { $_.gameClass })

        foreach ($ed in $concrete) {
            $info = Get-SdkClassInfo $ed.gameClass
            if ($null -eq $info) { continue }
            $ed.abstract = [bool]$info.Abstract

            # covered = first segment of every game field this editor applies
            $covered = @($ed.fields | Where-Object { $_.gameField } | ForEach-Object { ($_.gameField -split '[\.\[]')[0] })
            $notEditable = [System.Collections.Generic.List[object]]::new()
            foreach ($v in $info.Vars) {
                if ($v.Name -in $covered) { continue }
                $reason = $v.Reason
                if ($null -eq $reason) { $reason = 'not yet supported' }
                $notEditable.Add([ordered]@{ name = $v.Name; reason = $reason })
            }
            $ed.notEditable = $notEditable.ToArray()
        }

        # dispatch-order validation: a class must not be preceded by one of its ancestors
        for ($jj = 0; $jj -lt $concrete.Count; $jj++) {
            $anc = Get-SdkAncestor $concrete[$jj].gameClass
            for ($ii = 0; $ii -lt $jj; $ii++) {
                if ($concrete[$ii].gameClass -in $anc) {
                    $Warnings.Add("Dispatch order ($($famModel.name)): $($concrete[$jj].class) is registered after $($concrete[$ii].class), but $($concrete[$jj].gameClass) derives from $($concrete[$ii].gameClass) - it will never be dispatched.")
                }
            }
        }
    }
}

#endregion

#region 4c. Consumption tracking and orphan warnings

# Template-level consumption + nested family keys on AbilityEdit
foreach ($rec in $TemplateFields) {
    $sf = $Structs['AbilityEdit'] | Where-Object { $_.Name -eq $rec.Config }
    if (-not $sf) { continue }

    $sf.Consumed = $true
    if ($sf.ModeField) {
        $msf = $Structs['AbilityEdit'] | Where-Object { $_.Name -eq $sf.ModeField }
        if ($msf) { $msf.Consumed = $true }
    }
}

foreach ($fam in $Curated.Families) {
    $sf = $Structs['AbilityEdit'] | Where-Object { $_.Name -eq $fam.ConfigKey }
    if ($sf) { $sf.Consumed = $true }

    $famModel = $FamilyModels | Where-Object { $_.name -eq $fam.Name }
    if ($sf -and $sf.ModeField -and $famModel.wired) {
        $msf = $Structs['AbilityEdit'] | Where-Object { $_.Name -eq $sf.ModeField }
        if ($msf) { $msf.Consumed = $true }
    }
}

# Line comments are stripped first so commented-out scaffolding does not count as consumption.
$allEditorText = ConvertTo-CommentFreeText ((($Editors.Values | ForEach-Object { $_.Text }) -join "`n") + "`n" + $dlcText)
foreach ($structName in @('AdditionalCooldownEdit', 'BonusChargeEdit', 'StatChangeEdit', 'WeaponDamageValueEdit')) {
    foreach ($f in $Structs[$structName]) {
        if ($f.Kind -eq 'guard') { continue }
        if ($allEditorText -match ('\.' + [regex]::Escape($f.Name) + '\b')) { $f.Consumed = $true }
    }
}

# Structural fields consumed via helpers (Class, Mode, Slot, RemoveCharges, ...)
$helperFiles = Get-ChildItem -LiteralPath $ClassesDir -Filter '*_Helper.uc' -File | Where-Object { $_.Name -ne 'Helper_AbilityEditor.uc' }
$helperText = ConvertTo-CommentFreeText (($helperFiles | ForEach-Object { [System.IO.File]::ReadAllText($_.FullName) }) -join "`n")
$combinedText = $allEditorText + "`n" + $helperText
foreach ($structName in $StructOrder) {
    foreach ($f in $Structs[$structName]) {
        if ($f.Consumed -or $f.Kind -eq 'guard') { continue }
        if ($combinedText -match ('\.' + [regex]::Escape($f.Name) + '\b')) { $f.Consumed = $true }
    }
}

# Fields intentionally consumed by no built-in editor (bridge-mod surface).
$IntentionallyUnconsumed = @('CustomProperties', 'Key', 'Value', 'EditorClass', 'Priority')
foreach ($structName in $StructOrder) {
    foreach ($f in $Structs[$structName]) {
        if ($f.Kind -eq 'guard') { continue }
        if ($structName -in @('AECustomProperty', 'ExtraEditorRegistration')) { continue }
        if ($f.Name -in $IntentionallyUnconsumed) { continue }
        if (-not $f.Consumed) {
            $Warnings.Add("Orphan config field: $structName.$($f.Name) is declared but not consumed by any editor (not yet implemented?).")
        }
    }
}

foreach ($w in $Curated.KnownIssues) { $Warnings.Add("Known issue: $w") }

#endregion

#region 5. Build the schema object

$sha = Get-SourceHash $ClassesDir

$schemaEnums = @($Enums | ForEach-Object {
    $sem = $null
    if ($Curated.EnumSemantics.ContainsKey($_.Name)) { $sem = $Curated.EnumSemantics[$_.Name] }

    $values = [System.Collections.Generic.List[object]]::new()
    foreach ($v in $_.Values) {
        $d = ''
        if ($sem -and $sem.ContainsKey($v)) { $d = $sem[$v] }
        $values.Add([ordered]@{ name = $v; description = $d })
    }
    [ordered]@{ name = $_.Name; values = $values.ToArray() }
})

$schemaStructs = @($StructOrder | ForEach-Object {
    $sn = $_
    $fields = [System.Collections.Generic.List[object]]::new()
    foreach ($f in $Structs[$sn]) {
        if ($f.Kind -eq 'guard') { continue }

        $desc = $f.Description
        $key = "$sn.$($f.Name)"
        if ($Curated.StructuralFieldNotes.ContainsKey($key)) { $desc = $Curated.StructuralFieldNotes[$key] }

        $entry = [ordered]@{
            name        = $f.Name
            type        = $f.Type
            kind        = $f.Kind
            description = $desc
        }
        if ($f.Guard)     { $entry.guard = $f.Guard }
        if ($f.ModeField) { $entry.modeField = $f.ModeField; $entry.modeEnum = $f.ModeEnum }
        $fields.Add($entry)
    }
    [ordered]@{ name = $sn; fields = $fields.ToArray() }
})

# ApplyTemplateEdit gives the config name but not its type or doc comment; both live on AbilityEdit.
$abilityEditFields = @()
if ($Structs.ContainsKey('AbilityEdit')) { $abilityEditFields = $Structs['AbilityEdit'] }

$schemaTemplate = @($TemplateFields | ForEach-Object {
    $rec = $_
    $structField = $abilityEditFields | Where-Object { $_.Name -eq $rec.Config } | Select-Object -First 1

    $type = ''
    $desc = ''
    if ($structField) {
        $type = $structField.Type
        $desc = $structField.Description
    }
    $key = "AbilityEdit.$($rec.Config)"
    if ($Curated.StructuralFieldNotes.ContainsKey($key)) { $desc = $Curated.StructuralFieldNotes[$key] }

    $entry = [ordered]@{
        config      = $rec.Config
        type        = $type
        kind        = $rec.Kind
        gameField   = $rec.GameField
        description = $desc
    }
    if ($rec.Kind -eq 'scalar') { $entry.guard = 'Set' + $rec.Config }
    if ($rec.Kind -eq 'namearray') {
        if ($rec.ReplaceOnly) {
            $entry.replaceOnly = $true
        }
        else {
            $entry.modeField = $rec.Config + 'Mode'
            if ($structField -and $structField.ModeField) { $entry.modeField = $structField.ModeField }
            if ($structField -and $structField.ModeEnum)  { $entry.modeEnum = $structField.ModeEnum }
        }
    }
    $entry
})

$schema = [ordered]@{
    '$comment' = 'Generated by .scripts/generate-docs.ps1 - do not edit by hand.'
    sourceHash = $sha
    enums      = $schemaEnums
    structs    = $schemaStructs
    template   = [ordered]@{ fields = $schemaTemplate; notEditable = $TemplateNotEditable }
    families   = $FamilyModels.ToArray()
    warnings   = $Warnings.ToArray()
}

$schemaJson = ($schema | ConvertTo-Json -Depth 14) + "`n"

#endregion

#region 6. Render the markdown blocks

# ---- summary block ----
$summary = [System.Text.StringBuilder]::new()
[void]$summary.Append("An ``+AbilityEdits`` entry can change:$nl$nl")

$templateList = ($TemplateFields | ForEach-Object { '`' + $_.Config + '`' }) -join ', '
[void]$summary.Append("- **Ability template fields** &mdash; $templateList$nl")

foreach ($fam in $FamilyModels) {
    $classes = @($fam.editors | Where-Object { -not $_.catchAll } | ForEach-Object { '`' + $_.gameClass + '`' })
    $classList = $classes -join ', '
    if ($fam.editors | Where-Object { $_.catchAll }) { $classList += ' &mdash; plus shared fields on any other subclass' }

    $status = ''
    if (-not $fam.wired) { $status = ' &#9888;&#65039; **not yet functional** (work in progress)' }

    $keyLabel = ''
    if ($fam.configKey) { $keyLabel = " (``$($fam.configKey)``)" }

    [void]$summary.Append("- **$($fam.name)**$keyLabel$status &mdash; $classList$nl")
}
$summaryMd = $summary.ToString()


#endregion

#region 7. Write outputs

if (-not (Test-Path $DocsDir)) { $null = New-Item -ItemType Directory -Path $DocsDir }

# Only the "supported at a glance" summary is injected into README.md. The full reference and the
# edit-mode tables are rendered from docs/schema.json by scripts/gen_reference.py at docs-build
# time, so producing them here as well would be a second source of truth for the same data.
$GeneratedBlocks = [ordered]@{
    'summary' = $summaryMd
}

$stale = $false

# schema.json
$existingSchema = ''
if (Test-Path $SchemaPath) { $existingSchema = [System.IO.File]::ReadAllText($SchemaPath) }
if ($existingSchema -ne $schemaJson) {
    if ($CheckOnly) {
        $stale = $true
        Write-Information 'STALE: docs/schema.json differs.'
    }
    else {
        [System.IO.File]::WriteAllText($SchemaPath, $schemaJson)
        Write-Information "Wrote $SchemaPath"
    }
}
else {
    Write-Information 'docs/schema.json is up to date.'
}

# README blocks
if (-not $SchemaOnly) {
    if (-not (Test-Path $ReadmePath)) {
        throw "README.md not found at $ReadmePath. Create the scaffold (with generated-block markers) first."
    }

    $readme = [System.IO.File]::ReadAllText($ReadmePath)
    $newlineStyle = "`n"
    if ($readme -match "`r`n") { $newlineStyle = "`r`n" }

    $updated = $readme
    foreach ($blockName in $GeneratedBlocks.Keys) {
        $begin = "<!-- BEGIN:GENERATED $blockName -->"
        $end   = "<!-- END:GENERATED $blockName -->"
        if ($updated.IndexOf($begin) -lt 0 -or $updated.IndexOf($end) -lt 0) {
            throw "README.md is missing markers for block '$blockName' ($begin ... $end)."
        }

        $content = $GeneratedBlocks[$blockName]
        if ($newlineStyle -ne "`n") { $content = $content -replace "`n", $newlineStyle }

        $startIdx = $updated.IndexOf($begin)
        $endIdx = $updated.IndexOf($end, $startIdx)
        $replacement = $begin + $newlineStyle + $content.TrimEnd() + $newlineStyle
        $updated = $updated.Substring(0, $startIdx) + $replacement + $updated.Substring($endIdx)
    }

    if ($updated -ne $readme) {
        if ($CheckOnly) {
            $stale = $true
            Write-Information 'STALE: README.md generated blocks differ.'
        }
        else {
            [System.IO.File]::WriteAllText($ReadmePath, $updated)
            Write-Information "Updated generated blocks in $ReadmePath"
        }
    }
    else {
        Write-Information 'README.md generated blocks are up to date.'
    }
}

#endregion

#region 8. Report

Write-Information ''
Write-Information ('Families: ' + (($FamilyModels | ForEach-Object { "$($_.name)=$(@($_.editors).Count) editors (wired: $($_.wired))" }) -join '; '))

if ($Warnings.Count -gt 0) {
    Write-Information ''
    Write-Information "Warnings ($($Warnings.Count)):"
    foreach ($w in $Warnings) { Write-Information "  - $w" }
}

#endregion

if ($CheckOnly -and $stale) { exit 1 }
exit 0
