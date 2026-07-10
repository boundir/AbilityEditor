class X2AbilityConditionEditor_UnitInteractions extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitInteractions');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitInteractions InteractionsCondition;

	InteractionsCondition = X2Condition_UnitInteractions(Condition);

	if (InteractionsCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetInteractionType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".InteractionType",
			string(InteractionsCondition.InteractionType),
			string(ConditionEdit.InteractionType)
		);

		InteractionsCondition.InteractionType = ConditionEdit.InteractionType;
	}
}
