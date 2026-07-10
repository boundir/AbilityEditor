class X2AbilityConditionEditor_Bondmate extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_Bondmate');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_Bondmate BondmateCond;

	BondmateCond = X2Condition_Bondmate(Condition);

	if (BondmateCond == none)
	{
		return;
	}

	if (ConditionEdit.SetMinBondLevel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MinBondLevel",
			string(BondmateCond.MinBondLevel),
			string(ConditionEdit.MinBondLevel)
		);

		BondmateCond.MinBondLevel = ConditionEdit.MinBondLevel;
	}

	if (ConditionEdit.SetMaxBondLevel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxBondLevel",
			string(BondmateCond.MaxBondLevel),
			string(ConditionEdit.MaxBondLevel)
		);

		BondmateCond.MaxBondLevel = ConditionEdit.MaxBondLevel;
	}

	if (ConditionEdit.SetRequiresAdjacency)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiresAdjacency",
			string(BondmateCond.RequiresAdjacency),
			string(ConditionEdit.RequiresAdjacency)
		);

		BondmateCond.RequiresAdjacency = ConditionEdit.RequiresAdjacency;
	}

	if (ConditionEdit.SetSkipCheckWithSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSkipCheckWithSource",
			string(BondmateCond.bSkipCheckWithSource),
			string(ConditionEdit.SkipCheckWithSource)
		);

		BondmateCond.bSkipCheckWithSource = ConditionEdit.SkipCheckWithSource;
	}
}
