class X2AbilityEffectsEditor_LifeSteal extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_LifeSteal');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_LifeSteal LifeStealFX;

	LifeStealFX = X2Effect_LifeSteal(Effect);

	if (LifeStealFX == none)
	{
		return;
	}

	if (EffectEdit.SetLifeAmountMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".LifeAmountMultiplier",
			string(LifeStealFX.LifeAmountMultiplier),
			string(EffectEdit.LifeAmountMultiplier)
		);

		LifeStealFX.LifeAmountMultiplier = EffectEdit.LifeAmountMultiplier;
	}
}
