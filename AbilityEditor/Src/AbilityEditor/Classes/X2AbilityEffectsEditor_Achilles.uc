class X2AbilityEffectsEditor_Achilles extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Achilles');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Achilles AchillesFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	AchillesFX = X2Effect_Achilles(Effect);

	if (AchillesFX == none)
	{
		return;
	}

	if (EffectEdit.SetToHitMin)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ToHitMin",
			string(AchillesFX.ToHitMin),
			string(EffectEdit.ToHitMin)
		);

		AchillesFX.ToHitMin = EffectEdit.ToHitMin;
	}

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(AchillesFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		AchillesFX.DmgMod = EffectEdit.DmgMod;
	}
}
