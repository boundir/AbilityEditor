class X2AbilityToHitCalcEditor_StatCheck_UnitVsUnit extends X2AbilityToHitCalcEditor_StatCheck;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_StatCheck_UnitVsUnit');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit UnitVsUnitCalc;

	super.ApplyDerivedEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);

	UnitVsUnitCalc = X2AbilityToHitCalc_StatCheck_UnitVsUnit(ToHitCalc);

	if (UnitVsUnitCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetAttackerStat)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AttackerStat",
			string(UnitVsUnitCalc.AttackerStat),
			string(ToHitCalcEdit.AttackerStat)
		);

		UnitVsUnitCalc.AttackerStat = ToHitCalcEdit.AttackerStat;
	}

	if (ToHitCalcEdit.SetDefenderStat)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DefenderStat",
			string(UnitVsUnitCalc.DefenderStat),
			string(ToHitCalcEdit.DefenderStat)
		);

		UnitVsUnitCalc.DefenderStat = ToHitCalcEdit.DefenderStat;
	}
}
