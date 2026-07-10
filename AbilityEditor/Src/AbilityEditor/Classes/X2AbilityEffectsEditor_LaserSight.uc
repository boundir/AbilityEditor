class X2AbilityEffectsEditor_LaserSight extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_LaserSight');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_LaserSight LaserSightFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	LaserSightFX = X2Effect_LaserSight(Effect);

	if (LaserSightFX == none)
	{
		return;
	}

	if (EffectEdit.SetBenefitFromEmpoweredUpgrades)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bBenefitFromEmpoweredUpgrades",
			string(LaserSightFX.bBenefitFromEmpoweredUpgrades),
			string(EffectEdit.BenefitFromEmpoweredUpgrades)
		);

		LaserSightFX.bBenefitFromEmpoweredUpgrades = EffectEdit.BenefitFromEmpoweredUpgrades;
	}

	if (EffectEdit.SetCritBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritBonus",
			string(LaserSightFX.CritBonus),
			string(EffectEdit.CritBonus)
		);

		LaserSightFX.CritBonus = EffectEdit.CritBonus;
	}
}
