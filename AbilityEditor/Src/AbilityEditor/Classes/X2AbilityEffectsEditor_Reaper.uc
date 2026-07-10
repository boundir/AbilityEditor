class X2AbilityEffectsEditor_Reaper extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Reaper');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Reaper ReaperFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ReaperFX = X2Effect_Reaper(Effect);

	if (ReaperFX == none)
	{
		return;
	}

	if (EffectEdit.SetReaperActivatedName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReaperActivatedName",
			string(ReaperFX.ReaperActivatedName),
			string(EffectEdit.ReaperActivatedName)
		);

		ReaperFX.ReaperActivatedName = EffectEdit.ReaperActivatedName;
	}

	if (EffectEdit.SetReaperKillName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReaperKillName",
			string(ReaperFX.ReaperKillName),
			string(EffectEdit.ReaperKillName)
		);

		ReaperFX.ReaperKillName = EffectEdit.ReaperKillName;
	}
}
