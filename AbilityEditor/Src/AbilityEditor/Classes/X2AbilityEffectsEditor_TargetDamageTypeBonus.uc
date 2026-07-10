class X2AbilityEffectsEditor_TargetDamageTypeBonus extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TargetDamageTypeBonus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TargetDamageTypeBonus TargetDamageTypeBonusFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TargetDamageTypeBonusFX = X2Effect_TargetDamageTypeBonus(Effect);

	if (TargetDamageTypeBonusFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDmgFloat)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDmg",
			string(TargetDamageTypeBonusFX.BonusDmg),
			string(EffectEdit.BonusDmgFloat)
		);

		TargetDamageTypeBonusFX.BonusDmg = EffectEdit.BonusDmgFloat;
	}

	if (EffectEdit.SetBonusModType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusModType",
			string(TargetDamageTypeBonusFX.BonusModType),
			string(EffectEdit.BonusModType)
		);

		TargetDamageTypeBonusFX.BonusModType = EffectEdit.BonusModType;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".BonusDamageTypes",
		TargetDamageTypeBonusFX.BonusDamageTypes,
		EffectEdit.BonusDamageTypes,
		EffectEdit.BonusDamageTypesMode
	);
}
