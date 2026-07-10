class X2AbilityToHitCalcEditor_RollStatTiers extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_RollStatTiers');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_RollStatTiers RollTiersCalc;

	RollTiersCalc = X2AbilityToHitCalc_RollStatTiers(ToHitCalc);

	if (RollTiersCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetStatToRoll)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StatToRoll",
			string(RollTiersCalc.StatToRoll),
			string(ToHitCalcEdit.StatToRoll)
		);

		RollTiersCalc.StatToRoll = ToHitCalcEdit.StatToRoll;
	}
}
