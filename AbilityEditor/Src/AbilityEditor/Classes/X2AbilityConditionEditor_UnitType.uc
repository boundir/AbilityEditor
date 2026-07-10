class X2AbilityConditionEditor_UnitType extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitType');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitType TypeCondition;

	TypeCondition = X2Condition_UnitType(Condition);

	if (TypeCondition == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".IncludeTypes",
		TypeCondition.IncludeTypes,
		ConditionEdit.IncludeTypes,
		ConditionEdit.IncludeTypesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".ExcludeTypes",
		TypeCondition.ExcludeTypes,
		ConditionEdit.ExcludeTypes,
		ConditionEdit.ExcludeTypesMode
	);
}
