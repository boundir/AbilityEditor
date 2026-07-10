class X2AbilityEffectsEditor_VanishingWind extends X2AbilityEffectsEditor_Vanish;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_VanishingWind');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_VanishingWind VanishingWindFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	VanishingWindFX = X2Effect_VanishingWind(Effect);

	if (VanishingWindFX == none)
	{
		return;
	}

	if (EffectEdit.SetMovingVanishRevealAdditiveAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MovingVanishRevealAdditiveAnimName",
			string(VanishingWindFX.MovingVanishRevealAdditiveAnimName),
			string(EffectEdit.MovingVanishRevealAdditiveAnimName)
		);

		VanishingWindFX.MovingVanishRevealAdditiveAnimName = EffectEdit.MovingVanishRevealAdditiveAnimName;
	}
}
