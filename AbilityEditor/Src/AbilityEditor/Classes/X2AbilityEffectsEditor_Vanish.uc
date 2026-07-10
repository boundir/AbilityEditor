class X2AbilityEffectsEditor_Vanish extends X2AbilityEffectsEditor_PersistentStatChange;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Vanish');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Vanish VanishEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	VanishEffect = X2Effect_Vanish(Effect);

	if (VanishEffect == none)
	{
		return;
	}

	if (EffectEdit.SetReasonNotVisible)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReasonNotVisible",
			string(VanishEffect.ReasonNotVisible),
			string(EffectEdit.ReasonNotVisible)
		);

		VanishEffect.ReasonNotVisible = EffectEdit.ReasonNotVisible;
	}

	if (EffectEdit.SetVanishRevealAdditiveAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VanishRevealAdditiveAnimName",
			string(VanishEffect.VanishRevealAdditiveAnimName),
			string(EffectEdit.VanishRevealAdditiveAnimName)
		);

		VanishEffect.VanishRevealAdditiveAnimName = EffectEdit.VanishRevealAdditiveAnimName;
	}

	if (EffectEdit.SetVanishRevealAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VanishRevealAnimName",
			string(VanishEffect.VanishRevealAnimName),
			string(EffectEdit.VanishRevealAnimName)
		);

		VanishEffect.VanishRevealAnimName = EffectEdit.VanishRevealAnimName;
	}

	if (EffectEdit.SetVanishSyncAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VanishSyncAnimName",
			string(VanishEffect.VanishSyncAnimName),
			string(EffectEdit.VanishSyncAnimName)
		);

		VanishEffect.VanishSyncAnimName = EffectEdit.VanishSyncAnimName;
	}
}
