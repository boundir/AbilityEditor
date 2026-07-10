class X2AbilityConditionEditor_UnitInventory extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitInventory');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitInventory InventoryCondition;

	InventoryCondition = X2Condition_UnitInventory(Condition);

	if (InventoryCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetRelevantSlot)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RelevantSlot",
			string(InventoryCondition.RelevantSlot),
			string(ConditionEdit.RelevantSlot)
		);

		InventoryCondition.RelevantSlot = ConditionEdit.RelevantSlot;
	}

	if (ConditionEdit.SetExcludeWeaponCategory)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeWeaponCategory",
			string(InventoryCondition.ExcludeWeaponCategory),
			string(ConditionEdit.ExcludeWeaponCategory)
		);

		InventoryCondition.ExcludeWeaponCategory = ConditionEdit.ExcludeWeaponCategory;
	}

	if (ConditionEdit.SetRequireWeaponCategory)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireWeaponCategory",
			string(InventoryCondition.RequireWeaponCategory),
			string(ConditionEdit.RequireWeaponCategory)
		);

		InventoryCondition.RequireWeaponCategory = ConditionEdit.RequireWeaponCategory;
	}
}
