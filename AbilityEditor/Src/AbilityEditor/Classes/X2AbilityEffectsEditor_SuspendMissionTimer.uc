class X2AbilityEffectsEditor_SuspendMissionTimer extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SuspendMissionTimer');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SuspendMissionTimer SuspendMissionTimerFX;

	SuspendMissionTimerFX = X2Effect_SuspendMissionTimer(Effect);

	if (SuspendMissionTimerFX == none)
	{
		return;
	}

	if (EffectEdit.SetResumeMissionTimer)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bResumeMissionTimer",
			string(SuspendMissionTimerFX.bResumeMissionTimer),
			string(EffectEdit.ResumeMissionTimer)
		);

		SuspendMissionTimerFX.bResumeMissionTimer = EffectEdit.ResumeMissionTimer;
	}
}
