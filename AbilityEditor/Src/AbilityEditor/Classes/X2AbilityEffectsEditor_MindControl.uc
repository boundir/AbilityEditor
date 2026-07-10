class X2AbilityEffectsEditor_MindControl extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_MindControl');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_MindControl MindControlFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	MindControlFX = X2Effect_MindControl(Effect);

	if (MindControlFX == none)
	{
		return;
	}

	if (EffectEdit.SetNumTurnsForAI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".iNumTurnsForAI",
			string(MindControlFX.iNumTurnsForAI),
			string(EffectEdit.NumTurnsForAI)
		);

		MindControlFX.iNumTurnsForAI = EffectEdit.NumTurnsForAI;
	}
}
