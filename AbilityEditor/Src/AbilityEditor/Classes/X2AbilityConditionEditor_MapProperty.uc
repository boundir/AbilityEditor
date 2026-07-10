class X2AbilityConditionEditor_MapProperty extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_MapProperty');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_MapProperty MapCond;

	MapCond = X2Condition_MapProperty(Condition);

	if (MapCond == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyStringArrayEdit(
		AbilityName,
		Slot $ ".AllowedBiomes",
		MapCond.AllowedBiomes,
		ConditionEdit.AllowedBiomes,
		ConditionEdit.AllowedBiomesMode
	);
}
