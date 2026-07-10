class X2AbilityConditionEditor_UnitImmunities extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitImmunities');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitImmunities ImmunitiesCondition;

	ImmunitiesCondition = X2Condition_UnitImmunities(Condition);

	if (ImmunitiesCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetOnlyOnCharacterTemplate)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyOnCharacterTemplate",
			string(ImmunitiesCondition.bOnlyOnCharacterTemplate),
			string(ConditionEdit.OnlyOnCharacterTemplate)
		);

		ImmunitiesCondition.bOnlyOnCharacterTemplate = ConditionEdit.OnlyOnCharacterTemplate;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".ExcludeDamageTypes",
		ImmunitiesCondition.ExcludeDamageTypes,
		ConditionEdit.ExcludeDamageTypes,
		ConditionEdit.ExcludeDamageTypesMode
	);
}
