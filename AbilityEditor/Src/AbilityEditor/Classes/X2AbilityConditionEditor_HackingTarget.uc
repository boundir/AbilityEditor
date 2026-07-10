class X2AbilityConditionEditor_HackingTarget extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_HackingTarget');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_HackingTarget HackingTargetCond;

	HackingTargetCond = X2Condition_HackingTarget(Condition);

	if (HackingTargetCond == none)
	{
		return;
	}

	if (ConditionEdit.SetIntrusionProtocol)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIntrusionProtocol",
			string(HackingTargetCond.bIntrusionProtocol),
			string(ConditionEdit.IntrusionProtocol)
		);

		HackingTargetCond.bIntrusionProtocol = ConditionEdit.IntrusionProtocol;
	}

	if (ConditionEdit.SetHaywireProtocol)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHaywireProtocol",
			string(HackingTargetCond.bHaywireProtocol),
			string(ConditionEdit.HaywireProtocol)
		);

		HackingTargetCond.bHaywireProtocol = ConditionEdit.HaywireProtocol;
	}

	if (ConditionEdit.SetRequiredAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequiredAbilityName",
			string(HackingTargetCond.RequiredAbilityName),
			string(ConditionEdit.RequiredAbilityName)
		);

		HackingTargetCond.RequiredAbilityName = ConditionEdit.RequiredAbilityName;
	}

	if (ConditionEdit.SetMustBeDoor)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bMustBeDoor",
			string(HackingTargetCond.bMustBeDoor),
			string(ConditionEdit.MustBeDoor)
		);

		HackingTargetCond.bMustBeDoor = ConditionEdit.MustBeDoor;
	}
}
