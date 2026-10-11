# CustomSrc

Copies of SDK classes with one access modifier relaxed, so that editors can write fields the
game declares `private`, `protected` or `const`. `build.ps1` registers this folder with
`IncludeSrc`; the build mirrors `Development\SrcOrig` to `Development\Src` and then copies these
files over it, so the SDK's own sources are never modified and nothing needs reverting.

UnrealScript access modifiers exist only at compile time. The compiled package binds fields by
name and writes them by offset, and relaxing a modifier changes neither, so the `.u` this produces
runs against the stock game. Players do not need anything from here.

Rules for adding a file:

- Copy it verbatim from the SDK's `Development\SrcOrig\<Package>\Classes`, keeping line endings, into `CustomSrc\<Package>\Classes`. `SrcOrig` must be the unmodified game sources: Ability Editor builds against a vanilla SDK, which is what keeps it free of the Community Highlander. A Highlander field belongs in the `AbilityEditorHighlander` bridge, which carries the Highlander classes it needs in its own overlay.
- Change only the modifier on the fields an editor writes. Leave everything else alone, including other non-public fields in the same class.
- Add it to the table below.

| File | Field(s) | Was | Now | Copied from SrcOrig |
|---|---|---|---|---|
| `XComGame\Classes\X2Effect_Solace.uc` | `DamageTypeImmunities` | `private` | public | 2026-09-26 |
| `XComGame\Classes\X2Effect_CombatStims.uc` | `DamageTypeImmunities` | `private` | public | 2026-09-26 |
| `XComGame\Classes\X2Effect_ChryssalidBurrowedAttack.uc` | `NumActions` | `private` | public | 2026-09-26 |
| `XComGame\Classes\X2Effect_BondmateAimAdjust.uc` | `ThreatenedBondmateAimBonus`, `BondmateTargetAimBonus`, `BondmateTargetCritBonus` | `protected const config` | `config` | 2026-09-26 |
| `XComGame\Classes\X2Effect_BondmateBleedout.uc` | `BleedoutDurationAdjustment` | `protected const config` | `config` | 2026-09-26 |
| `XComGame\Classes\X2Effect_MimicBeacon.uc` | `ABILITIES_ALLOWED_TO_HIT` | `private config` | `config` | 2026-09-26 |
| `XComGame\Classes\X2AbilityTemplate.uc` | `AbilityTargetEffects`, `AbilityMultiTargetEffects`, `AbilityShooterEffects` | `editinlineuse protectedwrite` | `editinlineuse` | 2026-10-12 |
