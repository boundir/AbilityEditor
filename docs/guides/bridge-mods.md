# Extending Ability Editor (bridge mods)

Other mods can plug their own editor classes into Ability Editor's dispatch. This is the intended way to support game classes from a DLC package or from another mod, without Ability Editor itself depending on them: a mod whose script package imports `DLC_2` fails to load for players who do not own Alien Hunters, so those editors have to live in a mod that only they install.

The first bridge is [Ability Editor: Alien Hunters](../reference/bridges/abilityeditoralienhunters.md) (`AbilityEditorAlienHunters`). It is the worked example on this page.

## Three steps

**1. Depend on the `AbilityEditor` script package.** Your mod compiles against `AbilityEditor.u` and, at runtime, needs it loaded. Three lines:

`.scripts\build.ps1` - copy Ability Editor's sources into the SDK before compiling, and its `CustomSrc` overlay, which its own editors need:

```powershell
$builder.IncludeSrc("$srcDirectory\..\AbilityEditor\CustomSrc")
$builder.IncludeSrc("$srcDirectory\..\AbilityEditor\AbilityEditor\Src")
```

`Config\XComEngine.ini` - tell the compiler the package exists:

```ini
[UnrealEd.EditorEngine]
+ModEditPackages=AbilityEditor
```

`Config\XComGame.ini` - tell the Highlander it must be installed:

```ini
[AbilityEditorAlienHunters CHModDependency]
+RequiredMods=AbilityEditor
```

No `CHDLCRunOrder` entry is needed: registrations are config, read by Ability Editor itself.

**2. Subclass the right family editor** - the built-in editor of your game class's **nearest ancestor** - and declare which class you handle:

```unrealscript
class X2AbilityEffectsEditor_DLC_Day60Freeze extends X2AbilityEffectsEditor_PersistentStatChange;

static function bool CanEdit(X2Effect Effect)
{
    return Effect.IsA('X2Effect_DLC_Day60Freeze');
}

static function ApplyDerivedEdit(name AbilityName, string Slot, X2Effect Effect, EffectEdit EffectEdit)
{
    local X2Effect_DLC_Day60Freeze FreezeEffect;

    super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

    FreezeEffect = X2Effect_DLC_Day60Freeze(Effect);

    if (EffectEdit.SetNormalUnitFreezeDuration)
    {
        class'X2AbilityEditor_Logger'.static.LogInfo(AbilityName, Slot $ ".NORMAL_UNIT_FREEZE_DURATION",
            string(FreezeEffect.NORMAL_UNIT_FREEZE_DURATION), string(EffectEdit.NormalUnitFreezeDuration));
        FreezeEffect.NORMAL_UNIT_FREEZE_DURATION = EffectEdit.NormalUnitFreezeDuration;
    }
}
```

Call `super.ApplyDerivedEdit` first - that is what gets the inherited fields applied. Name the editor after the game class, and keep to the shapes in [Adding an editor](../contributing/adding-an-editor.md): one `if (Edit.SetX)` block per field, `ApplyNameArrayEdit` for name arrays, `CanEdit` with a single `IsA`.

!!! warning "Signatures differ by family"
    Six families pass a `Slot` string. **Cost, Cooldown and Charges do not** - their signature is
    `(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)` and they build the log path
    from a literal instead.

**3. Register it from your own mod's `Config\XComAbilityEditor.ini`:**

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+ExtraEffectsEditors=(EditorClass="AbilityEditorAlienHunters.X2AbilityEffectsEditor_DLC_Day60Freeze", Priority=10)
```

An `Extra<Family>Editors` array exists for all nine families - `ExtraCostEditors`, `ExtraConditionEditors`, `ExtraTriggerEditors`, and so on. The class name must be package-qualified.

## Dispatch and priority

Registered extras are dispatched **before** every built-in editor, sorted by `Priority` (highest first). Because the whole extras list is checked before any built-in, the built-in catch-all cannot steal your class - `Priority` only orders extras against each other.

Rule of thumb: the more derived your target class, the higher the `Priority`, so an editor for a child class always wins over one for its parent. Targeting a class Ability Editor already handles deliberately **overrides** the built-in editor.

Classes are resolved with `DynamicLoadObject` at `OnPostTemplatesCreated` time. A class that fails to load is logged and skipped, not fatal. When the bridge is not installed its registrations are not there either, so the game class simply falls back to the built-in editor of its ancestor.

## Naming DLC classes in config

Bare `Class=` names are prefixed `XComGame.`, so a class from another package is written with its package, and matching is by exact class:

```ini
Effects=( ( Class="DLC_2.X2Effect_DLC_Day60Freeze", Slot=eAES_Target, Mode=eAEM_Merge, ... ) )
```

`CanEdit` in the editor still uses the bare name: `Effect.IsA('X2Effect_DLC_Day60Freeze')`.

## Where your fields live

The config fields your editor reads are ordinary fields on the shared edit structs, declared upstream in Ability Editor's `AE_DataStructures.uc` - plain types only (`int`, `bool`, `name`, `array<name>`, enums), never a DLC type, so Ability Editor keeps compiling without the DLC. Users then write them exactly like any other field:

```ini
SetNormalUnitFreezeDuration=true, NormalUnitFreezeDuration=3
```

Propose the fields in a pull request together with your bridge's fragment (next section). They appear on the reference pages, marked as provided by your bridge.

For a class nobody wants upstream, the six `Slot`-taking structs (`EffectEdit`, `ConditionEdit`, `ToHitCalcEdit`, `TargetStyleEdit`, `MultiTargetStyleEdit`, `TriggerEdit`) carry a `CustomProperties` array of `(Key=..., Value="...")` pairs that built-in editors ignore and yours can interpret. Those keys are not documented here - document them in your own README. `CostEdit`, `CooldownEdit` and `ChargesEdit` have no `CustomProperties`; a bridge cost editor either gets its fields upstream or reads its own `config` array keyed on the `AbilityName` it receives.

## Publishing your bridge on this site

The reference pages and the [config builder](../app/index.md) are generated from `docs/schema.json`. A bridge is added to it through a **fragment** that the same generator writes:

1. Put a `bridge.json` at your mod's root:

   ```json
   {
     "displayName": "Ability Editor: Alien Hunters",
     "repo": "https://github.com/boundir/AbilityEditorAlienHunters",
     "requires": { "mods": [], "dlc": ["Alien Hunters"] }
   }
   ```

   `requires.mods` lists other mods your bridge needs (Ability Editor itself is implied); `dlc` is shown to users next to every class you provide. An optional `classPackages` map (`{ "X2Effect_Foo": "MyOtherMod" }`) names the package of a game class the SDK does not have.

2. From a checkout of Ability Editor, with your bridge as a sibling folder:

   ```powershell
   .\.scripts\generate-docs.ps1 -Bridge ..\AbilityEditorAlienHunters -SdkPath '<WOTC SDK>'
   .\.scripts\generate-docs.ps1 -SdkPath '<WOTC SDK>'
   ```

   The first command reads your editors, your `Config\XComAbilityEditor.ini` registrations and the SDK, and writes `docs/bridges/<Package>.json`. The second merges every fragment into `docs/schema.json`. Read the warnings: a field your editor reads that Ability Editor does not declare is reported there.

3. Open a pull request with the fragment, the regenerated `docs/schema.json` and `README.md`, and any new struct fields.

The fragment records the Ability Editor sources it was generated against. When those change, the site marks the bridge as needing a refresh; the inherited fields on your pages stay current regardless, because they are recomposed from the current built-in editors at merge time. Generate the fragment with PowerShell 7 if you can: Windows PowerShell 5.1 escapes `&` and `<` differently in JSON, which is harmless but makes the diff noisier.
