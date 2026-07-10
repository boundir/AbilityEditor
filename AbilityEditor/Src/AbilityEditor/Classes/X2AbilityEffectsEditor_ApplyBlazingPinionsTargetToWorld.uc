class X2AbilityEffectsEditor_ApplyBlazingPinionsTargetToWorld extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyBlazingPinionsTargetToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyBlazingPinionsTargetToWorld ApplyBlazingPinionsTargetToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplyBlazingPinionsTargetToWorldFX = X2Effect_ApplyBlazingPinionsTargetToWorld(Effect);

	if (ApplyBlazingPinionsTargetToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetOverrideParticleSystemFill_Name)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideParticleSystemFill_Name",
			ApplyBlazingPinionsTargetToWorldFX.OverrideParticleSystemFill_Name,
			EffectEdit.OverrideParticleSystemFill_Name
		);

		ApplyBlazingPinionsTargetToWorldFX.OverrideParticleSystemFill_Name = EffectEdit.OverrideParticleSystemFill_Name;
	}
}
