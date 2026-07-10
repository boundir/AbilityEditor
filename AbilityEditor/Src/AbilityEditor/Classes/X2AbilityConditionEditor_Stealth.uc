class X2AbilityConditionEditor_Stealth extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_Stealth');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_Stealth StealthCond;

	StealthCond = X2Condition_Stealth(Condition);

	if (StealthCond == none)
	{
		return;
	}

	if (ConditionEdit.SetCheckFlanking)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCheckFlanking",
			string(StealthCond.bCheckFlanking),
			string(ConditionEdit.CheckFlanking)
		);

		StealthCond.bCheckFlanking = ConditionEdit.CheckFlanking;
	}
}
