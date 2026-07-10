class X2AbilityEffectsEditor_ApplyDirectionalWorldDamage extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyDirectionalWorldDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyDirectionalWorldDamage ApplyDirectionalWorldDamageFX;

	ApplyDirectionalWorldDamageFX = X2Effect_ApplyDirectionalWorldDamage(Effect);

	if (ApplyDirectionalWorldDamageFX == none)
	{
		return;
	}

	if (EffectEdit.SetEnvironmentalDamageAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EnvironmentalDamageAmount",
			string(ApplyDirectionalWorldDamageFX.EnvironmentalDamageAmount),
			string(EffectEdit.EnvironmentalDamageAmount)
		);

		ApplyDirectionalWorldDamageFX.EnvironmentalDamageAmount = EffectEdit.EnvironmentalDamageAmount;
	}

	if (EffectEdit.SetDamageTypeTemplateName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageTypeTemplateName",
			string(ApplyDirectionalWorldDamageFX.DamageTypeTemplateName),
			string(EffectEdit.DamageTypeTemplateName)
		);

		ApplyDirectionalWorldDamageFX.DamageTypeTemplateName = EffectEdit.DamageTypeTemplateName;
	}

	if (EffectEdit.SetPlusNumZTiles)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PlusNumZTiles",
			string(ApplyDirectionalWorldDamageFX.PlusNumZTiles),
			string(EffectEdit.PlusNumZTiles)
		);

		ApplyDirectionalWorldDamageFX.PlusNumZTiles = EffectEdit.PlusNumZTiles;
	}

	if (EffectEdit.SetUseWeaponEnvironmentalDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponEnvironmentalDamage",
			string(ApplyDirectionalWorldDamageFX.bUseWeaponEnvironmentalDamage),
			string(EffectEdit.UseWeaponEnvironmentalDamage)
		);

		ApplyDirectionalWorldDamageFX.bUseWeaponEnvironmentalDamage = EffectEdit.UseWeaponEnvironmentalDamage;
	}

	if (EffectEdit.SetUseWeaponDamageType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponDamageType",
			string(ApplyDirectionalWorldDamageFX.bUseWeaponDamageType),
			string(EffectEdit.UseWeaponDamageType)
		);

		ApplyDirectionalWorldDamageFX.bUseWeaponDamageType = EffectEdit.UseWeaponDamageType;
	}

	if (EffectEdit.SetHitSourceTile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHitSourceTile",
			string(ApplyDirectionalWorldDamageFX.bHitSourceTile),
			string(EffectEdit.HitSourceTile)
		);

		ApplyDirectionalWorldDamageFX.bHitSourceTile = EffectEdit.HitSourceTile;
	}

	if (EffectEdit.SetHitTargetTile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHitTargetTile",
			string(ApplyDirectionalWorldDamageFX.bHitTargetTile),
			string(EffectEdit.HitTargetTile)
		);

		ApplyDirectionalWorldDamageFX.bHitTargetTile = EffectEdit.HitTargetTile;
	}

	if (EffectEdit.SetHitAdjacentDestructibles)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHitAdjacentDestructibles",
			string(ApplyDirectionalWorldDamageFX.bHitAdjacentDestructibles),
			string(EffectEdit.HitAdjacentDestructibles)
		);

		ApplyDirectionalWorldDamageFX.bHitAdjacentDestructibles = EffectEdit.HitAdjacentDestructibles;
	}

	if (EffectEdit.SetAllowDestructionOfDamageCauseCover)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowDestructionOfDamageCauseCover",
			string(ApplyDirectionalWorldDamageFX.bAllowDestructionOfDamageCauseCover),
			string(EffectEdit.AllowDestructionOfDamageCauseCover)
		);

		ApplyDirectionalWorldDamageFX.bAllowDestructionOfDamageCauseCover = EffectEdit.AllowDestructionOfDamageCauseCover;
	}
}
