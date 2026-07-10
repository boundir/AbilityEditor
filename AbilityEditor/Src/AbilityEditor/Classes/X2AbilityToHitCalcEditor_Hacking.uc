class X2AbilityToHitCalcEditor_Hacking extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_Hacking');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_Hacking HackingCalc;

	HackingCalc = X2AbilityToHitCalc_Hacking(ToHitCalc);

	if (HackingCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetAlwaysSucceed)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAlwaysSucceed",
			string(HackingCalc.bAlwaysSucceed),
			string(ToHitCalcEdit.AlwaysSucceed)
		);

		HackingCalc.bAlwaysSucceed = ToHitCalcEdit.AlwaysSucceed;
	}
}
