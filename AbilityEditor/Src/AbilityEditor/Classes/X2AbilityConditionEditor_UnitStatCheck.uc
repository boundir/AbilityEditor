class X2AbilityConditionEditor_UnitStatCheck extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitStatCheck');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitStatCheck StatCheckCondition;
	local int i, j, Index;

	StatCheckCondition = X2Condition_UnitStatCheck(Condition);

	if (StatCheckCondition == none)
	{
		return;
	}

	if (ConditionEdit.CheckStats.Length > 0)
	{
		if (ConditionEdit.CheckStatsMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".m_aCheckStats replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			StatCheckCondition.m_aCheckStats = ConditionEdit.CheckStats;
		}
		else if (ConditionEdit.CheckStatsMode == eNAEM_AddOnly)
		{
			if (StatCheckCondition.m_aCheckStats.Length == 0)
			{
				StatCheckCondition.m_aCheckStats = ConditionEdit.CheckStats;
			}
		}
		else if (ConditionEdit.CheckStatsMode == eNAEM_Merge)
		{
			for (i = 0; i < ConditionEdit.CheckStats.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < StatCheckCondition.m_aCheckStats.Length; ++j)
				{
					if (StatCheckCondition.m_aCheckStats[j].StatType == ConditionEdit.CheckStats[i].StatType)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					StatCheckCondition.m_aCheckStats.AddItem(ConditionEdit.CheckStats[i]);
				}
				else
				{
					StatCheckCondition.m_aCheckStats[Index] = ConditionEdit.CheckStats[i];
				}
			}
		}
		else if (ConditionEdit.CheckStatsMode == eNAEM_Remove)
		{
			for (i = 0; i < ConditionEdit.CheckStats.Length; ++i)
			{
				for (j = StatCheckCondition.m_aCheckStats.Length - 1; j >= 0; --j)
				{
					if (StatCheckCondition.m_aCheckStats[j].StatType == ConditionEdit.CheckStats[i].StatType)
					{
						StatCheckCondition.m_aCheckStats.Remove(j, 1);
					}
				}
			}
		}
	}
}
