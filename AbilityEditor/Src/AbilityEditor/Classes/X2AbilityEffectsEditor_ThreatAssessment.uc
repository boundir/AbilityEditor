class X2AbilityEffectsEditor_ThreatAssessment extends X2AbilityEffectsEditor_CoveringFire;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ThreatAssessment');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ThreatAssessment ThreatAssessmentFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ThreatAssessmentFX = X2Effect_ThreatAssessment(Effect);

	if (ThreatAssessmentFX == none)
	{
		return;
	}

	if (EffectEdit.SetImmediateActionPoint)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ImmediateActionPoint",
			string(ThreatAssessmentFX.ImmediateActionPoint),
			string(EffectEdit.ImmediateActionPoint)
		);

		ThreatAssessmentFX.ImmediateActionPoint = EffectEdit.ImmediateActionPoint;
	}
}
