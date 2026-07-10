class X2AbilityEffectsEditor_BonusWeaponDamage extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BonusWeaponDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BonusWeaponDamage BonusWeaponDamageFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BonusWeaponDamageFX = X2Effect_BonusWeaponDamage(Effect);

	if (BonusWeaponDamageFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDmg)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDmg",
			string(BonusWeaponDamageFX.BonusDmg),
			string(EffectEdit.BonusDmg)
		);

		BonusWeaponDamageFX.BonusDmg = EffectEdit.BonusDmg;
	}
}
