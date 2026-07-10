class X2AbilityEffectsEditor_ConditionalDamageModifier extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ConditionalDamageModifier');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ConditionalDamageModifier ConditionalDamageModifierFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ConditionalDamageModifierFX = X2Effect_ConditionalDamageModifier(Effect);

	if (ConditionalDamageModifierFX == none)
	{
		return;
	}

	if (EffectEdit.SetModifyOutgoingDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bModifyOutgoingDamage",
			string(ConditionalDamageModifierFX.bModifyOutgoingDamage),
			string(EffectEdit.ModifyOutgoingDamage)
		);

		ConditionalDamageModifierFX.bModifyOutgoingDamage = EffectEdit.ModifyOutgoingDamage;
	}

	if (EffectEdit.SetModifyIncomingDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bModifyIncomingDamage",
			string(ConditionalDamageModifierFX.bModifyIncomingDamage),
			string(EffectEdit.ModifyIncomingDamage)
		);

		ConditionalDamageModifierFX.bModifyIncomingDamage = EffectEdit.ModifyIncomingDamage;
	}

	if (EffectEdit.SetDamageModifier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageModifier",
			string(ConditionalDamageModifierFX.DamageModifier),
			string(EffectEdit.DamageModifier)
		);

		ConditionalDamageModifierFX.DamageModifier = EffectEdit.DamageModifier;
	}

	if (EffectEdit.SetDamageBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageBonus",
			string(ConditionalDamageModifierFX.DamageBonus),
			string(EffectEdit.DamageBonus)
		);

		ConditionalDamageModifierFX.DamageBonus = EffectEdit.DamageBonus;
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		AbilityName,
		Slot $ ".ApplyDamageModConditions",
		ConditionalDamageModifierFX.ApplyDamageModConditions,
		EffectEdit.ApplyDamageModConditions
	);
}
