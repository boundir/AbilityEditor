class X2AbilityEffectsEditor_Obsessed extends X2AbilityEffectsEditor_PersistentStatChange;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Obsessed');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Obsessed ObsessedFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ObsessedFX = X2Effect_Obsessed(Effect);

	if (ObsessedFX == none)
	{
		return;
	}

	if (EffectEdit.SetObsessedTargetValueName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ObsessedTargetValueName",
			string(ObsessedFX.ObsessedTargetValueName),
			string(EffectEdit.ObsessedTargetValueName)
		);

		ObsessedFX.ObsessedTargetValueName = EffectEdit.ObsessedTargetValueName;
	}
}
