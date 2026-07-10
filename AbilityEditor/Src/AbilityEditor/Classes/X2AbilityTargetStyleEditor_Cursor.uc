class X2AbilityTargetStyleEditor_Cursor extends X2AbilityTargetStyleEditor_Base;

static function bool CanEdit(X2AbilityTargetStyle TargetStyle)
{
	return TargetStyle.IsA('X2AbilityTarget_Cursor');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	local X2AbilityTarget_Cursor CursorStyle;

	CursorStyle = X2AbilityTarget_Cursor(TargetStyle);

	if (CursorStyle == none)
	{
		return;
	}

	if (TargetStyleEdit.SetRestrictToWeaponRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRestrictToWeaponRange",
			string(CursorStyle.bRestrictToWeaponRange),
			string(TargetStyleEdit.RestrictToWeaponRange)
		);

		CursorStyle.bRestrictToWeaponRange = TargetStyleEdit.RestrictToWeaponRange;
	}

	if (TargetStyleEdit.SetIncreaseWeaponRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IncreaseWeaponRange",
			string(CursorStyle.IncreaseWeaponRange),
			string(TargetStyleEdit.IncreaseWeaponRange)
		);

		CursorStyle.IncreaseWeaponRange = TargetStyleEdit.IncreaseWeaponRange;
	}

	if (TargetStyleEdit.SetRestrictToSquadsightRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRestrictToSquadsightRange",
			string(CursorStyle.bRestrictToSquadsightRange),
			string(TargetStyleEdit.RestrictToSquadsightRange)
		);

		CursorStyle.bRestrictToSquadsightRange = TargetStyleEdit.RestrictToSquadsightRange;
	}

	if (TargetStyleEdit.SetFixedAbilityRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FixedAbilityRange",
			string(CursorStyle.FixedAbilityRange),
			string(TargetStyleEdit.FixedAbilityRange)
		);

		CursorStyle.FixedAbilityRange = TargetStyleEdit.FixedAbilityRange;
	}
}
