class X2AbilityConditionEditor_PanicOnPod extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_PanicOnPod');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_PanicOnPod PanicOnPodCond;

	PanicOnPodCond = X2Condition_PanicOnPod(Condition);

	if (PanicOnPodCond == none)
	{
		return;
	}

	if (ConditionEdit.SetMaxPanicUnitsPerPod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxPanicUnitsPerPod",
			string(PanicOnPodCond.MaxPanicUnitsPerPod),
			string(ConditionEdit.MaxPanicUnitsPerPod)
		);

		PanicOnPodCond.MaxPanicUnitsPerPod = ConditionEdit.MaxPanicUnitsPerPod;
	}
}
