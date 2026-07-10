class X2AbilityConditionEditor_UnitActionPoints extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitActionPoints');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitActionPoints ActionPointsCondition;
	local int i, j, Index;

	ActionPointsCondition = X2Condition_UnitActionPoints(Condition);

	if (ActionPointsCondition == none)
	{
		return;
	}

	if (ConditionEdit.ActionPointChecks.Length > 0)
	{
		if (ConditionEdit.ActionPointChecksMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".m_aCheckValues replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			ActionPointsCondition.m_aCheckValues = ConditionEdit.ActionPointChecks;
		}
		else if (ConditionEdit.ActionPointChecksMode == eNAEM_AddOnly)
		{
			if (ActionPointsCondition.m_aCheckValues.Length == 0)
			{
				ActionPointsCondition.m_aCheckValues = ConditionEdit.ActionPointChecks;
			}
		}
		else if (ConditionEdit.ActionPointChecksMode == eNAEM_Merge)
		{
			for (i = 0; i < ConditionEdit.ActionPointChecks.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < ActionPointsCondition.m_aCheckValues.Length; ++j)
				{
					if (ActionPointsCondition.m_aCheckValues[j].ActionPointType == ConditionEdit.ActionPointChecks[i].ActionPointType)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					ActionPointsCondition.m_aCheckValues.AddItem(ConditionEdit.ActionPointChecks[i]);
				}
				else
				{
					ActionPointsCondition.m_aCheckValues[Index] = ConditionEdit.ActionPointChecks[i];
				}
			}
		}
		else if (ConditionEdit.ActionPointChecksMode == eNAEM_Remove)
		{
			for (i = 0; i < ConditionEdit.ActionPointChecks.Length; ++i)
			{
				for (j = ActionPointsCondition.m_aCheckValues.Length - 1; j >= 0; --j)
				{
					if (ActionPointsCondition.m_aCheckValues[j].ActionPointType == ConditionEdit.ActionPointChecks[i].ActionPointType)
					{
						ActionPointsCondition.m_aCheckValues.Remove(j, 1);
					}
				}
			}
		}
	}
}
