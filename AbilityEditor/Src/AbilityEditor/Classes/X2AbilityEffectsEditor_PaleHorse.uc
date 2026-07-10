class X2AbilityEffectsEditor_PaleHorse extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PaleHorse');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PaleHorse PaleHorseFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	PaleHorseFX = X2Effect_PaleHorse(Effect);

	if (PaleHorseFX == none)
	{
		return;
	}

	if (EffectEdit.SetCritBoostPerKill)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritBoostPerKill",
			string(PaleHorseFX.CritBoostPerKill),
			string(EffectEdit.CritBoostPerKill)
		);

		PaleHorseFX.CritBoostPerKill = EffectEdit.CritBoostPerKill;
	}

	if (EffectEdit.SetMaxCritBoost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxCritBoost",
			string(PaleHorseFX.MaxCritBoost),
			string(EffectEdit.MaxCritBoost)
		);

		PaleHorseFX.MaxCritBoost = EffectEdit.MaxCritBoost;
	}
}
