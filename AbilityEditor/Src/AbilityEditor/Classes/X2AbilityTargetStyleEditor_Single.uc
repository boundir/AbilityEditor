class X2AbilityTargetStyleEditor_Single extends X2AbilityTargetStyleEditor_Base;

static function bool CanEdit(X2AbilityTargetStyle TargetStyle)
{
	return TargetStyle.IsA('X2AbilityTarget_Single');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	local X2AbilityTarget_Single SingleStyle;

	SingleStyle = X2AbilityTarget_Single(TargetStyle);

	if (SingleStyle == none)
	{
		return;
	}

	if (TargetStyleEdit.SetOnlyIncludeTargetsInsideWeaponRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OnlyIncludeTargetsInsideWeaponRange",
			string(SingleStyle.OnlyIncludeTargetsInsideWeaponRange),
			string(TargetStyleEdit.OnlyIncludeTargetsInsideWeaponRange)
		);

		SingleStyle.OnlyIncludeTargetsInsideWeaponRange = TargetStyleEdit.OnlyIncludeTargetsInsideWeaponRange;
	}

	if (TargetStyleEdit.SetAllowInteractiveObjects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowInteractiveObjects",
			string(SingleStyle.bAllowInteractiveObjects),
			string(TargetStyleEdit.AllowInteractiveObjects)
		);

		SingleStyle.bAllowInteractiveObjects = TargetStyleEdit.AllowInteractiveObjects;
	}

	if (TargetStyleEdit.SetAllowDestructibleObjects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowDestructibleObjects",
			string(SingleStyle.bAllowDestructibleObjects),
			string(TargetStyleEdit.AllowDestructibleObjects)
		);

		SingleStyle.bAllowDestructibleObjects = TargetStyleEdit.AllowDestructibleObjects;
	}

	if (TargetStyleEdit.SetIncludeSelf)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIncludeSelf",
			string(SingleStyle.bIncludeSelf),
			string(TargetStyleEdit.IncludeSelf)
		);

		SingleStyle.bIncludeSelf = TargetStyleEdit.IncludeSelf;
	}

	if (TargetStyleEdit.SetShowAOE)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bShowAOE",
			string(SingleStyle.bShowAOE),
			string(TargetStyleEdit.ShowAOE)
		);

		SingleStyle.bShowAOE = TargetStyleEdit.ShowAOE;
	}
}
