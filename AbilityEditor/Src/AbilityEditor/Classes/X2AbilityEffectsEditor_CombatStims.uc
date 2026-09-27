class X2AbilityEffectsEditor_CombatStims extends X2AbilityEffectsEditor_BonusArmor;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_CombatStims');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_CombatStims CombatStimsEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	CombatStimsEffect = X2Effect_CombatStims(Effect);

	if (CombatStimsEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".DamageTypeImmunities",
		CombatStimsEffect.DamageTypeImmunities,
		EffectEdit.DamageTypeImmunities,
		EffectEdit.DamageTypeImmunitiesMode
	);
}
