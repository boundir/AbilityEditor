class X2AbilityMultiTargetStyleEditor_Cone extends X2AbilityMultiTargetStyleEditor_Radius;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_Cone');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_Cone ConeStyle;
	local int i, j, Index;

	super.ApplyDerivedEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);

	ConeStyle = X2AbilityMultiTarget_Cone(MultiTargetStyle);

	if (ConeStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetConeEndDiameter)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ConeEndDiameter",
			string(ConeStyle.ConeEndDiameter),
			string(MultiTargetStyleEdit.ConeEndDiameter)
		);

		ConeStyle.ConeEndDiameter = MultiTargetStyleEdit.ConeEndDiameter;
	}

	if (MultiTargetStyleEdit.SetConeLength)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ConeLength",
			string(ConeStyle.ConeLength),
			string(MultiTargetStyleEdit.ConeLength)
		);

		ConeStyle.ConeLength = MultiTargetStyleEdit.ConeLength;
	}

	if (MultiTargetStyleEdit.SetUseWeaponRangeForLength)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponRangeForLength",
			string(ConeStyle.bUseWeaponRangeForLength),
			string(MultiTargetStyleEdit.UseWeaponRangeForLength)
		);

		ConeStyle.bUseWeaponRangeForLength = MultiTargetStyleEdit.UseWeaponRangeForLength;
	}

	if (MultiTargetStyleEdit.SetLockShooterZ)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bLockShooterZ",
			string(ConeStyle.bLockShooterZ),
			string(MultiTargetStyleEdit.LockShooterZ)
		);

		ConeStyle.bLockShooterZ = MultiTargetStyleEdit.LockShooterZ;
	}

	if (MultiTargetStyleEdit.AbilityBonusCones.Length > 0)
	{
		if (MultiTargetStyleEdit.AbilityBonusConesMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".AbilityBonusCones replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			ConeStyle.AbilityBonusCones = MultiTargetStyleEdit.AbilityBonusCones;
		}
		else if (MultiTargetStyleEdit.AbilityBonusConesMode == eNAEM_AddOnly)
		{
			if (ConeStyle.AbilityBonusCones.Length == 0)
			{
				ConeStyle.AbilityBonusCones = MultiTargetStyleEdit.AbilityBonusCones;
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusConesMode == eNAEM_Merge)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusCones.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < ConeStyle.AbilityBonusCones.Length; ++j)
				{
					if (ConeStyle.AbilityBonusCones[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusCones[i].RequiredAbility)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					ConeStyle.AbilityBonusCones.AddItem(MultiTargetStyleEdit.AbilityBonusCones[i]);
				}
				else
				{
					ConeStyle.AbilityBonusCones[Index] = MultiTargetStyleEdit.AbilityBonusCones[i];
				}
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusConesMode == eNAEM_Remove)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusCones.Length; ++i)
			{
				for (j = ConeStyle.AbilityBonusCones.Length - 1; j >= 0; --j)
				{
					if (ConeStyle.AbilityBonusCones[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusCones[i].RequiredAbility)
					{
						ConeStyle.AbilityBonusCones.Remove(j, 1);
					}
				}
			}
		}
	}
}
