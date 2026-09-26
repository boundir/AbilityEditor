class X2AbilityEffectsEditor_BondmateAimAdjust extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BondmateAimAdjust');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BondmateAimAdjust BondmateAimEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BondmateAimEffect = X2Effect_BondmateAimAdjust(Effect);

	if (BondmateAimEffect == none)
	{
		return;
	}

	if (EffectEdit.SetThreatenedBondmateAimBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ThreatenedBondmateAimBonus",
			string(BondmateAimEffect.ThreatenedBondmateAimBonus),
			string(EffectEdit.ThreatenedBondmateAimBonus)
		);

		BondmateAimEffect.ThreatenedBondmateAimBonus = EffectEdit.ThreatenedBondmateAimBonus;
	}

	if (EffectEdit.SetBondmateTargetAimBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BondmateTargetAimBonus",
			string(BondmateAimEffect.BondmateTargetAimBonus),
			string(EffectEdit.BondmateTargetAimBonus)
		);

		BondmateAimEffect.BondmateTargetAimBonus = EffectEdit.BondmateTargetAimBonus;
	}

	if (EffectEdit.SetBondmateTargetCritBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BondmateTargetCritBonus",
			string(BondmateAimEffect.BondmateTargetCritBonus),
			string(EffectEdit.BondmateTargetCritBonus)
		);

		BondmateAimEffect.BondmateTargetCritBonus = EffectEdit.BondmateTargetCritBonus;
	}
}
