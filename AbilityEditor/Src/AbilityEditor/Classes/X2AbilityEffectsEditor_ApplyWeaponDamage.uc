class X2AbilityEffectsEditor_ApplyWeaponDamage extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyWeaponDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(Effect);

	if (EffectEdit.SetExplosiveDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bExplosiveDamage",
			string(WeaponDamageEffect.bExplosiveDamage),
			string(EffectEdit.ExplosiveDamage)
		);

		WeaponDamageEffect.bExplosiveDamage = EffectEdit.ExplosiveDamage;
	}

	if (EffectEdit.SetIgnoreBaseDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIgnoreBaseDamage",
			string(WeaponDamageEffect.bIgnoreBaseDamage),
			string(EffectEdit.IgnoreBaseDamage)
		);

		WeaponDamageEffect.bIgnoreBaseDamage = EffectEdit.IgnoreBaseDamage;
	}

	if (EffectEdit.SetDamageTag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageTag",
			string(WeaponDamageEffect.DamageTag),
			string(EffectEdit.DamageTag)
		);

		WeaponDamageEffect.DamageTag = EffectEdit.DamageTag;
	}

	if (EffectEdit.SetAlwaysKillsCivilians)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAlwaysKillsCivilians",
			string(WeaponDamageEffect.bAlwaysKillsCivilians),
			string(EffectEdit.AlwaysKillsCivilians)
		);

		WeaponDamageEffect.bAlwaysKillsCivilians = EffectEdit.AlwaysKillsCivilians;
	}

	if (EffectEdit.SetApplyWorldEffectsForEachTargetLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyWorldEffectsForEachTargetLocation",
			string(WeaponDamageEffect.bApplyWorldEffectsForEachTargetLocation),
			string(EffectEdit.ApplyWorldEffectsForEachTargetLocation)
		);

		WeaponDamageEffect.bApplyWorldEffectsForEachTargetLocation = EffectEdit.ApplyWorldEffectsForEachTargetLocation;
	}

	if (EffectEdit.SetAllowFreeKill)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowFreeKill",
			string(WeaponDamageEffect.bAllowFreeKill),
			string(EffectEdit.AllowFreeKill)
		);

		WeaponDamageEffect.bAllowFreeKill = EffectEdit.AllowFreeKill;
	}

	if (EffectEdit.SetAllowWeaponUpgrade)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowWeaponUpgrade",
			string(WeaponDamageEffect.bAllowWeaponUpgrade),
			string(EffectEdit.AllowWeaponUpgrade)
		);

		WeaponDamageEffect.bAllowWeaponUpgrade = EffectEdit.AllowWeaponUpgrade;
	}

	if (EffectEdit.SetBypassShields)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bBypassShields",
			string(WeaponDamageEffect.bBypassShields),
			string(EffectEdit.BypassShields)
		);

		WeaponDamageEffect.bBypassShields = EffectEdit.BypassShields;
	}

	if (EffectEdit.SetIgnoreArmor)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIgnoreArmor",
			string(WeaponDamageEffect.bIgnoreArmor),
			string(EffectEdit.IgnoreArmor)
		);

		WeaponDamageEffect.bIgnoreArmor = EffectEdit.IgnoreArmor;
	}

	if (EffectEdit.SetBypassSustainEffects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bBypassSustainEffects",
			string(WeaponDamageEffect.bBypassSustainEffects),
			string(EffectEdit.BypassSustainEffects)
		);

		WeaponDamageEffect.bBypassSustainEffects = EffectEdit.BypassSustainEffects;
	}

	if (EffectEdit.SetEnvironmentalDamageAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EnvironmentalDamageAmount",
			string(WeaponDamageEffect.EnvironmentalDamageAmount),
			string(EffectEdit.EnvironmentalDamageAmount)
		);

		WeaponDamageEffect.EnvironmentalDamageAmount = EffectEdit.EnvironmentalDamageAmount;
	}

	ApplyWeaponDamageValueEdit(
		AbilityName,
		Slot,
		WeaponDamageEffect,
		EffectEdit.WeaponDamageValue
	);
}

static function ApplyWeaponDamageValueEdit(
	name AbilityName,
	string Slot,
	X2Effect_ApplyWeaponDamage DamageEffect,
	WeaponDamageValueEdit WeaponDamageEdit
)
{
	if (WeaponDamageEdit.SetDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Damage",
			string(DamageEffect.EffectDamageValue.Damage),
			string(WeaponDamageEdit.Damage)
		);

		DamageEffect.EffectDamageValue.Damage = WeaponDamageEdit.Damage;
	}

	if (WeaponDamageEdit.SetSpread)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Spread",
			string(DamageEffect.EffectDamageValue.Spread),
			string(WeaponDamageEdit.Spread)
		);

		DamageEffect.EffectDamageValue.Spread = WeaponDamageEdit.Spread;
	}

	if (WeaponDamageEdit.SetPlusOne)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.PlusOne",
			string(DamageEffect.EffectDamageValue.PlusOne),
			string(WeaponDamageEdit.PlusOne)
		);

		DamageEffect.EffectDamageValue.PlusOne = WeaponDamageEdit.PlusOne;
	}

	if (WeaponDamageEdit.SetCrit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Crit",
			string(DamageEffect.EffectDamageValue.Crit),
			string(WeaponDamageEdit.Crit)
		);

		DamageEffect.EffectDamageValue.Crit = WeaponDamageEdit.Crit;
	}

	if (WeaponDamageEdit.SetPierce)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Pierce",
			string(DamageEffect.EffectDamageValue.Pierce),
			string(WeaponDamageEdit.Pierce)
		);

		DamageEffect.EffectDamageValue.Pierce = WeaponDamageEdit.Pierce;
	}

	if (WeaponDamageEdit.SetRupture)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Rupture",
			string(DamageEffect.EffectDamageValue.Rupture),
			string(WeaponDamageEdit.Rupture)
		);

		DamageEffect.EffectDamageValue.Rupture = WeaponDamageEdit.Rupture;
	}

	if (WeaponDamageEdit.SetShred)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Shred",
			string(DamageEffect.EffectDamageValue.Shred),
			string(WeaponDamageEdit.Shred)
		);

		DamageEffect.EffectDamageValue.Shred = WeaponDamageEdit.Shred;
	}

	if (WeaponDamageEdit.SetTag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.Tag",
			string(DamageEffect.EffectDamageValue.Tag),
			string(WeaponDamageEdit.Tag)
		);

		DamageEffect.EffectDamageValue.Tag = WeaponDamageEdit.Tag;
	}

	if (WeaponDamageEdit.SetDamageType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectDamageValue.DamageType",
			string(DamageEffect.EffectDamageValue.DamageType),
			string(WeaponDamageEdit.DamageType)
		);

		DamageEffect.EffectDamageValue.DamageType = WeaponDamageEdit.DamageType;
	}
}
