class X2AbilityToHitCalcEditor_RollStat extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_RollStat');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_RollStat RollStatCalc;

	RollStatCalc = X2AbilityToHitCalc_RollStat(ToHitCalc);

	if (RollStatCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetStatToRoll)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StatToRoll",
			string(RollStatCalc.StatToRoll),
			string(ToHitCalcEdit.StatToRoll)
		);

		RollStatCalc.StatToRoll = ToHitCalcEdit.StatToRoll;
	}

	if (ToHitCalcEdit.SetBaseChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BaseChance",
			string(RollStatCalc.BaseChance),
			string(ToHitCalcEdit.BaseChance)
		);

		RollStatCalc.BaseChance = ToHitCalcEdit.BaseChance;
	}
}
