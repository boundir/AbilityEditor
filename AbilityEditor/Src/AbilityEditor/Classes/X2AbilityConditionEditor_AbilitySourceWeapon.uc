class X2AbilityConditionEditor_AbilitySourceWeapon extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_AbilitySourceWeapon');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_AbilitySourceWeapon WeaponCondition;

	WeaponCondition = X2Condition_AbilitySourceWeapon(Condition);

	if (WeaponCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetWantsReload)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WantsReload",
			string(WeaponCondition.WantsReload),
			string(ConditionEdit.WantsReload)
		);

		WeaponCondition.WantsReload = ConditionEdit.WantsReload;
	}

	if (ConditionEdit.SetCheckAmmo)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CheckAmmo",
			string(WeaponCondition.CheckAmmo),
			string(ConditionEdit.CheckAmmo)
		);

		WeaponCondition.CheckAmmo = ConditionEdit.CheckAmmo;
	}

	if (ConditionEdit.SetCheckAmmoData)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CheckAmmoData",
			"(CheckConfig)",
			"(CheckConfig)"
		);

		WeaponCondition.CheckAmmoData = ConditionEdit.CheckAmmoData;
	}

	if (ConditionEdit.SetNotLoadedAmmoInSecondaryWeapon)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NotLoadedAmmoInSecondaryWeapon",
			string(WeaponCondition.NotLoadedAmmoInSecondaryWeapon),
			string(ConditionEdit.NotLoadedAmmoInSecondaryWeapon)
		);

		WeaponCondition.NotLoadedAmmoInSecondaryWeapon = ConditionEdit.NotLoadedAmmoInSecondaryWeapon;
	}

	if (ConditionEdit.SetMatchGrenadeType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MatchGrenadeType",
			string(WeaponCondition.MatchGrenadeType),
			string(ConditionEdit.MatchGrenadeType)
		);

		WeaponCondition.MatchGrenadeType = ConditionEdit.MatchGrenadeType;
	}

	if (ConditionEdit.SetCheckGrenadeFriendlyFire)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CheckGrenadeFriendlyFire",
			string(WeaponCondition.CheckGrenadeFriendlyFire),
			string(ConditionEdit.CheckGrenadeFriendlyFire)
		);

		WeaponCondition.CheckGrenadeFriendlyFire = ConditionEdit.CheckGrenadeFriendlyFire;
	}

	if (ConditionEdit.SetCheckAmmoTechLevel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CheckAmmoTechLevel",
			string(WeaponCondition.CheckAmmoTechLevel),
			string(ConditionEdit.CheckAmmoTechLevel)
		);

		WeaponCondition.CheckAmmoTechLevel = ConditionEdit.CheckAmmoTechLevel;
	}

	if (ConditionEdit.SetMatchWeaponTemplate)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MatchWeaponTemplate",
			string(WeaponCondition.MatchWeaponTemplate),
			string(ConditionEdit.MatchWeaponTemplate)
		);

		WeaponCondition.MatchWeaponTemplate = ConditionEdit.MatchWeaponTemplate;
	}
}
