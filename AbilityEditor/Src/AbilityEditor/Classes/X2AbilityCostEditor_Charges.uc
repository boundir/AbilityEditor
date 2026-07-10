class X2AbilityCostEditor_Charges extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_Charges');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local X2AbilityCost_Charges ChargesCost;

	ChargesCost = X2AbilityCost_Charges(AbilityCost);

	if (CostEdit.SetNumCharges)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ChargesCost.NumCharges",
			string(ChargesCost.NumCharges),
			string(CostEdit.NumCharges)
		);

		ChargesCost.NumCharges = CostEdit.NumCharges;
	}

	if (CostEdit.SetOnlyOnHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ChargesCost.bOnlyOnHit",
			string(ChargesCost.bOnlyOnHit),
			string(CostEdit.OnlyOnHit)
		);

		ChargesCost.bOnlyOnHit = CostEdit.OnlyOnHit;
	}

	if (CostEdit.SetAlsoExpendChargesOnSharedBondmateAbility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"ChargesCost.bAlsoExpendChargesOnSharedBondmateAbility",
			string(ChargesCost.bAlsoExpendChargesOnSharedBondmateAbility),
			string(CostEdit.AlsoExpendChargesOnSharedBondmateAbility)
		);

		ChargesCost.bAlsoExpendChargesOnSharedBondmateAbility = CostEdit.AlsoExpendChargesOnSharedBondmateAbility;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		"ChargesCost.SharedAbilityCharges",
		ChargesCost.SharedAbilityCharges,
		CostEdit.SharedAbilityCharges,
		CostEdit.SharedAbilityChargesMode
	);
}
