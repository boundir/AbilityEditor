class X2AbilityEffectsEditor_OverrideDeathAnimOnLoad extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_OverrideDeathAnimOnLoad');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_OverrideDeathAnimOnLoad OverrideDeathAnimOnLoadFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	OverrideDeathAnimOnLoadFX = X2Effect_OverrideDeathAnimOnLoad(Effect);

	if (OverrideDeathAnimOnLoadFX == none)
	{
		return;
	}

	if (EffectEdit.SetOverrideAnimNameOnLoad)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideAnimNameOnLoad",
			string(OverrideDeathAnimOnLoadFX.OverrideAnimNameOnLoad),
			string(EffectEdit.OverrideAnimNameOnLoad)
		);

		OverrideDeathAnimOnLoadFX.OverrideAnimNameOnLoad = EffectEdit.OverrideAnimNameOnLoad;
	}
}
