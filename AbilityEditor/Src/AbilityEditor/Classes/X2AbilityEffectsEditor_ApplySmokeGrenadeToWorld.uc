class X2AbilityEffectsEditor_ApplySmokeGrenadeToWorld extends X2AbilityEffectsEditor_World;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplySmokeGrenadeToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplySmokeGrenadeToWorld ApplySmokeGrenadeToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplySmokeGrenadeToWorldFX = X2Effect_ApplySmokeGrenadeToWorld(Effect);

	if (ApplySmokeGrenadeToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetSmokeParticleSystem)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SmokeParticleSystemFill_Name",
			ApplySmokeGrenadeToWorldFX.SmokeParticleSystemFill_Name,
			EffectEdit.SmokeParticleSystem
		);

		ApplySmokeGrenadeToWorldFX.SmokeParticleSystemFill_Name = EffectEdit.SmokeParticleSystem;
	}
}
