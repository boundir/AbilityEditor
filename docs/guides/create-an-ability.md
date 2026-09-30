# Create an ability

An `+AbilityEdits` entry with `Create=true` makes the ability instead of finding it. The new template is registered with the game before any entry is applied, so everything else on the page works on it exactly as it does on an existing ability: costs, effects, conditions, triggers, template fields.

There are two starting points:

| | Starts as | Best for |
|---|---|---|
| `CloneFrom=<existing ability>` | a deep copy of that ability | a variant of something that already works: another cost, another name, one more effect |
| nothing (blank) | an empty template shaped by `Preset` | something the game has no equivalent of |

A copy is independent. Its costs, cooldown, charges, effects (down to their `ApplyOnTick` and condition lists), conditions, triggers and styles are all copied, not shared, so editing the copy never changes the original.

The game validates every template after the mods have run. An ability without a target style, a trigger or a game-state function gets a RedScreen and is not usable. The mod checks the same things first and writes what is missing to the log, in plain words, next to the entry that caused it - see [Reading the log](#reading-the-log).

## A copy: Slash for two action points

```ini
+AbilityEdits=( \\
    Ability=SwordSlice_Heavy, \\
    Create=true, \\
    CloneFrom=SwordSlice, \\
    SetFriendlyName=true, \\
    FriendlyName="Heavy Slash", \\
    CostMode=eACEM_Merge, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_ActionPoints", \\
            Mode=eACEM_Merge, \\
            SetNumPoints=true, \\
            NumPoints=2 \\
        ) \\
    ) \\
)
```

`SwordSlice` keeps costing one point. `CostMode=eACEM_Merge` matters here just as it does on an edit: the copy arrived with Slash's cost list, and the default mode would wipe it.

## A blank passive: +2 Mobility

`Preset=eACP_Passive` builds what every passive needs - a self target style, a `UnitPostBeginPlay` trigger, a DeadEye to-hit calc, no visualization, hidden from the shot HUD - so the entry only has to add the persistent effect that does the work.

```ini
+AbilityEdits=( \\
    Ability=IronLegs, \\
    Create=true, \\
    Preset=eACP_Passive, \\
    SetIconImage=true, \\
    IconImage="img:///UILibrary_PerkIcons.UIPerk_hunkerdown", \\
    SetFriendlyName=true, \\
    FriendlyName="Iron Legs", \\
    Effects=( \\
        ( \\
            Class="X2Effect_PersistentStatChange", \\
            Slot=eAES_Target, \\
            Mode=eAEM_Merge, \\
            SetEffectName=true, \\
            EffectName=IronLegs, \\
            SetInfiniteDuration=true, \\
            InfiniteDuration=true, \\
            SetDisplayInUI=true, \\
            DisplayInUI=true, \\
            SetFriendlyName=true, \\
            FriendlyName="Iron Legs", \\
            SetIconImage=true, \\
            IconImage="img:///UILibrary_PerkIcons.UIPerk_hunkerdown", \\
            StatChangeMode=eSCM_Replace, \\
            StatChange=( \\
                (SetStatType=true, StatType=eStat_Mobility, SetStatAmount=true, StatAmount=2.0) \\
            ) \\
        ) \\
    ) \\
)
```

## A blank active ability: a one-point shot

`Preset=eACP_Standard` only sets the game-state and visualization functions. Everything a shot is made of has to be named: the target style, the to-hit calc, at least one trigger, a cost, the damage effect, and the conditions that keep it from targeting allies or the dead.

```ini
+AbilityEdits=( \\
    Ability=SnapShot, \\
    Create=true, \\
    Preset=eACP_Standard, \\
    SetIconImage=true, \\
    IconImage="img:///UILibrary_PerkIcons.UIPerk_snapshot", \\
    SetAbilityIconBehaviorHUD=true, \\
    AbilityIconBehaviorHUD=eAbilityIconBehavior_AlwaysShow, \\
    SetDefaultSourceItemSlot=true, \\
    DefaultSourceItemSlot=eInvSlot_PrimaryWeapon, \\
    SetTargetingMethod=true, \\
    TargetingMethod="XComGame.X2TargetingMethod_OverTheShoulder", \\
    SetCinescriptCameraType=true, \\
    CinescriptCameraType="StandardGunFiring", \\
    SetFriendlyName=true, \\
    FriendlyName="Snap Shot", \\
    ToHitCalc=(Class="X2AbilityToHitCalc_StandardAim"), \\
    TargetStyle=(Class="X2AbilityTarget_Single"), \\
    Triggers=( \\
        (Class="X2AbilityTrigger_PlayerInput", Mode=eAEM_Merge) \\
    ), \\
    CostMode=eACEM_Merge, \\
    Costs=( \\
        (Class="X2AbilityCost_ActionPoints", Mode=eACEM_Merge, SetNumPoints=true, NumPoints=1, SetConsumeAllPoints=true, ConsumeAllPoints=true), \\
        (Class="X2AbilityCost_Ammo", Mode=eACEM_Merge, SetNumAmmo=true, NumAmmo=1) \\
    ), \\
    ShooterConditions=( \\
        (Class="X2Condition_UnitProperty", Mode=eAEM_Merge, SetExcludeDead=true, ExcludeDead=true) \\
    ), \\
    TargetConditions=( \\
        (Class="X2Condition_UnitProperty", Mode=eAEM_Merge, SetExcludeFriendlyToSource=true, ExcludeFriendlyToSource=true), \\
        (Class="X2Condition_Visibility", Mode=eAEM_Merge, SetRequireGameplayVisible=true, RequireGameplayVisible=true, SetAllowSquadsight=true, AllowSquadsight=true) \\
    ), \\
    Effects=( \\
        (Class="X2Effect_ApplyWeaponDamage", Slot=eAES_Target, Mode=eAEM_Merge) \\
    ) \\
)
```

`TargetStyle`, `ToHitCalc` and `Triggers` are not optional here. Leave one out and the log says which. `Preset=eACP_MoveEnd` is the same recipe for a move-then-strike ability; give it an `X2AbilityTarget_MovingMelee` target style.

## Getting it onto a unit

Creating the template is where this mod stops. Which units get the ability, and how, is a separate decision with mods built for it - Repurpose Abilities puts abilities on classes, items and characters from config, and others do the same. Whatever grants it only needs Ability Editor to have run first, so that the template exists when it is looked up. With the Community Highlander the granting mod declares that in its own `XComGame.ini`, under its DLC identifier:

```ini
[RepurposeAbilities CHDLCRunOrder]
+RunAfter=AbilityEditor
```

If you would rather stay in this file, `AdditionalAbilities` on an ability the unit already has grants the new one alongside it:

```ini
+AbilityEdits=( \
    Ability=SwordSlice, \
    AdditionalAbilitiesMode=eNAEM_Merge, \
    AdditionalAbilities=(SwordSlice_Heavy) \
)
```

## Naming it

`FriendlyName`, `LongDescription`, `HelpText` and `FlyOverText` set the text from the entry.
They are short-text fields: the ini dialect cannot carry quotes, commas or parentheses.

For prose, or for translations, give your mod a `Localization\XComGame.int` (UTF-16 LE; one file
per language - `XComGame.fra`, `XComGame.deu` and so on) with a section named after the ability.
This is how the game's own abilities are named and how any mod renames one, and it works for a
created ability the same way, because the template takes the ability name as its object name.
The four config fields above are applied after the `.int` is read, so a value set there wins in
every language: use them for a quick rename, the `.int` for anything translated.

```ini
[SwordSlice_Heavy X2AbilityTemplate]
LocFriendlyName="Heavy Slash"
LocLongDescription="Slash for two action points."
LocHelpText="Slash for two action points."
LocFlyOverText="Heavy Slash"
```

Without either, a blank ability shows no name and a copy shows its source's.

## Reading the log

With `EnableDebug=true`, creation writes one line per ability before the edit lines:

```
AbilityEdit: created SwordSlice_Heavy as a copy of SwordSlice
AbilityEdit: created blank ability IronLegs with preset eACP_Passive
AbilityEdit: IronLegs preset eACP_Passive set ToHitCalc to X2AbilityToHitCalc_DeadEye, TargetStyle to X2AbilityTarget_Self and added an X2AbilityTrigger_UnitPostBeginPlay trigger
```

Then the usual `changed from ... to ...` lines for every field the entry set. And, only when something is wrong:

| Line | Meaning |
|---|---|
| `Create=true but <name> already exists, applying the entry as an edit` | An ability of that name was already there (the game's, or another mod's). Nothing was created; the entry edited it. |
| `CloneFrom source not found: <src> - not creating <name>` | Nothing was created, so the entry then also logs `Ability not found`. |
| `<name> has no TargetStyle; the game will RedScreen it at validation. Add ...` | Also for `Triggers`, a player-input trigger with no visualization, and `AdditionalAbilities` / `OverrideAbilities` that name nothing. The RedScreen that follows is that. |
| `<name> has no ToHitCalc; activating it will fail` | Not a validation failure, but the ability breaks when used. |
| `<name> will fail the game's validation: <text>` | The game's own message for the same problem. |

Entries can be in any order: every ability is created first, then every entry is applied, so a created ability can list another created ability in `AdditionalAbilities`. The one thing that runs before creation is the legacy `[AbilityEditor.OPTC_Abilities]` config, which therefore cannot see created abilities.
