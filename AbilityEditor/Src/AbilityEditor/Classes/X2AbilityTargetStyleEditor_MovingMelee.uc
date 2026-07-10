class X2AbilityTargetStyleEditor_MovingMelee extends X2AbilityTargetStyleEditor_Single;

static function bool CanEdit(X2AbilityTargetStyle TargetStyle)
{
	return TargetStyle.IsA('X2AbilityTarget_MovingMelee');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	local X2AbilityTarget_MovingMelee MeleeStyle;

	super.ApplyDerivedEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);

	MeleeStyle = X2AbilityTarget_MovingMelee(TargetStyle);

	if (MeleeStyle == none)
	{
		return;
	}

	if (TargetStyleEdit.SetMovementRangeAdjustment)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MovementRangeAdjustment",
			string(MeleeStyle.MovementRangeAdjustment),
			string(TargetStyleEdit.MovementRangeAdjustment)
		);

		MeleeStyle.MovementRangeAdjustment = TargetStyleEdit.MovementRangeAdjustment;
	}
}
