class X2AbilityEffectsEditor_SpawnShadowbindUnit extends X2AbilityEffectsEditor_SpawnUnit;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SpawnShadowbindUnit');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SpawnShadowbindUnit SpawnShadowbindUnitFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SpawnShadowbindUnitFX = X2Effect_SpawnShadowbindUnit(Effect);

	if (SpawnShadowbindUnitFX == none)
	{
		return;
	}

	if (EffectEdit.SetShadowbindUnconciousCheckName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ShadowbindUnconciousCheckName",
			string(SpawnShadowbindUnitFX.ShadowbindUnconciousCheckName),
			string(EffectEdit.ShadowbindUnconciousCheckName)
		);

		SpawnShadowbindUnitFX.ShadowbindUnconciousCheckName = EffectEdit.ShadowbindUnconciousCheckName;
	}
}
