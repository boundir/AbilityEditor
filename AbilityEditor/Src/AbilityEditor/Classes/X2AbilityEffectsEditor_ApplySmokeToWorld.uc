class X2AbilityEffectsEditor_ApplySmokeToWorld extends X2AbilityEffectsEditor_World;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplySmokeToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplySmokeToWorld ApplySmokeToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplySmokeToWorldFX = X2Effect_ApplySmokeToWorld(Effect);

	if (ApplySmokeToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetSmokeParticleSystem)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SmokeParticleSystemFill_Name",
			ApplySmokeToWorldFX.SmokeParticleSystemFill_Name,
			EffectEdit.SmokeParticleSystem
		);

		ApplySmokeToWorldFX.SmokeParticleSystemFill_Name = EffectEdit.SmokeParticleSystem;
	}
}
