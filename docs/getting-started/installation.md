# Installation

## Get the mod

Subscribe on the Steam Workshop, or drop the mod folder into your
`XCOM 2/XCom2-WarOfTheChosen/Mods/` directory and enable it in the launcher.

Ability Editor has no dependencies for players. It does not replace any game class, so it coexists
with overhaul mods - though what it can reach depends on load order when another mod rewrites the
same templates. See [Troubleshooting](../guides/troubleshooting.md#load-order).

## Where your config goes

Edits live under the `[AbilityEditor.X2DLCInfo_AbilityEditor]` section of `XComAbilityEditor.ini`.

You have two reasonable places to put them:

**In Ability Editor's own config** - fine for personal tweaks, but a Workshop update can overwrite it:

```
.../Mods/AbilityEditor/Config/XComAbilityEditor.ini
```

**In your own mod** - the right home for anything you want to keep or share. Create a tiny mod with
just a `Config/XComAbilityEditor.ini` containing the same section header and your `+AbilityEdits`
entries. The `+` prefix appends to Ability Editor's list rather than replacing it, so several mods
can contribute edits at once.

## Check it is working

Turn on logging - in `XComEngine.ini`, under the same section:

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
EnableDebug=true
```

Every applied change is then written to `Launch.log` under the `AbilityEditor` tag, as:

```
<Ability> <Field> changed from <old> to <new>
```

Unresolvable ability names and class names are reported there too. If a field you expected is
absent from the log, it was never applied - start with
[Troubleshooting](../guides/troubleshooting.md).

## Next

- [Config syntax](config-syntax.md) - how an entry is structured.
- [Examples](../guides/examples.md) - worked entries you can paste and adapt.
