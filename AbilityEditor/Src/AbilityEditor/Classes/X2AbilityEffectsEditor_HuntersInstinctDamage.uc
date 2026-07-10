class X2AbilityEffectsEditor_HuntersInstinctDamage extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_HuntersInstinctDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_HuntersInstinctDamage HuntersInstinctDamageFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	HuntersInstinctDamageFX = X2Effect_HuntersInstinctDamage(Effect);

	if (HuntersInstinctDamageFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDamage",
			string(HuntersInstinctDamageFX.BonusDamage),
			string(EffectEdit.BonusDamage)
		);

		HuntersInstinctDamageFX.BonusDamage = EffectEdit.BonusDamage;
	}

	if (EffectEdit.SetBonusCritChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusCritChance",
			string(HuntersInstinctDamageFX.BonusCritChance),
			string(EffectEdit.BonusCritChance)
		);

		HuntersInstinctDamageFX.BonusCritChance = EffectEdit.BonusCritChance;
	}
}
