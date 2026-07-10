class X2AbilityMultiTargetStyleEditor_Cylinder extends X2AbilityMultiTargetStyleEditor_Radius;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_Cylinder');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_Cylinder CylinderStyle;

	super.ApplyDerivedEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);

	CylinderStyle = X2AbilityMultiTarget_Cylinder(MultiTargetStyle);

	if (CylinderStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetTargetHeight)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".fTargetHeight",
			string(CylinderStyle.fTargetHeight),
			string(MultiTargetStyleEdit.TargetHeight)
		);

		CylinderStyle.fTargetHeight = MultiTargetStyleEdit.TargetHeight;
	}

	if (MultiTargetStyleEdit.SetUseOnlyGroundTiles)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseOnlyGroundTiles",
			string(CylinderStyle.bUseOnlyGroundTiles),
			string(MultiTargetStyleEdit.UseOnlyGroundTiles)
		);

		CylinderStyle.bUseOnlyGroundTiles = MultiTargetStyleEdit.UseOnlyGroundTiles;
	}
}
