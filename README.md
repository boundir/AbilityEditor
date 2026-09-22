# Ability Editor

An XCOM 2: War of the Chosen mod that lets you change how existing abilities work **purely from config** — no UnrealScript required. Costs, cooldowns, charges, effects, conditions and template fields of any ability (base game, DLC or other mods) can be edited by adding `+AbilityEdits` entries to an `.ini` file.

For example, letting a Ranger keep acting after using Slash is just:

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+AbilityEdits=( \\
    Ability=SwordSlice, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_ActionPoints", \\
            SetNumPoints=true, \\
            NumPoints=1, \\
            SetConsumeAllPoints=true, \\
            ConsumeAllPoints=false \\
        ) \\
    ) \\
)
```

> This documents the **2.0 config API**. The legacy 1.0 API (`[AbilityEditor.OPTC_Abilities]`, see `AbilityEditor/ReadMe.txt`) still works but is superseded by this one.

## How it works

At game start (`OnPostTemplatesCreated`), the mod reads every `+AbilityEdits=(...)` entry from the `[AbilityEditor.X2DLCInfo_AbilityEditor]` section of `XComAbilityEditor.ini`, finds the ability template named by `Ability`, and applies your edits to it.

Things to know about the syntax:

- **Line continuation**: end each line of a multi-line entry with ` \\` (a space and two backslashes), as in the examples.
- **`Set` + value pairs**: most fields come as a pair — a `SetX=true` switch and the `X=value` itself. A value without its `Set` switch is **ignored**. This is how the mod tells "you asked for 0" apart from "you didn't ask".
  ```ini
  SetNumTurns=true, NumTurns=5    ; applied
  NumTurns=5                      ; ignored!
  ```
- **Arrays** (`AdditionalAbilities`, `DamageTypes`, ...) instead come with a companion `...Mode` field that says how your list combines with the existing one — see [Edit modes](#edit-modes).
- **`Class=` resolution**: class names without a package prefix are assumed to come from the base game (`X2AbilityCost_ActionPoints` becomes `XComGame.X2AbilityCost_ActionPoints`). To target a class from another mod, qualify it: `Class="MyModPackage.X2AbilityCost_Custom"`.
- **Dispatch**: for each `Class` the mod picks the most specific editor it has for it (see the dispatch order lists in the [Reference](#reference)). Classes without a dedicated editor still get the family's *shared* fields.
- **Edit in place vs replace**: everything edits existing objects **in place** when possible. For the single-object slots (`Cooldown`, `Charges`, `ToHitCalc`, `ToHitOwnerOnMissCalc`, `TargetStyle`, `MultiTargetStyle`): omit `Class` to edit whatever is there, or set `Class` — if the existing object is already exactly that class it is edited in place, otherwise it is **replaced** by a fresh instance (fields you don't `Set` then fall back to that class's defaults).
- **Conditions** can be edited in seven places: `ShooterConditions`, `TargetConditions` and `MultiTargetConditions` at the top level of an `AbilityEdit` (the template's condition arrays), plus `TargetConditions`, `ApplyDamageModConditions`, `LethalDamageConditions` and `ToHitConditions` inside an `Effects` entry.

## Supported at a glance

<!-- BEGIN:GENERATED summary -->
An `+AbilityEdits` entry can change:

- **Ability template fields** &mdash; `Hostility`, `ConcealmentRule`, `CrossClassEligible`, `IsPassive`, `UniqueSource`, `AllowedByDefault`, `TriggerChance`, `SuperConcealmentLoss`, `ChosenActivationIncreasePerUse`, `LostSpawnIncreasePerUse`, `AbilityPointCost`, `DefaultSourceItemSlot`, `UseThrownGrenadeEffects`, `UseLaunchedGrenadeEffects`, `AllowFreeFireWeaponUpgrade`, `AllowAmmoEffects`, `AllowBonusWeaponEffects`, `SilentAbility`, `CannotTeleport`, `PreventsTargetTeleport`, `FinalizeAbilityName`, `CancelAbilityName`, `TwoTurnAttackAbility`, `IconImage`, `AbilityIconColor`, `AbilityIconBehaviorHUD`, `ShotHUDPriority`, `DisplayInUITooltip`, `DisplayInUITacticalText`, `DontDisplayInAbilitySummary`, `DisplayTargetHitChance`, `HideOnClassUnlock`, `AbilitySourceName`, `LimitTargetIcons`, `BypassAbilityConfirm`, `UseAmmoAsChargesForHUD`, `AmmoAsChargesDivisor`, `FriendlyFireWarning`, `FriendlyFireWarningRobotsOnly`, `CommanderAbility`, `AdditionalAbilities`, `PrerequisiteAbilities`, `OverrideAbilities`, `AssociatedPassives`, `PostActivationEvents`, `HideIfAvailable`
- **Costs** (`Costs`) &mdash; `X2AbilityCost_Ammo`, `X2AbilityCost_Charges`, `X2AbilityCost_ConsumeItem`, `X2AbilityCost_Focus`, `X2AbilityCost_ReserveActionPoints`, `X2AbilityCost_HeavyWeaponActionPoints`, `X2AbilityCost_QuickdrawActionPoints`, `X2AbilityCost_ActionPoints` &mdash; plus shared fields on any other subclass
- **Cooldown** (`Cooldown`) &mdash; `X2AbilityCooldown_AidProtocol`, `X2AbilityCooldown_PerPlayerType`, `X2AbilityCooldown_LocalAndGlobal`, `X2AbilityCooldown_Global`, `X2AbilityCooldown_Rend` &mdash; plus shared fields on any other subclass
- **Charges** (`Charges`) &mdash; `X2AbilityCharges_CocoonSpawnChryssalid`, `X2AbilityCharges_GremlinHeal`, `X2AbilityCharges_RevivalProtocol`, `X2AbilityCharges_ScanningProtocol`, `X2AbilityCharges_StasisLance` &mdash; plus shared fields on any other subclass
- **Effects** (`Effects`) &mdash; `X2Effect_Obsessed`, `X2Effect_Shattered`, `X2Effect_VanishingWind`, `X2Effect_KineticPlating`, `X2Effect_Vanish`, `X2Effect_BlastPadding`, `X2Effect_KillUnit`, `X2Effect_ParthenogenicPoison`, `X2Effect_PersistentStatChange`, `X2Effect_PersistentStatChangeRestoreDefault`, `X2Effect_SpawnPsiZombie`, `X2Effect_SpawnShadowbindUnit`, `X2Effect_ThreatAssessment`, `X2Effect_WallBreaking`, `X2Effect_Achilles`, `X2Effect_AdverseSoldierClasses`, `X2Effect_Amplify`, `X2Effect_ApplyBlazingPinionsTargetToWorld`, `X2Effect_ApplyFireToWorld`, `X2Effect_APRounds`, `X2Effect_Aura`, `X2Effect_Bewildered`, `X2Effect_BloodTrail`, `X2Effect_BonusArmor`, `X2Effect_BonusWeaponDamage`, `X2Effect_ConditionalDamageModifier`, `X2Effect_CoveringFire`, `X2Effect_DamageImmunity`, `X2Effect_DelayedAbilityActivation`, `X2Effect_FaceMultiRoundTarget`, `X2Effect_GenerateCover`, `X2Effect_Groundling`, `X2Effect_Guardian`, `X2Effect_HoloTarget`, `X2Effect_HolyWarriorDeath`, `X2Effect_HomingMine`, `X2Effect_HuntersInstinctDamage`, `X2Effect_ImmediateAbilityActivation`, `X2Effect_Impatient`, `X2Effect_Implacable`, `X2Effect_LaserSight`, `X2Effect_MeleeDamageAdjust`, `X2Effect_MindControl`, `X2Effect_ModifyReactionFire`, `X2Effect_ModifyStats`, `X2Effect_Nearsighted`, `X2Effect_Needle`, `X2Effect_Oblivious`, `X2Effect_OverrideDeathAnimOnLoad`, `X2Effect_PaleHorse`, `X2Effect_PersistentSquadViewer`, `X2Effect_PersistentTraversalChange`, `X2Effect_PersistentVoidConduit`, `X2Effect_Possessed`, `X2Effect_Reaper`, `X2Effect_Regeneration`, `X2Effect_RemoveEffectsByDamageType`, `X2Effect_ReserveOverwatchPoints`, `X2Effect_RunBehaviorTree`, `X2Effect_ScanningProtocol`, `X2Effect_SmokeGrenade`, `X2Effect_SpawnDestructible`, `X2Effect_SpawnUnit`, `X2Effect_Stasis`, `X2Effect_Stunned`, `X2Effect_SuperConcealModifier`, `X2Effect_Sustain`, `X2Effect_Sustained`, `X2Effect_TalonRounds`, `X2Effect_TargetDamageDistanceBonus`, `X2Effect_TargetDamageTypeBonus`, `X2Effect_ToHitModifier`, `X2Effect_TrackingShotMarkTarget`, `X2Effect_TurnStartActionPoints`, `X2Effect_VolatileMix`, `X2Effect_ApplyDirectionalWorldDamage`, `X2Effect_ApplyMedikitHeal`, `X2Effect_ApplyWeaponDamage`, `X2Effect_Brutal`, `X2Effect_EnableGlobalAbility`, `X2Effect_GetOverHere`, `X2Effect_GrantActionPoints`, `X2Effect_IncreaseBondmateCohesion`, `X2Effect_Knockback`, `X2Effect_LifeSteal`, `X2Effect_MarkValidActivationTiles`, `X2Effect_ModifyInitiativeOrder`, `X2Effect_ModifyTemplarFocus`, `X2Effect_LethalWeaponDamage`, `X2Effect_Persistent`, `X2Effect_ReduceCooldowns`, `X2Effect_RemoteStart`, `X2Effect_RemoveEffects`, `X2Effect_ReserveActionPoints`, `X2Effect_SetUnitValue`, `X2Effect_SoulSteal`, `X2Effect_Spotted`, `X2Effect_SuspendMissionTimer`, `X2Effect_TriggerEvent`, `X2Effect_VoidConduit`, `X2Effect_World` &mdash; plus shared fields on any other subclass
- **Conditions** &mdash; `X2Condition_UnitEffectsApplying`, `X2Condition_UnitEffectsOnSource`, `X2Condition_UnitEffectsWithAbilitySource`, `X2Condition_UnitEffectsWithAbilityTarget`, `X2Condition_AbilityProperty`, `X2Condition_AbilitySourceWeapon`, `X2Condition_BattleState`, `X2Condition_BerserkerDevastatingPunch`, `X2Condition_Bondmate`, `X2Condition_DarkEvent`, `X2Condition_EverVigilant`, `X2Condition_FuseTarget`, `X2Condition_GameplayTag`, `X2Condition_HackingTarget`, `X2Condition_Interactive`, `X2Condition_Lootable`, `X2Condition_MapProperty`, `X2Condition_OnGroundTile`, `X2Condition_PanicOnPod`, `X2Condition_PlayerTurns`, `X2Condition_StasisLanceTarget`, `X2Condition_StasisTarget`, `X2Condition_Stealth`, `X2Condition_UnblockedNeighborTile`, `X2Condition_UnitActionPoints`, `X2Condition_UnitAlertStatus`, `X2Condition_UnitEffects`, `X2Condition_UnitImmunities`, `X2Condition_UnitInEvacZone`, `X2Condition_UnitInteractions`, `X2Condition_UnitInventory`, `X2Condition_UnitProperty`, `X2Condition_UnitStatCheck`, `X2Condition_UnitType`, `X2Condition_UnitValue`, `X2Condition_Visibility` &mdash; plus shared fields on any other subclass
- **ToHitCalc** (`ToHitCalc`) &mdash; `X2AbilityToHitCalc_StatCheck_UnitVsUnit`, `X2AbilityToHitCalc_PercentChancePlusFocus`, `X2AbilityToHitCalc_PercentChanceWithBuddyZone`, `X2AbilityToHitCalc_StandardAim`, `X2AbilityToHitCalc_PercentChance`, `X2AbilityToHitCalc_Hacking`, `X2AbilityToHitCalc_RollStat`, `X2AbilityToHitCalc_RollStatTiers`, `X2AbilityToHitCalc_StatCheck` &mdash; plus shared fields on any other subclass
- **TargetStyle** (`TargetStyle`) &mdash; `X2AbilityTarget_MovingMelee`, `X2AbilityTarget_Single`, `X2AbilityTarget_Cursor` &mdash; plus shared fields on any other subclass
- **MultiTargetStyle** (`MultiTargetStyle`) &mdash; `X2AbilityMultiTarget_Cone`, `X2AbilityMultiTarget_Cylinder`, `X2AbilityMultiTarget_AllUnits`, `X2AbilityMultiTarget_ClaymoreRadius`, `X2AbilityMultiTarget_Radius`, `X2AbilityMultiTarget_Line`, `X2AbilityMultiTarget_BurstFire` &mdash; plus shared fields on any other subclass
- **Triggers** (`Triggers`) &mdash; `X2AbilityTrigger_UnitPostBeginPlay`, `X2AbilityTrigger_EventListener`, `X2AbilityTrigger_Event` &mdash; plus shared fields on any other subclass
<!-- END:GENERATED summary -->

## Edit modes

Array-type fields and multi-entry blocks take a mode that controls how your config combines with what the ability already has. The exact semantics per enum value:

<!-- BEGIN:GENERATED enums -->
#### `EStatChangeMode`

| Value | Meaning |
|---|---|
| `eSCM_Replace` | Clear existing stat changes (`m_aStatChanges`) before applying yours. (Default) |
| `eSCM_Merge` | Update the entry for each `StatType` if present, otherwise add it. |

#### `EAbilityEffectSlot`

| Value | Meaning |
|---|---|
| `eAES_Target` | Edit `AbilityTargetEffects` (effects applied to the primary target). (Default) |
| `eAES_MultiTarget` | Edit `AbilityMultiTargetEffects`. |
| `eAES_Shooter` | Edit `AbilityShooterEffects` (effects applied to the shooter). |

#### `EChargesBonusMode`

| Value | Meaning |
|---|---|
| `eCBM_Replace` | Clear existing `BonusCharges` entries before applying yours. (Default) |
| `eCBM_Merge` | Update the entry for each `AbilityName` if present, otherwise add it. |

#### `EAdditionalCooldownEditMode`

| Value | Meaning |
|---|---|
| `eACEM_Replace` | Clear existing `AditionalAbilityCooldowns` entries before applying yours. (Default) |
| `eACEM_Merge` | Update the entry for each `AbilityName` if present, otherwise add it. |

#### `EAbilityCostEditMode`

| Value | Meaning |
|---|---|
| `eACEM_ReplaceAll` | As `CostMode`: clear **all** existing costs before applying the entries. As per-entry `Mode`: edit in place if a cost of that class exists, otherwise skip (unless `CostMode=eACEM_ReplaceAll`, in which case a new cost is added). (Default) |
| `eACEM_Merge` | Edit the existing cost of that class in place; if none exists, instantiate and add it. |
| `eACEM_AddOnly` | Same as `eACEM_Merge`: edit in place if present, otherwise add. |
| `eACEM_Remove` | Remove the cost of that class from the ability. |

#### `EArrayEditMode`

| Value | Meaning |
|---|---|
| `eAEM_ReplaceAll` | Clear the whole target array, then add this effect/condition. (Default) |
| `eAEM_Merge` | Edit the existing effect/condition of that class in place; if none exists, instantiate and add it. |
| `eAEM_AddOnly` | Same as `eAEM_Merge`: edit in place if present, otherwise add. |
| `eAEM_Remove` | Remove the first effect/condition of that class from the target array. |

#### `ENameArrayEditMode`

| Value | Meaning |
|---|---|
| `eNAEM_Replace` | Replace the whole target array with the provided values. (Default) |
| `eNAEM_Merge` | Append each provided value that is not already present. |
| `eNAEM_AddOnly` | Set the provided values **only if the target array is currently empty**; otherwise do nothing. It does not append. |
| `eNAEM_Remove` | Remove each provided value from the target array. |
<!-- END:GENERATED enums -->

> **Watch out:** the *default* mode is always the first enum value. For `Costs` that means `eACEM_ReplaceAll` — listing any `Costs` without setting `CostMode` **wipes all existing costs** and keeps only what you list. And `AddOnly` for name arrays does **not** append; it only sets the values when the target array is empty.

## Reference

<!-- BEGIN:GENERATED reference -->
### Template fields

Applied directly to the `X2AbilityTemplate`.

| Config key | Requires | Game field |
|---|---|---|
| `Ability` | required | template lookup (`FindAbilityTemplate`) |
| `Hostility` | `SetHostility=true` | `Hostility` |
| `ConcealmentRule` | `SetConcealmentRule=true` | `ConcealmentRule` |
| `CrossClassEligible` | `SetCrossClassEligible=true` | `bCrossClassEligible` |
| `IsPassive` | `SetIsPassive=true` | `bIsPassive` |
| `UniqueSource` | `SetUniqueSource=true` | `bUniqueSource` |
| `AllowedByDefault` | `SetAllowedByDefault=true` | `bAllowedByDefault` |
| `TriggerChance` | `SetTriggerChance=true` | `TriggerChance` |
| `SuperConcealmentLoss` | `SetSuperConcealmentLoss=true` | `SuperConcealmentLoss` |
| `ChosenActivationIncreasePerUse` | `SetChosenActivationIncreasePerUse=true` | `ChosenActivationIncreasePerUse` |
| `LostSpawnIncreasePerUse` | `SetLostSpawnIncreasePerUse=true` | `LostSpawnIncreasePerUse` |
| `AbilityPointCost` | `SetAbilityPointCost=true` | `AbilityPointCost` |
| `DefaultSourceItemSlot` | `SetDefaultSourceItemSlot=true` | `DefaultSourceItemSlot` |
| `UseThrownGrenadeEffects` | `SetUseThrownGrenadeEffects=true` | `bUseThrownGrenadeEffects` |
| `UseLaunchedGrenadeEffects` | `SetUseLaunchedGrenadeEffects=true` | `bUseLaunchedGrenadeEffects` |
| `AllowFreeFireWeaponUpgrade` | `SetAllowFreeFireWeaponUpgrade=true` | `bAllowFreeFireWeaponUpgrade` |
| `AllowAmmoEffects` | `SetAllowAmmoEffects=true` | `bAllowAmmoEffects` |
| `AllowBonusWeaponEffects` | `SetAllowBonusWeaponEffects=true` | `bAllowBonusWeaponEffects` |
| `SilentAbility` | `SetSilentAbility=true` | `bSilentAbility` |
| `CannotTeleport` | `SetCannotTeleport=true` | `bCannotTeleport` |
| `PreventsTargetTeleport` | `SetPreventsTargetTeleport=true` | `bPreventsTargetTeleport` |
| `FinalizeAbilityName` | `SetFinalizeAbilityName=true` | `FinalizeAbilityName` |
| `CancelAbilityName` | `SetCancelAbilityName=true` | `CancelAbilityName` |
| `TwoTurnAttackAbility` | `SetTwoTurnAttackAbility=true` | `TwoTurnAttackAbility` |
| `IconImage` | `SetIconImage=true` | `IconImage` |
| `AbilityIconColor` | `SetAbilityIconColor=true` | `AbilityIconColor` |
| `AbilityIconBehaviorHUD` | `SetAbilityIconBehaviorHUD=true` | `eAbilityIconBehaviorHUD` |
| `ShotHUDPriority` | `SetShotHUDPriority=true` | `ShotHUDPriority` |
| `DisplayInUITooltip` | `SetDisplayInUITooltip=true` | `bDisplayInUITooltip` |
| `DisplayInUITacticalText` | `SetDisplayInUITacticalText=true` | `bDisplayInUITacticalText` |
| `DontDisplayInAbilitySummary` | `SetDontDisplayInAbilitySummary=true` | `bDontDisplayInAbilitySummary` |
| `DisplayTargetHitChance` | `SetDisplayTargetHitChance=true` | `DisplayTargetHitChance` |
| `HideOnClassUnlock` | `SetHideOnClassUnlock=true` | `bHideOnClassUnlock` |
| `AbilitySourceName` | `SetAbilitySourceName=true` | `AbilitySourceName` |
| `LimitTargetIcons` | `SetLimitTargetIcons=true` | `bLimitTargetIcons` |
| `BypassAbilityConfirm` | `SetBypassAbilityConfirm=true` | `bBypassAbilityConfirm` |
| `UseAmmoAsChargesForHUD` | `SetUseAmmoAsChargesForHUD=true` | `bUseAmmoAsChargesForHUD` |
| `AmmoAsChargesDivisor` | `SetAmmoAsChargesDivisor=true` | `iAmmoAsChargesDivisor` |
| `FriendlyFireWarning` | `SetFriendlyFireWarning=true` | `bFriendlyFireWarning` |
| `FriendlyFireWarningRobotsOnly` | `SetFriendlyFireWarningRobotsOnly=true` | `bFriendlyFireWarningRobotsOnly` |
| `CommanderAbility` | `SetCommanderAbility=true` | `bCommanderAbility` |
| `AdditionalAbilities` | `AdditionalAbilitiesMode` | `AdditionalAbilities` |
| `PrerequisiteAbilities` | `PrerequisiteAbilitiesMode` | `PrerequisiteAbilities` |
| `OverrideAbilities` | `OverrideAbilitiesMode` | `OverrideAbilities` |
| `AssociatedPassives` | `AssociatedPassivesMode` | `AssociatedPassives` |
| `PostActivationEvents` | `PostActivationEventsMode` | `PostActivationEvents` |
| `HideIfAvailable` | `HideIfAvailableMode` | `HideIfAvailable` |
| `AbilityEventListenerEdits` | `EventID` match | `AbilityEventListeners` &mdash; edit-existing-only, see [`AbilityEventListenerEdit`](#nested-structs) |

<details><summary>Template fields not editable via config (84)</summary>

`Requirements` *(type `StrategyRequirement`)*, `bRecordValidTiles` *(not covered (deliberate core-set choice))*, `bTickPerActionEffects` *(not covered (deliberate core-set choice))*, `bCheckCollision` *(not covered (deliberate core-set choice))*, `bAffectNeighboringTiles` *(not covered (deliberate core-set choice))*, `bFragileDamageOnly` *(not covered (deliberate core-set choice))*, `AbilityRevealEvent` *(not covered (deliberate core-set choice))*, `ChosenReinforcementGroupName` *(not covered (deliberate core-set choice))*, `ChosenTraitType` *(not covered (deliberate core-set choice))*, `ChosenExcludeTraits` *(not covered (deliberate core-set choice))*, `ChosenTraitForceLevelGate` *(not covered (deliberate core-set choice))*, `HideErrors` *(not covered (deliberate core-set choice))*, `bNoConfirmationWithHotKey` *(not covered (deliberate core-set choice))*, `AbilityConfirmSound` *(not covered (deliberate core-set choice))*, `DefaultKeyBinding` *(not covered (deliberate core-set choice))*, `UIStatMarkups` *(array of `UIAbilityStatMarkup`)*, `CustomFireAnim` *(not covered (deliberate core-set choice))*, `CustomFireKillAnim` *(not covered (deliberate core-set choice))*, `CustomMovingFireAnim` *(not covered (deliberate core-set choice))*, `CustomMovingFireKillAnim` *(not covered (deliberate core-set choice))*, `CustomMovingTurnLeftFireAnim` *(not covered (deliberate core-set choice))*, `CustomMovingTurnLeftFireKillAnim` *(not covered (deliberate core-set choice))*, `CustomMovingTurnRightFireAnim` *(not covered (deliberate core-set choice))*, `CustomMovingTurnRightFireKillAnim` *(not covered (deliberate core-set choice))*, `CustomSelfFireAnim` *(not covered (deliberate core-set choice))*, `AssociatedPlayTiming` *(type `SequencePlayTiming`)*, `bShowActivation` *(not covered (deliberate core-set choice))*, `bShowPostActivation` *(not covered (deliberate core-set choice))*, `bSkipFireAction` *(not covered (deliberate core-set choice))*, `bSkipExitCoverWhenFiring` *(not covered (deliberate core-set choice))*, `bSkipPerkActivationActions` *(not covered (deliberate core-set choice))*, `bSkipPerkActivationActionsSync` *(not covered (deliberate core-set choice))*, `bSkipMoveStop` *(not covered (deliberate core-set choice))*, `bOverrideMeleeDeath` *(not covered (deliberate core-set choice))*, `bOverrideVisualResult` *(not covered (deliberate core-set choice))*, `OverrideVisualResult` *(not covered (deliberate core-set choice))*, `bHideWeaponDuringFire` *(not covered (deliberate core-set choice))*, `bHideAmmoWeaponDuringFire` *(not covered (deliberate core-set choice))*, `bIsASuppressionEffect` *(not covered (deliberate core-set choice))*, `bOverrideAim` *(not covered (deliberate core-set choice))*, `bUseSourceLocationZToAim` *(not covered (deliberate core-set choice))*, `bOverrideWeapon` *(not covered (deliberate core-set choice))*, `bStationaryWeapon` *(not covered (deliberate core-set choice))*, `ActionFireClass` *(class reference)*, `bForceProjectileTouchEvents` *(not covered (deliberate core-set choice))*, `ActivationSpeech` *(not covered (deliberate core-set choice))*, `SourceHitSpeech` *(not covered (deliberate core-set choice))*, `TargetHitSpeech` *(not covered (deliberate core-set choice))*, `SourceMissSpeech` *(not covered (deliberate core-set choice))*, `TargetMissSpeech` *(not covered (deliberate core-set choice))*, `TargetKilledByAlienSpeech` *(not covered (deliberate core-set choice))*, `TargetKilledByXComSpeech` *(not covered (deliberate core-set choice))*, `MultiTargetsKilledByAlienSpeech` *(not covered (deliberate core-set choice))*, `MultiTargetsKilledByXComSpeech` *(not covered (deliberate core-set choice))*, `TargetWingedSpeech` *(not covered (deliberate core-set choice))*, `TargetArmorHitSpeech` *(not covered (deliberate core-set choice))*, `TargetMissedSpeech` *(not covered (deliberate core-set choice))*, `AbilityPassiveAOEStyle` *(type `X2AbilityPassiveAOEStyle`)*, `bAllowUnderhandAnim` *(not covered (deliberate core-set choice))*, `TargetingMethod` *(class reference)*, `SecondaryTargetingMethod` *(class reference)*, `SkipRenderOfAOETargetingTiles` *(not covered (deliberate core-set choice))*, `SkipRenderOfTargetingTemplate` *(not covered (deliberate core-set choice))*, `MeleePuckMeshPath` *(not covered (deliberate core-set choice))*, `CinescriptCameraType` *(not covered (deliberate core-set choice))*, `CameraPriority` *(not covered (deliberate core-set choice))*, `bUsesFiringCamera` *(not covered (deliberate core-set choice))*, `FrameAbilityCameraType` *(not covered (deliberate core-set choice))*, `bFrameEvenWhenUnitIsHidden` *(not covered (deliberate core-set choice))*, `BuildNewGameStateFn` *(delegate &mdash; code-only)*, `BuildInterruptGameStateFn` *(delegate &mdash; code-only)*, `BuildVisualizationFn` *(delegate &mdash; code-only)*, `BuildAppliedVisualizationSyncFn` *(delegate &mdash; code-only)*, `BuildAffectedVisualizationSyncFn` *(delegate &mdash; code-only)*, `SoldierAbilityPurchasedFn` *(delegate &mdash; code-only)*, `OnVisualizationTrackInsertedFn` *(delegate &mdash; code-only)*, `ModifyNewContextFn` *(delegate &mdash; code-only)*, `DamagePreviewFn` *(delegate &mdash; code-only)*, `GetBonusWeaponAmmoFn` *(delegate &mdash; code-only)*, `MergeVisualizationFn` *(delegate &mdash; code-only)*, `AlternateFriendlyNameFn` *(delegate &mdash; code-only)*, `ShouldRevealChosenTraitFn` *(delegate &mdash; code-only)*, `OverrideAbilityAvailabilityFn` *(delegate &mdash; code-only)*, `MP_PerkOverride` *(not covered (deliberate core-set choice))*

</details>

### Costs (`Costs`)

Edits the `AbilityCosts` array of the template. Costs are edited **in place** when a cost of the given `Class` already exists; otherwise behaviour depends on the modes below. Fields you do not `Set` keep their current value.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Cost class to target/instantiate, e.g. `X2AbilityCost_ActionPoints`. Bare names are auto-prefixed with `XComGame.`; empty falls back to `X2AbilityCost`. |
| `Mode` | `EAbilityCostEditMode` | Per-entry edit mode (`EAbilityCostEditMode`), see [Edit modes](#edit-modes). |

Editor dispatch order (first match wins): `X2AbilityCost_Ammo` &rarr; `X2AbilityCost_Charges` &rarr; `X2AbilityCost_ConsumeItem` &rarr; `X2AbilityCost_Focus` &rarr; `X2AbilityCost_ReserveActionPoints` &rarr; `X2AbilityCost_HeavyWeaponActionPoints` &rarr; `X2AbilityCost_QuickdrawActionPoints` &rarr; `X2AbilityCost_ActionPoints` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `FreeCost` | `bool` | `SetFreeCost=true` | `bFreeCost` |  |

#### `X2AbilityCost_Ammo`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumAmmo` | `int` | `SetNumAmmo=true` | `iAmmo` |  |
| `UseLoadedAmmo` | `bool` | `SetUseLoadedAmmo=true` | `UseLoadedAmmo` |  |
| `ReturnChargesError` | `bool` | `SetReturnChargesError=true` | `bReturnChargesError` |  |
| `ConsumeAllAmmo` | `bool` | `SetConsumeAllAmmo=true` | `bConsumeAllAmmo` |  |

#### `X2AbilityCost_Charges`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumCharges` | `int` | `SetNumCharges=true` | `NumCharges` |  |
| `OnlyOnHit` | `bool` | `SetOnlyOnHit=true` | `bOnlyOnHit` |  |
| `AlsoExpendChargesOnSharedBondmateAbility` | `bool` | `SetAlsoExpendChargesOnSharedBondmateAbility=true` | `bAlsoExpendChargesOnSharedBondmateAbility` |  |
| `SharedAbilityCharges` | `array<name>` | `SharedAbilityChargesMode` | `SharedAbilityCharges` |  |

#### `X2AbilityCost_ConsumeItem`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCost_Focus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `FocusAmount` | `int` | `SetFocusAmount=true` | `FocusAmount` |  |
| `ConsumeAllFocus` | `bool` | `SetConsumeAllFocus=true` | `ConsumeAllFocus` |  |
| `GhostOnlyCost` | `bool` | `SetGhostOnlyCost=true` | `GhostOnlyCost` |  |

#### `X2AbilityCost_ReserveActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumPoints` | `int` | `SetNumPoints=true` | `iNumPoints` |  |
| `ConsumeAllPoints` | `bool` | `SetConsumeAllPoints=true` | `bConsumeAllPoints` |  |
| `AllowedTypes` | `array<name>` | `AllowedTypesMode` | `AllowedTypes` |  |

#### `X2AbilityCost_HeavyWeaponActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumPoints` | `int` | `SetNumPoints=true` | `iNumPoints` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `ConsumeAllPoints` | `bool` | `SetConsumeAllPoints=true` | `bConsumeAllPoints` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `AddWeaponTypicalCost` | `bool` | `SetAddWeaponTypicalCost=true` | `bAddWeaponTypicalCost` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `MoveCost` | `bool` | `SetMoveCost=true` | `bMoveCost` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `AllowedTypes` | `array<name>` | `AllowedTypesMode` | `AllowedTypes` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `DoNotConsumeAllEffects` | `array<name>` | `DoNotConsumeAllEffectsMode` | `DoNotConsumeAllEffects` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `DoNotConsumeAllSoldierAbilities` | `array<name>` | `DoNotConsumeAllSoldierAbilitiesMode` | `DoNotConsumeAllSoldierAbilities` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |

#### `X2AbilityCost_QuickdrawActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumPoints` | `int` | `SetNumPoints=true` | `iNumPoints` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `ConsumeAllPoints` | `bool` | `SetConsumeAllPoints=true` | `bConsumeAllPoints` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `AddWeaponTypicalCost` | `bool` | `SetAddWeaponTypicalCost=true` | `bAddWeaponTypicalCost` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `MoveCost` | `bool` | `SetMoveCost=true` | `bMoveCost` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `AllowedTypes` | `array<name>` | `AllowedTypesMode` | `AllowedTypes` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `DoNotConsumeAllEffects` | `array<name>` | `DoNotConsumeAllEffectsMode` | `DoNotConsumeAllEffects` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |
| `DoNotConsumeAllSoldierAbilities` | `array<name>` | `DoNotConsumeAllSoldierAbilitiesMode` | `DoNotConsumeAllSoldierAbilities` | *(shared &mdash; from `X2AbilityCostEditor_ActionPoints`)* |

#### `X2AbilityCost_ActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumPoints` | `int` | `SetNumPoints=true` | `iNumPoints` |  |
| `ConsumeAllPoints` | `bool` | `SetConsumeAllPoints=true` | `bConsumeAllPoints` |  |
| `AddWeaponTypicalCost` | `bool` | `SetAddWeaponTypicalCost=true` | `bAddWeaponTypicalCost` |  |
| `MoveCost` | `bool` | `SetMoveCost=true` | `bMoveCost` |  |
| `AllowedTypes` | `array<name>` | `AllowedTypesMode` | `AllowedTypes` |  |
| `DoNotConsumeAllEffects` | `array<name>` | `DoNotConsumeAllEffectsMode` | `DoNotConsumeAllEffects` |  |
| `DoNotConsumeAllSoldierAbilities` | `array<name>` | `DoNotConsumeAllSoldierAbilitiesMode` | `DoNotConsumeAllSoldierAbilities` |  |

#### Any other class

Handled by `X2AbilityCostEditor_Base`: only the shared fields above apply.

### Cooldown (`Cooldown`)

Edits the template's `AbilityCooldown`. With `Class` **omitted**, the existing cooldown is edited **in place** (no-op if the ability has none). With `Class` set, the existing cooldown is edited in place when it is already exactly that class; otherwise it is **replaced** by a new instance — any field you do not `Set` then takes the class's default value.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Optional. Omitted = edit the existing cooldown in place. Set = target/instantiate that class, e.g. `X2AbilityCooldown_PerPlayerType`. Bare names are auto-prefixed with `XComGame.`. |

Editor dispatch order (first match wins): `X2AbilityCooldown_AidProtocol` &rarr; `X2AbilityCooldown_PerPlayerType` &rarr; `X2AbilityCooldown_LocalAndGlobal` &rarr; `X2AbilityCooldown_Global` &rarr; `X2AbilityCooldown_Rend` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` |  |
| `IgnoreOnHit` | `bool` | `SetIgnoreOnHit=true` | `bDoNotApplyOnHit` |  |
| `AdditionalCooldowns` | `array<AdditionalCooldownEdit>` | `AdditionalCooldownMode` | `AditionalAbilityCooldowns` | see [`AdditionalCooldownEdit`](#nested-structs) |

#### `X2AbilityCooldown_AidProtocol`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCooldown_PerPlayerType`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumTurnsForAI` | `int` | `SetNumTurnsForAI=true` | `iNumTurnsForAI` |  |
| `NumGlobalTurns` | `int` | `SetNumGlobalTurns=true` | `NumGlobalTurns` | *(shared &mdash; from `X2AbilityCooldownEditor_LocalAndGlobal`)* |

#### `X2AbilityCooldown_LocalAndGlobal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumGlobalTurns` | `int` | `SetNumGlobalTurns=true` | `NumGlobalTurns` |  |

#### `X2AbilityCooldown_Global`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCooldown_Rend`

No class-specific fields; the shared fields above apply.

#### Any other class

Handled by `X2AbilityCooldownEditor_Base`: only the shared fields above apply.

### Charges (`Charges`)

Edits the template's `AbilityCharges`. With `Class` **omitted**, the existing charges object is edited **in place** (no-op if the ability has none). With `Class` set, the existing object is edited in place when it is already exactly that class; otherwise it is **replaced** by a new instance — any field you do not `Set` then takes the class's default value. `RemoveCharges=true` removes the charges object entirely.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Optional. Omitted = edit the existing charges object in place. Set = target/instantiate that class, e.g. `X2AbilityCharges_GremlinHeal`. Bare names are auto-prefixed with `XComGame.`. |
| `RemoveCharges` | `bool` | Set to true to remove the ability's charges object entirely. No `Class` needed; the other fields of the block are ignored. |

Editor dispatch order (first match wins): `X2AbilityCharges_CocoonSpawnChryssalid` &rarr; `X2AbilityCharges_GremlinHeal` &rarr; `X2AbilityCharges_RevivalProtocol` &rarr; `X2AbilityCharges_ScanningProtocol` &rarr; `X2AbilityCharges_StasisLance` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InitialCharges` | `int` | `SetInitialCharges=true` | `InitialCharges` |  |
| `BonusCharges` | `array<BonusChargeEdit>` | `BonusChargesMode` | `BonusCharges` | see [`BonusChargeEdit`](#nested-structs) |

#### `X2AbilityCharges_CocoonSpawnChryssalid`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCharges_GremlinHeal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `Stabilize` | `bool` | `SetStabilize=true` | `bStabilize` |  |

#### `X2AbilityCharges_RevivalProtocol`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCharges_ScanningProtocol`

No class-specific fields; the shared fields above apply.

#### `X2AbilityCharges_StasisLance`

No class-specific fields; the shared fields above apply.

#### Any other class

Handled by `X2AbilityChargesEditor_Base`: only the shared fields above apply.

### Effects (`Effects`)

Edits the effect arrays of the template. `Slot` selects which array is edited (see `EAbilityEffectSlot`). Within the selected array the effect of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Effect class to target/instantiate, e.g. `X2Effect_ApplyWeaponDamage`. Bare names are auto-prefixed with `XComGame.`; empty falls back to `X2Effect`. |
| `Slot` | `EAbilityEffectSlot` | Which effect array to edit (`EAbilityEffectSlot`): `eAES_Target`, `eAES_MultiTarget` or `eAES_Shooter`. |
| `Mode` | `EArrayEditMode` | Per-entry edit mode (`EArrayEditMode`), see [Edit modes](#edit-modes). |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2Effect_Obsessed` &rarr; `X2Effect_Shattered` &rarr; `X2Effect_VanishingWind` &rarr; `X2Effect_KineticPlating` &rarr; `X2Effect_Vanish` &rarr; `X2Effect_BlastPadding` &rarr; `X2Effect_KillUnit` &rarr; `X2Effect_ParthenogenicPoison` &rarr; `X2Effect_PersistentStatChange` &rarr; `X2Effect_PersistentStatChangeRestoreDefault` &rarr; `X2Effect_SpawnPsiZombie` &rarr; `X2Effect_SpawnShadowbindUnit` &rarr; `X2Effect_ThreatAssessment` &rarr; `X2Effect_WallBreaking` &rarr; `X2Effect_Achilles` &rarr; `X2Effect_AdverseSoldierClasses` &rarr; `X2Effect_Amplify` &rarr; `X2Effect_ApplyBlazingPinionsTargetToWorld` &rarr; `X2Effect_ApplyFireToWorld` &rarr; `X2Effect_APRounds` &rarr; `X2Effect_Aura` &rarr; `X2Effect_Bewildered` &rarr; `X2Effect_BloodTrail` &rarr; `X2Effect_BonusArmor` &rarr; `X2Effect_BonusWeaponDamage` &rarr; `X2Effect_ConditionalDamageModifier` &rarr; `X2Effect_CoveringFire` &rarr; `X2Effect_DamageImmunity` &rarr; `X2Effect_DelayedAbilityActivation` &rarr; `X2Effect_FaceMultiRoundTarget` &rarr; `X2Effect_GenerateCover` &rarr; `X2Effect_Groundling` &rarr; `X2Effect_Guardian` &rarr; `X2Effect_HoloTarget` &rarr; `X2Effect_HolyWarriorDeath` &rarr; `X2Effect_HomingMine` &rarr; `X2Effect_HuntersInstinctDamage` &rarr; `X2Effect_ImmediateAbilityActivation` &rarr; `X2Effect_Impatient` &rarr; `X2Effect_Implacable` &rarr; `X2Effect_LaserSight` &rarr; `X2Effect_MeleeDamageAdjust` &rarr; `X2Effect_MindControl` &rarr; `X2Effect_ModifyReactionFire` &rarr; `X2Effect_ModifyStats` &rarr; `X2Effect_Nearsighted` &rarr; `X2Effect_Needle` &rarr; `X2Effect_Oblivious` &rarr; `X2Effect_OverrideDeathAnimOnLoad` &rarr; `X2Effect_PaleHorse` &rarr; `X2Effect_PersistentSquadViewer` &rarr; `X2Effect_PersistentTraversalChange` &rarr; `X2Effect_PersistentVoidConduit` &rarr; `X2Effect_Possessed` &rarr; `X2Effect_Reaper` &rarr; `X2Effect_Regeneration` &rarr; `X2Effect_RemoveEffectsByDamageType` &rarr; `X2Effect_ReserveOverwatchPoints` &rarr; `X2Effect_RunBehaviorTree` &rarr; `X2Effect_ScanningProtocol` &rarr; `X2Effect_SmokeGrenade` &rarr; `X2Effect_SpawnDestructible` &rarr; `X2Effect_SpawnUnit` &rarr; `X2Effect_Stasis` &rarr; `X2Effect_Stunned` &rarr; `X2Effect_SuperConcealModifier` &rarr; `X2Effect_Sustain` &rarr; `X2Effect_Sustained` &rarr; `X2Effect_TalonRounds` &rarr; `X2Effect_TargetDamageDistanceBonus` &rarr; `X2Effect_TargetDamageTypeBonus` &rarr; `X2Effect_ToHitModifier` &rarr; `X2Effect_TrackingShotMarkTarget` &rarr; `X2Effect_TurnStartActionPoints` &rarr; `X2Effect_VolatileMix` &rarr; `X2Effect_ApplyDirectionalWorldDamage` &rarr; `X2Effect_ApplyMedikitHeal` &rarr; `X2Effect_ApplyWeaponDamage` &rarr; `X2Effect_Brutal` &rarr; `X2Effect_EnableGlobalAbility` &rarr; `X2Effect_GetOverHere` &rarr; `X2Effect_GrantActionPoints` &rarr; `X2Effect_IncreaseBondmateCohesion` &rarr; `X2Effect_Knockback` &rarr; `X2Effect_LifeSteal` &rarr; `X2Effect_MarkValidActivationTiles` &rarr; `X2Effect_ModifyInitiativeOrder` &rarr; `X2Effect_ModifyTemplarFocus` &rarr; `X2Effect_LethalWeaponDamage` &rarr; `X2Effect_Persistent` &rarr; `X2Effect_ReduceCooldowns` &rarr; `X2Effect_RemoteStart` &rarr; `X2Effect_RemoveEffects` &rarr; `X2Effect_ReserveActionPoints` &rarr; `X2Effect_SetUnitValue` &rarr; `X2Effect_SoulSteal` &rarr; `X2Effect_Spotted` &rarr; `X2Effect_SuspendMissionTimer` &rarr; `X2Effect_TriggerEvent` &rarr; `X2Effect_VoidConduit` &rarr; `X2Effect_World` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ApplyOnHit` | `bool` | `SetApplyOnHit=true` | `bApplyOnHit` |  |
| `ApplyOnMiss` | `bool` | `SetApplyOnMiss=true` | `bApplyOnMiss` |  |
| `ApplyChance` | `int` | `SetApplyChance=true` | `ApplyChance` |  |
| `ApplyToWorldOnHit` | `bool` | `SetApplyToWorldOnHit=true` | `bApplyToWorldOnHit` |  |
| `ApplyToWorldOnMiss` | `bool` | `SetApplyToWorldOnMiss=true` | `bApplyToWorldOnMiss` |  |
| `UseSourcePlayerState` | `bool` | `SetUseSourcePlayerState=true` | `bUseSourcePlayerState` |  |
| `IsImpairing` | `bool` | `SetIsImpairing=true` | `bIsImpairing` |  |
| `IsImpairingMomentarily` | `bool` | `SetIsImpairingMomentarily=true` | `bIsImpairingMomentarily` |  |
| `BringRemoveVisualizationForward` | `bool` | `SetBringRemoveVisualizationForward=true` | `bBringRemoveVisualizationForward` |  |
| `ShowImmunity` | `bool` | `SetShowImmunity=true` | `bShowImmunity` |  |
| `ShowImmunityAnyFailure` | `bool` | `SetShowImmunityAnyFailure=true` | `bShowImmunityAnyFailure` |  |
| `AppliesDamage` | `bool` | `SetAppliesDamage=true` | `bAppliesDamage` |  |
| `CanBeRedirected` | `bool` | `SetCanBeRedirected=true` | `bCanBeRedirected` |  |
| `HideDeathWorldMessage` | `bool` | `SetHideDeathWorldMessage=true` | `bHideDeathWorldMessage` |  |
| `MinStatContestResult` | `int` | `SetMinStatContestResult=true` | `MinStatContestResult` |  |
| `MaxStatContestResult` | `int` | `SetMaxStatContestResult=true` | `MaxStatContestResult` |  |
| `DelayVisualizationSec` | `float` | `SetDelayVisualizationSec=true` | `DelayVisualizationSec` |  |
| `OverrideMissMessage` | `string` | `SetOverrideMissMessage=true` | `OverrideMissMessage` |  |
| `DamageTypes` | `array<name>` | `DamageTypesMode` | `DamageTypes` |  |
| `TargetConditions` | `array<ConditionEdit>` | &mdash; | `TargetConditions` | Conditions attached to the effect (X2Effect.TargetConditions) &mdash; see [Conditions](#conditions) |

#### `X2Effect_Obsessed`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ObsessedTargetValueName` | `Name` | `SetObsessedTargetValueName=true` | `ObsessedTargetValueName` |  |
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* &mdash; see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Shattered`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ShatteredTargetValueName` | `Name` | `SetShatteredTargetValueName=true` | `ShatteredTargetValueName` |  |
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* &mdash; see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_VanishingWind`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MovingVanishRevealAdditiveAnimName` | `name` | `SetMovingVanishRevealAdditiveAnimName=true` | `MovingVanishRevealAdditiveAnimName` |  |
| `ReasonNotVisible` | `name` | `SetReasonNotVisible=true` | `ReasonNotVisible` | *(shared &mdash; from `X2AbilityEffectsEditor_Vanish`)* |
| `VanishRevealAdditiveAnimName` | `name` | `SetVanishRevealAdditiveAnimName=true` | `VanishRevealAdditiveAnimName` | *(shared &mdash; from `X2AbilityEffectsEditor_Vanish`)* |
| `VanishRevealAnimName` | `name` | `SetVanishRevealAnimName=true` | `VanishRevealAnimName` | *(shared &mdash; from `X2AbilityEffectsEditor_Vanish`)* |
| `VanishSyncAnimName` | `name` | `SetVanishSyncAnimName=true` | `VanishSyncAnimName` | *(shared &mdash; from `X2AbilityEffectsEditor_Vanish`)* |
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* &mdash; see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_KineticPlating`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ShieldPerMiss` | `int` | `SetShieldPerMiss=true` | `ShieldPerMiss` |  |
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* &mdash; see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Vanish`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ReasonNotVisible` | `name` | `SetReasonNotVisible=true` | `ReasonNotVisible` |  |
| `VanishRevealAdditiveAnimName` | `name` | `SetVanishRevealAdditiveAnimName=true` | `VanishRevealAdditiveAnimName` |  |
| `VanishRevealAnimName` | `name` | `SetVanishRevealAnimName=true` | `VanishRevealAnimName` |  |
| `VanishSyncAnimName` | `name` | `SetVanishSyncAnimName=true` | `VanishSyncAnimName` |  |
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentStatChange`)* &mdash; see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_BlastPadding`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExplosiveDamageReduction` | `float` | `SetExplosiveDamageReduction=true` | `ExplosiveDamageReduction` |  |
| `ArmorMitigationAmount` | `int` | `SetArmorMitigationAmount=true` | `ArmorMitigationAmount` | *(shared &mdash; from `X2AbilityEffectsEditor_BonusArmor`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_KillUnit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ParthenogenicPoison`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ParthenogenicPoisonType` | `name` | `SetParthenogenicPoisonType=true` | `ParthenogenicPoisonType` |  |
| `ParthenogenicPoisonCocoonSpawnedName` | `name` | `SetParthenogenicPoisonCocoonSpawnedName=true` | `ParthenogenicPoisonCocoonSpawnedName` |  |
| `AltUnitToSpawnName` | `name` | `SetAltUnitToSpawnName=true` | `AltUnitToSpawnName` |  |
| `UnitToSpawnName` | `name` | `SetUnitToSpawnName=true` | `UnitToSpawnName` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `ClearTileBlockedByTargetUnitFlag` | `bool` | `SetClearTileBlockedByTargetUnitFlag=true` | `bClearTileBlockedByTargetUnitFlag` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyTargetAppearance` | `bool` | `SetCopyTargetAppearance=true` | `bCopyTargetAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopySourceAppearance` | `bool` | `SetCopySourceAppearance=true` | `bCopySourceAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `KnockbackAffectsSpawnLocation` | `bool` | `SetKnockbackAffectsSpawnLocation=true` | `bKnockbackAffectsSpawnLocation` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `AddToSourceGroup` | `bool` | `SetAddToSourceGroup=true` | `bAddToSourceGroup` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedFromUnit` | `bool` | `SetCopyReanimatedFromUnit=true` | `bCopyReanimatedFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedStatsFromUnit` | `bool` | `SetCopyReanimatedStatsFromUnit=true` | `bCopyReanimatedStatsFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `SetProcessedScamperAs` | `bool` | `SetSetProcessedScamperAs=true` | `bSetProcessedScamperAs` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PersistentStatChange`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CHLForceReapplyOnRefresh` | `bool` | `SetCHLForceReapplyOnRefresh=true` | `bForceReapplyOnRefresh` |  |
| `StatChange` | `array<StatChangeEdit>` | `StatChangeMode` | `m_aStatChanges` | see [`StatChangeEdit`](#nested-structs) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PersistentStatChangeRestoreDefault`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StatTypesToRestore` | `array<ECharStatType>` | `StatTypesToRestoreMode` | `StatTypesToRestore` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_SpawnPsiZombie`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AnimationName` | `name` | `SetAnimationName=true` | `AnimationName` |  |
| `AltUnitToSpawnName` | `name` | `SetAltUnitToSpawnName=true` | `AltUnitToSpawnName` |  |
| `StartAnimationMinDelaySec` | `float` | `SetStartAnimationMinDelaySec=true` | `StartAnimationMinDelaySec` |  |
| `StartAnimationMaxDelaySec` | `float` | `SetStartAnimationMaxDelaySec=true` | `StartAnimationMaxDelaySec` |  |
| `UnitToSpawnName` | `name` | `SetUnitToSpawnName=true` | `UnitToSpawnName` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `ClearTileBlockedByTargetUnitFlag` | `bool` | `SetClearTileBlockedByTargetUnitFlag=true` | `bClearTileBlockedByTargetUnitFlag` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyTargetAppearance` | `bool` | `SetCopyTargetAppearance=true` | `bCopyTargetAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopySourceAppearance` | `bool` | `SetCopySourceAppearance=true` | `bCopySourceAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `KnockbackAffectsSpawnLocation` | `bool` | `SetKnockbackAffectsSpawnLocation=true` | `bKnockbackAffectsSpawnLocation` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `AddToSourceGroup` | `bool` | `SetAddToSourceGroup=true` | `bAddToSourceGroup` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedFromUnit` | `bool` | `SetCopyReanimatedFromUnit=true` | `bCopyReanimatedFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedStatsFromUnit` | `bool` | `SetCopyReanimatedStatsFromUnit=true` | `bCopyReanimatedStatsFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `SetProcessedScamperAs` | `bool` | `SetSetProcessedScamperAs=true` | `bSetProcessedScamperAs` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_SpawnShadowbindUnit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ShadowbindUnconciousCheckName` | `name` | `SetShadowbindUnconciousCheckName=true` | `ShadowbindUnconciousCheckName` |  |
| `UnitToSpawnName` | `name` | `SetUnitToSpawnName=true` | `UnitToSpawnName` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `ClearTileBlockedByTargetUnitFlag` | `bool` | `SetClearTileBlockedByTargetUnitFlag=true` | `bClearTileBlockedByTargetUnitFlag` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyTargetAppearance` | `bool` | `SetCopyTargetAppearance=true` | `bCopyTargetAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopySourceAppearance` | `bool` | `SetCopySourceAppearance=true` | `bCopySourceAppearance` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `KnockbackAffectsSpawnLocation` | `bool` | `SetKnockbackAffectsSpawnLocation=true` | `bKnockbackAffectsSpawnLocation` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `AddToSourceGroup` | `bool` | `SetAddToSourceGroup=true` | `bAddToSourceGroup` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedFromUnit` | `bool` | `SetCopyReanimatedFromUnit=true` | `bCopyReanimatedFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `CopyReanimatedStatsFromUnit` | `bool` | `SetCopyReanimatedStatsFromUnit=true` | `bCopyReanimatedStatsFromUnit` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `SetProcessedScamperAs` | `bool` | `SetSetProcessedScamperAs=true` | `bSetProcessedScamperAs` | *(shared &mdash; from `X2AbilityEffectsEditor_SpawnUnit`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ThreatAssessment`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ImmediateActionPoint` | `name` | `SetImmediateActionPoint=true` | `ImmediateActionPoint` |  |
| `AbilityToActivate` | `name` | `SetAbilityToActivate=true` | `AbilityToActivate` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `GrantActionPoint` | `name` | `SetGrantActionPoint=true` | `GrantActionPoint` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `MaxPointsPerTurn` | `int` | `SetMaxPointsPerTurn=true` | `MaxPointsPerTurn` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `DirectAttackOnly` | `bool` | `SetDirectAttackOnly=true` | `bDirectAttackOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `PreEmptiveFire` | `bool` | `SetPreEmptiveFire=true` | `bPreEmptiveFire` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `OnlyDuringEnemyTurn` | `bool` | `SetOnlyDuringEnemyTurn=true` | `bOnlyDuringEnemyTurn` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `UseMultiTargets` | `bool` | `SetUseMultiTargets=true` | `bUseMultiTargets` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `OnlyWhenAttackMisses` | `bool` | `SetOnlyWhenAttackMisses=true` | `bOnlyWhenAttackMisses` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `SelfTargeting` | `bool` | `SetSelfTargeting=true` | `bSelfTargeting` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `ActivationPercentChance` | `int` | `SetActivationPercentChance=true` | `ActivationPercentChance` | *(shared &mdash; from `X2AbilityEffectsEditor_CoveringFire`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_WallBreaking`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `WallBreakingEffectName` | `name` | `SetWallBreakingEffectName=true` | `WallBreakingEffectName` |  |
| `TraversalChanges` | `array<TraversalChange>` | `TraversalChangesMode` | `aTraversalChanges` | *(shared &mdash; from `X2AbilityEffectsEditor_PersistentTraversalChange`)* |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Achilles`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ToHitMin` | `int` | `SetToHitMin=true` | `ToHitMin` |  |
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_AdverseSoldierClasses`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AdverseClasses` | `array<name>` | `AdverseClassesMode` | `AdverseClasses` |  |
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Amplify`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDamageMult` | `float` | `SetBonusDamageMult=true` | `BonusDamageMult` |  |
| `MinBonusDamage` | `int` | `SetMinBonusDamage=true` | `MinBonusDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ApplyBlazingPinionsTargetToWorld`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OverrideParticleSystemFill_Name` | `string` | `SetOverrideParticleSystemFill_Name=true` | `OverrideParticleSystemFill_Name` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ApplyFireToWorld`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `FireChance_Level1` | `float` | `SetFireChance_Level1=true` | `FireChance_Level1` |  |
| `FireChance_Level2` | `float` | `SetFireChance_Level2=true` | `FireChance_Level2` |  |
| `FireChance_Level3` | `float` | `SetFireChance_Level3=true` | `FireChance_Level3` |  |
| `UseFireChanceLevel` | `bool` | `SetUseFireChanceLevel=true` | `bUseFireChanceLevel` |  |
| `DamageFragileOnly` | `bool` | `SetDamageFragileOnly=true` | `bDamageFragileOnly` |  |
| `CheckForLOSFromTargetLocation` | `bool` | `SetCheckForLOSFromTargetLocation=true` | `bCheckForLOSFromTargetLocation` |  |
| `CenterTile` | `bool` | `SetCenterTile=true` | `bCenterTile` | *(shared &mdash; from `X2AbilityEffectsEditor_World`)* |

#### `X2Effect_APRounds`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `Pierce` | `int` | `SetPierce=true` | `Pierce` |  |
| `CritChance` | `int` | `SetCritChance=true` | `CritChance` |  |
| `CritDamage` | `int` | `SetCritDamage=true` | `CritDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Aura`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `EventsToUpdate` | `array<name>` | `EventsToUpdateMode` | `EventsToUpdate` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Bewildered`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `NumHitsForMod` | `int` | `SetNumHitsForMod=true` | `NumHitsForMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_BloodTrail`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDamage` | `int` | `SetBonusDamage=true` | `BonusDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_BonusArmor`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ArmorMitigationAmount` | `int` | `SetArmorMitigationAmount=true` | `ArmorMitigationAmount` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_BonusWeaponDamage`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDmg` | `int` | `SetBonusDmg=true` | `BonusDmg` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ConditionalDamageModifier`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ModifyOutgoingDamage` | `bool` | `SetModifyOutgoingDamage=true` | `bModifyOutgoingDamage` |  |
| `ModifyIncomingDamage` | `bool` | `SetModifyIncomingDamage=true` | `bModifyIncomingDamage` |  |
| `DamageModifier` | `float` | `SetDamageModifier=true` | `DamageModifier` |  |
| `DamageBonus` | `int` | `SetDamageBonus=true` | `DamageBonus` |  |
| `ApplyDamageModConditions` | `array<ConditionEdit>` | &mdash; |  | X2Effect_ConditionalDamageModifier &mdash; see [Conditions](#conditions) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

Not editable via config: `ApplyDamageModConditions` *(array of `X2Condition`)*

#### `X2Effect_CoveringFire`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AbilityToActivate` | `name` | `SetAbilityToActivate=true` | `AbilityToActivate` |  |
| `GrantActionPoint` | `name` | `SetGrantActionPoint=true` | `GrantActionPoint` |  |
| `MaxPointsPerTurn` | `int` | `SetMaxPointsPerTurn=true` | `MaxPointsPerTurn` |  |
| `DirectAttackOnly` | `bool` | `SetDirectAttackOnly=true` | `bDirectAttackOnly` |  |
| `PreEmptiveFire` | `bool` | `SetPreEmptiveFire=true` | `bPreEmptiveFire` |  |
| `OnlyDuringEnemyTurn` | `bool` | `SetOnlyDuringEnemyTurn=true` | `bOnlyDuringEnemyTurn` |  |
| `UseMultiTargets` | `bool` | `SetUseMultiTargets=true` | `bUseMultiTargets` |  |
| `OnlyWhenAttackMisses` | `bool` | `SetOnlyWhenAttackMisses=true` | `bOnlyWhenAttackMisses` |  |
| `SelfTargeting` | `bool` | `SetSelfTargeting=true` | `bSelfTargeting` |  |
| `ActivationPercentChance` | `int` | `SetActivationPercentChance=true` | `ActivationPercentChance` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_DamageImmunity`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ImmuneTypesAreInclusive` | `bool` | `SetImmuneTypesAreInclusive=true` | `ImmueTypesAreInclusive` |  |
| `RemoveAfterAttackCount` | `int` | `SetRemoveAfterAttackCount=true` | `RemoveAfterAttackCount` |  |
| `ImmuneTypes` | `array<name>` | `ImmuneTypesMode` | `ImmuneTypes` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_DelayedAbilityActivation`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TriggerEventName` | `name` | `SetTriggerEventName=true` | `TriggerEventName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_FaceMultiRoundTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TriggerEventName` | `name` | `SetTriggerEventName=true` | `TriggerEventName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_GenerateCover`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CoverType` | `ECoverForceFlag` | `SetCoverType=true` | `CoverType` |  |
| `RemoveWhenMoved` | `bool` | `SetRemoveWhenMoved=true` | `bRemoveWhenMoved` |  |
| `RemoveOnOtherActivation` | `bool` | `SetRemoveOnOtherActivation=true` | `bRemoveOnOtherActivation` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Groundling`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HeightBonus` | `int` | `SetHeightBonus=true` | `HeightBonus` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Guardian`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AllowedAbilities` | `array<name>` | `AllowedAbilitiesMode` | `AllowedAbilities` |  |
| `ProcChance` | `int` | `SetProcChance=true` | `ProcChance` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_HoloTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HitMod` | `int` | `SetHitMod=true` | `HitMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_HolyWarriorDeath`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DelayTimeS` | `float` | `SetDelayTimeS=true` | `DelayTimeS` |  |
| `ExplosiveDamage` | `bool` | `SetExplosiveDamage=true` | `bExplosiveDamage` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `IgnoreBaseDamage` | `bool` | `SetIgnoreBaseDamage=true` | `bIgnoreBaseDamage` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `DamageTag` | `name` | `SetDamageTag=true` | `DamageTag` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `AlwaysKillsCivilians` | `bool` | `SetAlwaysKillsCivilians=true` | `bAlwaysKillsCivilians` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `ApplyWorldEffectsForEachTargetLocation` | `bool` | `SetApplyWorldEffectsForEachTargetLocation=true` | `bApplyWorldEffectsForEachTargetLocation` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `AllowFreeKill` | `bool` | `SetAllowFreeKill=true` | `bAllowFreeKill` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `AllowWeaponUpgrade` | `bool` | `SetAllowWeaponUpgrade=true` | `bAllowWeaponUpgrade` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `BypassShields` | `bool` | `SetBypassShields=true` | `bBypassShields` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `IgnoreArmor` | `bool` | `SetIgnoreArmor=true` | `bIgnoreArmor` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `BypassSustainEffects` | `bool` | `SetBypassSustainEffects=true` | `bBypassSustainEffects` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `EnvironmentalDamageAmount` | `int` | `SetEnvironmentalDamageAmount=true` | `EnvironmentalDamageAmount` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* |
| `WeaponDamageValue` | `WeaponDamageValueEdit` | &mdash; | `EffectDamageValue` | *(shared &mdash; from `X2AbilityEffectsEditor_ApplyWeaponDamage`)* &mdash; see [`WeaponDamageValueEdit`](#nested-structs) |

#### `X2Effect_HomingMine`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AbilityToTrigger` | `name` | `SetAbilityToTrigger=true` | `AbilityToTrigger` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_HuntersInstinctDamage`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDamage` | `int` | `SetBonusDamage=true` | `BonusDamage` |  |
| `BonusCritChance` | `int` | `SetBonusCritChance=true` | `BonusCritChance` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ImmediateAbilityActivation`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AbilityName` | `name` | `SetAbilityName=true` | `AbilityName` |  |
| `ActivateAbilityOnTarget` | `bool` | `SetActivateAbilityOnTarget=true` | `ActivateAbilityOnTarget` |  |
| `EffectTargetOnly` | `bool` | `SetEffectTargetOnly=true` | `EffectTargetOnly` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Impatient`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Implacable`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ImplacableThisTurnValue` | `name` | `SetImplacableThisTurnValue=true` | `ImplacableThisTurnValue` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_LaserSight`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BenefitFromEmpoweredUpgrades` | `bool` | `SetBenefitFromEmpoweredUpgrades=true` | `bBenefitFromEmpoweredUpgrades` |  |
| `CritBonus` | `int` | `SetCritBonus=true` | `CritBonus` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_MeleeDamageAdjust`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DamageMod` | `int` | `SetDamageMod=true` | `DamageMod` |  |
| `MeleeDamageTypeName` | `name` | `SetMeleeDamageTypeName=true` | `MeleeDamageTypeName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_MindControl`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumTurnsForAI` | `int` | `SetNumTurnsForAI=true` | `iNumTurnsForAI` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ModifyReactionFire`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AllowCrit` | `bool` | `SetAllowCrit=true` | `bAllowCrit` |  |
| `ReactionModifier` | `int` | `SetReactionModifier=true` | `ReactionModifier` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ModifyStats`

*Abstract class &mdash; existing instances (of its subclasses) can be edited in place, but it cannot be added as a new instance from config.*

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Nearsighted`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Needle`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ArmorPierce` | `int` | `SetArmorPierce=true` | `ArmorPierce` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Oblivious`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DmgMod` | `float` | `SetDmgMod=true` | `DmgMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_OverrideDeathAnimOnLoad`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OverrideAnimNameOnLoad` | `name` | `SetOverrideAnimNameOnLoad=true` | `OverrideAnimNameOnLoad` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PaleHorse`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CritBoostPerKill` | `int` | `SetCritBoostPerKill=true` | `CritBoostPerKill` |  |
| `MaxCritBoost` | `int` | `SetMaxCritBoost=true` | `MaxCritBoost` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PersistentSquadViewer`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` |  |
| `ViewRadius` | `float` | `SetViewRadius=true` | `ViewRadius` |  |
| `UseSourceLocation` | `bool` | `SetUseSourceLocation=true` | `bUseSourceLocation` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PersistentTraversalChange`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TraversalChanges` | `array<TraversalChange>` | `TraversalChangesMode` | `aTraversalChanges` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_PersistentVoidConduit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InitialDamage` | `int` | `SetInitialDamage=true` | `InitialDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Possessed`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `WeaponTemplateName` | `name` | `SetWeaponTemplateName=true` | `WeaponTemplateName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Reaper`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ReaperActivatedName` | `name` | `SetReaperActivatedName=true` | `ReaperActivatedName` |  |
| `ReaperKillName` | `name` | `SetReaperKillName=true` | `ReaperKillName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Regeneration`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HealAmount` | `int` | `SetHealAmount=true` | `HealAmount` |  |
| `MaxHealAmount` | `int` | `SetMaxHealAmount=true` | `MaxHealAmount` |  |
| `HealthRegeneratedName` | `name` | `SetHealthRegeneratedName=true` | `HealthRegeneratedName` |  |
| `EventToTriggerOnHeal` | `name` | `SetEventToTriggerOnHeal=true` | `EventToTriggerOnHeal` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_RemoveEffectsByDamageType`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DamageTypesToRemove` | `array<name>` | `DamageTypesToRemoveMode` | `DamageTypesToRemove` |  |
| `Cleanse` | `bool` | `SetCleanse=true` | `bCleanse` | *(shared &mdash; from `X2AbilityEffectsEditor_RemoveEffects`)* |
| `CheckSource` | `bool` | `SetCheckSource=true` | `bCheckSource` | *(shared &mdash; from `X2AbilityEffectsEditor_RemoveEffects`)* |
| `DoNotVisualize` | `bool` | `SetDoNotVisualize=true` | `bDoNotVisualize` | *(shared &mdash; from `X2AbilityEffectsEditor_RemoveEffects`)* |
| `EffectNamesToRemove` | `array<name>` | `EffectNamesToRemoveMode` | `EffectNamesToRemove` | *(shared &mdash; from `X2AbilityEffectsEditor_RemoveEffects`)* |

#### `X2Effect_ReserveOverwatchPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UseAllPointsWithAbilities` | `array<name>` | `UseAllPointsWithAbilitiesMode` | `UseAllPointsWithAbilities` |  |
| `ReserveType` | `name` | `SetReserveType=true` | `ReserveType` | *(shared &mdash; from `X2AbilityEffectsEditor_ReserveActionPoints`)* |
| `NumPoints` | `int` | `SetNumPoints=true` | `NumPoints` | *(shared &mdash; from `X2AbilityEffectsEditor_ReserveActionPoints`)* |

#### `X2Effect_RunBehaviorTree`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumActions` | `int` | `SetNumActions=true` | `NumActions` |  |
| `BehaviorTreeName` | `name` | `SetBehaviorTreeName=true` | `BehaviorTreeName` |  |
| `InitFromPlayer` | `bool` | `SetInitFromPlayer=true` | `bInitFromPlayer` |  |
| `SetActionPointCount` | `int` | `SetSetActionPointCount=true` | `SetActionPointCount` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ScanningProtocol`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `LookAtDuration` | `float` | `SetLookAtDuration=true` | `LookAtDuration` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_SmokeGrenade`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HitMod` | `int` | `SetHitMod=true` | `HitMod` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_SpawnDestructible`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DestructibleArchetype` | `string` | `SetDestructibleArchetype=true` | `DestructibleArchetype` |  |
| `DestroyOnRemoval` | `bool` | `SetDestroyOnRemoval=true` | `bDestroyOnRemoval` |  |
| `TargetableBySpawnedTeamOnly` | `bool` | `SetTargetableBySpawnedTeamOnly=true` | `bTargetableBySpawnedTeamOnly` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

Not editable via config: `TargetingIcon` *(type `Texture2D`)*

#### `X2Effect_SpawnUnit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UnitToSpawnName` | `name` | `SetUnitToSpawnName=true` | `UnitToSpawnName` |  |
| `ClearTileBlockedByTargetUnitFlag` | `bool` | `SetClearTileBlockedByTargetUnitFlag=true` | `bClearTileBlockedByTargetUnitFlag` |  |
| `CopyTargetAppearance` | `bool` | `SetCopyTargetAppearance=true` | `bCopyTargetAppearance` |  |
| `CopySourceAppearance` | `bool` | `SetCopySourceAppearance=true` | `bCopySourceAppearance` |  |
| `KnockbackAffectsSpawnLocation` | `bool` | `SetKnockbackAffectsSpawnLocation=true` | `bKnockbackAffectsSpawnLocation` |  |
| `AddToSourceGroup` | `bool` | `SetAddToSourceGroup=true` | `bAddToSourceGroup` |  |
| `CopyReanimatedFromUnit` | `bool` | `SetCopyReanimatedFromUnit=true` | `bCopyReanimatedFromUnit` |  |
| `CopyReanimatedStatsFromUnit` | `bool` | `SetCopyReanimatedStatsFromUnit=true` | `bCopyReanimatedStatsFromUnit` |  |
| `SetProcessedScamperAs` | `bool` | `SetSetProcessedScamperAs=true` | `bSetProcessedScamperAs` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Stasis`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StunStartAnim` | `name` | `SetStunStartAnim=true` | `StunStartAnim` |  |
| `StunStopAnim` | `name` | `SetStunStopAnim=true` | `StunStopAnim` |  |
| `SkipFlyover` | `bool` | `SetSkipFlyover=true` | `bSkipFlyover` |  |
| `StartAnimBlendTime` | `float` | `SetStartAnimBlendTime=true` | `StartAnimBlendTime` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Stunned`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StunLevel` | `int` | `SetStunLevel=true` | `StunLevel` |  |
| `SkipAnimation` | `bool` | `SetSkipAnimation=true` | `bSkipAnimation` |  |
| `StunStartAnimName` | `name` | `SetStunStartAnimName=true` | `StunStartAnimName` |  |
| `StunStopAnimName` | `name` | `SetStunStopAnimName=true` | `StunStopAnimName` |  |
| `StunnedTriggerName` | `name` | `SetStunnedTriggerName=true` | `StunnedTriggerName` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_SuperConcealModifier`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ConcealAmountScalar` | `float` | `SetConcealAmountScalar=true` | `ConcealAmountScalar` |  |
| `AbilitiesAffectedFilter` | `array<name>` | `AbilitiesAffectedFilterMode` | `AbilitiesAffectedFilter` |  |
| `RemoveOnAbilityActivation` | `array<name>` | `RemoveOnAbilityActivationMode` | `RemoveOnAbilityActivation` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Sustain`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_Sustained`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `SustainedAbilityName` | `name` | `SetSustainedAbilityName=true` | `SustainedAbilityName` |  |
| `FragileAmount` | `int` | `SetFragileAmount=true` | `FragileAmount` |  |
| `EffectsToRemoveFromSource` | `array<name>` | `EffectsToRemoveFromSourceMode` | `EffectsToRemoveFromSource` |  |
| `EffectsToRemoveFromTarget` | `array<name>` | `EffectsToRemoveFromTargetMode` | `EffectsToRemoveFromTarget` |  |
| `RegisterAdditionalEventsLikeImpair` | `array<name>` | `RegisterAdditionalEventsLikeImpairMode` | `RegisterAdditionalEventsLikeImpair` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_TalonRounds`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AimMod` | `int` | `SetAimMod=true` | `AimMod` |  |
| `CritChance` | `int` | `SetCritChance=true` | `CritChance` |  |
| `CritDamage` | `int` | `SetCritDamage=true` | `CritDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_TargetDamageDistanceBonus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDmgFloat` | `float` | `SetBonusDmgFloat=true` | `BonusDmg` |  |
| `BonusModType` | `EStatModOp` | `SetBonusModType=true` | `BonusModType` |  |
| `WithinTileDistance` | `int` | `SetWithinTileDistance=true` | `WithinTileDistance` |  |
| `PrimaryTargetOnly` | `bool` | `SetPrimaryTargetOnly=true` | `bPrimaryTargetOnly` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_TargetDamageTypeBonus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDmgFloat` | `float` | `SetBonusDmgFloat=true` | `BonusDmg` |  |
| `BonusModType` | `EStatModOp` | `SetBonusModType=true` | `BonusModType` |  |
| `BonusDamageTypes` | `array<name>` | `BonusDamageTypesMode` | `BonusDamageTypes` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ToHitModifier`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ApplyAsTarget` | `bool` | `SetApplyAsTarget=true` | `bApplyAsTarget` |  |
| `EffectHitModifiers` | `array<EffectHitModifier>` | non-empty *(replace-only)* | `Modifiers` | X2Effect_ToHitModifier: replace-only — when non-empty, replaces Modifiers entirely |
| `ToHitConditions` | `array<ConditionEdit>` | &mdash; |  | X2Effect_ToHitModifier &mdash; see [Conditions](#conditions) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

Not editable via config: `ToHitConditions` *(array of `X2Condition`)*

#### `X2Effect_TrackingShotMarkTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ConeLength` | `float` | `SetConeLength=true` | `ConeLength` |  |
| `ConeEndDiameter` | `float` | `SetConeEndDiameter=true` | `ConeEndDiameter` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_TurnStartActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ActionPointType` | `name` | `SetActionPointType=true` | `ActionPointType` |  |
| `NumActionPoints` | `int` | `SetNumActionPoints=true` | `NumActionPoints` |  |
| `ActionPointsRemoved` | `bool` | `SetActionPointsRemoved=true` | `bActionPointsRemoved` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_VolatileMix`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BonusDamage` | `int` | `SetBonusDamage=true` | `BonusDamage` |  |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

#### `X2Effect_ApplyDirectionalWorldDamage`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `EnvironmentalDamageAmount` | `int` | `SetEnvironmentalDamageAmount=true` | `EnvironmentalDamageAmount` |  |
| `DamageTypeTemplateName` | `name` | `SetDamageTypeTemplateName=true` | `DamageTypeTemplateName` |  |
| `PlusNumZTiles` | `int` | `SetPlusNumZTiles=true` | `PlusNumZTiles` |  |
| `UseWeaponEnvironmentalDamage` | `bool` | `SetUseWeaponEnvironmentalDamage=true` | `bUseWeaponEnvironmentalDamage` |  |
| `UseWeaponDamageType` | `bool` | `SetUseWeaponDamageType=true` | `bUseWeaponDamageType` |  |
| `HitSourceTile` | `bool` | `SetHitSourceTile=true` | `bHitSourceTile` |  |
| `HitTargetTile` | `bool` | `SetHitTargetTile=true` | `bHitTargetTile` |  |
| `HitAdjacentDestructibles` | `bool` | `SetHitAdjacentDestructibles=true` | `bHitAdjacentDestructibles` |  |
| `AllowDestructionOfDamageCauseCover` | `bool` | `SetAllowDestructionOfDamageCauseCover=true` | `bAllowDestructionOfDamageCauseCover` |  |

#### `X2Effect_ApplyMedikitHeal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `PerUseHP` | `int` | `SetPerUseHP=true` | `PerUseHP` |  |
| `IncreasedHealProject` | `name` | `SetIncreasedHealProject=true` | `IncreasedHealProject` |  |
| `IncreasedPerUseHP` | `int` | `SetIncreasedPerUseHP=true` | `IncreasedPerUseHP` |  |

#### `X2Effect_ApplyWeaponDamage`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExplosiveDamage` | `bool` | `SetExplosiveDamage=true` | `bExplosiveDamage` |  |
| `IgnoreBaseDamage` | `bool` | `SetIgnoreBaseDamage=true` | `bIgnoreBaseDamage` |  |
| `DamageTag` | `name` | `SetDamageTag=true` | `DamageTag` |  |
| `AlwaysKillsCivilians` | `bool` | `SetAlwaysKillsCivilians=true` | `bAlwaysKillsCivilians` |  |
| `ApplyWorldEffectsForEachTargetLocation` | `bool` | `SetApplyWorldEffectsForEachTargetLocation=true` | `bApplyWorldEffectsForEachTargetLocation` |  |
| `AllowFreeKill` | `bool` | `SetAllowFreeKill=true` | `bAllowFreeKill` |  |
| `AllowWeaponUpgrade` | `bool` | `SetAllowWeaponUpgrade=true` | `bAllowWeaponUpgrade` |  |
| `BypassShields` | `bool` | `SetBypassShields=true` | `bBypassShields` |  |
| `IgnoreArmor` | `bool` | `SetIgnoreArmor=true` | `bIgnoreArmor` |  |
| `BypassSustainEffects` | `bool` | `SetBypassSustainEffects=true` | `bBypassSustainEffects` |  |
| `EnvironmentalDamageAmount` | `int` | `SetEnvironmentalDamageAmount=true` | `EnvironmentalDamageAmount` |  |
| `WeaponDamageValue` | `WeaponDamageValueEdit` | &mdash; | `EffectDamageValue` | see [`WeaponDamageValueEdit`](#nested-structs) |

Not editable via config: `HideVisualizationOfResultsAdditional` *(not yet supported)*

#### `X2Effect_Brutal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `WillMod` | `int` | `SetWillMod=true` | `WillMod` |  |

#### `X2Effect_EnableGlobalAbility`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `GlobalAbility` | `name` | `SetGlobalAbility=true` | `GlobalAbility` |  |

#### `X2Effect_GetOverHere`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OverrideStartAnimName` | `Name` | `SetOverrideStartAnimName=true` | `OverrideStartAnimName` |  |
| `OverrideStopAnimName` | `Name` | `SetOverrideStopAnimName=true` | `OverrideStopAnimName` |  |
| `RequireVisibleTile` | `bool` | `SetRequireVisibleTile=true` | `RequireVisibleTile` |  |

#### `X2Effect_GrantActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumActionPoints` | `int` | `SetNumActionPoints=true` | `NumActionPoints` |  |
| `PointType` | `name` | `SetPointType=true` | `PointType` |  |
| `ApplyOnlyWhenOut` | `bool` | `SetApplyOnlyWhenOut=true` | `bApplyOnlyWhenOut` |  |
| `SelectUnit` | `bool` | `SetSelectUnit=true` | `bSelectUnit` |  |
| `SkipWithEffect` | `array<name>` | `SkipWithEffectMode` | `SkipWithEffect` |  |

#### `X2Effect_IncreaseBondmateCohesion`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CohesionAmount` | `int` | `SetCohesionAmount=true` | `CohesionAmount` |  |

#### `X2Effect_Knockback`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `KnockbackDistance` | `int` | `SetKnockbackDistance=true` | `KnockbackDistance` |  |
| `KnockbackDestroysNonFragile` | `bool` | `SetKnockbackDestroysNonFragile=true` | `bKnockbackDestroysNonFragile` |  |
| `OverrideRagdollFinishTimerSec` | `float` | `SetOverrideRagdollFinishTimerSec=true` | `OverrideRagdollFinishTimerSec` |  |
| `OnlyOnDeath` | `bool` | `SetOnlyOnDeath=true` | `OnlyOnDeath` |  |

#### `X2Effect_LifeSteal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `LifeAmountMultiplier` | `float` | `SetLifeAmountMultiplier=true` | `LifeAmountMultiplier` |  |

#### `X2Effect_MarkValidActivationTiles`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AbilityToMark` | `name` | `SetAbilityToMark=true` | `AbilityToMark` |  |
| `OnlyUseTargetLocation` | `bool` | `SetOnlyUseTargetLocation=true` | `OnlyUseTargetLocation` |  |
| `VisualizeFlagsOnCursor` | `bool` | `SetVisualizeFlagsOnCursor=true` | `bVisualizeFlagsOnCursor` |  |

#### `X2Effect_ModifyInitiativeOrder`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RemoveGroupFromInitiativeOrder` | `bool` | `SetRemoveGroupFromInitiativeOrder=true` | `bRemoveGroupFromInitiativeOrder` |  |
| `AddGroupToInitiativeOrder` | `bool` | `SetAddGroupToInitiativeOrder=true` | `bAddGroupToInitiativeOrder` |  |

#### `X2Effect_ModifyTemplarFocus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ModifyFocus` | `int` | `SetModifyFocus=true` | `ModifyFocus` |  |

#### `X2Effect_LethalWeaponDamage`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `LethalDamageConditions` | `array<ConditionEdit>` | &mdash; |  | X2Effect_LethalWeaponDamage &mdash; see [Conditions](#conditions) |
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` | *(shared &mdash; from `X2AbilityEffectsEditor_Persistent`)* |

Not editable via config: `LethalDamageConditions` *(array of `X2Condition`)*

#### `X2Effect_Persistent`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InfiniteDuration` | `bool` | `SetInfiniteDuration=true` | `bInfiniteDuration` |  |
| `TickWhenApplied` | `bool` | `SetTickWhenApplied=true` | `bTickWhenApplied` |  |
| `CanTickEveryAction` | `bool` | `SetCanTickEveryAction=true` | `bCanTickEveryAction` |  |
| `ConvertTurnsToActions` | `bool` | `SetConvertTurnsToActions=true` | `bConvertTurnsToActions` |  |
| `RemoveWhenSourceDies` | `bool` | `SetRemoveWhenSourceDies=true` | `bRemoveWhenSourceDies` |  |
| `RemoveWhenTargetDies` | `bool` | `SetRemoveWhenTargetDies=true` | `bRemoveWhenTargetDies` |  |
| `RemoveWhenSourceDamaged` | `bool` | `SetRemoveWhenSourceDamaged=true` | `bRemoveWhenSourceDamaged` |  |
| `RemoveWhenTargetConcealmentBroken` | `bool` | `SetRemoveWhenTargetConcealmentBroken=true` | `bRemoveWhenTargetConcealmentBroken` |  |
| `PersistThroughTacticalGameEnd` | `bool` | `SetPersistThroughTacticalGameEnd=true` | `bPersistThroughTacticalGameEnd` |  |
| `IgnorePlayerCheckOnTick` | `bool` | `SetIgnorePlayerCheckOnTick=true` | `bIgnorePlayerCheckOnTick` |  |
| `UniqueTarget` | `bool` | `SetUniqueTarget=true` | `bUniqueTarget` |  |
| `StackOnRefresh` | `bool` | `SetStackOnRefresh=true` | `bStackOnRefresh` |  |
| `DupeForSameSourceOnly` | `bool` | `SetDupeForSameSourceOnly=true` | `bDupeForSameSourceOnly` |  |
| `EffectForcesBleedout` | `bool` | `SetEffectForcesBleedout=true` | `bEffectForcesBleedout` |  |
| `DisplayInUI` | `bool` | `SetDisplayInUI=true` | `bDisplayInUI` |  |
| `DisplayInSpecialDamageMessageUI` | `bool` | `SetDisplayInSpecialDamageMessageUI=true` | `bDisplayInSpecialDamageMessageUI` |  |
| `SourceDisplayInUI` | `bool` | `SetSourceDisplayInUI=true` | `bSourceDisplayInUI` |  |
| `NumTurns` | `int` | `SetNumTurns=true` | `iNumTurns` |  |
| `InitialShedChance` | `int` | `SetInitialShedChance=true` | `iInitialShedChance` |  |
| `PerTurnShedChance` | `int` | `SetPerTurnShedChance=true` | `iPerTurnShedChance` |  |
| `EffectRank` | `int` | `SetEffectRank=true` | `EffectRank` |  |
| `EffectHierarchyValue` | `int` | `SetEffectHierarchyValue=true` | `EffectHierarchyValue` |  |
| `VisionArcDegreesOverride` | `float` | `SetVisionArcDegreesOverride=true` | `VisionArcDegreesOverride` |  |
| `CustomIdleOverrideAnim` | `name` | `SetCustomIdleOverrideAnim=true` | `CustomIdleOverrideAnim` |  |
| `EffectName` | `name` | `SetEffectName=true` | `EffectName` |  |
| `AbilitySourceName` | `name` | `SetAbilitySourceName=true` | `AbilitySourceName` |  |
| `EffectAppliedEventName` | `name` | `SetEffectAppliedEventName=true` | `EffectAppliedEventName` |  |
| `ChanceEventTriggerName` | `name` | `SetChanceEventTriggerName=true` | `ChanceEventTriggerName` |  |
| `VFXSocket` | `name` | `SetVFXSocket=true` | `VFXSocket` |  |
| `VFXSocketsArrayName` | `name` | `SetVFXSocketsArrayName=true` | `VFXSocketsArrayName` |  |
| `FriendlyName` | `string` | `SetFriendlyName=true` | `FriendlyName` |  |
| `FriendlyDescription` | `string` | `SetFriendlyDescription=true` | `FriendlyDescription` |  |
| `IconImage` | `string` | `SetIconImage=true` | `IconImage` |  |
| `SourceFriendlyName` | `string` | `SetSourceFriendlyName=true` | `SourceFriendlyName` |  |
| `SourceFriendlyDescription` | `string` | `SetSourceFriendlyDescription=true` | `SourceFriendlyDescription` |  |
| `SourceIconLabel` | `string` | `SetSourceIconLabel=true` | `SourceIconLabel` |  |
| `StatusIcon` | `string` | `SetStatusIcon=true` | `StatusIcon` |  |
| `VFXTemplateName` | `string` | `SetVFXTemplateName=true` | `VFXTemplateName` |  |
| `PersistentPerkName` | `string` | `SetPersistentPerkName=true` | `PersistentPerkName` |  |

Not editable via config: `TickTriggers` *(array of `X2EffectTrigger`)*, `DuplicateResponse` *(not yet supported)*, `ApplyOnTick` *(array of `X2Effect`)*, `WatchRule` *(type `GameRuleStateChange`)*, `BuffCategory` *(not yet supported)*, `SourceBuffCategory` *(not yet supported)*, `GameStateEffectClass` *(class reference)*, `VisualizationFn` *(delegate &mdash; code-only)*, `CleansedVisualizationFn` *(delegate &mdash; code-only)*, `EffectTickedVisualizationFn` *(delegate &mdash; code-only)*, `EffectSyncVisualizationFn` *(delegate &mdash; code-only)*, `EffectRemovedVisualizationFn` *(delegate &mdash; code-only)*, `EffectRemovedSourceVisualizationFn` *(delegate &mdash; code-only)*, `DeathVisualizationFn` *(delegate &mdash; code-only)*, `ModifyTracksFn` *(delegate &mdash; code-only)*, `EffectRemovedFn` *(delegate &mdash; code-only)*, `EffectAddedFn` *(delegate &mdash; code-only)*, `EffectTickedFn` *(delegate &mdash; code-only)*, `GetModifyChosenActivationIncreasePerUseFn` *(delegate &mdash; code-only)*, `UnitBreaksConcealmentIgnoringDistanceFn` *(delegate &mdash; code-only)*

#### `X2Effect_ReduceCooldowns`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `Amount` | `int` | `SetAmount=true` | `Amount` |  |
| `ReduceAll` | `bool` | `SetReduceAll=true` | `ReduceAll` |  |
| `AbilitiesToTick` | `array<name>` | `AbilitiesToTickMode` | `AbilitiesToTick` |  |

#### `X2Effect_RemoteStart`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UnitDamageMultiplier` | `float` | `SetUnitDamageMultiplier=true` | `UnitDamageMultiplier` |  |
| `DamageRadiusMultiplier` | `float` | `SetDamageRadiusMultiplier=true` | `DamageRadiusMultiplier` |  |

#### `X2Effect_RemoveEffects`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `Cleanse` | `bool` | `SetCleanse=true` | `bCleanse` |  |
| `CheckSource` | `bool` | `SetCheckSource=true` | `bCheckSource` |  |
| `DoNotVisualize` | `bool` | `SetDoNotVisualize=true` | `bDoNotVisualize` |  |
| `EffectNamesToRemove` | `array<name>` | `EffectNamesToRemoveMode` | `EffectNamesToRemove` |  |

#### `X2Effect_ReserveActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ReserveType` | `name` | `SetReserveType=true` | `ReserveType` |  |
| `NumPoints` | `int` | `SetNumPoints=true` | `NumPoints` |  |

#### `X2Effect_SetUnitValue`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UnitName` | `name` | `SetUnitName=true` | `UnitName` |  |
| `NewValueToSet` | `float` | `SetNewValueToSet=true` | `NewValueToSet` |  |
| `CleanupType` | `EUnitValueCleanup` | `SetCleanupType=true` | `CleanupType` |  |

#### `X2Effect_SoulSteal`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UnitValueToRead` | `name` | `SetUnitValueToRead=true` | `UnitValueToRead` |  |

#### `X2Effect_Spotted`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BecomeUnspotted` | `bool` | `SetBecomeUnspotted=true` | `m_bBecomeUnspotted` |  |

#### `X2Effect_SuspendMissionTimer`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ResumeMissionTimer` | `bool` | `SetResumeMissionTimer=true` | `bResumeMissionTimer` |  |

#### `X2Effect_TriggerEvent`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TriggerEventName` | `name` | `SetTriggerEventName=true` | `TriggerEventName` |  |
| `PassTargetAsSource` | `bool` | `SetPassTargetAsSource=true` | `PassTargetAsSource` |  |

#### `X2Effect_VoidConduit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `DamagePerAction` | `int` | `SetDamagePerAction=true` | `DamagePerAction` |  |
| `HealthReturnMod` | `float` | `SetHealthReturnMod=true` | `HealthReturnMod` |  |

#### `X2Effect_World`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CenterTile` | `bool` | `SetCenterTile=true` | `bCenterTile` |  |

#### Any other class

Handled by `X2AbilityEffectsEditor_Base`: only the shared fields above apply.

### Conditions

Conditions can be edited in seven places: the template-level arrays (`ShooterConditions`, `TargetConditions`, `MultiTargetConditions` directly inside an `AbilityEdit`) and, inside an `Effects` entry, the effect's own `TargetConditions` plus the class-specific `ApplyDamageModConditions`, `LethalDamageConditions` and `ToHitConditions`. All take an array of `ConditionEdit` entries. Within the targeted array, the condition of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Condition class to target/instantiate, e.g. `X2Condition_UnitProperty`. Bare names are auto-prefixed with `XComGame.`. |
| `Mode` | `EArrayEditMode` | Per-entry edit mode (`EArrayEditMode`), see [Edit modes](#edit-modes). |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2Condition_UnitEffectsApplying` &rarr; `X2Condition_UnitEffectsOnSource` &rarr; `X2Condition_UnitEffectsWithAbilitySource` &rarr; `X2Condition_UnitEffectsWithAbilityTarget` &rarr; `X2Condition_AbilityProperty` &rarr; `X2Condition_AbilitySourceWeapon` &rarr; `X2Condition_BattleState` &rarr; `X2Condition_BerserkerDevastatingPunch` &rarr; `X2Condition_Bondmate` &rarr; `X2Condition_DarkEvent` &rarr; `X2Condition_EverVigilant` &rarr; `X2Condition_FuseTarget` &rarr; `X2Condition_GameplayTag` &rarr; `X2Condition_HackingTarget` &rarr; `X2Condition_Interactive` &rarr; `X2Condition_Lootable` &rarr; `X2Condition_MapProperty` &rarr; `X2Condition_OnGroundTile` &rarr; `X2Condition_PanicOnPod` &rarr; `X2Condition_PlayerTurns` &rarr; `X2Condition_StasisLanceTarget` &rarr; `X2Condition_StasisTarget` &rarr; `X2Condition_Stealth` &rarr; `X2Condition_UnblockedNeighborTile` &rarr; `X2Condition_UnitActionPoints` &rarr; `X2Condition_UnitAlertStatus` &rarr; `X2Condition_UnitEffects` &rarr; `X2Condition_UnitImmunities` &rarr; `X2Condition_UnitInEvacZone` &rarr; `X2Condition_UnitInteractions` &rarr; `X2Condition_UnitInventory` &rarr; `X2Condition_UnitProperty` &rarr; `X2Condition_UnitStatCheck` &rarr; `X2Condition_UnitType` &rarr; `X2Condition_UnitValue` &rarr; `X2Condition_Visibility` &rarr; any other class

#### `X2Condition_UnitEffectsApplying`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeEffects` | `array<EffectReason>` | `ExcludeEffectsMode` | `ExcludeEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |
| `RequireEffects` | `array<EffectReason>` | `RequireEffectsMode` | `RequireEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |

#### `X2Condition_UnitEffectsOnSource`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeEffects` | `array<EffectReason>` | `ExcludeEffectsMode` | `ExcludeEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |
| `RequireEffects` | `array<EffectReason>` | `RequireEffectsMode` | `RequireEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |

#### `X2Condition_UnitEffectsWithAbilitySource`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeEffects` | `array<EffectReason>` | `ExcludeEffectsMode` | `ExcludeEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |
| `RequireEffects` | `array<EffectReason>` | `RequireEffectsMode` | `RequireEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |

#### `X2Condition_UnitEffectsWithAbilityTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeEffects` | `array<EffectReason>` | `ExcludeEffectsMode` | `ExcludeEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |
| `RequireEffects` | `array<EffectReason>` | `RequireEffectsMode` | `RequireEffects` | *(shared &mdash; from `X2AbilityConditionEditor_UnitEffects`)* |

#### `X2Condition_AbilityProperty`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TargetMustBeInValidTiles` | `bool` | `SetTargetMustBeInValidTiles=true` | `TargetMustBeInValidTiles` |  |
| `OwnerHasSoldierAbilities` | `array<name>` | `OwnerHasSoldierAbilitiesMode` | `OwnerHasSoldierAbilities` |  |

#### `X2Condition_AbilitySourceWeapon`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `WantsReload` | `bool` | `SetWantsReload=true` | `WantsReload` |  |
| `CheckAmmo` | `bool` | `SetCheckAmmo=true` | `CheckAmmo` |  |
| `CheckAmmoData` | `CheckConfig` | `SetCheckAmmoData=true` | `CheckAmmoData` |  |
| `NotLoadedAmmoInSecondaryWeapon` | `bool` | `SetNotLoadedAmmoInSecondaryWeapon=true` | `NotLoadedAmmoInSecondaryWeapon` |  |
| `MatchGrenadeType` | `name` | `SetMatchGrenadeType=true` | `MatchGrenadeType` |  |
| `CheckGrenadeFriendlyFire` | `bool` | `SetCheckGrenadeFriendlyFire=true` | `CheckGrenadeFriendlyFire` |  |
| `CheckAmmoTechLevel` | `bool` | `SetCheckAmmoTechLevel=true` | `CheckAmmoTechLevel` |  |
| `MatchWeaponTemplate` | `name` | `SetMatchWeaponTemplate=true` | `MatchWeaponTemplate` |  |

#### `X2Condition_BattleState`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MissionAborted` | `bool` | `SetMissionAborted=true` | `bMissionAborted` |  |
| `MissionNotAborted` | `bool` | `SetMissionNotAborted=true` | `bMissionNotAborted` |  |
| `CiviliansTargetedByAliens` | `bool` | `SetCiviliansTargetedByAliens=true` | `bCiviliansTargetedByAliens` |  |
| `CiviliansNotTargetedByAliens` | `bool` | `SetCiviliansNotTargetedByAliens=true` | `bCiviliansNotTargetedByAliens` |  |
| `IncludeTheLostInEngagedCount` | `bool` | `SetIncludeTheLostInEngagedCount=true` | `bIncludeTheLostInEngagedCount` |  |
| `MinEngagedEnemies` | `int` | `SetMinEngagedEnemies=true` | `MinEngagedEnemies` |  |
| `MaxEngagedEnemies` | `int` | `SetMaxEngagedEnemies=true` | `MaxEngagedEnemies` |  |

#### `X2Condition_BerserkerDevastatingPunch`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `FailOnNonUnitTargets` | `bool` | `SetFailOnNonUnitTargets=true` | `bFailOnNonUnitTargets` |  |

#### `X2Condition_Bondmate`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MinBondLevel` | `int` | `SetMinBondLevel=true` | `MinBondLevel` |  |
| `MaxBondLevel` | `int` | `SetMaxBondLevel=true` | `MaxBondLevel` |  |
| `RequiresAdjacency` | `AdjacencyRequirement` | `SetRequiresAdjacency=true` | `RequiresAdjacency` |  |
| `SkipCheckWithSource` | `bool` | `SetSkipCheckWithSource=true` | `bSkipCheckWithSource` |  |

#### `X2Condition_DarkEvent`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StilettoRounds` | `bool` | `SetStilettoRounds=true` | `bStilettoRounds` |  |

#### `X2Condition_EverVigilant`

No class-specific fields; the shared fields above apply.

#### `X2Condition_FuseTarget`

No class-specific fields; the shared fields above apply.

#### `X2Condition_GameplayTag`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RequiredGameplayTag` | `name` | `SetRequiredGameplayTag=true` | `RequiredGameplayTag` |  |
| `DisallowGameplayTag` | `name` | `SetDisallowGameplayTag=true` | `DisallowGameplayTag` |  |

#### `X2Condition_HackingTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `IntrusionProtocol` | `bool` | `SetIntrusionProtocol=true` | `bIntrusionProtocol` |  |
| `HaywireProtocol` | `bool` | `SetHaywireProtocol=true` | `bHaywireProtocol` |  |
| `RequiredAbilityName` | `name` | `SetRequiredAbilityName=true` | `RequiredAbilityName` |  |
| `MustBeDoor` | `bool` | `SetMustBeDoor=true` | `bMustBeDoor` |  |

#### `X2Condition_Interactive`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InteractionType` | `UnitInterationType` | `SetInteractionType=true` | `InteractionType` |  |
| `RequiredAbilityName` | `name` | `SetRequiredAbilityName=true` | `RequiredAbilityName` |  |

#### `X2Condition_Lootable`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RestrictRange` | `bool` | `SetRestrictRange=true` | `bRestrictRange` |  |
| `LootableRange` | `int` | `SetLootableRange=true` | `LootableRange` |  |

#### `X2Condition_MapProperty`

No class-specific fields; the shared fields above apply.

Not editable via config: `AllowedBiomes` *(array of `string`)*

#### `X2Condition_OnGroundTile`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NotAFloorTileTag` | `name` | `SetNotAFloorTileTag=true` | `NotAFloorTileTag` |  |

#### `X2Condition_PanicOnPod`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MaxPanicUnitsPerPod` | `int` | `SetMaxPanicUnitsPerPod=true` | `MaxPanicUnitsPerPod` |  |

#### `X2Condition_PlayerTurns`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumTurnsCheck` | `CheckConfig` | `SetNumTurnsCheck=true` | `NumTurnsCheck` |  |

#### `X2Condition_StasisLanceTarget`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HackAbilityName` | `Name` | `SetHackAbilityName=true` | `HackAbilityName` |  |

#### `X2Condition_StasisTarget`

No class-specific fields; the shared fields above apply.

#### `X2Condition_Stealth`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CheckFlanking` | `bool` | `SetCheckFlanking=true` | `bCheckFlanking` |  |

#### `X2Condition_UnblockedNeighborTile`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RequireVisible` | `bool` | `SetRequireVisible=true` | `RequireVisible` |  |

#### `X2Condition_UnitActionPoints`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ActionPointChecks` | `array<ActionPointCheck>` | `ActionPointChecksMode` | `m_aCheckValues` |  |

#### `X2Condition_UnitAlertStatus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RequiredAlertStatusMaximum` | `int` | `SetRequiredAlertStatusMaximum=true` | `RequiredAlertStatusMaximum` |  |
| `RequiredAlertStatusMinimum` | `int` | `SetRequiredAlertStatusMinimum=true` | `RequiredAlertStatusMinimum` |  |

#### `X2Condition_UnitEffects`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeEffects` | `array<EffectReason>` | `ExcludeEffectsMode` | `ExcludeEffects` |  |
| `RequireEffects` | `array<EffectReason>` | `RequireEffectsMode` | `RequireEffects` |  |

#### `X2Condition_UnitImmunities`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OnlyOnCharacterTemplate` | `bool` | `SetOnlyOnCharacterTemplate=true` | `bOnlyOnCharacterTemplate` |  |
| `ExcludeDamageTypes` | `array<name>` | `ExcludeDamageTypesMode` | `ExcludeDamageTypes` |  |

#### `X2Condition_UnitInEvacZone`

No class-specific fields; the shared fields above apply.

#### `X2Condition_UnitInteractions`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `InteractionType` | `UnitInterationType` | `SetInteractionType=true` | `InteractionType` |  |

#### `X2Condition_UnitInventory`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RelevantSlot` | `EInventorySlot` | `SetRelevantSlot=true` | `RelevantSlot` |  |
| `ExcludeWeaponCategory` | `name` | `SetExcludeWeaponCategory=true` | `ExcludeWeaponCategory` |  |
| `RequireWeaponCategory` | `name` | `SetRequireWeaponCategory=true` | `RequireWeaponCategory` |  |

#### `X2Condition_UnitProperty`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ExcludeAlive` | `bool` | `SetExcludeAlive=true` | `ExcludeAlive` |  |
| `ExcludeDead` | `bool` | `SetExcludeDead=true` | `ExcludeDead` |  |
| `ExcludeRobotic` | `bool` | `SetExcludeRobotic=true` | `ExcludeRobotic` |  |
| `ExcludeOrganic` | `bool` | `SetExcludeOrganic=true` | `ExcludeOrganic` |  |
| `ExcludeCivilian` | `bool` | `SetExcludeCivilian=true` | `ExcludeCivilian` |  |
| `ExcludeNonCivilian` | `bool` | `SetExcludeNonCivilian=true` | `ExcludeNonCivilian` |  |
| `ExcludeCosmetic` | `bool` | `SetExcludeCosmetic=true` | `ExcludeCosmetic` |  |
| `ExcludeImpaired` | `bool` | `SetExcludeImpaired=true` | `ExcludeImpaired` |  |
| `ExcludePanicked` | `bool` | `SetExcludePanicked=true` | `ExcludePanicked` |  |
| `ExcludeInStasis` | `bool` | `SetExcludeInStasis=true` | `ExcludeInStasis` |  |
| `ExcludeTurret` | `bool` | `SetExcludeTurret=true` | `ExcludeTurret` |  |
| `ExcludePsionic` | `bool` | `SetExcludePsionic=true` | `ExcludePsionic` |  |
| `ExcludeNonPsionic` | `bool` | `SetExcludeNonPsionic=true` | `ExcludeNonPsionic` |  |
| `IsAdvent` | `bool` | `SetIsAdvent=true` | `IsAdvent` |  |
| `ExcludeAdvent` | `bool` | `SetExcludeAdvent=true` | `ExcludeAdvent` |  |
| `ExcludeNoCover` | `bool` | `SetExcludeNoCover=true` | `ExcludeNoCover` |  |
| `ExcludeNoCoverToSource` | `bool` | `SetExcludeNoCoverToSource=true` | `ExcludeNoCoverToSource` |  |
| `ExcludeFullHealth` | `bool` | `SetExcludeFullHealth=true` | `ExcludeFullHealth` |  |
| `IsBleedingOut` | `bool` | `SetIsBleedingOut=true` | `IsBleedingOut` |  |
| `IsUnspotted` | `bool` | `SetIsUnspotted=true` | `IsUnspotted` |  |
| `CanBeCarried` | `bool` | `SetCanBeCarried=true` | `CanBeCarried` |  |
| `IsOutdoors` | `bool` | `SetIsOutdoors=true` | `IsOutdoors` |  |
| `IsConcealed` | `bool` | `SetIsConcealed=true` | `IsConcealed` |  |
| `ExcludeConcealed` | `bool` | `SetExcludeConcealed=true` | `ExcludeConcealed` |  |
| `IsSuperConcealed` | `bool` | `SetIsSuperConcealed=true` | `IsSuperConcealed` |  |
| `IsImpaired` | `bool` | `SetIsImpaired=true` | `IsImpaired` |  |
| `HasClearanceToMaxZ` | `bool` | `SetHasClearanceToMaxZ=true` | `HasClearanceToMaxZ` |  |
| `ExcludeAlien` | `bool` | `SetExcludeAlien=true` | `ExcludeAlien` |  |
| `ExcludeNonHumanoidAliens` | `bool` | `SetExcludeNonHumanoidAliens=true` | `ExcludeNonHumanoidAliens` |  |
| `ExcludeStunned` | `bool` | `SetExcludeStunned=true` | `ExcludeStunned` |  |
| `ExcludeDazed` | `bool` | `SetExcludeDazed=true` | `ExcludeDazed` |  |
| `ExcludeUnableToAct` | `bool` | `SetExcludeUnableToAct=true` | `ExcludeUnableToAct` |  |
| `IsPlayerControlled` | `bool` | `SetIsPlayerControlled=true` | `IsPlayerControlled` |  |
| `ExcludeUnrevealedAI` | `bool` | `SetExcludeUnrevealedAI=true` | `ExcludeUnrevealedAI` |  |
| `IncludeWeakAgainstTechLikeRobot` | `bool` | `SetIncludeWeakAgainstTechLikeRobot=true` | `IncludeWeakAgainstTechLikeRobot` |  |
| `ImpairedIgnoresStuns` | `bool` | `SetImpairedIgnoresStuns=true` | `ImpairedIgnoresStuns` |  |
| `IsScampering` | `bool` | `SetIsScampering=true` | `IsScampering` |  |
| `ExcludeDeadFromSpecialDeath` | `bool` | `SetExcludeDeadFromSpecialDeath=true` | `ExcludeDeadFromSpecialDeath` |  |
| `ExcludeLargeUnits` | `bool` | `SetExcludeLargeUnits=true` | `ExcludeLargeUnits` |  |
| `ImpairedIgnoresImpairingMomentarily` | `bool` | `SetImpairedIgnoresImpairingMomentarily=true` | `ImpairedIgnoresImpairingMomentarily` |  |
| `ExcludeHostileToSource` | `bool` | `SetExcludeHostileToSource=true` | `ExcludeHostileToSource` |  |
| `ExcludeFriendlyToSource` | `bool` | `SetExcludeFriendlyToSource=true` | `ExcludeFriendlyToSource` |  |
| `TreatMindControlledSquadmateAsHostile` | `bool` | `SetTreatMindControlledSquadmateAsHostile=true` | `TreatMindControlledSquadmateAsHostile` |  |
| `ExcludeSquadmates` | `bool` | `SetExcludeSquadmates=true` | `ExcludeSquadmates` |  |
| `RequireSquadmates` | `bool` | `SetRequireSquadmates=true` | `RequireSquadmates` |  |
| `RequireWithinRange` | `bool` | `SetRequireWithinRange=true` | `RequireWithinRange` |  |
| `RequireWithinMinRange` | `bool` | `SetRequireWithinMinRange=true` | `RequireWithinMinRange` |  |
| `BeingCarriedBySource` | `bool` | `SetBeingCarriedBySource=true` | `BeingCarriedBySource` |  |
| `RequireUnitSelectedFromHQ` | `bool` | `SetRequireUnitSelectedFromHQ=true` | `RequireUnitSelectedFromHQ` |  |
| `FailOnNonUnits` | `bool` | `SetFailOnNonUnits=true` | `FailOnNonUnits` |  |
| `MinRank` | `int` | `SetMinRank=true` | `MinRank` |  |
| `MaxRank` | `int` | `SetMaxRank=true` | `MaxRank` |  |
| `WithinRange` | `float` | `SetWithinRange=true` | `WithinRange` |  |
| `WithinMinRange` | `float` | `SetWithinMinRange=true` | `WithinMinRange` |  |
| `ExcludeSoldierClasses` | `array<name>` | `ExcludeSoldierClassesMode` | `ExcludeSoldierClasses` |  |
| `RequireSoldierClasses` | `array<name>` | `RequireSoldierClassesMode` | `RequireSoldierClasses` |  |

#### `X2Condition_UnitStatCheck`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CheckStats` | `array<CheckStat>` | `CheckStatsMode` | `m_aCheckStats` |  |

#### `X2Condition_UnitType`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `IncludeTypes` | `array<name>` | `IncludeTypesMode` | `IncludeTypes` |  |
| `ExcludeTypes` | `array<name>` | `ExcludeTypesMode` | `ExcludeTypes` |  |

#### `X2Condition_UnitValue`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `CheckValues` | `array<CheckValue>` | `CheckValuesMode` | `m_aCheckValues` |  |

#### `X2Condition_Visibility`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NoEnemyViewers` | `bool` | `SetNoEnemyViewers=true` | `bNoEnemyViewers` |  |
| `RequireMatchCoverType` | `bool` | `SetRequireMatchCoverType=true` | `bRequireMatchCoverType` |  |
| `RequireNotMatchCoverType` | `bool` | `SetRequireNotMatchCoverType=true` | `bRequireNotMatchCoverType` |  |
| `TargetCover` | `ECoverType` | `SetTargetCover=true` | `TargetCover` |  |
| `CannotPeek` | `bool` | `SetCannotPeek=true` | `bCannotPeek` |  |
| `RequireLOS` | `bool` | `SetRequireLOS=true` | `bRequireLOS` |  |
| `RequireBasicVisibility` | `bool` | `SetRequireBasicVisibility=true` | `bRequireBasicVisibility` |  |
| `RequireGameplayVisible` | `bool` | `SetRequireGameplayVisible=true` | `bRequireGameplayVisible` |  |
| `AllowSquadsight` | `bool` | `SetAllowSquadsight=true` | `bAllowSquadsight` |  |
| `ActAsSquadsight` | `bool` | `SetActAsSquadsight=true` | `bActAsSquadsight` |  |
| `VisibleToAnyAlly` | `bool` | `SetVisibleToAnyAlly=true` | `bVisibleToAnyAlly` |  |
| `DisablePeeksOnMovement` | `bool` | `SetDisablePeeksOnMovement=true` | `bDisablePeeksOnMovement` |  |
| `ExcludeGameplayVisible` | `bool` | `SetExcludeGameplayVisible=true` | `bExcludeGameplayVisible` |  |
| `RequireGameplayVisibleTags` | `array<name>` | `RequireGameplayVisibleTagsMode` | `RequireGameplayVisibleTags` |  |

#### Any other class

Handled by `X2AbilityConditionEditor_Base`: only the shared fields above apply.

### ToHitCalc (`ToHitCalc`)

Edits the template's to-hit calculation. Two slots exist: `ToHitCalc` (`Template.AbilityToHitCalc`) and `ToHitOwnerOnMissCalc` (`Template.AbilityToHitOwnerOnMissCalc`), both taking a `ToHitCalcEdit` block. With `Class` **omitted**, the existing calc is edited **in place**; with `Class` set, the existing calc is edited in place when it is already exactly that class, otherwise it is **replaced** by a new instance (unset fields then take class defaults). Classes without a dedicated editor below (e.g. `X2AbilityToHitCalc_StandardMelee`, `X2AbilityToHitCalc_DeadEye`) are still valid `Class` values — they get the fields of their nearest listed ancestor.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Optional. Omitted = edit the existing calc in place. Set = target/instantiate that class, e.g. `X2AbilityToHitCalc_StandardAim`. Bare names are auto-prefixed with `XComGame.`. |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2AbilityToHitCalc_StatCheck_UnitVsUnit` &rarr; `X2AbilityToHitCalc_PercentChancePlusFocus` &rarr; `X2AbilityToHitCalc_PercentChanceWithBuddyZone` &rarr; `X2AbilityToHitCalc_StandardAim` &rarr; `X2AbilityToHitCalc_PercentChance` &rarr; `X2AbilityToHitCalc_Hacking` &rarr; `X2AbilityToHitCalc_RollStat` &rarr; `X2AbilityToHitCalc_RollStatTiers` &rarr; `X2AbilityToHitCalc_StatCheck` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `HitModifiers` | `array<ShotModifierInfo>` | non-empty *(replace-only)* | `HitModifiers` | Replace-only: when non-empty, replaces the calc's HitModifiers array entirely |

#### `X2AbilityToHitCalc_StatCheck_UnitVsUnit`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AttackerStat` | `ECharStatType` | `SetAttackerStat=true` | `AttackerStat` |  |
| `DefenderStat` | `ECharStatType` | `SetDefenderStat=true` | `DefenderStat` |  |
| `BaseValue` | `int` | `SetBaseValue=true` | `BaseValue` | *(shared &mdash; from `X2AbilityToHitCalcEditor_StatCheck`)* |

#### `X2AbilityToHitCalc_PercentChancePlusFocus`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `FocusMultiplier` | `int` | `SetFocusMultiplier=true` | `FocusMultiplier` |  |
| `PercentToHit` | `int` | `SetPercentToHit=true` | `PercentToHit` | *(shared &mdash; from `X2AbilityToHitCalcEditor_PercentChance`)* |
| `NoGameStateOnMiss` | `bool` | `SetNoGameStateOnMiss=true` | `bNoGameStateOnMiss` | *(shared &mdash; from `X2AbilityToHitCalcEditor_PercentChance`)* |

#### `X2AbilityToHitCalc_PercentChanceWithBuddyZone`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `PercentToHitInBuddyZone` | `int` | `SetPercentToHitInBuddyZone=true` | `PercentToHitInBuddyZone` |  |
| `PercentToHit` | `int` | `SetPercentToHit=true` | `PercentToHit` | *(shared &mdash; from `X2AbilityToHitCalcEditor_PercentChance`)* |
| `NoGameStateOnMiss` | `bool` | `SetNoGameStateOnMiss=true` | `bNoGameStateOnMiss` | *(shared &mdash; from `X2AbilityToHitCalcEditor_PercentChance`)* |

#### `X2AbilityToHitCalc_StandardAim`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `IndirectFire` | `bool` | `SetIndirectFire=true` | `bIndirectFire` |  |
| `MeleeAttack` | `bool` | `SetMeleeAttack=true` | `bMeleeAttack` |  |
| `ReactionFire` | `bool` | `SetReactionFire=true` | `bReactionFire` |  |
| `AllowCrit` | `bool` | `SetAllowCrit=true` | `bAllowCrit` |  |
| `HitsAreCrits` | `bool` | `SetHitsAreCrits=true` | `bHitsAreCrits` |  |
| `MultiTargetOnly` | `bool` | `SetMultiTargetOnly=true` | `bMultiTargetOnly` |  |
| `OnlyMultiHitWithSuccess` | `bool` | `SetOnlyMultiHitWithSuccess=true` | `bOnlyMultiHitWithSuccess` |  |
| `GuaranteedHit` | `bool` | `SetGuaranteedHit=true` | `bGuaranteedHit` |  |
| `IgnoreCoverBonus` | `bool` | `SetIgnoreCoverBonus=true` | `bIgnoreCoverBonus` |  |
| `FinalMultiplier` | `float` | `SetFinalMultiplier=true` | `FinalMultiplier` |  |
| `BuiltInHitMod` | `int` | `SetBuiltInHitMod=true` | `BuiltInHitMod` |  |
| `BuiltInCritMod` | `int` | `SetBuiltInCritMod=true` | `BuiltInCritMod` |  |

#### `X2AbilityToHitCalc_PercentChance`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `PercentToHit` | `int` | `SetPercentToHit=true` | `PercentToHit` |  |
| `NoGameStateOnMiss` | `bool` | `SetNoGameStateOnMiss=true` | `bNoGameStateOnMiss` |  |

#### `X2AbilityToHitCalc_Hacking`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AlwaysSucceed` | `bool` | `SetAlwaysSucceed=true` | `bAlwaysSucceed` |  |

#### `X2AbilityToHitCalc_RollStat`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StatToRoll` | `ECharStatType` | `SetStatToRoll=true` | `StatToRoll` |  |
| `BaseChance` | `int` | `SetBaseChance=true` | `BaseChance` |  |

#### `X2AbilityToHitCalc_RollStatTiers`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `StatToRoll` | `ECharStatType` | `SetStatToRoll=true` | `StatToRoll` |  |

#### `X2AbilityToHitCalc_StatCheck`

*Abstract class &mdash; existing instances (of its subclasses) can be edited in place, but it cannot be added as a new instance from config.*

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `BaseValue` | `int` | `SetBaseValue=true` | `BaseValue` |  |

#### Any other class

Handled by `X2AbilityToHitCalcEditor_Base`: only the shared fields above apply.

### TargetStyle (`TargetStyle`)

Edits `Template.AbilityTargetStyle` (how the ability picks its primary target). Same in-place/replace semantics as `ToHitCalc`. Field-less styles (`X2AbilityTarget_Self`, `X2AbilityTarget_Path`, ...) are valid `Class` values for swapping the style.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Optional. Omitted = edit the existing style in place. Set = target/instantiate that class, e.g. `X2AbilityTarget_Cursor`. Bare names are auto-prefixed with `XComGame.`. |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2AbilityTarget_MovingMelee` &rarr; `X2AbilityTarget_Single` &rarr; `X2AbilityTarget_Cursor` &rarr; any other class

#### `X2AbilityTarget_MovingMelee`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MovementRangeAdjustment` | `int` | `SetMovementRangeAdjustment=true` | `MovementRangeAdjustment` |  |
| `OnlyIncludeTargetsInsideWeaponRange` | `bool` | `SetOnlyIncludeTargetsInsideWeaponRange=true` | `OnlyIncludeTargetsInsideWeaponRange` | *(shared &mdash; from `X2AbilityTargetStyleEditor_Single`)* |
| `AllowInteractiveObjects` | `bool` | `SetAllowInteractiveObjects=true` | `bAllowInteractiveObjects` | *(shared &mdash; from `X2AbilityTargetStyleEditor_Single`)* |
| `AllowDestructibleObjects` | `bool` | `SetAllowDestructibleObjects=true` | `bAllowDestructibleObjects` | *(shared &mdash; from `X2AbilityTargetStyleEditor_Single`)* |
| `IncludeSelf` | `bool` | `SetIncludeSelf=true` | `bIncludeSelf` | *(shared &mdash; from `X2AbilityTargetStyleEditor_Single`)* |
| `ShowAOE` | `bool` | `SetShowAOE=true` | `bShowAOE` | *(shared &mdash; from `X2AbilityTargetStyleEditor_Single`)* |

#### `X2AbilityTarget_Single`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OnlyIncludeTargetsInsideWeaponRange` | `bool` | `SetOnlyIncludeTargetsInsideWeaponRange=true` | `OnlyIncludeTargetsInsideWeaponRange` |  |
| `AllowInteractiveObjects` | `bool` | `SetAllowInteractiveObjects=true` | `bAllowInteractiveObjects` |  |
| `AllowDestructibleObjects` | `bool` | `SetAllowDestructibleObjects=true` | `bAllowDestructibleObjects` |  |
| `IncludeSelf` | `bool` | `SetIncludeSelf=true` | `bIncludeSelf` |  |
| `ShowAOE` | `bool` | `SetShowAOE=true` | `bShowAOE` |  |

#### `X2AbilityTarget_Cursor`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `RestrictToWeaponRange` | `bool` | `SetRestrictToWeaponRange=true` | `bRestrictToWeaponRange` |  |
| `IncreaseWeaponRange` | `int` | `SetIncreaseWeaponRange=true` | `IncreaseWeaponRange` |  |
| `RestrictToSquadsightRange` | `bool` | `SetRestrictToSquadsightRange=true` | `bRestrictToSquadsightRange` |  |
| `FixedAbilityRange` | `int` | `SetFixedAbilityRange=true` | `FixedAbilityRange` |  |

#### Any other class

Handled by `X2AbilityTargetStyleEditor_Base`: only the shared fields above apply.

### MultiTargetStyle (`MultiTargetStyle`)

Edits the template's multi-target styles. Two slots exist: `MultiTargetStyle` (`Template.AbilityMultiTargetStyle`) and `PassiveAOEStyle` (`Template.AbilityPassiveAOEStyle`), both taking a `MultiTargetStyleEdit` block. Same in-place/replace semantics as `ToHitCalc`.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Optional. Omitted = edit the existing style in place. Set = target/instantiate that class, e.g. `X2AbilityMultiTarget_Radius`. Bare names are auto-prefixed with `XComGame.`. |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2AbilityMultiTarget_Cone` &rarr; `X2AbilityMultiTarget_Cylinder` &rarr; `X2AbilityMultiTarget_AllUnits` &rarr; `X2AbilityMultiTarget_ClaymoreRadius` &rarr; `X2AbilityMultiTarget_Radius` &rarr; `X2AbilityMultiTarget_Line` &rarr; `X2AbilityMultiTarget_BurstFire` &rarr; any other class

Shared fields (available for **every** class of this family):

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `AllowSameTarget` | `bool` | `SetAllowSameTarget=true` | `bAllowSameTarget` |  |
| `UseSourceWeaponLocation` | `bool` | `SetUseSourceWeaponLocation=true` | `bUseSourceWeaponLocation` |  |
| `NumTargetsRequired` | `int` | `SetNumTargetsRequired=true` | `NumTargetsRequired` |  |

#### `X2AbilityMultiTarget_Cone`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ConeEndDiameter` | `float` | `SetConeEndDiameter=true` | `ConeEndDiameter` |  |
| `ConeLength` | `float` | `SetConeLength=true` | `ConeLength` |  |
| `UseWeaponRangeForLength` | `bool` | `SetUseWeaponRangeForLength=true` | `bUseWeaponRangeForLength` |  |
| `LockShooterZ` | `bool` | `SetLockShooterZ=true` | `bLockShooterZ` |  |
| `AbilityBonusCones` | `array<AbilityGrantedBonusCone>` | `AbilityBonusConesMode` | `AbilityBonusCones` |  |
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `UseWeaponBlockingCoverFlag` | `bool` | `SetUseWeaponBlockingCoverFlag=true` | `bUseWeaponBlockingCoverFlag` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `IgnoreBlockingCover` | `bool` | `SetIgnoreBlockingCover=true` | `bIgnoreBlockingCover` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetRadius` | `float` | `SetTargetRadius=true` | `fTargetRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetCoveragePercentage` | `float` | `SetTargetCoveragePercentage=true` | `fTargetCoveragePercentage` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AddPrimaryTargetAsMultiTarget` | `bool` | `SetAddPrimaryTargetAsMultiTarget=true` | `bAddPrimaryTargetAsMultiTarget` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AllowDeadMultiTargetUnits` | `bool` | `SetAllowDeadMultiTargetUnits=true` | `bAllowDeadMultiTargetUnits` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `ExcludeSelfAsTargetIfWithinRadius` | `bool` | `SetExcludeSelfAsTargetIfWithinRadius=true` | `bExcludeSelfAsTargetIfWithinRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AbilityBonusRadii` | `array<AbilityGrantedBonusRadius>` | `AbilityBonusRadiiMode` | `AbilityBonusRadii` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |

#### `X2AbilityMultiTarget_Cylinder`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TargetHeight` | `float` | `SetTargetHeight=true` | `fTargetHeight` |  |
| `UseOnlyGroundTiles` | `bool` | `SetUseOnlyGroundTiles=true` | `bUseOnlyGroundTiles` |  |
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `UseWeaponBlockingCoverFlag` | `bool` | `SetUseWeaponBlockingCoverFlag=true` | `bUseWeaponBlockingCoverFlag` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `IgnoreBlockingCover` | `bool` | `SetIgnoreBlockingCover=true` | `bIgnoreBlockingCover` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetRadius` | `float` | `SetTargetRadius=true` | `fTargetRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetCoveragePercentage` | `float` | `SetTargetCoveragePercentage=true` | `fTargetCoveragePercentage` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AddPrimaryTargetAsMultiTarget` | `bool` | `SetAddPrimaryTargetAsMultiTarget=true` | `bAddPrimaryTargetAsMultiTarget` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AllowDeadMultiTargetUnits` | `bool` | `SetAllowDeadMultiTargetUnits=true` | `bAllowDeadMultiTargetUnits` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `ExcludeSelfAsTargetIfWithinRadius` | `bool` | `SetExcludeSelfAsTargetIfWithinRadius=true` | `bExcludeSelfAsTargetIfWithinRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AbilityBonusRadii` | `array<AbilityGrantedBonusRadius>` | `AbilityBonusRadiiMode` | `AbilityBonusRadii` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |

#### `X2AbilityMultiTarget_AllUnits`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `OnlyAllyOfType` | `name` | `SetOnlyAllyOfType=true` | `OnlyAllyOfType` |  |
| `AcceptFriendlyUnits` | `bool` | `SetAcceptFriendlyUnits=true` | `bAcceptFriendlyUnits` |  |
| `AcceptEnemyUnits` | `bool` | `SetAcceptEnemyUnits=true` | `bAcceptEnemyUnits` |  |
| `OnlyAcceptRoboticUnits` | `bool` | `SetOnlyAcceptRoboticUnits=true` | `bOnlyAcceptRoboticUnits` |  |
| `OnlyAcceptAlienUnits` | `bool` | `SetOnlyAcceptAlienUnits=true` | `bOnlyAcceptAlienUnits` |  |
| `OnlyAcceptAdventUnits` | `bool` | `SetOnlyAcceptAdventUnits=true` | `bOnlyAcceptAdventUnits` |  |
| `RandomlySelectOne` | `bool` | `SetRandomlySelectOne=true` | `bRandomlySelectOne` |  |
| `DontAcceptNeutralUnits` | `bool` | `SetDontAcceptNeutralUnits=true` | `bDontAcceptNeutralUnits` |  |
| `RandomChance` | `int` | `SetRandomChance=true` | `RandomChance` |  |
| `UseAbilitySourceAsPrimaryTarget` | `bool` | `SetUseAbilitySourceAsPrimaryTarget=true` | `bUseAbilitySourceAsPrimaryTarget` |  |
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `UseWeaponBlockingCoverFlag` | `bool` | `SetUseWeaponBlockingCoverFlag=true` | `bUseWeaponBlockingCoverFlag` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `IgnoreBlockingCover` | `bool` | `SetIgnoreBlockingCover=true` | `bIgnoreBlockingCover` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetRadius` | `float` | `SetTargetRadius=true` | `fTargetRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetCoveragePercentage` | `float` | `SetTargetCoveragePercentage=true` | `fTargetCoveragePercentage` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AddPrimaryTargetAsMultiTarget` | `bool` | `SetAddPrimaryTargetAsMultiTarget=true` | `bAddPrimaryTargetAsMultiTarget` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AllowDeadMultiTargetUnits` | `bool` | `SetAllowDeadMultiTargetUnits=true` | `bAllowDeadMultiTargetUnits` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `ExcludeSelfAsTargetIfWithinRadius` | `bool` | `SetExcludeSelfAsTargetIfWithinRadius=true` | `bExcludeSelfAsTargetIfWithinRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AbilityBonusRadii` | `array<AbilityGrantedBonusRadius>` | `AbilityBonusRadiiMode` | `AbilityBonusRadii` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |

#### `X2AbilityMultiTarget_ClaymoreRadius`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ClaymoreEnvironmentalDamage` | `int` | `SetClaymoreEnvironmentalDamage=true` | `ClaymoreEnvironmentalDamage` |  |
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `UseWeaponBlockingCoverFlag` | `bool` | `SetUseWeaponBlockingCoverFlag=true` | `bUseWeaponBlockingCoverFlag` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `IgnoreBlockingCover` | `bool` | `SetIgnoreBlockingCover=true` | `bIgnoreBlockingCover` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetRadius` | `float` | `SetTargetRadius=true` | `fTargetRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `TargetCoveragePercentage` | `float` | `SetTargetCoveragePercentage=true` | `fTargetCoveragePercentage` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AddPrimaryTargetAsMultiTarget` | `bool` | `SetAddPrimaryTargetAsMultiTarget=true` | `bAddPrimaryTargetAsMultiTarget` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AllowDeadMultiTargetUnits` | `bool` | `SetAllowDeadMultiTargetUnits=true` | `bAllowDeadMultiTargetUnits` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `ExcludeSelfAsTargetIfWithinRadius` | `bool` | `SetExcludeSelfAsTargetIfWithinRadius=true` | `bExcludeSelfAsTargetIfWithinRadius` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |
| `AbilityBonusRadii` | `array<AbilityGrantedBonusRadius>` | `AbilityBonusRadiiMode` | `AbilityBonusRadii` | *(shared &mdash; from `X2AbilityMultiTargetStyleEditor_Radius`)* |

#### `X2AbilityMultiTarget_Radius`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `UseWeaponRadius` | `bool` | `SetUseWeaponRadius=true` | `bUseWeaponRadius` |  |
| `UseWeaponBlockingCoverFlag` | `bool` | `SetUseWeaponBlockingCoverFlag=true` | `bUseWeaponBlockingCoverFlag` |  |
| `IgnoreBlockingCover` | `bool` | `SetIgnoreBlockingCover=true` | `bIgnoreBlockingCover` |  |
| `TargetRadius` | `float` | `SetTargetRadius=true` | `fTargetRadius` |  |
| `TargetCoveragePercentage` | `float` | `SetTargetCoveragePercentage=true` | `fTargetCoveragePercentage` |  |
| `AddPrimaryTargetAsMultiTarget` | `bool` | `SetAddPrimaryTargetAsMultiTarget=true` | `bAddPrimaryTargetAsMultiTarget` |  |
| `AllowDeadMultiTargetUnits` | `bool` | `SetAllowDeadMultiTargetUnits=true` | `bAllowDeadMultiTargetUnits` |  |
| `ExcludeSelfAsTargetIfWithinRadius` | `bool` | `SetExcludeSelfAsTargetIfWithinRadius=true` | `bExcludeSelfAsTargetIfWithinRadius` |  |
| `AbilityBonusRadii` | `array<AbilityGrantedBonusRadius>` | `AbilityBonusRadiiMode` | `AbilityBonusRadii` |  |

#### `X2AbilityMultiTarget_Line`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `TileWidthExtension` | `int` | `SetTileWidthExtension=true` | `TileWidthExtension` |  |
| `SightRangeLimited` | `bool` | `SetSightRangeLimited=true` | `bSightRangeLimited` |  |
| `AbilityBonusWidths` | `array<AbilityGrantedBonusWidth>` | `AbilityBonusWidthsMode` | `AbilityBonusWidths` |  |

#### `X2AbilityMultiTarget_BurstFire`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `NumExtraShots` | `int` | `SetNumExtraShots=true` | `NumExtraShots` |  |

#### Any other class

Handled by `X2AbilityMultiTargetStyleEditor_Base`: only the shared fields above apply.

### Triggers (`Triggers`)

Edits the `AbilityTriggers` array of the template. The trigger of class `Class` is edited **in place** if present; otherwise behaviour depends on `Mode`. **Caveat:** adding a *new* `X2AbilityTrigger_EventListener` from config is rarely useful — its `ListenerData.EventFn` delegate can only be assigned in code and stays `none`. Editing an existing listener trigger preserves its `EventFn`. `X2AbilityTrigger_OnAbilityActivated` is handled by the EventListener editor (its `MatchAbilityActivated` field is protected and cannot be set). See also `AbilityEventListenerEdits` in the template fields for the separate `Template.AbilityEventListeners` array.

Structural fields:

| Config key | Type | Notes |
|---|---|---|
| `Class` | `string` | Trigger class to target/instantiate, e.g. `X2AbilityTrigger_UnitPostBeginPlay`. Bare names are auto-prefixed with `XComGame.`. |
| `Mode` | `EArrayEditMode` | Per-entry edit mode (`EArrayEditMode`), see [Edit modes](#edit-modes). |
| `CustomProperties` | `array<AECustomProperty>` | Free-form key/value pairs for bridge-mod editors; ignored by the built-in editors. |

Editor dispatch order (first match wins): `X2AbilityTrigger_UnitPostBeginPlay` &rarr; `X2AbilityTrigger_EventListener` &rarr; `X2AbilityTrigger_Event` &rarr; any other class

#### `X2AbilityTrigger_UnitPostBeginPlay`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `Priority` | `int` | `SetPriority=true` | `Priority` |  |

#### `X2AbilityTrigger_EventListener`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `ListenerEventID` | `name` | `SetListenerEventID=true` | `ListenerData.EventID` |  |
| `ListenerDeferral` | `EventListenerDeferral` | `SetListenerDeferral=true` | `ListenerData.Deferral` |  |
| `ListenerFilter` | `AbilityEventFilter` | `SetListenerFilter=true` | `ListenerData.Filter` |  |
| `ListenerPriority` | `int` | `SetListenerPriority=true` | `ListenerData.Priority` |  |

#### `X2AbilityTrigger_Event`

| Config key | Type | Requires | Game field | Notes |
|---|---|---|---|---|
| `MethodName` | `name` | `SetMethodName=true` | `MethodName` |  |
| `EventObserverClass` | `string` | `SetEventObserverClass=true` |  |  |

Not editable via config: `EventObserverClass` *(class reference)*

#### Any other class

Handled by `X2AbilityTriggerEditor_Base`: only the shared fields above apply.

### Nested structs

#### `AdditionalCooldownEdit`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `AbilityName` | `name` | &mdash; | Ability whose cooldown entry is added/updated in `AditionalAbilityCooldowns`. |
| `NumTurns` | `int` | `SetNumTurns=true` |  |
| `UseAbilityCooldownNumTurns` | `bool` | `SetUseAbilityCooldownNumTurns=true` |  |
| `ApplyCooldownType` | `name` | &mdash; | `AdditionalCooldown_ApplyLarger` or `AdditionalCooldown_ApplySmaller`. Applied when non-empty. |

#### `BonusChargeEdit`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `AbilityName` | `name` | &mdash; | Ability that grants the bonus charges. |
| `NumCharges` | `int` | `SetNumCharges=true` |  |

#### `StatChangeEdit`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `StatType` | `ECharStatType` | `SetStatType=true` |  |
| `StatAmount` | `float` | `SetStatAmount=true` |  |
| `ModOp` | `EStatModOp` | `SetModOp=true` |  |
| `ApplicationRule` | `ECharStatModApplicationRule` | `SetApplicationRule=true` |  |

#### `WeaponDamageValueEdit`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `Damage` | `int` | `SetDamage=true` |  |
| `Spread` | `int` | `SetSpread=true` |  |
| `PlusOne` | `int` | `SetPlusOne=true` |  |
| `Crit` | `int` | `SetCrit=true` |  |
| `Pierce` | `int` | `SetPierce=true` |  |
| `Rupture` | `int` | `SetRupture=true` |  |
| `Shred` | `int` | `SetShred=true` |  |
| `Tag` | `name` | `SetTag=true` |  |
| `DamageType` | `name` | `SetDamageType=true` |  |

#### `AbilityEventListenerEdit`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `EventID` | `name` | &mdash; | Matches the existing `Template.AbilityEventListeners` entry to edit. Entries cannot be added (their `EventFn` delegate is code-only). |
| `Deferral` | `EventListenerDeferral` | `SetDeferral=true` |  |
| `Filter` | `AbilityEventFilter` | `SetFilter=true` |  |
| `Priority` | `int` | `SetPriority=true` |  |

#### `AECustomProperty`

| Config key | Type | Requires | Notes |
|---|---|---|---|
| `Key` | `name` | &mdash; |  |
| `Value` | `string` | &mdash; |  |
<!-- END:GENERATED reference -->

## Examples

**Slash no longer ends the turn (for soldiers with Blademaster), gets 5 charges and a 5-turn cooldown that also puts Blademaster on a 3-turn cooldown:**

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+AbilityEdits=( \\
    Ability=SwordSlice, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_ActionPoints", \\
            SetNumPoints=true, \\
            NumPoints=1, \\
            SetConsumeAllPoints=true, \\
            ConsumeAllPoints=true, \\
            DoNotConsumeAllSoldierAbilities=(Blademaster) \\
        ), \\
        ( \\
            Class="X2AbilityCost_Charges", \\
            SetNumCharges=true, \\
            NumCharges=1 \\
        ) \\
    ), \\
    Charges=( \\
        Class="X2AbilityCharges", \\
        SetInitialCharges=true, \\
        InitialCharges=5 \\
    ), \\
    Cooldown=( \\
        Class="X2AbilityCooldown", \\
        SetNumTurns=true, \\
        NumTurns=5, \\
        AdditionalCooldowns=( \\
            ( \\
                AbilityName=Blademaster, \\
                SetNumTurns=true, \\
                NumTurns=3 \\
            ) \\
        ) \\
    ) \\
)
```

Note that both `Costs` entries are listed: since the default `CostMode` is `eACEM_ReplaceAll`, the ability ends up with exactly the costs written here.

**Aid Protocol on a 9-turn cooldown for XCOM, 1 turn for the AI:**

```ini
+AbilityEdits=( \\
    Ability=AidProtocol, \\
    Cooldown=( \\
        Class="XComGame.X2AbilityCooldown_PerPlayerType", \\
        SetNumTurns=true, \\
        NumTurns=9, \\
        SetNumTurnsForAI=true, \\
        NumTurnsForAI=1 \\
    ) \\
)
```

**Add a cost to an ability without touching its other costs** — set `CostMode` away from the default and use `Mode=eACEM_AddOnly` on the entry:

```ini
+AbilityEdits=( \\
    Ability=ScanningProtocol, \\
    CostMode=eACEM_Merge, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_Charges", \\
            Mode=eACEM_AddOnly, \\
            SetNumCharges=true, \\
            NumCharges=1 \\
        ) \\
    ) \\
)
```

**Edit an effect and its conditions** — make Combat Protocol's damage effect deal 3 guaranteed damage, and restrict the ability to robotic targets only:

```ini
+AbilityEdits=( \\
    Ability=CombatProtocol, \\
    Effects=( \\
        ( \\
            Class="X2Effect_ApplyWeaponDamage", \\
            Slot=eAES_Target, \\
            Mode=eAEM_Merge, \\
            WeaponDamageValue=( \\
                SetDamage=true, \\
                Damage=3, \\
                SetSpread=true, \\
                Spread=0 \\
            ) \\
        ) \\
    ), \\
    TargetConditions=( \\
        ( \\
            Class="X2Condition_UnitProperty", \\
            Mode=eAEM_Merge, \\
            SetExcludeOrganic=true, \\
            ExcludeOrganic=true \\
        ) \\
    ) \\
)
```

The template-level `TargetConditions` edits the condition of class `X2Condition_UnitProperty` **in place** if the ability already has one (only the fields you `Set` change), or adds a new one otherwise.

**Tweak aim and targeting** — give an ability +15 built-in aim (editing its existing to-hit calc in place, no `Class` needed) and widen its cone:

```ini
+AbilityEdits=( \\
    Ability=SomeConeAbility, \\
    ToHitCalc=( \\
        SetBuiltInHitMod=true, \\
        BuiltInHitMod=15 \\
    ), \\
    MultiTargetStyle=( \\
        SetConeEndDiameter=true, \\
        ConeEndDiameter=20.0, \\
        SetConeLength=true, \\
        ConeLength=28.0 \\
    ) \\
)
```

## Extending Ability Editor (bridge mods)

Other mods can plug their own editor classes into Ability Editor's dispatch — the intended way to support DLC-package or mod-added classes without adding dependencies to Ability Editor itself:

1. Make your mod depend on the `AbilityEditor` script package (X2ModBuildCommon dependency).
2. Subclass the right family editor and declare which game class you handle:
   ```unrealscript
   class X2AbilityEffectsEditor_MyDLCEffect extends X2AbilityEffectsEditor_Persistent;

   static function bool CanEdit(X2Effect Effect)
   {
       return Effect.IsA('X2Effect_MyDLCEffect');
   }

   static function ApplyDerivedEdit(name AbilityName, string Slot, X2Effect Effect, EffectEdit EffectEdit)
   {
       super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);
       // read shared EffectEdit fields, or your own values from EffectEdit.CustomProperties
   }
   ```
3. Register it in your mod's `XComAbilityEditor.ini`:
   ```ini
   [AbilityEditor.X2DLCInfo_AbilityEditor]
   +ExtraEffectsEditors=(EditorClass="MyMod.X2AbilityEffectsEditor_MyDLCEffect", Priority=10)
   ```

Registered extras are dispatched **before** all built-in editors, sorted by `Priority` (highest first). Rule of thumb: the more derived your target class, the higher the `Priority` — that way an editor for a child class always wins over one for its parent. Targeting a class Ability Editor already handles deliberately **overrides** the built-in editor. Every `Extra<Family>Editors` array exists for all nine families (`ExtraCostEditors`, `ExtraConditionEditors`, `ExtraToHitCalcEditors`, ...).

For data the shared edit structs don't carry, every `EffectEdit`/`ConditionEdit`/`ToHitCalcEdit`/`TargetStyleEdit`/`MultiTargetStyleEdit`/`TriggerEdit` has a `CustomProperties` array of `(Key=..., Value="...")` pairs that built-in editors ignore and your editor can interpret freely.

## Troubleshooting

- Enable logging in the mod's `XComEngine.ini` (or your own config): section `[AbilityEditor.X2DLCInfo_AbilityEditor]`, `EnableDebug=true`. Every applied change is logged to `Launch.log` under the `AbilityEditor` tag as `<Ability> <Field> changed from <old> to <new>`; unknown abilities and classes are reported too.
- Nothing happens? Check that every value has its `SetX=true` switch, that `Cooldown`/`Charges` blocks include `Class=`, and that the `\\` line continuations are intact.
- Config changes require deleting the config cache (or starting with `-regenerateconfig`... in practice: delete `Documents\My Games\XCOM2 War of the Chosen\XComGame\Config`) for the game to pick them up.

## For developers

### Build prerequisite: Community Highlander sources

**Building this mod requires an SDK whose `Development/Src` is Community Highlander-patched.** It is
not a requirement for *players* — see below.

`X2AbilityEffectsEditor_Helper.uc` writes `Template.AbilityTargetEffects`,
`AbilityMultiTargetEffects` and `AbilityShooterEffects`. In stock Firaxis sources those three are
`protectedwrite`, so the writes will not compile. Community Highlander
[Issue #68](https://github.com/X2CommunityCore/X2WOTCCommunityHighlander/issues/68) removes that
modifier (`X2AbilityTemplate.uc`, "Start Issue #68 / End Issue #68").

This is a **compile-time** dependency only. Issue #68 changes nothing but the accessibility
modifier — same types, same declaration order, same class layout — and UnrealScript access
modifiers do not affect the compiled property layout, so the resulting `.u` loads and runs against
vanilla `XComGame` as well as the Highlander's. No `RequiredHighlanderVersion` is declared, and none
is needed.

If you see `Error, Can't write to protected variable` on `AbilityTargetEffects` during a build, your
SDK sources are stock; deploy the Highlander into the SDK.

### Regenerating the docs

The [Reference](#reference), [Supported at a glance](#supported-at-a-glance) and [Edit modes](#edit-modes) sections above are **generated** from the UnrealScript sources. After adding or changing an editor class, regenerate them with:

```powershell
.\.scripts\generate-docs.ps1 -SdkPath '<path to WOTC SDK>'   # updates README.md and docs/schema.json
.\.scripts\generate-docs.ps1 -CheckOnly                      # exits 1 if the docs are stale
.\.scripts\generate-docs.ps1 -PrintSourceHash                # prints the .uc source hash and exits
```

Always pass `-SdkPath`: without it the generator silently skips abstract-class badges, the
per-class "not editable via config" lists, and the **dispatch-order check** — the only automated
guard against registering an editor after one of its game class's ancestors, which makes it dead
code. `-PrintSourceHash` is the CI-friendly staleness check: it needs no SDK, so CI can compare it
against `sourceHash` in the committed `docs/schema.json`.

The script also emits [`docs/schema.json`](docs/schema.json), a machine-readable description of the whole config API (enums, structs, families, editors, fields), meant to be consumed by external tooling such as a config-builder web app.

For the docs to pick up a new editor class automatically, follow the existing conventions:

1. Declare the handled game class with a single `IsA('X2Thing_Class')` in `CanEdit()`.
2. Apply optional scalars with the `if (Edit.SetX) { LogInfo(...); Target.Field = Edit.X; }` triplet, and name arrays through `X2AbilityEditor_Helper.ApplyNameArrayEdit`.
3. Register the class in the family's registry in `X2DLCInfo_AbilityEditor.uc` `defaultproperties` — **before** any editor whose game class is a parent of yours (first match wins).
4. Declare new config fields in `AE_DataStructures.uc` as `Set`/value pairs. To document a field, put the `// comment` **directly above the value var, not above the `Set` guard** — the parser attaches a comment to the next `var` it sees, and guards are not documented fields, so a comment above the pair is dropped. Comments above a guard are therefore free to act as section headers (`// X2Condition_UnitValue`), which is how the file already uses them.

   ```unrealscript
   var bool SetNumAmmo;
   // Rounds consumed per shot. 0 makes the ability free to fire.
   var int NumAmmo;
   ```

Everything hand-written in this file lives outside the `<!-- BEGIN:GENERATED ... -->` markers and survives regeneration.
