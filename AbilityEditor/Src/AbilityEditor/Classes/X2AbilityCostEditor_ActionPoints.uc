class X2AbilityCostEditor_ActionPoints extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_ActionPoints');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local X2AbilityCost_ActionPoints ActionPointCost;

	ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);

	if (ActionPointCost == none)
	{
		return;
	}

	if (CostEdit.SetNumPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ActionPointCost.iNumPoints",
			string(ActionPointCost.iNumPoints),
			string(CostEdit.NumPoints)
		);

		ActionPointCost.iNumPoints = CostEdit.NumPoints;
	}

	if (CostEdit.SetConsumeAllPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ActionPointCost.bConsumeAllPoints",
			string(ActionPointCost.bConsumeAllPoints),
			string(CostEdit.ConsumeAllPoints)
		);

		ActionPointCost.bConsumeAllPoints = CostEdit.ConsumeAllPoints;
	}

	if (CostEdit.SetAddWeaponTypicalCost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ActionPointCost.bAddWeaponTypicalCost",
			string(ActionPointCost.bAddWeaponTypicalCost),
			string(CostEdit.AddWeaponTypicalCost)
		);

		ActionPointCost.bAddWeaponTypicalCost = CostEdit.AddWeaponTypicalCost;
	}

	if (CostEdit.SetMoveCost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ActionPointCost.bMoveCost",
			string(ActionPointCost.bMoveCost),
			string(CostEdit.MoveCost)
		);

		ActionPointCost.bMoveCost = CostEdit.MoveCost;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		"ActionPointCost.AllowedTypes",
		ActionPointCost.AllowedTypes,
		CostEdit.AllowedTypes,
		CostEdit.AllowedTypesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		"ActionPointCost.DoNotConsumeAllEffects",
		ActionPointCost.DoNotConsumeAllEffects,
		CostEdit.DoNotConsumeAllEffects,
		CostEdit.DoNotConsumeAllEffectsMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		"ActionPointCost.DoNotConsumeAllSoldierAbilities",
		ActionPointCost.DoNotConsumeAllSoldierAbilities,
		CostEdit.DoNotConsumeAllSoldierAbilities,
		CostEdit.DoNotConsumeAllSoldierAbilitiesMode
	);
}
