# Changelog

All notable changes to **Ability Editor** are documented here. The mod lets you retune
XCOM 2 (War of the Chosen) abilities entirely from `.ini` config - no scripting, no
rebuilds. See the [README](README.md) for the full field reference.

This project follows [Keep a Changelog](https://keepachangelog.com/) and
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- **Abilities can be created from config.** `Create=true` on an `+AbilityEdits` entry makes the ability instead of finding it, then applies the rest of the entry to it. Start from a copy of an existing ability with `CloneFrom` - the copy is independent, so editing it never changes the original - or from a blank template shaped by `Preset` (`eACP_Standard`, `eACP_MoveEnd` or `eACP_Passive`).
  The log explains anything the game's validation would reject.

  ```ini
  ; Slash, but for two action points and under another name
  +AbilityEdits=( \\
      Ability=SwordSlice_Heavy, Create=true, CloneFrom=SwordSlice, \\
      SetFriendlyName=true, FriendlyName="Heavy Slash", \\
      CostMode=eACEM_Merge, \\
      Costs=( ( Class="X2AbilityCost_ActionPoints", Mode=eACEM_Merge, SetNumPoints=true, NumPoints=2 ) ) \\
  )
  ```

  Granting it to units is left to mods made for that, such as Repurpose Abilities, Weapon Skin Replacer or Template Master; they only need to run after Ability Editor. See [Create an ability](docs/guides/create-an-ability.md).

- **Thirteen more template fields**: the display text (`FriendlyName`, `LongDescription`, `HelpText`, `FlyOverText`), `TargetingMethod`, `CinescriptCameraType`, `AbilityConfirmSound`, `ActivationSpeech`, `CustomFireAnim`, `SkipFireAction`, `ShowActivation`, `SkipMoveStop` and `FrameEvenWhenUnitIsHidden`.
  They apply to existing abilities too, so an ability can be renamed from config.

- **Damage-over-time effects can now be retuned.** A persistent effect is only the *state*;
  what it does each turn lives in a child effect inside its `ApplyOnTick` list. 
  Editing `X2Effect_Burning` reached its duration but never its damage, which sits in a nested `X2Effect_ApplyWeaponDamage`.
  Three new `EffectEdit` keys — `ApplyOnTickClass`, `ApplyOnTickIndex` and `ApplyOnTickMode` - redirect an entry at that child, so the rest of the entry edits it instead.

  ```ini
  ; Molotov burn ticks for 5 (+/-2) instead of its usual damage
  +AbilityEdits=( \\
      Ability=ThrowMolotov, \\
      Effects=( \\
          ( Class="X2Effect_Burning", Mode=eAEM_Merge, \\
            ApplyOnTickClass="X2Effect_ApplyWeaponDamage", ApplyOnTickMode=eAEM_Merge, \\
            WeaponDamageValue=(SetDamage=true, Damage=5, SetSpread=true, Spread=2) ) \\
      ) \\
  )
  ```

  This is not specific to burning. It reaches every vanilla effect that uses the pattern -
  poisoned, bleeding, parthenogenic poison, Steady Hands, Void Conduit, the evac delay and
  Alert Mechanics - and modded ones too.

- **A documentation site** at [boundir.github.io/AbilityEditor](https://boundir.github.io/AbilityEditor/),
  built with mkdocs-material and published by GitHub Actions. Game classes haves their own page
  with a guessable URL (`/reference/effects/x2effect_achilles/`), so a link can point at one class instead of one page documentation.

- **A config builder** at [boundir.github.io/AbilityEditor/app](https://boundir.github.io/AbilityEditor/app/).
  Pick an ability, tick the fields, get the `+AbilityEdits` entry - with the mode-default and missing-`Set` mistakes flagged before the game silently ignores them. Paste an existing entry in to check it.

- **Fifteen more effect editors and one condition editor.** `X2Effect_ApplyAcidToWorld`,
  `ApplyPoisonToWorld`, `ApplySmokeToWorld`, `ApplySmokeGrenadeToWorld` (particle systems);
  `Fortress`, `DeadeyeDamage`, `AlertTheLost`; `Solace`, `CombatStims`,
  `ChryssalidBurrowedAttack`, `BondmateAimAdjust`, `BondmateBleedout`, `MimicBeacon`;
  `ModifyStatCheckSuccesses`, `TemplarFocus`, `GrantActionPointsWithRecord`,
  `OverrideDeathAction`; and `X2Condition_GameTime`. Struct-array fields such as
  `TemplarFocus.FocusLevels` take the game's own structs:

  ```ini
  ; Templars start at +1 Mobility on focus level 0
  +AbilityEdits=( \\
      Ability=TemplarFocus, \\
      Effects=( \\
          ( Class="X2Effect_TemplarFocus", Mode=eAEM_Merge, FocusLevelsMode=eNAEM_Merge, \\
            FocusLevels=( (StatChanges=((StatType=eStat_Mobility, StatAmount=1.0)), ArmorMitigation=0, WeaponDamage=0) ) ) \\
      ) \\
  )
  ```

- **Every config key now has a description** on the reference pages and in `docs/schema.json`.

### Changed

- Fields renaming:
  `AcidParticleSystem1Tile` … `AcidParticleSystem4TilesReverseS`, `PoisonParticleSystem`, `SmokeParticleSystem`, and `OverrideParticleSystem` in place of `OverrideParticleSystemFill_Name`.

### Removed

- Five effect fields that never did anything, because the game reads them from the class default rather than the ability: `ReaperActivatedName`, `ReaperKillName` (`X2Effect_Reaper`), `LookAtDuration` (`X2Effect_ScanningProtocol`), `ParthenogenicPoisonType` and `ParthenogenicPoisonCocoonSpawnedName`.
  The Reaper and ScanningProtocol editors went with them; both classes still take the shared persistent-effect fields.

### Fixed

- **Replace-only array fields no longer advertise a mode field that doesn't exist.** The reference
  tables listed `HitModifiersMode` and `EffectHitModifiersMode` in the "Requires" column for
  `ToHitCalcEdit.HitModifiers` and `EffectEdit.EffectHitModifiers`. Neither field exists - both
  arrays are replace-only - so anyone who wrote them was silently ignored. They now render as
  "non-empty *(replace-only)*". This affected 11 entries in `docs/schema.json` too, so any tooling
  consuming the schema inherited the same wrong information.

### Added

- Ability template fields in `docs/schema.json` now carry `type` and `description`. Previously all
  46 had neither, and consumers had to join against the `AbilityEdit` struct to recover the type.
- `generate-docs.ps1 -PrintSourceHash` prints the hash of the UnrealScript sources and exits. It
  needs no SDK, so CI can compare it against `sourceHash` in the committed schema to catch a
  forgotten regeneration.

### Documentation

- Corrected the field-documentation convention: a `//` comment must sit directly above the **value** var, not above the `Set`/value pair.
  A comment above the pair attaches to the guard and is dropped, which is why 219 existing comments act as section headers rather than field docs.
- A [Why isn't this editable?](docs/contributing/coverage-triage.md) page records the game fields that do not have an editor and the reason for each - mostly fields the game reads from the class default, which are tunable globally in the game's own ini.

## [2.0.0] - 2026-07-10

A ground-up rewrite. The old options still work, but there's now a single, consistent
`+AbilityEdits` config that can reach almost every part of an ability.

### Added

- **New unified config API.** Edit any ability by adding an `+AbilityEdits=(...)` entry
  under `[AbilityEditor.X2DLCInfo_AbilityEditor]` in `XComAbilityEditor.ini`. One entry can
  change as much or as little of an ability as you like.

- **Costs** - action points, ammo, charges, focus, "consume item", and the special
  reserve/heavy-weapon/quickdraw action-point costs. Add, remove, or tweak them per ability.
  ```ini
  ; Let Ranger's Slash keep the turn going (1 point, don't end turn) for Blademaster users
  +AbilityEdits=( \\
      Ability=SwordSlice, \\
      Costs=( \\
          ( Class="X2AbilityCost_ActionPoints", SetNumPoints=true, NumPoints=1, \\
            SetConsumeAllPoints=true, ConsumeAllPoints=false ) \\
      ) \\
  )
  ```

- **Cooldowns & charges** - set turn cooldowns (including separate XCOM/AI values and
  shared cooldowns with other abilities), initial charges, and bonus charges granted by
  other abilities.

- **Effects** - change what an ability actually *does*: weapon damage, stat changes,
  stuns, armor, damage immunities, action-point grants, effect removal, covering fire,
  and dozens more. Every applicable in-game effect type is supported.

- **Conditions** - control *who and when* an ability can affect: unit type, health,
  cover, range, alert status, active effects, inventory, visibility, and more. Attach
  them to the ability or to an individual effect.
  ```ini
  ; Make Combat Protocol only target robotic units
  +AbilityEdits=( \\
      Ability=CombatProtocol, \\
      TargetConditions=( \\
          ( Class="X2Condition_UnitProperty", Mode=eAEM_Merge, \\
            SetExcludeOrganic=true, ExcludeOrganic=true ) \\
      ) \\
  )
  ```

- **Aim & hit chance** - edit an ability's to-hit calculation: built-in aim/crit
  modifiers, guaranteed hits, flat percent-to-hit, stat rolls, and more.

- **Targeting shape** - change how an ability picks targets: single-target rules, cursor
  range, moving-melee reach, and area shapes (radius, cone, line, cylinder, burst, all-units).

- **Triggers** - change what makes an ability fire (e.g. passive on spawn, event-driven).

- **Ability template settings** - hostility, concealment rules, cross-class eligibility,
  passive/unique flags, HUD icon and color, tooltip/summary visibility, point cost, default
  item slot, friendly-fire warnings, added/prerequisite/override abilities, and more.

- **Flexible list editing.** Wherever an ability has a list (costs, effects, conditions,
  damage types, ability names…), you choose how your entry combines with what's already
  there: **replace all**, **merge**, **add-only**, or **remove**.

- **Documentation.** A complete, always-up-to-date field reference in the
  [README](README.md), generated directly from the mod's code, plus a machine-readable
  `docs/schema.json` for tooling.

### Changed

- **Edit in place by default.** Ability Editor now changes only the fields you set and
  leaves everything else intact. For the single-object slots (cooldown, charges, to-hit,
  targeting), omit `Class` to tweak whatever the ability already uses, or set `Class` to
  swap in a different one.
- The legacy options are unchanged and continue to work (see below), so existing configs
  keep functioning.

### Fixed

- Removing an ability's charges now works correctly.
- Stat-change and duration effects (e.g. Persistent-based effects) now apply all of their
  settings as expected.
- Per-player-type cooldowns (separate XCOM/AI turns) now apply correctly.

### For mod authors

- **Extensible by other mods.** Bridge mods can register their own editor classes to
  support abilities from DLC or other mods, without Ability Editor needing to know about
  them. Add your editor class via `+ExtraEffectsEditors=(EditorClass="...", Priority=N)`
  (and the equivalents for costs, cooldowns, charges, conditions, to-hit, targeting, and
  triggers). Details in the README's "Extending Ability Editor" section.

### Notes

- After changing config, clear the game's config cache (delete
  `Documents\My Games\XCOM2 War of the Chosen\XComGame\Config`) so your edits are picked up.
- Turn on `EnableDebug=true` under `[AbilityEditor.X2DLCInfo_AbilityEditor]` to log every
  change the mod makes to `Launch.log` (tag `AbilityEditor`).

## [1.x] - Earlier releases

The original configuration lived under `[AbilityEditor.OPTC_Abilities]` and supported a
fixed set of per-ability tweaks: ammo cost, cooldown, action-point cost, ends-turn/free-action,
consume-item, charges (and keep-on-miss), shared charges/cooldowns, added/prerequisite/override
abilities, bonus charges, focus cost options, item slot, concealment rule, and cross-class
eligibility. These options still work in 2.0.
