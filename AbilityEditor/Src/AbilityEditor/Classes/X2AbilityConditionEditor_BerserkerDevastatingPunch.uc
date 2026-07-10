class X2AbilityConditionEditor_BerserkerDevastatingPunch extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_BerserkerDevastatingPunch');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_BerserkerDevastatingPunch BerserkerDevastatingPunchCond;

	BerserkerDevastatingPunchCond = X2Condition_BerserkerDevastatingPunch(Condition);

	if (BerserkerDevastatingPunchCond == none)
	{
		return;
	}

	if (ConditionEdit.SetFailOnNonUnitTargets)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bFailOnNonUnitTargets",
			string(BerserkerDevastatingPunchCond.bFailOnNonUnitTargets),
			string(ConditionEdit.FailOnNonUnitTargets)
		);

		BerserkerDevastatingPunchCond.bFailOnNonUnitTargets = ConditionEdit.FailOnNonUnitTargets;
	}
}
