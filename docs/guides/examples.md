# Examples

Worked entries you can paste and adapt. All of them go under
`[AbilityEditor.X2DLCInfo_AbilityEditor]` in `XComAbilityEditor.ini`.

## Rework Slash

Slash no longer ends the turn for soldiers with Blademaster, gains 5 charges, and takes a 5-turn
cooldown that also puts Blademaster on a 3-turn cooldown.

```ini
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

## Split a cooldown between XCOM and the AI

Aid Protocol on a 9-turn cooldown for the player, 1 turn for the AI.

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

Because `Class` names a *different* class than the ability's current cooldown, the cooldown object
is replaced - so every field you care about must be set explicitly.

## Add a cost without disturbing the others

Set `CostMode` away from its default and use `Mode=eACEM_AddOnly` on the entry.

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

Both modes are needed. `CostMode=eACEM_Merge` stops the wipe; the per-entry `Mode` also defaults to
`ReplaceAll`, which once the outer mode is Merge would *skip* a cost that isn't already present.

## Edit an effect and restrict its targets

Make Combat Protocol's damage effect deal 3 guaranteed damage, and restrict the ability to robotic
targets.

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

The template-level `TargetConditions` edits the existing `X2Condition_UnitProperty` **in place** if
the ability has one - changing only the fields you `Set` - and adds a new one otherwise.

## Tweak aim and targeting shape

Give an ability +15 built-in aim and widen its cone. No `Class` on either block, so both edit
whatever the ability already has.

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

Omitting `Class` means these are no-ops if the ability has no to-hit calc or multi-target style at
all - which is silent. Check the log if nothing changes.
