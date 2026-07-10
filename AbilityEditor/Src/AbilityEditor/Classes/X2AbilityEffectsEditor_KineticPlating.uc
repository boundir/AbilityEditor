class X2AbilityEffectsEditor_KineticPlating extends X2AbilityEffectsEditor_PersistentStatChange;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_KineticPlating');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_KineticPlating KineticPlatingFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	KineticPlatingFX = X2Effect_KineticPlating(Effect);

	if (KineticPlatingFX == none)
	{
		return;
	}

	if (EffectEdit.SetShieldPerMiss)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ShieldPerMiss",
			string(KineticPlatingFX.ShieldPerMiss),
			string(EffectEdit.ShieldPerMiss)
		);

		KineticPlatingFX.ShieldPerMiss = EffectEdit.ShieldPerMiss;
	}
}
