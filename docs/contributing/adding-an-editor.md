# Adding an editor

This page is for people working on Ability Editor itself. To extend it *from another mod* without
forking, see [Bridge mods](../guides/bridge-mods.md) instead.

## Build prerequisites

UnrealScript access modifiers (`private`, `protected`, `privatewrite`, `const`) exist only at
compile time. Compiling against relaxed sources runs against the stock game.
This mod relies on that twice. Neither is a requirement for players.

### Community Highlander sources

`X2AbilityEffectsEditor_Helper.uc` writes `Template.AbilityTargetEffects`,
`AbilityMultiTargetEffects` and `AbilityShooterEffects`. In stock Firaxis sources those three are
`protectedwrite`, so the writes will not compile. Community Highlander
[Issue #68](https://github.com/X2CommunityCore/X2WOTCCommunityHighlander/issues/68) removes that
modifier; `Development/SrcOrig` must be the Highlander-patched copy.

If a build fails with `Can't write to protected variable` on `AbilityTargetEffects`, your SDK
sources are stock: deploy the Highlander into the SDK.

### Relaxing fields

A few game fields are `private` or `protected const` and have no setter. Rather than patching the
SDK by hand before every build, `SdkOverlay/XComGame/Classes/` holds verbatim copies of those
classes with only the modifier relaxed, and `build.ps1` from `X2ModBuildCommon` registers the folder with IncludeSrc`.

To write such a field from a new editor: copy the class from `Development/SrcOrig` into the
overlay, change only the modifier on the field you write, add a row to `SdkOverlay/README.md`, and
write the editor as usual. If a Highlander release changes one of those classes, refresh the copy.

The overlay cannot help with a field the game reads as `default.X` - see
[Why isn't this editable?](coverage-triage.md).

## The four places

Adding support for a game class means touching four things. Three of them fail *silently* if
forgotten - no compile error, just an edit that does nothing or a field missing from these docs.

### 1. The editor class

`AbilityEditor/Src/AbilityEditor/Classes/X2Ability<Family>Editor_<Name>.uc`

```unrealscript
class X2AbilityEffectsEditor_Achilles extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
    return Effect.IsA('X2Effect_Achilles');
}

static function ApplyDerivedEdit(
    name AbilityName,
    string Slot,
    X2Effect Effect,
    EffectEdit EffectEdit
)
{
    local X2Effect_Achilles AchillesFX;

    super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

    AchillesFX = X2Effect_Achilles(Effect);

    if (AchillesFX == none)
    {
        return;
    }

    if (EffectEdit.SetToHitMin)
    {
        class'X2AbilityEditor_Logger'.static.LogInfo(
            AbilityName,
            Slot $ ".ToHitMin",
            string(AchillesFX.ToHitMin),
            string(EffectEdit.ToHitMin)
        );

        AchillesFX.ToHitMin = EffectEdit.ToHitMin;
    }
}
```

Four things carry weight:

- **Extend the editor of the game class's nearest ancestor.** The editor hierarchy mirrors the
  game inheritance.
- **`CanEdit` names exactly one game class** via `IsA`. The doc generator reads that string; a
  `CanEdit` that checks two classes, or uses something other than `IsA`, makes the editor invisible
  to these pages.
- **`super.ApplyDerivedEdit(...)` first**, whenever the parent is not the family root.
- **One `if (Edit.SetX)` block per field**, logging before assigning.

### 2. The config struct

Add the pair to the family's struct in `AE_DataStructures.uc`:

```unrealscript
var bool SetToHitMin;
// Minimum to-hit chance this effect will allow, as a percentage.
var int ToHitMin;
```

!!! important "Where the `//` comment goes"
    Put the description **directly above the value var, not above the `Set` guard**. The parser
    attaches a comment to the next `var` it sees, and guards are not documented fields - so a
    comment above the pair is dropped.

    Comments above a guard are therefore free to act as section headers (`// X2Condition_UnitValue`).

Because inheritance is flattened in the schema, **one comment can document dozens of rendered
rows**. See [Documentation coverage](doc-coverage.md) for which keys are worth writing next.

### 3. The registry - the step that silently breaks things

Add the class to `defaultproperties` in `X2DLCInfo_AbilityEditor.uc`.

Dispatch is **first match wins**, scanning in index order. Because `CanEdit` uses `IsA` - true for
subclasses too - an editor registered *after* one of its game-class ancestors never runs. The
ancestor claims the object first.

**Every editor must appear before the editor of any game class it derives from.** The family's
`_Base` catch-all returns `true` unconditionally and is always last.

Nothing enforces this at compile time. The generator detects it, but only with `-SdkPath`.

### 4. Regenerate

```powershell
.\.scripts\generate-docs.ps1 -SdkPath '<path to WOTC SDK>'
```

Read the warnings as text, not just the exit code:

- **`Orphan config field: <Struct>.<Field>`** - you added the struct field but the editor doesn't
  read it, or reads it in a shape the parser can't see. This is the exact symptom of steps 1 and 2
  being out of sync.
- **`Dispatch order (<family>): X is registered after Y`** - step 3 is wrong.

Then confirm your field appears in `docs/schema.json`. Review that file rather than the README
diff.

## Check the field is real before promising it

Read the game class in the SDK and confirm the field exists *and* is settable. Four things
routinely aren't:

- **The field doesn't exist.** `X2Effect_Burning` sounds like it should have damage-per-tick; it
  has exactly one var, and that isn't it. Its damage lives in a nested `X2Effect_ApplyWeaponDamage`
  at `ApplyOnTick[0]`.
- **The field is read via `default.X`, not the instance.** An editor writes the template's copy,
  the game reads the class default, and nothing happens.
- **The concept isn't on the template at all** - native code, or `XComGameCore.ini` config.

## Docs pipeline

`.scripts/generate-docs.ps1` parses the UnrealScript sources into `docs/schema.json`. This site is
rendered from that file by `scripts/gen_reference.py` at build time; generated pages are never
committed.

```powershell
.\.scripts\generate-docs.ps1 -CheckOnly        # exits 1 if schema or README are stale
.\.scripts\generate-docs.ps1 -PrintSourceHash  # hash of the .uc sources; needs no SDK
```

To preview the site:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements-docs.txt
mkdocs serve
```
