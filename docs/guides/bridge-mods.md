# Extending Ability Editor (bridge mods)

Other mods can plug their own editor classes into Ability Editor's dispatch. This is the intended
way to support DLC-package or mod-added game classes without adding dependencies to Ability Editor
itself.

## Three steps

**1. Depend on the `AbilityEditor` script package**

**2. Subclass the right family editor** and declare which game class you handle:

```unrealscript
class X2AbilityEffectsEditor_MyDLCEffect extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
    return Effect.IsA('X2Effect_MyDLCEffect');
}

static function ApplyDerivedEdit(name AbilityName, string Slot, X2Effect Effect, EffectEdit EffectEdit)
{
    super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);
    // read shared EffectEdit fields, or your own values from EffectEdit.CustomProperties
}
```

Extend the editor for your game class's **nearest ancestor**, and call `super.ApplyDerivedEdit`
first - that is what gets the inherited fields applied.

!!! warning "Signatures differ by family"
    Six families pass a `Slot` string. **Cost, Cooldown and Charges do not** - their signature is
    `(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)` and they build the log path
    from a literal instead.

**3. Register it from your own mod's `XComAbilityEditor.ini`:**

```ini
[AbilityEditor.X2DLCInfo_AbilityEditor]
+ExtraEffectsEditors=(EditorClass="MyMod.X2AbilityEffectsEditor_MyDLCEffect", Priority=10)
```

An `Extra<Family>Editors` array exists for all nine families - `ExtraCostEditors`,
`ExtraConditionEditors`, `ExtraToHitCalcEditors`, and so on.

## Dispatch and priority

Registered extras are dispatched **before** every built-in editor, sorted by `Priority` (highest
first). Because the whole extras list is checked before any built-in, the built-in catch-all cannot
steal your class - `Priority` only orders extras against each other.

Rule of thumb: the more derived your target class, the higher the `Priority`, so an editor for a
child class always wins over one for its parent. Targeting a class Ability Editor already handles
deliberately **overrides** the built-in editor.

Classes are resolved with `DynamicLoadObject` at `OnPostTemplatesCreated` time. A class that fails
to load is logged and skipped, not fatal.

## Passing your own data

The shared edit structs only carry fields Ability Editor knows about. For anything else,
`EffectEdit`, `ConditionEdit`, `ToHitCalcEdit`, `TargetStyleEdit`, `MultiTargetStyleEdit` and
`TriggerEdit` each have a `CustomProperties` array of `(Key=..., Value="...")` pairs that built-in
editors ignore and yours can interpret freely.

```ini
+AbilityEdits=( \\
    Ability=MyAbility, \\
    Effects=( \\
        ( \\
            Class="MyMod.X2Effect_MyDLCEffect", \\
            Mode=eAEM_Merge, \\
            CustomProperties=( (Key=Intensity, Value="3") ) \\
        ) \\
    ) \\
)
```

!!! danger "Cost, Cooldown and Charges have no `CustomProperties`"
    Only the six `Slot`-taking structs carry it. `CostEdit`, `CooldownEdit` and `ChargesEdit` do
    not, so a bridge **cost** editor has no config channel for custom fields at all.

    Two workable routes: have your editor read its own `config` array in your own mod, keyed on
    the `AbilityName` that `ApplyEdit` already receives - this works today with no changes to
    Ability Editor - or propose adding `CustomProperties` to the struct upstream, which is a
    one-line additive change.

Note there is no `GetCustomProperty` helper in the codebase; every consumer does its own lookup.

## What your fields won't do

Bridge-mod fields do not appear in this site or in `schema.json`. Both are generated from Ability
Editor's own sources, and `CustomProperties` is deliberately outside the documented surface.
Document your keys in your own mod's README.
