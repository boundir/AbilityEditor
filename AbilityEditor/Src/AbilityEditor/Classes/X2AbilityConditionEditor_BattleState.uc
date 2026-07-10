class X2AbilityConditionEditor_BattleState extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_BattleState');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_BattleState BattleStateCond;

	BattleStateCond = X2Condition_BattleState(Condition);

	if (BattleStateCond == none)
	{
		return;
	}

	if (ConditionEdit.SetMissionAborted)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bMissionAborted",
			string(BattleStateCond.bMissionAborted),
			string(ConditionEdit.MissionAborted)
		);

		BattleStateCond.bMissionAborted = ConditionEdit.MissionAborted;
	}

	if (ConditionEdit.SetMissionNotAborted)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bMissionNotAborted",
			string(BattleStateCond.bMissionNotAborted),
			string(ConditionEdit.MissionNotAborted)
		);

		BattleStateCond.bMissionNotAborted = ConditionEdit.MissionNotAborted;
	}

	if (ConditionEdit.SetCiviliansTargetedByAliens)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCiviliansTargetedByAliens",
			string(BattleStateCond.bCiviliansTargetedByAliens),
			string(ConditionEdit.CiviliansTargetedByAliens)
		);

		BattleStateCond.bCiviliansTargetedByAliens = ConditionEdit.CiviliansTargetedByAliens;
	}

	if (ConditionEdit.SetCiviliansNotTargetedByAliens)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCiviliansNotTargetedByAliens",
			string(BattleStateCond.bCiviliansNotTargetedByAliens),
			string(ConditionEdit.CiviliansNotTargetedByAliens)
		);

		BattleStateCond.bCiviliansNotTargetedByAliens = ConditionEdit.CiviliansNotTargetedByAliens;
	}

	if (ConditionEdit.SetIncludeTheLostInEngagedCount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIncludeTheLostInEngagedCount",
			string(BattleStateCond.bIncludeTheLostInEngagedCount),
			string(ConditionEdit.IncludeTheLostInEngagedCount)
		);

		BattleStateCond.bIncludeTheLostInEngagedCount = ConditionEdit.IncludeTheLostInEngagedCount;
	}

	if (ConditionEdit.SetMinEngagedEnemies)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MinEngagedEnemies",
			string(BattleStateCond.MinEngagedEnemies),
			string(ConditionEdit.MinEngagedEnemies)
		);

		BattleStateCond.MinEngagedEnemies = ConditionEdit.MinEngagedEnemies;
	}

	if (ConditionEdit.SetMaxEngagedEnemies)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxEngagedEnemies",
			string(BattleStateCond.MaxEngagedEnemies),
			string(ConditionEdit.MaxEngagedEnemies)
		);

		BattleStateCond.MaxEngagedEnemies = ConditionEdit.MaxEngagedEnemies;
	}
}
