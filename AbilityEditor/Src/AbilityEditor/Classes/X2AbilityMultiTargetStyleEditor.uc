class X2AbilityMultiTargetStyleEditor extends Object abstract;

static function bool CanEdit(X2AbilityMultiTargetStyle MultiTargetStyle);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);
	ApplyDerivedEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	if (MultiTargetStyleEdit.SetAllowSameTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowSameTarget",
			string(MultiTargetStyle.bAllowSameTarget),
			string(MultiTargetStyleEdit.AllowSameTarget)
		);

		MultiTargetStyle.bAllowSameTarget = MultiTargetStyleEdit.AllowSameTarget;
	}

	if (MultiTargetStyleEdit.SetUseSourceWeaponLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseSourceWeaponLocation",
			string(MultiTargetStyle.bUseSourceWeaponLocation),
			string(MultiTargetStyleEdit.UseSourceWeaponLocation)
		);

		MultiTargetStyle.bUseSourceWeaponLocation = MultiTargetStyleEdit.UseSourceWeaponLocation;
	}

	if (MultiTargetStyleEdit.SetNumTargetsRequired)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumTargetsRequired",
			string(MultiTargetStyle.NumTargetsRequired),
			string(MultiTargetStyleEdit.NumTargetsRequired)
		);

		MultiTargetStyle.NumTargetsRequired = MultiTargetStyleEdit.NumTargetsRequired;
	}
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
);