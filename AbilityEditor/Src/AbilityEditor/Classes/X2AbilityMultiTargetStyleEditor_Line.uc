class X2AbilityMultiTargetStyleEditor_Line extends X2AbilityMultiTargetStyleEditor_Base;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_Line');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_Line LineStyle;
	local int i, j, Index;

	LineStyle = X2AbilityMultiTarget_Line(MultiTargetStyle);

	if (LineStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetTileWidthExtension)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TileWidthExtension",
			string(LineStyle.TileWidthExtension),
			string(MultiTargetStyleEdit.TileWidthExtension)
		);

		LineStyle.TileWidthExtension = MultiTargetStyleEdit.TileWidthExtension;
	}

	if (MultiTargetStyleEdit.SetSightRangeLimited)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSightRangeLimited",
			string(LineStyle.bSightRangeLimited),
			string(MultiTargetStyleEdit.SightRangeLimited)
		);

		LineStyle.bSightRangeLimited = MultiTargetStyleEdit.SightRangeLimited;
	}

	if (MultiTargetStyleEdit.AbilityBonusWidths.Length > 0)
	{
		if (MultiTargetStyleEdit.AbilityBonusWidthsMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".AbilityBonusWidths replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			LineStyle.AbilityBonusWidths = MultiTargetStyleEdit.AbilityBonusWidths;
		}
		else if (MultiTargetStyleEdit.AbilityBonusWidthsMode == eNAEM_AddOnly)
		{
			if (LineStyle.AbilityBonusWidths.Length == 0)
			{
				LineStyle.AbilityBonusWidths = MultiTargetStyleEdit.AbilityBonusWidths;
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusWidthsMode == eNAEM_Merge)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusWidths.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < LineStyle.AbilityBonusWidths.Length; ++j)
				{
					if (LineStyle.AbilityBonusWidths[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusWidths[i].RequiredAbility)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					LineStyle.AbilityBonusWidths.AddItem(MultiTargetStyleEdit.AbilityBonusWidths[i]);
				}
				else
				{
					LineStyle.AbilityBonusWidths[Index] = MultiTargetStyleEdit.AbilityBonusWidths[i];
				}
			}
		}
		else if (MultiTargetStyleEdit.AbilityBonusWidthsMode == eNAEM_Remove)
		{
			for (i = 0; i < MultiTargetStyleEdit.AbilityBonusWidths.Length; ++i)
			{
				for (j = LineStyle.AbilityBonusWidths.Length - 1; j >= 0; --j)
				{
					if (LineStyle.AbilityBonusWidths[j].RequiredAbility == MultiTargetStyleEdit.AbilityBonusWidths[i].RequiredAbility)
					{
						LineStyle.AbilityBonusWidths.Remove(j, 1);
					}
				}
			}
		}
	}
}
