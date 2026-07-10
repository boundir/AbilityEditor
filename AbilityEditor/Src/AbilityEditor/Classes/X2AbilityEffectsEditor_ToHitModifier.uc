class X2AbilityEffectsEditor_ToHitModifier extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ToHitModifier');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ToHitModifier ToHitModifierFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ToHitModifierFX = X2Effect_ToHitModifier(Effect);

	if (ToHitModifierFX == none)
	{
		return;
	}

	if (EffectEdit.SetApplyAsTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyAsTarget",
			string(ToHitModifierFX.bApplyAsTarget),
			string(EffectEdit.ApplyAsTarget)
		);

		ToHitModifierFX.bApplyAsTarget = EffectEdit.ApplyAsTarget;
	}

	// Replace-only: EffectHitModifier has no natural merge key
	if (EffectEdit.EffectHitModifiers.Length > 0)
	{
		`log(string(AbilityName) @ Slot $ ".Modifiers replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		ToHitModifierFX.Modifiers = EffectEdit.EffectHitModifiers;
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		AbilityName,
		Slot $ ".ToHitConditions",
		ToHitModifierFX.ToHitConditions,
		EffectEdit.ToHitConditions
	);
}
