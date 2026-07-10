class X2AbilityEffectsEditor_RemoveEffects extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_RemoveEffects');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_RemoveEffects RemoveEffect;

	RemoveEffect = X2Effect_RemoveEffects(Effect);

	if (RemoveEffect == none)
	{
		return;
	}

	if (EffectEdit.SetCleanse)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCleanse",
			string(RemoveEffect.bCleanse),
			string(EffectEdit.Cleanse)
		);

		RemoveEffect.bCleanse = EffectEdit.Cleanse;
	}

	if (EffectEdit.SetCheckSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCheckSource",
			string(RemoveEffect.bCheckSource),
			string(EffectEdit.CheckSource)
		);

		RemoveEffect.bCheckSource = EffectEdit.CheckSource;
	}

	if (EffectEdit.SetDoNotVisualize)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDoNotVisualize",
			string(RemoveEffect.bDoNotVisualize),
			string(EffectEdit.DoNotVisualize)
		);

		RemoveEffect.bDoNotVisualize = EffectEdit.DoNotVisualize;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".EffectNamesToRemove",
		RemoveEffect.EffectNamesToRemove,
		EffectEdit.EffectNamesToRemove,
		EffectEdit.EffectNamesToRemoveMode
	);
}
