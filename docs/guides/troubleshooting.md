# Troubleshooting

The mod does not validate your config. Bad entries are logged and skipped at best, and a
**misspelled field name inside a block is silently ignored by the game's `.ini` parser with no log
line at all**. So the order below matters - it goes from most to least common.

## Turn the log on first

In `XComEngine.ini`:

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
EnableDebug=true
```

Every applied change appears in `Launch.log` under the `AbilityEditor` tag:

```
SwordSlice ActionPointCost.iNumPoints changed from 2 to 1
```

**If a field you expected is not in that log, it was never applied.** That single fact resolves
most problems here.

## Nothing happened at all

1. **Did you clear the config cache?** Delete
   `Documents\My Games\XCOM2 War of the Chosen\XComGame\Config`. XCOM 2 caches config aggressively
   and will otherwise keep using the old values. This is the most common cause by a wide margin.
2. **Missing `Set` guard.** `NumPoints=1` on its own does nothing; it needs `SetNumPoints=true`
   beside it. See [Config syntax](../getting-started/config-syntax.md#set-value-pairs).
3. **Broken line continuation.** Every line but the last needs a trailing ` \\` with nothing after
   it. A broken one truncates the entry silently.
4. **Wrong ability name.** The log says `AbilityEdit: Ability not found: <name>`. Names are
   template names, not display names - the counter-attack from Bladestorm is `BladestormAttack`,
   not `Bladestorm`, and `Bladestorm` itself is a passive with no costs at all.
5. **Single-object slot with no `Class` on an ability that has none.** A `Cooldown` block without
   `Class` edits the existing cooldown; if the ability never had one, the block is a silent no-op.
   Name the `Class` to create one.

## Something changed that I didn't ask for

Almost always a mode default. **Every mode enum's first value is a Replace**, and UnrealScript uses
the first value when you omit the field.

- `Costs` listed without `CostMode` => every existing cost is wiped, keeping only what you listed.
- An `Effects`, `Triggers` or conditions entry without `Mode` => the whole target array is cleared
  first. With several entries each defaulting, *each one re-clears*, so only the last survives.
- A name array without its `...Mode` => the game's array is replaced wholesale.

See [Edit modes](../getting-started/edit-modes.md). The log records array wipes, so the debug
output will show it.

There is a second-order effect worth knowing: after a wipe, an entry you *did* list is constructed
fresh from its class, so every field you did not `Set` holds that class's defaults - not the
ability's old values.

## The field I want isn't listed anywhere

Some things genuinely cannot be edited per ability:

- **The field is `config` on the game class.** It is read from the game's own `.ini`, not from the
  template, so it is global rather than per-ability. Set it in your own mod's `XComGameCore.ini`
  instead. For example:

  ```ini
  [XComGame.X2Effect_BondmateAimAdjust]
  ThreatenedBondmateAimBonus=10
  BondmateTargetAimBonus=20
  BondmateTargetCritBonus=0

  [XComGame.X2Effect_BondmateBleedout]
  BleedoutDurationAdjustment=2
  ```

- **The field is read via the class default rather than the instance.** Editing the template's copy
  changes nothing because the game never reads it. These are listed as *not editable* on the
  relevant reference page, with the reason.

- **The behaviour lives in native code or in a different config file entirely.** Fire's
  tile-to-tile spread is one of these: it is native, and the only knob is the global
  `LimitFireSpreadTiles` in `XComGameData.ini`.

!!! warning "Inert keys in the game's own config"
    `DefaultGameCore.ini` ships `ThreatenedBondmateAimBonusOutsideZone`,
    `BondmateTargetAimBonusOutsideZone` and `BondmateTargetCritBonusOutsideZone`. **No game class
    declares any of them** - they do nothing, whatever you set. Also note
    `X2Effect_SpectralZombie` and `X2Effect_SpectralArmyUnit` have identically-named keys in
    separate sections; it is easy to edit the wrong one.

## Load order

If an edit works alone but not alongside another mod, that mod is probably rewriting the same
template after Ability Editor does. Edits are applied in
`OnPostTemplatesCreated`; a mod that runs later wins.

Ability Editor ships a commented run-order hint in `XComGame.ini`:

```ini
[AbilityEditor CHDLCRunOrder]
; +RunAfter=LWOverhaul
```

Uncomment and adapt it to force Ability Editor to run after a specific overhaul mod. This uses the
Community Highlander's run-order mechanism, so it requires the Highlander to be installed.

## I edited a class from another mod and nothing resolved

Unqualified class names are assumed to be base game - `X2Effect_Foo` becomes
`XComGame.X2Effect_Foo`. Qualify cross-mod classes with their package:

```ini
Class="MyModPackage.X2Effect_Foo"
```

The log reports `AbilityEdit: Failed to load <family> class: <name>` when a class cannot be
resolved. If the class loads but has no dedicated editor, it still accepts its family's shared
fields - and for conditions, that shared set is **empty**, so nothing but `Class` and `Mode` will
apply.
