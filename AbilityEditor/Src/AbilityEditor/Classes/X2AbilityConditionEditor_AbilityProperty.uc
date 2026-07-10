class X2AbilityConditionEditor_AbilityProperty extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_AbilityProperty');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_AbilityProperty PropertyCondition;

	PropertyCondition = X2Condition_AbilityProperty(Condition);

	if (PropertyCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetTargetMustBeInValidTiles)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TargetMustBeInValidTiles",
			string(PropertyCondition.TargetMustBeInValidTiles),
			string(ConditionEdit.TargetMustBeInValidTiles)
		);

		PropertyCondition.TargetMustBeInValidTiles = ConditionEdit.TargetMustBeInValidTiles;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".OwnerHasSoldierAbilities",
		PropertyCondition.OwnerHasSoldierAbilities,
		ConditionEdit.OwnerHasSoldierAbilities,
		ConditionEdit.OwnerHasSoldierAbilitiesMode
	);
}
