class X2AbilityMultiTargetStyleEditor_ClaymoreRadius extends X2AbilityMultiTargetStyleEditor_Radius;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle)
{
	return MultiTargetStyle.IsA('X2AbilityMultiTarget_ClaymoreRadius');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTarget_ClaymoreRadius ClaymoreStyle;

	super.ApplyDerivedEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);

	ClaymoreStyle = X2AbilityMultiTarget_ClaymoreRadius(MultiTargetStyle);

	if (ClaymoreStyle == none)
	{
		return;
	}

	if (MultiTargetStyleEdit.SetClaymoreEnvironmentalDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ClaymoreEnvironmentalDamage",
			string(ClaymoreStyle.ClaymoreEnvironmentalDamage),
			string(MultiTargetStyleEdit.ClaymoreEnvironmentalDamage)
		);

		ClaymoreStyle.ClaymoreEnvironmentalDamage = MultiTargetStyleEdit.ClaymoreEnvironmentalDamage;
	}
}
