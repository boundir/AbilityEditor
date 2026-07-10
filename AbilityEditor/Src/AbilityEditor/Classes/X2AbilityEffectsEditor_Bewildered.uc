class X2AbilityEffectsEditor_Bewildered extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Bewildered');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Bewildered BewilderedFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BewilderedFX = X2Effect_Bewildered(Effect);

	if (BewilderedFX == none)
	{
		return;
	}

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(BewilderedFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		BewilderedFX.DmgMod = EffectEdit.DmgMod;
	}

	if (EffectEdit.SetNumHitsForMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumHitsForMod",
			string(BewilderedFX.NumHitsForMod),
			string(EffectEdit.NumHitsForMod)
		);

		BewilderedFX.NumHitsForMod = EffectEdit.NumHitsForMod;
	}
}
