class X2AbilityEffectsEditor_TargetDamageDistanceBonus extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TargetDamageDistanceBonus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TargetDamageDistanceBonus TargetDamageDistanceBonusFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TargetDamageDistanceBonusFX = X2Effect_TargetDamageDistanceBonus(Effect);

	if (TargetDamageDistanceBonusFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDmgFloat)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDmg",
			string(TargetDamageDistanceBonusFX.BonusDmg),
			string(EffectEdit.BonusDmgFloat)
		);

		TargetDamageDistanceBonusFX.BonusDmg = EffectEdit.BonusDmgFloat;
	}

	if (EffectEdit.SetBonusModType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusModType",
			string(TargetDamageDistanceBonusFX.BonusModType),
			string(EffectEdit.BonusModType)
		);

		TargetDamageDistanceBonusFX.BonusModType = EffectEdit.BonusModType;
	}

	if (EffectEdit.SetWithinTileDistance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WithinTileDistance",
			string(TargetDamageDistanceBonusFX.WithinTileDistance),
			string(EffectEdit.WithinTileDistance)
		);

		TargetDamageDistanceBonusFX.WithinTileDistance = EffectEdit.WithinTileDistance;
	}

	if (EffectEdit.SetPrimaryTargetOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bPrimaryTargetOnly",
			string(TargetDamageDistanceBonusFX.bPrimaryTargetOnly),
			string(EffectEdit.PrimaryTargetOnly)
		);

		TargetDamageDistanceBonusFX.bPrimaryTargetOnly = EffectEdit.PrimaryTargetOnly;
	}
}
