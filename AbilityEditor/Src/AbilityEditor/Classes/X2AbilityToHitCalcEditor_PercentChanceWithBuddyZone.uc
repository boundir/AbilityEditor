class X2AbilityToHitCalcEditor_PercentChanceWithBuddyZone extends X2AbilityToHitCalcEditor_PercentChance;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_PercentChanceWithBuddyZone');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_PercentChanceWithBuddyZone BuddyCalc;

	super.ApplyDerivedEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);

	BuddyCalc = X2AbilityToHitCalc_PercentChanceWithBuddyZone(ToHitCalc);

	if (BuddyCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetPercentToHitInBuddyZone)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PercentToHitInBuddyZone",
			string(BuddyCalc.PercentToHitInBuddyZone),
			string(ToHitCalcEdit.PercentToHitInBuddyZone)
		);

		BuddyCalc.PercentToHitInBuddyZone = ToHitCalcEdit.PercentToHitInBuddyZone;
	}
}
