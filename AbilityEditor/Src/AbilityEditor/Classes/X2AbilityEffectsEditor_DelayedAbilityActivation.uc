class X2AbilityEffectsEditor_DelayedAbilityActivation extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_DelayedAbilityActivation');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_DelayedAbilityActivation DelayedAbilityActivationFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	DelayedAbilityActivationFX = X2Effect_DelayedAbilityActivation(Effect);

	if (DelayedAbilityActivationFX == none)
	{
		return;
	}

	if (EffectEdit.SetTriggerEventName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TriggerEventName",
			string(DelayedAbilityActivationFX.TriggerEventName),
			string(EffectEdit.TriggerEventName)
		);

		DelayedAbilityActivationFX.TriggerEventName = EffectEdit.TriggerEventName;
	}
}
