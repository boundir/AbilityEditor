class X2AbilityConditionEditor_DarkEvent extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_DarkEvent');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_DarkEvent DarkEventCondition;

	DarkEventCondition = X2Condition_DarkEvent(Condition);

	if (DarkEventCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetStilettoRounds)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bStilettoRounds",
			string(DarkEventCondition.bStilettoRounds),
			string(ConditionEdit.StilettoRounds)
		);

		DarkEventCondition.bStilettoRounds = ConditionEdit.StilettoRounds;
	}
}
