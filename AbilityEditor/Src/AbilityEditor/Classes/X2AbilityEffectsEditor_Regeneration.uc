class X2AbilityEffectsEditor_Regeneration extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Regeneration');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Regeneration RegenerationFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	RegenerationFX = X2Effect_Regeneration(Effect);

	if (RegenerationFX == none)
	{
		return;
	}

	if (EffectEdit.SetHealAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HealAmount",
			string(RegenerationFX.HealAmount),
			string(EffectEdit.HealAmount)
		);

		RegenerationFX.HealAmount = EffectEdit.HealAmount;
	}

	if (EffectEdit.SetMaxHealAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxHealAmount",
			string(RegenerationFX.MaxHealAmount),
			string(EffectEdit.MaxHealAmount)
		);

		RegenerationFX.MaxHealAmount = EffectEdit.MaxHealAmount;
	}

	if (EffectEdit.SetHealthRegeneratedName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HealthRegeneratedName",
			string(RegenerationFX.HealthRegeneratedName),
			string(EffectEdit.HealthRegeneratedName)
		);

		RegenerationFX.HealthRegeneratedName = EffectEdit.HealthRegeneratedName;
	}

	if (EffectEdit.SetEventToTriggerOnHeal)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EventToTriggerOnHeal",
			string(RegenerationFX.EventToTriggerOnHeal),
			string(EffectEdit.EventToTriggerOnHeal)
		);

		RegenerationFX.EventToTriggerOnHeal = EffectEdit.EventToTriggerOnHeal;
	}
}
