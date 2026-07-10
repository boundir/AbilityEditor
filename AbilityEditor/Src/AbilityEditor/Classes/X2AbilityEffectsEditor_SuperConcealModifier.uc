class X2AbilityEffectsEditor_SuperConcealModifier extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SuperConcealModifier');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SuperConcealModifier SuperConcealModifierFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SuperConcealModifierFX = X2Effect_SuperConcealModifier(Effect);

	if (SuperConcealModifierFX == none)
	{
		return;
	}

	if (EffectEdit.SetConcealAmountScalar)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ConcealAmountScalar",
			string(SuperConcealModifierFX.ConcealAmountScalar),
			string(EffectEdit.ConcealAmountScalar)
		);

		SuperConcealModifierFX.ConcealAmountScalar = EffectEdit.ConcealAmountScalar;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".AbilitiesAffectedFilter",
		SuperConcealModifierFX.AbilitiesAffectedFilter,
		EffectEdit.AbilitiesAffectedFilter,
		EffectEdit.AbilitiesAffectedFilterMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".RemoveOnAbilityActivation",
		SuperConcealModifierFX.RemoveOnAbilityActivation,
		EffectEdit.RemoveOnAbilityActivation,
		EffectEdit.RemoveOnAbilityActivationMode
	);
}
