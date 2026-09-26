class X2AbilityConditionEditor_GameTime extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_GameTime');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_GameTime GameTimeCondition;

	GameTimeCondition = X2Condition_GameTime(Condition);

	if (GameTimeCondition == none)
	{
		return;
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyCheckConfigArrayEdit(
		AbilityName,
		Slot $ ".HourChecks",
		GameTimeCondition.HourChecks,
		ConditionEdit.HourChecks,
		ConditionEdit.HourChecksMode
	);
}
