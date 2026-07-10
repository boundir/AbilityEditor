class X2AbilityToHitCalcEditor_PercentChance extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_PercentChance');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_PercentChance PercentCalc;

	PercentCalc = X2AbilityToHitCalc_PercentChance(ToHitCalc);

	if (PercentCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetPercentToHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PercentToHit",
			string(PercentCalc.PercentToHit),
			string(ToHitCalcEdit.PercentToHit)
		);

		PercentCalc.PercentToHit = ToHitCalcEdit.PercentToHit;
	}

	if (ToHitCalcEdit.SetNoGameStateOnMiss)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bNoGameStateOnMiss",
			string(PercentCalc.bNoGameStateOnMiss),
			string(ToHitCalcEdit.NoGameStateOnMiss)
		);

		PercentCalc.bNoGameStateOnMiss = ToHitCalcEdit.NoGameStateOnMiss;
	}
}
