class X2AbilityEffectsEditor_VolatileMix extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_VolatileMix');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_VolatileMix VolatileMixFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	VolatileMixFX = X2Effect_VolatileMix(Effect);

	if (VolatileMixFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDamage",
			string(VolatileMixFX.BonusDamage),
			string(EffectEdit.BonusDamage)
		);

		VolatileMixFX.BonusDamage = EffectEdit.BonusDamage;
	}
}
