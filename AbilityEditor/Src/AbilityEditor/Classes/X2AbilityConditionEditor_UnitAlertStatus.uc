class X2AbilityConditionEditor_UnitAlertStatus extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitAlertStatus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitAlertStatus AlertCondition;

	AlertCondition = X2Condition_UnitAlertStatus(Condition);

	if (AlertCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetRequiredAlertStatusMaximum)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiredAlertStatusMaximum",
			string(AlertCondition.RequiredAlertStatusMaximum),
			string(ConditionEdit.RequiredAlertStatusMaximum)
		);

		AlertCondition.RequiredAlertStatusMaximum = ConditionEdit.RequiredAlertStatusMaximum;
	}

	if (ConditionEdit.SetRequiredAlertStatusMinimum)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiredAlertStatusMinimum",
			string(AlertCondition.RequiredAlertStatusMinimum),
			string(ConditionEdit.RequiredAlertStatusMinimum)
		);

		AlertCondition.RequiredAlertStatusMinimum = ConditionEdit.RequiredAlertStatusMinimum;
	}
}
