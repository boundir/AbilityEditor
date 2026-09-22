# The legacy 1.x config

Ability Editor 1.x used a different, flatter config format. **It still works** - 2.0 runs the old
entries before the new ones.

If you are writing something new, use [the 2.0 format](../getting-started/config-syntax.md).

## What it looked like

Section `[AbilityEditor.OPTC_Abilities]`, key `+Abilities`, one flat struct per ability:

```ini
[AbilityEditor.OPTC_Abilities]
+Abilities = (AbilityName=SwordSlice, APCost=1, EndsTurn=true, DoNotConsumeAllActionsWith[0]=Blademaster)
+Abilities = (AbilityName=ScanningProtocol, Cooldown=2, Charges=9, FreeAction=true)
+Abilities = (AbilityName=GremlinHeal, Charges=2, BonusChargeWith[0]=(BonusAbilityName=RestorativeMist, NumBonusCharges=3))
```

Fields: `AbilityName`, `ItemSlot`, `RetainConcealment`, `AmmoCost`, `Cooldown`, `APCost`,
`EndsTurn`, `FreeAction`, `ConsumeItem`, `Charges`, `KeepChargeOnMiss`,
`DoNotConsumeAllActionsWith[]`, `DoNotConsumeAllActionsUnderEffects[]`, `SharedAbilityCharges[]`,
`SharedCooldowns[]`, `bCrossClassEligible`, `AddAbility[]`, `BonusChargeWith[]`,
`OverrideAbilities[]`, `PrerequisiteAbilities[]`, `FocusAmount`, `ConsumeAllFocus`,
`GhostOnlyCost`.

## Why 2.0 replaced it

!!! danger "1.x is destructive by design"
    For every ability it lists, the 1.x code unconditionally clears the ability's costs, charges
    and cooldown before rebuilding them from your entry. It also always re-adds an action-point
    cost even when you set `APCost=0`. There is no way to change one thing and leave the rest
    alone - which is precisely what the 2.0 `Set` guards and `Mode` fields exist to make possible.

Beyond that, 1.x could only reach costs, charges, cooldowns and a handful of template flags. It had
no access to effects, conditions, to-hit calculation, targeting shape or triggers.

A few quirks worth knowing if you are reading old config:

- `bCrossClassEligible` took the *names* `TRUE`/`FALSE`, not booleans.
- `FocusAmount` was a string holding an integer.
- `ItemSlot` and `RetainConcealment` were matched against a hardcoded whitelist; an unrecognised
  value silently did nothing.

## Ordering

1.x entries are applied **first**, before any `+AbilityEdits`. So if both formats touch the same
ability, the 2.0 entry edits whatever 1.x left behind. Mixing them on one ability is possible but
confusing - pick one.

## Translating an entry

| 1.x | 2.0 |
|---|---|
| `APCost=1` | `Costs` => `X2AbilityCost_ActionPoints`, `SetNumPoints=true, NumPoints=1` |
| `EndsTurn=true` | same cost entry, `SetConsumeAllPoints=true, ConsumeAllPoints=true` |
| `FreeAction=true` | same cost entry, `SetFreeCost=true, FreeCost=true` |
| `AmmoCost=3` | `Costs` => `X2AbilityCost_Ammo`, `SetNumAmmo=true, NumAmmo=3` |
| `Cooldown=2` | `Cooldown=(Class="X2AbilityCooldown", SetNumTurns=true, NumTurns=2)` |
| `Charges=9` | `Charges=(Class="X2AbilityCharges", SetInitialCharges=true, InitialCharges=9)` |
| `DoNotConsumeAllActionsWith[0]=X` | `DoNotConsumeAllSoldierAbilities=(X)` on the action-point cost |

Remember to set `CostMode=eACEM_Merge` when translating, unless you genuinely want the 1.x
replace-everything behaviour. See [Examples](examples.md).
