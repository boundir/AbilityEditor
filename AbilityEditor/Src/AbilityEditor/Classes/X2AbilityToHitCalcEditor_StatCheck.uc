class X2AbilityToHitCalcEditor_StatCheck extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_StatCheck');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_StatCheck StatCheckCalc;

	StatCheckCalc = X2AbilityToHitCalc_StatCheck(ToHitCalc);

	if (StatCheckCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetBaseValue)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BaseValue",
			string(StatCheckCalc.BaseValue),
			string(ToHitCalcEdit.BaseValue)
		);

		StatCheckCalc.BaseValue = ToHitCalcEdit.BaseValue;
	}
}
