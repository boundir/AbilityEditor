class X2AbilityCostEditor_ReserveActionPoints extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_ReserveActionPoints');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local X2AbilityCost_ReserveActionPoints ReserveActionPointsCost;

	ReserveActionPointsCost = X2AbilityCost_ReserveActionPoints(AbilityCost);

	if (CostEdit.SetNumPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ReserveActionPointsCost.iNumPoints",
			string(ReserveActionPointsCost.iNumPoints),
			string(CostEdit.NumPoints)
		);

		ReserveActionPointsCost.iNumPoints = CostEdit.NumPoints;
	}

	if (CostEdit.SetConsumeAllPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ReserveActionPointsCost.bConsumeAllPoints",
			string(ReserveActionPointsCost.bConsumeAllPoints),
			string(CostEdit.ConsumeAllPoints)
		);

		ReserveActionPointsCost.bConsumeAllPoints = CostEdit.ConsumeAllPoints;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		"ReserveActionPointsCost.AllowedTypes",
		ReserveActionPointsCost.AllowedTypes,
		CostEdit.AllowedTypes,
		CostEdit.AllowedTypesMode
	);
}
