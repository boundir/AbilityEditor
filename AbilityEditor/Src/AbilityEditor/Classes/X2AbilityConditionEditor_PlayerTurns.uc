class X2AbilityConditionEditor_PlayerTurns extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_PlayerTurns');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_PlayerTurns TurnsCondition;

	TurnsCondition = X2Condition_PlayerTurns(Condition);

	if (TurnsCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetNumTurnsCheck)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumTurnsCheck",
			"(CheckConfig)",
			"(CheckConfig)"
		);

		TurnsCondition.NumTurnsCheck = ConditionEdit.NumTurnsCheck;
	}
}
