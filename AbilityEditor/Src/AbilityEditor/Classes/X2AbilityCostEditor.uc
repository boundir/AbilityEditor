class X2AbilityCostEditor extends Object abstract;

static function bool CanEdit(X2AbilityCost AbilityCost);

static function ApplyEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
    ApplyBaseEdit(AbilityName, AbilityCost, CostEdit);
    ApplyDerivedEdit(AbilityName, AbilityCost, CostEdit);
}

static function ApplyBaseEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	if (CostEdit.SetFreeCost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AbilityCost.bFreeCost",
			string(AbilityCost.bFreeCost),
			string(CostEdit.FreeCost)
		);
		AbilityCost.bFreeCost = CostEdit.FreeCost;
	}
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
}
