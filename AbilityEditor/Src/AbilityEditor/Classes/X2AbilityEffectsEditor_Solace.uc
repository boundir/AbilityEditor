class X2AbilityEffectsEditor_Solace extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Solace');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Solace SolaceEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SolaceEffect = X2Effect_Solace(Effect);

	if (SolaceEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".DamageTypeImmunities",
		SolaceEffect.DamageTypeImmunities,
		EffectEdit.DamageTypeImmunities,
		EffectEdit.DamageTypeImmunitiesMode
	);
}
