class X2AbilityConditionEditor_GameplayTag extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_GameplayTag');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_GameplayTag TagCondition;

	TagCondition = X2Condition_GameplayTag(Condition);

	if (TagCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetRequiredGameplayTag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiredGameplayTag",
			string(TagCondition.RequiredGameplayTag),
			string(ConditionEdit.RequiredGameplayTag)
		);

		TagCondition.RequiredGameplayTag = ConditionEdit.RequiredGameplayTag;
	}

	if (ConditionEdit.SetDisallowGameplayTag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DisallowGameplayTag",
			string(TagCondition.DisallowGameplayTag),
			string(ConditionEdit.DisallowGameplayTag)
		);

		TagCondition.DisallowGameplayTag = ConditionEdit.DisallowGameplayTag;
	}
}
