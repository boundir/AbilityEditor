class X2AbilityMultiTargetStyleEditor_Radius extends X2AbilityMultiTargetStyleEditor_Base;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_Radius');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_Radius RadiusStyle;
	local int i, j, Index;

	RadiusStyle = X2AbilityMultiTarget_Radius(MultiTargetStyle);

	if (RadiusStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetUseWeaponRadius)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponRadius",
			string(RadiusStyle.bUseWeaponRadius),
			string(MultiTargetStyleEdit.UseWeaponRadius)
		);

		RadiusStyle.bUseWeaponRadius = MultiTargetStyleEdit.UseWeaponRadius;
	}

	if (MultiTargetStyleEdit.SetUseWeaponBlockingCoverFlag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponBlockingCoverFlag",
			string(RadiusStyle.bUseWeaponBlockingCoverFlag),
			string(MultiTargetStyleEdit.UseWeaponBlockingCoverFlag)
		);

		RadiusStyle.bUseWeaponBlockingCoverFlag = MultiTargetStyleEdit.UseWeaponBlockingCoverFlag;
	}

	if (MultiTargetStyleEdit.SetIgnoreBlockingCover)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIgnoreBlockingCover",
			string(RadiusStyle.bIgnoreBlockingCover),
			string(MultiTargetStyleEdit.IgnoreBlockingCover)
		);

		RadiusStyle.bIgnoreBlockingCover = MultiTargetStyleEdit.IgnoreBlockingCover;
	}

	if (MultiTargetStyleEdit.SetTargetRadius)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".fTargetRadius",
			string(RadiusStyle.fTargetRadius),
			string(MultiTargetStyleEdit.TargetRadius)
		);

		RadiusStyle.fTargetRadius = MultiTargetStyleEdit.TargetRadius;
	}

	if (MultiTargetStyleEdit.SetTargetCoveragePercentage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".fTargetCoveragePercentage",
			string(RadiusStyle.fTargetCoveragePercentage),
			string(MultiTargetStyleEdit.TargetCoveragePercentage)
		);

		RadiusStyle.fTargetCoveragePercentage = MultiTargetStyleEdit.TargetCoveragePercentage;
	}

	if (MultiTargetStyleEdit.SetAddPrimaryTargetAsMultiTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAddPrimaryTargetAsMultiTarget",
			string(RadiusStyle.bAddPrimaryTargetAsMultiTarget),
			string(MultiTargetStyleEdit.AddPrimaryTargetAsMultiTarget)
		);

		RadiusStyle.bAddPrimaryTargetAsMultiTarget = MultiTargetStyleEdit.AddPrimaryTargetAsMultiTarget;
	}

	if (MultiTargetStyleEdit.SetAllowDeadMultiTargetUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowDeadMultiTargetUnits",
			string(RadiusStyle.bAllowDeadMultiTargetUnits),
			string(MultiTargetStyleEdit.AllowDeadMultiTargetUnits)
		);

		RadiusStyle.bAllowDeadMultiTargetUnits = MultiTargetStyleEdit.AllowDeadMultiTargetUnits;
	}

	if (MultiTargetStyleEdit.SetExcludeSelfAsTargetIfWithinRadius)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bExcludeSelfAsTargetIfWithinRadius",
			string(RadiusStyle.bExcludeSelfAsTargetIfWithinRadius),
			string(MultiTargetStyleEdit.ExcludeSelfAsTargetIfWithinRadius)
		);

		RadiusStyle.bExcludeSelfAsTargetIfWithinRadius = MultiTargetStyleEdit.ExcludeSelfAsTargetIfWithinRadius;
	}

	if (MultiTargetStyleEdit.AbilityBonusRadii.Length > 0)
	{
		if (MultiTargetStyleEdit.AbilityBonusRadiiMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".AbilityBonusRadii replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			RadiusStyle.AbilityBonusRadii = MultiTargetStyleEdit.AbilityBonusRadii;
		}
		else if (MultiTargetStyleEdit.AbilityBonusRadiiMode == eNAEM_AddOnly)
		{
			if (RadiusStyle.AbilityBonusRadii.Length == 0)
			{
				RadiusStyle.AbilityBonusRadii = MultiTargetStyleEdit.AbilityBonusRadii;
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusRadiiMode == eNAEM_Merge)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusRadii.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < RadiusStyle.AbilityBonusRadii.Length; ++j)
				{
					if (RadiusStyle.AbilityBonusRadii[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusRadii[i].RequiredAbility)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					RadiusStyle.AbilityBonusRadii.AddItem(MultiTargetStyleEdit.AbilityBonusRadii[i]);
				}
				else
				{
					RadiusStyle.AbilityBonusRadii[Index] = MultiTargetStyleEdit.AbilityBonusRadii[i];
				}
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusRadiiMode == eNAEM_Remove)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusRadii.Length; ++i)
			{
				for (j = RadiusStyle.AbilityBonusRadii.Length - 1; j >= 0; --j)
				{
					if (RadiusStyle.AbilityBonusRadii[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusRadii[i].RequiredAbility)
					{
						RadiusStyle.AbilityBonusRadii.Remove(j, 1);
					}
				}
			}
		}
	}
}
