class X2AbilityEffectsEditor_Groundling extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Groundling');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Groundling GroundlingFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	GroundlingFX = X2Effect_Groundling(Effect);

	if (GroundlingFX == none)
	{
		return;
	}

	if (EffectEdit.SetHeightBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HeightBonus",
			string(GroundlingFX.HeightBonus),
			string(EffectEdit.HeightBonus)
		);

		GroundlingFX.HeightBonus = EffectEdit.HeightBonus;
	}
}
