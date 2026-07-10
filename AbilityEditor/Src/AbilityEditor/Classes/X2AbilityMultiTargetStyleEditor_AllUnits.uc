class X2AbilityMultiTargetStyleEditor_AllUnits extends X2AbilityMultiTargetStyleEditor_Radius;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_AllUnits');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_AllUnits AllUnitsStyle;

	super.ApplyDerivedEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);

	AllUnitsStyle = X2AbilityMultiTarget_AllUnits(MultiTargetStyle);

	if (AllUnitsStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetOnlyAllyOfType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OnlyAllyOfType",
			string(AllUnitsStyle.OnlyAllyOfType),
			string(MultiTargetStyleEdit.OnlyAllyOfType)
		);

		AllUnitsStyle.OnlyAllyOfType = MultiTargetStyleEdit.OnlyAllyOfType;
	}

	if (MultiTargetStyleEdit.SetAcceptFriendlyUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAcceptFriendlyUnits",
			string(AllUnitsStyle.bAcceptFriendlyUnits),
			string(MultiTargetStyleEdit.AcceptFriendlyUnits)
		);

		AllUnitsStyle.bAcceptFriendlyUnits = MultiTargetStyleEdit.AcceptFriendlyUnits;
	}

	if (MultiTargetStyleEdit.SetAcceptEnemyUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAcceptEnemyUnits",
			string(AllUnitsStyle.bAcceptEnemyUnits),
			string(MultiTargetStyleEdit.AcceptEnemyUnits)
		);

		AllUnitsStyle.bAcceptEnemyUnits = MultiTargetStyleEdit.AcceptEnemyUnits;
	}

	if (MultiTargetStyleEdit.SetOnlyAcceptRoboticUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyAcceptRoboticUnits",
			string(AllUnitsStyle.bOnlyAcceptRoboticUnits),
			string(MultiTargetStyleEdit.OnlyAcceptRoboticUnits)
		);

		AllUnitsStyle.bOnlyAcceptRoboticUnits = MultiTargetStyleEdit.OnlyAcceptRoboticUnits;
	}

	if (MultiTargetStyleEdit.SetOnlyAcceptAlienUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyAcceptAlienUnits",
			string(AllUnitsStyle.bOnlyAcceptAlienUnits),
			string(MultiTargetStyleEdit.OnlyAcceptAlienUnits)
		);

		AllUnitsStyle.bOnlyAcceptAlienUnits = MultiTargetStyleEdit.OnlyAcceptAlienUnits;
	}

	if (MultiTargetStyleEdit.SetOnlyAcceptAdventUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyAcceptAdventUnits",
			string(AllUnitsStyle.bOnlyAcceptAdventUnits),
			string(MultiTargetStyleEdit.OnlyAcceptAdventUnits)
		);

		AllUnitsStyle.bOnlyAcceptAdventUnits = MultiTargetStyleEdit.OnlyAcceptAdventUnits;
	}

	if (MultiTargetStyleEdit.SetRandomlySelectOne)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRandomlySelectOne",
			string(AllUnitsStyle.bRandomlySelectOne),
			string(MultiTargetStyleEdit.RandomlySelectOne)
		);

		AllUnitsStyle.bRandomlySelectOne = MultiTargetStyleEdit.RandomlySelectOne;
	}

	if (MultiTargetStyleEdit.SetDontAcceptNeutralUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDontAcceptNeutralUnits",
			string(AllUnitsStyle.bDontAcceptNeutralUnits),
			string(MultiTargetStyleEdit.DontAcceptNeutralUnits)
		);

		AllUnitsStyle.bDontAcceptNeutralUnits = MultiTargetStyleEdit.DontAcceptNeutralUnits;
	}

	if (MultiTargetStyleEdit.SetRandomChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RandomChance",
			string(AllUnitsStyle.RandomChance),
			string(MultiTargetStyleEdit.RandomChance)
		);

		AllUnitsStyle.RandomChance = MultiTargetStyleEdit.RandomChance;
	}

	if (MultiTargetStyleEdit.SetUseAbilitySourceAsPrimaryTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseAbilitySourceAsPrimaryTarget",
			string(AllUnitsStyle.bUseAbilitySourceAsPrimaryTarget),
			string(MultiTargetStyleEdit.UseAbilitySourceAsPrimaryTarget)
		);

		AllUnitsStyle.bUseAbilitySourceAsPrimaryTarget = MultiTargetStyleEdit.UseAbilitySourceAsPrimaryTarget;
	}
}
