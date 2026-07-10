class X2AbilityConditionEditor_UnitValue extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitValue');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitValue ValueCondition;
	local int i, j, Index;

	ValueCondition = X2Condition_UnitValue(Condition);

	if (ValueCondition == none)
	{
		return;
	}

	if (ConditionEdit.CheckValues.Length > 0)
	{
		if (ConditionEdit.CheckValuesMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".m_aCheckValues replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			ValueCondition.m_aCheckValues = ConditionEdit.CheckValues;
		}
		else if (ConditionEdit.CheckValuesMode == eNAEM_AddOnly)
		{
			if (ValueCondition.m_aCheckValues.Length == 0)
			{
				ValueCondition.m_aCheckValues = ConditionEdit.CheckValues;
			}
		}
		else if (ConditionEdit.CheckValuesMode == eNAEM_Merge)
		{
			for (i = 0; i < ConditionEdit.CheckValues.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < ValueCondition.m_aCheckValues.Length; ++j)
				{
					if (ValueCondition.m_aCheckValues[j].UnitValue == ConditionEdit.CheckValues[i].UnitValue)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					ValueCondition.m_aCheckValues.AddItem(ConditionEdit.CheckValues[i]);
				}
				else
				{
					ValueCondition.m_aCheckValues[Index] = ConditionEdit.CheckValues[i];
				}
			}
		}
		else if (ConditionEdit.CheckValuesMode == eNAEM_Remove)
		{
			for (i = 0; i < ConditionEdit.CheckValues.Length; ++i)
			{
				for (j = ValueCondition.m_aCheckValues.Length - 1; j >= 0; --j)
				{
					if (ValueCondition.m_aCheckValues[j].UnitValue == ConditionEdit.CheckValues[i].UnitValue)
					{
						ValueCondition.m_aCheckValues.Remove(j, 1);
					}
				}
			}
		}
	}
}
