class X2AbilityEffectsEditor_DeadeyeDamage extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_DeadeyeDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_DeadeyeDamage DeadeyeDamageEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	DeadeyeDamageEffect = X2Effect_DeadeyeDamage(Effect);

	if (DeadeyeDamageEffect == none)
	{
		return;
	}

	if (EffectEdit.SetDamageMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageMultiplier",
			string(DeadeyeDamageEffect.DamageMultiplier),
			string(EffectEdit.DamageMultiplier)
		);

		DeadeyeDamageEffect.DamageMultiplier = EffectEdit.DamageMultiplier;
	}
}
