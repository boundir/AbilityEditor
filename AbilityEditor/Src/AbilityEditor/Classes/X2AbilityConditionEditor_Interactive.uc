class X2AbilityConditionEditor_Interactive extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_Interactive');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_Interactive InteractiveCond;

	InteractiveCond = X2Condition_Interactive(Condition);

	if (InteractiveCond == none)
	{
		return;
	}

	if (ConditionEdit.SetInteractionType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".InteractionType",
			string(InteractiveCond.InteractionType),
			string(ConditionEdit.InteractionType)
		);

		InteractiveCond.InteractionType = ConditionEdit.InteractionType;
	}

	if (ConditionEdit.SetRequiredAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiredAbilityName",
			string(InteractiveCond.RequiredAbilityName),
			string(ConditionEdit.RequiredAbilityName)
		);

		InteractiveCond.RequiredAbilityName = ConditionEdit.RequiredAbilityName;
	}
}
