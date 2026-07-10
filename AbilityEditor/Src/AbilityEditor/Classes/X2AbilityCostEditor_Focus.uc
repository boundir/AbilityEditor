class X2AbilityCostEditor_Focus extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_Focus');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local X2AbilityCost_Focus FocusCost;

	FocusCost = X2AbilityCost_Focus(AbilityCost);

	if (CostEdit.SetFocusAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"FocusCost.FocusAmount",
			string(FocusCost.FocusAmount),
			string(CostEdit.FocusAmount)
		);

		FocusCost.FocusAmount = CostEdit.FocusAmount;
	}

	if (CostEdit.SetConsumeAllFocus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"FocusCost.ConsumeAllFocus",
			string(FocusCost.ConsumeAllFocus),
			string(CostEdit.ConsumeAllFocus)
		);

		FocusCost.ConsumeAllFocus = CostEdit.ConsumeAllFocus;
	}

	if (CostEdit.SetGhostOnlyCost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"FocusCost.GhostOnlyCost",
			string(FocusCost.GhostOnlyCost),
			string(CostEdit.GhostOnlyCost)
		);

		FocusCost.GhostOnlyCost = CostEdit.GhostOnlyCost;
	}
}
