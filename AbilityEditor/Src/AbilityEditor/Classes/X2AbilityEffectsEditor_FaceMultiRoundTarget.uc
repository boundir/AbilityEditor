class X2AbilityEffectsEditor_FaceMultiRoundTarget extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_FaceMultiRoundTarget');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_FaceMultiRoundTarget FaceMultiRoundTargetFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	FaceMultiRoundTargetFX = X2Effect_FaceMultiRoundTarget(Effect);

	if (FaceMultiRoundTargetFX == none)
	{
		return;
	}

	if (EffectEdit.SetTriggerEventName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TriggerEventName",
			string(FaceMultiRoundTargetFX.TriggerEventName),
			string(EffectEdit.TriggerEventName)
		);

		FaceMultiRoundTargetFX.TriggerEventName = EffectEdit.TriggerEventName;
	}
}
