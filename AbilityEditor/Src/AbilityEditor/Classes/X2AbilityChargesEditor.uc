class X2AbilityChargesEditor extends Object abstract;

static function bool CanEdit(X2AbilityCharges AbilityCharge);

static function ApplyEdit(name AbilityName, X2AbilityCharges AbilityCharge, ChargesEdit ChargesEdit)
{
	ApplyBaseEdit(AbilityName, AbilityCharge, ChargesEdit);
	ApplyDerivedEdit(AbilityName, AbilityCharge, ChargesEdit);
}

static function ApplyBaseEdit(name AbilityName, X2AbilityCharges AbilityCharge, ChargesEdit ChargesEdit)
{
	local int i, Index;
	local BonusChargeEdit EditBonus;
	local BonusCharge Bonus;

	// RemoveCharges is handled by X2AbilityChargesEditor_Helper.ApplyChargesEdit
	// (it must clear Template.AbilityCharges, which is out of reach here).

	if (ChargesEdit.SetInitialCharges)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AbilityCharge.InitialCharges",
			string(AbilityCharge.InitialCharges),
			string(ChargesEdit.InitialCharges)
		);

		AbilityCharge.InitialCharges = ChargesEdit.InitialCharges;
	}

	// Length guard: an empty edit must not clear existing bonus charges
	if (ChargesEdit.BonusCharges.Length == 0)
	{
		return;
	}

	if (ChargesEdit.BonusChargesMode == eCBM_Replace)
	{
		`log(string(AbilityName) @ "bonus charges replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		AbilityCharge.BonusCharges.Length = 0;
	}

	for (i = 0; i < ChargesEdit.BonusCharges.Length; ++i)
	{
		EditBonus = ChargesEdit.BonusCharges[i];

		Index = class'X2AbilityChargesEditor_Helper'.static.FindBonusChargeIndex(
			AbilityCharge.BonusCharges,
			EditBonus.AbilityName
		);

		if (Index == INDEX_NONE)
		{
			Bonus.AbilityName = EditBonus.AbilityName;
			Bonus.NumCharges = 0;

			Index = AbilityCharge.BonusCharges.Length;
			AbilityCharge.BonusCharges.AddItem(Bonus);
		}

		if (EditBonus.SetNumCharges)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"BonusCharges.NumCharges",
				string(AbilityCharge.BonusCharges[Index].NumCharges),
				string(EditBonus.NumCharges)
			);

			AbilityCharge.BonusCharges[Index].NumCharges = EditBonus.NumCharges;
		}
	}
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCharges AbilityCharge, ChargesEdit ChargesEdit)
{
}
