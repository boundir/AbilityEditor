class X2AbilityEffectsEditor_ModifyStatCheckSuccesses extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ModifyStatCheckSuccesses');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ModifyStatCheckSuccesses StatCheckEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	StatCheckEffect = X2Effect_ModifyStatCheckSuccesses(Effect);

	if (StatCheckEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyAdditionalSuccessModifierArrayEdit(
		AbilityName,
		Slot $ ".AdditionalSuccessModifiers",
		StatCheckEffect.AdditionalSuccessModifiers,
		EffectEdit.AdditionalSuccessModifiers,
		EffectEdit.AdditionalSuccessModifiersMode
	);
}
