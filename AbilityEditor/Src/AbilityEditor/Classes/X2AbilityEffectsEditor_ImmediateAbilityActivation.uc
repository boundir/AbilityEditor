class X2AbilityEffectsEditor_ImmediateAbilityActivation extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ImmediateAbilityActivation');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ImmediateAbilityActivation ImmediateAbilityActivationFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ImmediateAbilityActivationFX = X2Effect_ImmediateAbilityActivation(Effect);

	if (ImmediateAbilityActivationFX == none)
	{
		return;
	}

	if (EffectEdit.SetAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AbilityName",
			string(ImmediateAbilityActivationFX.AbilityName),
			string(EffectEdit.AbilityName)
		);

		ImmediateAbilityActivationFX.AbilityName = EffectEdit.AbilityName;
	}

	if (EffectEdit.SetActivateAbilityOnTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ActivateAbilityOnTarget",
			string(ImmediateAbilityActivationFX.ActivateAbilityOnTarget),
			string(EffectEdit.ActivateAbilityOnTarget)
		);

		ImmediateAbilityActivationFX.ActivateAbilityOnTarget = EffectEdit.ActivateAbilityOnTarget;
	}

	if (EffectEdit.SetEffectTargetOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectTargetOnly",
			string(ImmediateAbilityActivationFX.EffectTargetOnly),
			string(EffectEdit.EffectTargetOnly)
		);

		ImmediateAbilityActivationFX.EffectTargetOnly = EffectEdit.EffectTargetOnly;
	}
}
