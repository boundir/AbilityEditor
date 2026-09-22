# Ability Editor

An XCOM 2: War of the Chosen mod that changes how existing abilities work **purely from config**.
Costs, cooldowns, charges, effects, conditions and template fields of any
ability (base game, DLC or another mod's) can be edited by adding `+AbilityEdits` entries to an
`.ini` file.

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

## Start here

<div class="grid cards" markdown>

- **[Install](getting-started/installation.md)** - get the mod running and find your config file.
- **[Config syntax](getting-started/config-syntax.md)** - how an entry is put together, and the
  `Set` guard rule that trips up everyone once.
- **[Edit modes](getting-started/edit-modes.md)** - what the `Mode` fields do, and why leaving one
  out can wipe an ability's costs.
- **[Reference](reference/index.md)** - every field, for every class, across the nine families.

</div>

## What you can edit

Nine families of ability internals, plus the template's own fields:

| Family | Config key | What it controls |
|---|---|---|
| [Costs](reference/costs/index.md) | `Costs` | Action points, ammo, charges, focus, consumed items |
| [Cooldown](reference/cooldown/index.md) | `Cooldown` | Turn cooldowns, per-player-type and shared cooldowns |
| [Charges](reference/charges/index.md) | `Charges` | Initial charges and bonus charges from other abilities |
| [Effects](reference/effects/index.md) | `Effects` | What the ability actually *does* - damage, stats, stuns, armor |
| [Conditions](reference/conditions/index.md) | *(seven slots)* | Who and when the ability can affect |
| [ToHitCalc](reference/tohitcalc/index.md) | `ToHitCalc` | Aim, crit, guaranteed hits, stat rolls |
| [TargetStyle](reference/targetstyle/index.md) | `TargetStyle` | How the primary target is picked |
| [MultiTargetStyle](reference/multitargetstyle/index.md) | `MultiTargetStyle` | Area shapes - radius, cone, line, cylinder |
| [Triggers](reference/triggers/index.md) | `Triggers` | What causes the ability to fire |

!!! tip "For tool authors"
    The whole config API is published as machine-readable
    [`schema.json`](schema.json) - 

## Troubleshooting

The mod does not validate your config. A misspelled field name is silently ignored by the game's
`.ini` parser with no log line at all, and several `Mode` fields default to *replace*. If something
isn't working, [Troubleshooting](guides/troubleshooting.md) covers the failure modes in the order
they actually occur.
