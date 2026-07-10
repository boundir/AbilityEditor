class X2AbilityEffectsEditor_BonusArmor extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BonusArmor');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BonusArmor BonusArmorEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BonusArmorEffect = X2Effect_BonusArmor(Effect);

	if (BonusArmorEffect == none)
	{
		return;
	}

	if (EffectEdit.SetArmorMitigationAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ArmorMitigationAmount",
			string(BonusArmorEffect.ArmorMitigationAmount),
			string(EffectEdit.ArmorMitigationAmount)
		);

		BonusArmorEffect.ArmorMitigationAmount = EffectEdit.ArmorMitigationAmount;
	}
}
