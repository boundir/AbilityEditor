class X2AbilityEffectsEditor_VoidConduit extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_VoidConduit');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_VoidConduit VoidConduitFX;

	VoidConduitFX = X2Effect_VoidConduit(Effect);

	if (VoidConduitFX == none)
	{
		return;
	}

	if (EffectEdit.SetDamagePerAction)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamagePerAction",
			string(VoidConduitFX.DamagePerAction),
			string(EffectEdit.DamagePerAction)
		);

		VoidConduitFX.DamagePerAction = EffectEdit.DamagePerAction;
	}

	if (EffectEdit.SetHealthReturnMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HealthReturnMod",
			string(VoidConduitFX.HealthReturnMod),
			string(EffectEdit.HealthReturnMod)
		);

		VoidConduitFX.HealthReturnMod = EffectEdit.HealthReturnMod;
	}
}
