class X2AbilityEffectsEditor_Sustained extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Sustained');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Sustained SustainedEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SustainedEffect = X2Effect_Sustained(Effect);

	if (SustainedEffect == none)
	{
		return;
	}

	if (EffectEdit.SetSustainedAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SustainedAbilityName",
			string(SustainedEffect.SustainedAbilityName),
			string(EffectEdit.SustainedAbilityName)
		);

		SustainedEffect.SustainedAbilityName = EffectEdit.SustainedAbilityName;
	}

	if (EffectEdit.SetFragileAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FragileAmount",
			string(SustainedEffect.FragileAmount),
			string(EffectEdit.FragileAmount)
		);

		SustainedEffect.FragileAmount = EffectEdit.FragileAmount;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".EffectsToRemoveFromSource",
		SustainedEffect.EffectsToRemoveFromSource,
		EffectEdit.EffectsToRemoveFromSource,
		EffectEdit.EffectsToRemoveFromSourceMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".EffectsToRemoveFromTarget",
		SustainedEffect.EffectsToRemoveFromTarget,
		EffectEdit.EffectsToRemoveFromTarget,
		EffectEdit.EffectsToRemoveFromTargetMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".RegisterAdditionalEventsLikeImpair",
		SustainedEffect.RegisterAdditionalEventsLikeImpair,
		EffectEdit.RegisterAdditionalEventsLikeImpair,
		EffectEdit.RegisterAdditionalEventsLikeImpairMode
	);
}
