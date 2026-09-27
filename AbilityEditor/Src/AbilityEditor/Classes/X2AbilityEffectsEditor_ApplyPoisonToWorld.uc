class X2AbilityEffectsEditor_ApplyPoisonToWorld extends X2AbilityEffectsEditor_World;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyPoisonToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyPoisonToWorld ApplyPoisonToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplyPoisonToWorldFX = X2Effect_ApplyPoisonToWorld(Effect);

	if (ApplyPoisonToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetPoisonParticleSystem)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PoisonParticleSystemFill_Name",
			ApplyPoisonToWorldFX.PoisonParticleSystemFill_Name,
			EffectEdit.PoisonParticleSystem
		);

		ApplyPoisonToWorldFX.PoisonParticleSystemFill_Name = EffectEdit.PoisonParticleSystem;
	}
}
