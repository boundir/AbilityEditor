class X2AbilityCostEditor_Ammo extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_Ammo');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local X2AbilityCost_Ammo AmmoCost;

	AmmoCost = X2AbilityCost_Ammo(AbilityCost);

	if (CostEdit.SetNumAmmo)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AmmoCost.iAmmo",
			string(AmmoCost.iAmmo),
			string(CostEdit.NumAmmo)
		);

		AmmoCost.iAmmo = CostEdit.NumAmmo;
	}

	if (CostEdit.SetUseLoadedAmmo)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AmmoCost.UseLoadedAmmo",
			string(AmmoCost.UseLoadedAmmo),
			string(CostEdit.UseLoadedAmmo)
		);

		AmmoCost.UseLoadedAmmo = CostEdit.UseLoadedAmmo;
	}

	if (CostEdit.SetReturnChargesError)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AmmoCost.bReturnChargesError",
			string(AmmoCost.bReturnChargesError),
			string(CostEdit.ReturnChargesError)
		);

		AmmoCost.bReturnChargesError = CostEdit.ReturnChargesError;
	}

	if (CostEdit.SetConsumeAllAmmo)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AmmoCost.bConsumeAllAmmo",
			string(AmmoCost.bConsumeAllAmmo),
			string(CostEdit.ConsumeAllAmmo)
		);

		AmmoCost.bConsumeAllAmmo = CostEdit.ConsumeAllAmmo;
	}
}
