class X2AbilityMultiTargetStyleEditor_BurstFire extends X2AbilityMultiTargetStyleEditor_Base;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_BurstFire');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_BurstFire BurstStyle;

	BurstStyle = X2AbilityMultiTarget_BurstFire(MultiTargetStyle);

	if (BurstStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetNumExtraShots)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumExtraShots",
			string(BurstStyle.NumExtraShots),
			string(MultiTargetStyleEdit.NumExtraShots)
		);

		BurstStyle.NumExtraShots = MultiTargetStyleEdit.NumExtraShots;
	}
}
