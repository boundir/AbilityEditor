# Why isn't this editable?

Some game classes have fields that will never get an editor, because an editor could not
change anything. This page records which, and why.

## Read from the class default, not the instance

This is the largest group. An editor writes the ability template's *instance* of an effect.
If the game reads the field as `default.X`, it is reading the class default from `XComGameCore.ini` and never looks at the instance. The edit is applied, logged, and ignored.

```unrealscript
// X2Effect_Vengeance.uc:43 - every one of its 11 config ints reads this way
StatChance = default.STAT_BASE_CHANCE + DeadRank * default.STAT_PER_RANK_CHANCE;
```

These fields are not unreachable. They are already tunable, **globally**, in the game's own
config, and that is the right place to change them:

```ini
[XComGame.X2Effect_Vengeance]
AIM_BASE=10
```

What an editor would add is *per-ability* control, which the code does not support for these fields.
Adding it would need a global-scope edit family.

| Class | Fields read via `default.` | Where |
|---|---|---|
| `X2Effect_Vengeance` | all 11 config ints | `X2Effect_Vengeance.uc` |
| `X2Effect_CombatStims` | `ARMOR_CHANCE`, `ARMOR_MITIGATION` | `X2Effect_CombatStims.uc` |
| `X2Effect_IncendiaryRounds` | `AimMod` | `X2Effect_IncendiaryRounds.uc` |
| `X2Effect_TracerRounds` | `AimMod` | `X2Effect_TracerRounds.uc` |
| `X2Effect_ApplyPoisonToWorld` | `Duration` (the particle name *is* editable) | `X2Effect_ApplyPoisonToWorld.uc` |
| `X2Effect_ApplySmokeGrenadeToWorld` | `Duration` (the particle name *is* editable) | `X2Effect_ApplySmokeGrenadeToWorld.uc` |
| `X2Effect_Deflect` | 5 config ints | |
| `X2Effect_Marked` | 3 config ints | |
| `X2Effect_Shredder` | `ConventionalShred`, `MagneticShred`, `BeamShred` | |
| `X2Effect_Suppression` | 3 aim penalties | |
| `X2Effect_ZeroIn` | `CritPerShot`, `LockedInAimPerShot` | |
| `X2Effect_BiggestBooms` | `CRIT_CHANCE_BONUS`, `CRIT_DAMAGE_BONUS` | |
| `X2Effect_Frenzy` | `FRENZY_NUM_ACTION_POINTS_ADDED` | |
| `X2Effect_AidProtocol` | `BASE_DEFENSE` | |
| `X2Effect_Dazed` | `DAZE_REMOVE_EFFECTS_TARGET` | |
| `X2Effect_TheLostHeadshot` | `ValidHeadshotAbilities` | |
| `X2Effect_Blind` | `BlindStatusIcon` | |
| `X2Effect_Burrowed` | `BURROWED_PERCENT_DAMAGE_REDUCTION` | |
| `X2Effect_GatekeeperClosed` | `GATEKEEPER_CLOSED_PERCENT_DAMAGE_REDUCTION` | |
| `X2Effect_ProximityMine` | `PersistentParticles` | |
| `X2Effect_DisableWeapon` | `HideVisualizationOfResults`, `WeaponsImmuneToDisable` | |
| `X2Effect_SkirmisherReflex` | `ReflexUnitValue`, `TotalEarnedValue` | `X2Effect_SkirmisherReflex.uc`, `XComGameState_Effect.uc` |
| `X2Effect_TargetDefinition` | `TargetDefinitionTriggeredEventName` | |
| `X2Effect_MimicBeacon` | `REMOVE_EFFECT_ANIM_NAME` (`ABILITIES_ALLOWED_TO_HIT` *is* editable) | |
| `X2Effect_SpectralArmyUnit` | `ADD_EFFECT_ANIM_NAME`, `REMOVE_EFFECT_ANIM_NAME` | |

!!! note "`X2Effect_CombatStims` is worse"
    It overrides `GetArmorMitigation()` to return `default.ARMOR_MITIGATION`. So the `ArmorMitigationAmount` field it *inherits* from the BonusArmor editor is silently ignored too
    An entry naming `X2Effect_CombatStims` and setting `ArmorMitigationAmount` applies cleanly and does nothing.

## Never read at all

| Class | Field | Evidence |
|---|---|---|
| `X2AbilityToHitCalc_StasisLance` | `HP_THRESHOLD`, `CLAMPED_MIN`, `CLAMPED_MAX` | only inside commented-out code. `BASE_CHANCE` is live but `default.`-read. |
| `X2AbilityMultiTarget_Volt` | `DistanceBetweenTargets` | not referenced in the SDK. |

## No plain field to write

There is no assignment an editor could make. An editor would have to call the setter, or map a
config name to a delegate.

| Class | Route |
|---|---|
| `X2Effect_AdditionalAnimSets` | `AddAnimSetWithPath(string)` - append-only, no way to clear |
| `X2AbilityTrigger_OnAbilityActivated` | `SetListenerData(name)` - also overwrites `ListenerData.EventID/EventFn/Deferral/Filter`, so it resets the whole listener |
| `X2Effect_Unkillable` | `AdditionalEffectsFN` delegate |
| `X2Effect_WeakPoint` | `GetValueFn` delegate |

## Deliberately skipped

| Class | Why |
|---|---|
| `X2Effect_Panicked`, `X2Effect_Executed`, `X2Effect_SpawnGhost` | Localised strings only. That belongs in a localisation file, not an ability edit. |
| `X2Condition_Wrath` | `TargetTile` is runtime scratch, set by `X2Effect_GetOverThere` when applied. |
| `X2Effect_CallReinforcements` | `m_kAudioEvent` is an `AkEvent` object reference. Would need `DynamicLoadObject`. |

## Editable, despite appearances

**`X2Effect_Burning`** has no editor of its own and does not need one. Its only settable var, `BURNED_IGNORES_SHIELDS`, is consumed inside `SetBurnDamage()` at template-build time, before this mod runs.
Its duration and removal rules come from the `X2Effect_Persistent` editor it falls through to, and its *damage* lives in a nested `X2Effect_ApplyWeaponDamage` at `ApplyOnTick[0]`, reachable with `ApplyOnTickClass` - see [Examples](../guides/examples.md#change-how-much-damage-burning-does).

**`X2AbilityCooldown` and `X2AbilityCharges`** are the only two family base classes that are themselves concrete.
Neither has an `IsA` editor, but their own vars are written by `ApplyBaseEdit` in the abstract family editor, reached through the `_Base` catch-all.

**`private`, `protected` and `const` fields.** UnrealScript access modifiers exist only at compile time.
The build compiles against an [SDK overlay](adding-an-editor.md#sdk-overlay) that relaxes the few this mod writes, so `X2Effect_Solace.DamageTypeImmunities`, `X2Effect_BondmateAimAdjust`'s three bonuses and the like have ordinary editors.
What the overlay cannot fix is a `default.` read.
