class X2AbilityConditionEditor_Lootable extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_Lootable');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_Lootable LootableCond;

	LootableCond = X2Condition_Lootable(Condition);

	if (LootableCond == none)
	{
		return;
	}

	if (ConditionEdit.SetRestrictRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRestrictRange",
			string(LootableCond.bRestrictRange),
			string(ConditionEdit.RestrictRange)
		);

		LootableCond.bRestrictRange = ConditionEdit.RestrictRange;
	}

	if (ConditionEdit.SetLootableRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".LootableRange",
			string(LootableCond.LootableRange),
			string(ConditionEdit.LootableRange)
		);

		LootableCond.LootableRange = ConditionEdit.LootableRange;
	}
}
