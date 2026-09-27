class X2AbilityEffectsEditor_Fortress extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Fortress');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Fortress FortressEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	FortressEffect = X2Effect_Fortress(Effect);

	if (FortressEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".DamageImmunities",
		FortressEffect.DamageImmunities,
		EffectEdit.DamageImmunities,
		EffectEdit.DamageImmunitiesMode
	);
}
