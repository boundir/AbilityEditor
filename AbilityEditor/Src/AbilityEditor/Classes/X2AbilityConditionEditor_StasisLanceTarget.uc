class X2AbilityConditionEditor_StasisLanceTarget extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_StasisLanceTarget');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_StasisLanceTarget StasisLanceTargetCond;

	StasisLanceTargetCond = X2Condition_StasisLanceTarget(Condition);

	if (StasisLanceTargetCond == none)
	{
		return;
	}

	if (ConditionEdit.SetHackAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HackAbilityName",
			string(StasisLanceTargetCond.HackAbilityName),
			string(ConditionEdit.HackAbilityName)
		);

		StasisLanceTargetCond.HackAbilityName = ConditionEdit.HackAbilityName;
	}
}
