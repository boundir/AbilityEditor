# Config syntax

At game start (`OnPostTemplatesCreated`), the mod reads every `+AbilityEdits=(...)` entry from the
`[AbilityEditor.X2DLCInfo_AbilityEditor]` section of `XComAbilityEditor.ini`, finds the ability
template named by `Ability`, and applies your edits to it.

## Anatomy of an entry

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+AbilityEdits=( \\
    Ability=CombatProtocol, \\
    Effects=( \\
        ( \\
            Class="X2Effect_ApplyWeaponDamage", \\
            Slot=eAES_Target, \\
            Mode=eAEM_Merge, \\
            WeaponDamageValue=(SetDamage=true, Damage=3) \\
        ) \\
    ) \\
)
```

`Ability` is the only required key. Everything else is optional, and anything you leave out keeps
its current value.

## Line continuation

End each line of a multi-line entry with ` \\` - a space followed by **two** backslash characters.
Nothing may follow it on the line. *The space is optional and only contributes to style points*

A broken continuation doesn't always error.

## `Set` + value pairs

Most fields come as a pair: a `SetX=true` switch and the `X=value` itself. **A value without its
`Set` switch is ignored.**

```ini
SetNumTurns=true, NumTurns=5    ; applied
NumTurns=5                      ; silently ignored
```

This is how the mod distinguishes "you asked for 0" from "you didn't ask". `0`, `false` and `""`
are all legitimate values, so absence cannot be inferred from the value alone.

Forgetting the guard produces no warning. If an edit seems inert, check for a missing `Set` first.

## Arrays and modes

Array-shaped fields take a companion `...Mode` that says how your list combines with the existing
one.

```ini
AdditionalAbilities=(Blademaster, Bladestorm), \\
AdditionalAbilitiesMode=eNAEM_Merge
```

Omitting the mode is *not* neutral - see [Edit modes](edit-modes.md). Every mode enum's default is
a Replace.

## Naming a `Class`

Class names without a package prefix are assumed to be base game, so
`X2AbilityCost_ActionPoints` resolves to `XComGame.X2AbilityCost_ActionPoints`. To target another
mod's class, qualify it:

```ini
Class="MyModPackage.X2AbilityCost_Custom"
```

An unresolvable class is logged and that block is skipped; the rest of the entry still applies.

For each `Class` the mod picks the most specific editor it has (the family pages list the
[dispatch order](../reference/index.md)). A class with no dedicated editor still gets its family's
shared fields.

## Quoting

| Kind | Written as | Example |
|---|---|---|
| `string` | double-quoted | `Class="X2Effect_Persistent"` |
| `name` | bare, unquoted | `Ability=SwordSlice` |
| `bool` | bare | `SetNumPoints=true` |
| `float` | with a decimal point | `ConeLength=28.0` |
| `array<name>` | parenthesised, comma-separated, unquoted | `DoNotConsumeAllSoldierAbilities=(Blademaster)` |
| array of structs | outer parenthesis, inner parenthesis per element | `Costs=( ( ... ), ( ... ) )` |

## Edit in place vs replace

Everything edits existing objects **in place** where it can.

For the single-object slots - `Cooldown`, `Charges`, `ToHitCalc`, `ToHitOwnerOnMissCalc`,
`TargetStyle`, `MultiTargetStyle` - the presence of `Class` changes what the block means:

| `Class` | Behaviour |
|---|---|
| omitted | Edit whatever object is there. **No-op if the ability has none**, silently. |
| set, matches the existing class | Edit in place. |
| set, differs from the existing class | **Replace** with a fresh instance - every field you did not `Set` reverts to that class's defaults, not the ability's old values. |

That last row is worth re-reading before swapping a class: unset fields do not carry over.

For the array families (`Costs`, `Effects`, `Triggers`, the condition arrays), entries are matched
by **exact class equality**, not by inheritance. You cannot target the second
`X2Effect_ApplyWeaponDamage` on an ability, and naming a *subclass* of what the ability actually
has will add a new object rather than edit the existing one.

## Where conditions can go

`ConditionEdit` blocks are accepted in seven places - three on the entry itself, four inside an
`Effects` entry:

| Location | Slot |
|---|---|
| `+AbilityEdits` | `ShooterConditions` |
| `+AbilityEdits` | `TargetConditions` |
| `+AbilityEdits` | `MultiTargetConditions` |
| `Effects` entry | `TargetConditions` |
| `Effects` entry | `ApplyDamageModConditions` *(only on `X2Effect_ConditionalDamageModifier`)* |
| `Effects` entry | `LethalDamageConditions` *(only on `X2Effect_LethalWeaponDamage`)* |
| `Effects` entry | `ToHitConditions` *(only on `X2Effect_ToHitModifier`)* |

It is the same block in all seven - see [Conditions](../reference/conditions/index.md).
