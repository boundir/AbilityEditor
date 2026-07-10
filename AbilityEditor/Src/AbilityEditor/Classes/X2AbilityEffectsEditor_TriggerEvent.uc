class X2AbilityEffectsEditor_TriggerEvent extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TriggerEvent');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TriggerEvent TriggerEventFX;

	TriggerEventFX = X2Effect_TriggerEvent(Effect);

	if (TriggerEventFX == none)
	{
		return;
	}

	if (EffectEdit.SetTriggerEventName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TriggerEventName",
			string(TriggerEventFX.TriggerEventName),
			string(EffectEdit.TriggerEventName)
		);

		TriggerEventFX.TriggerEventName = EffectEdit.TriggerEventName;
	}

	if (EffectEdit.SetPassTargetAsSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PassTargetAsSource",
			string(TriggerEventFX.PassTargetAsSource),
			string(EffectEdit.PassTargetAsSource)
		);

		TriggerEventFX.PassTargetAsSource = EffectEdit.PassTargetAsSource;
	}
}
