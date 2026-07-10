class X2AbilityEffectsEditor_TrackingShotMarkTarget extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TrackingShotMarkTarget');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TrackingShotMarkTarget TrackingShotMarkTargetFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TrackingShotMarkTargetFX = X2Effect_TrackingShotMarkTarget(Effect);

	if (TrackingShotMarkTargetFX == none)
	{
		return;
	}

	if (EffectEdit.SetConeLength)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ConeLength",
			string(TrackingShotMarkTargetFX.ConeLength),
			string(EffectEdit.ConeLength)
		);

		TrackingShotMarkTargetFX.ConeLength = EffectEdit.ConeLength;
	}

	if (EffectEdit.SetConeEndDiameter)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ConeEndDiameter",
			string(TrackingShotMarkTargetFX.ConeEndDiameter),
			string(EffectEdit.ConeEndDiameter)
		);

		TrackingShotMarkTargetFX.ConeEndDiameter = EffectEdit.ConeEndDiameter;
	}
}
