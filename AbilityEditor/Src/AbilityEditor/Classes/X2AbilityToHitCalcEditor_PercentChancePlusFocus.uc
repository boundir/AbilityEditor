class X2AbilityToHitCalcEditor_PercentChancePlusFocus extends X2AbilityToHitCalcEditor_PercentChance;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_PercentChancePlusFocus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_PercentChancePlusFocus FocusCalc;

	super.ApplyDerivedEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);

	FocusCalc = X2AbilityToHitCalc_PercentChancePlusFocus(ToHitCalc);

	if (FocusCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetFocusMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FocusMultiplier",
			string(FocusCalc.FocusMultiplier),
			string(ToHitCalcEdit.FocusMultiplier)
		);

		FocusCalc.FocusMultiplier = ToHitCalcEdit.FocusMultiplier;
	}
}
