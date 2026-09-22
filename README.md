# Ability Editor

An XCOM 2: War of the Chosen mod that changes how existing abilities work **purely from config** - no UnrealScript required. Costs, cooldowns, charges, effects, conditions and template fields of any ability (base game, DLC or another mod's) can be edited by adding `+AbilityEdits` entries to an `.ini` file.

Letting a Ranger keep acting after Slash is just:

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+AbilityEdits=( \\
    Ability=SwordSlice, \\
    CostMode=eACEM_Merge, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_ActionPoints", \\
            Mode=eACEM_Merge, \\
            SetNumPoints=true, \\
            NumPoints=1, \\
            SetConsumeAllPoints=true, \\
            ConsumeAllPoints=false \\
        ) \\
    ) \\
)
```

## 📖 Documentation

**[boundir.github.io/AbilityEditor](https://boundir.github.io/AbilityEditor/)** - full field reference for every class across all nine families, plus guides.

Start with [Config syntax](https://boundir.github.io/AbilityEditor/getting-started/config-syntax/) and [Edit modes](https://boundir.github.io/AbilityEditor/getting-started/edit-modes/); the second one covers defaults that can wipe an ability's costs if you leave them out.

## Install

Subscribe on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=1789085465), or drop the mod folder into `XCom2-WarOfTheChosen/Mods/` and enable it in the launcher. No dependencies.

Put your edits under `[AbilityEditor.X2DLCInfo_AbilityEditor]` in an `XComAbilityEditor.ini` - either the mod's own, or (better, so a Workshop update can't overwrite them) your own small mod. The `+` prefix appends, so several mods can contribute edits at once.

> **Config changes need a cache clear.** Delete `Documents\My Games\XCOM2 War of the Chosen\XComGame\Config` after editing any `.ini`. Skipping this is the most common reason a correct edit appears to do nothing.

## What you can edit

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

## Troubleshooting

Set `EnableDebug=true` under `[AbilityEditor.X2DLCInfo_AbilityEditor]` in `XComEngine.ini`. Every applied change is then logged to `Launch.log` under the `AbilityEditor` tag - **if a field isn't in that log, it was never applied.**

The three usual causes: a stale config cache, a value written without its `SetX=true` guard, or a `Mode` left at its default (which is a *replace* in every mode enum). Full list: [Troubleshooting](https://boundir.github.io/AbilityEditor/guides/troubleshooting/).

## For developers

- [Adding an editor](https://boundir.github.io/AbilityEditor/contributing/adding-an-editor/) - conventions, and the build's Community Highlander requirement.
- [Extending from another mod](https://boundir.github.io/AbilityEditor/guides/bridge-mods/) - register your own editor classes without forking.
- [`docs/schema.json`](docs/schema.json) - the whole config API, machine-readable, for external tooling.

The reference documentation is generated from the UnrealScript sources:

```powershell
.\.scripts\generate-docs.ps1 -SdkPath '<path to WOTC SDK>'   # updates docs/schema.json and the block above
.\.scripts\generate-docs.ps1 -CheckOnly                      # exits 1 if either is stale
```

To preview the site locally:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements-docs.txt
mkdocs serve
```

## Links

- [Changelog](CHANGELOG.md)
- [Legacy 1.x config](https://boundir.github.io/AbilityEditor/guides/legacy-1x/) - still supported, superseded by the 2.0 format.
