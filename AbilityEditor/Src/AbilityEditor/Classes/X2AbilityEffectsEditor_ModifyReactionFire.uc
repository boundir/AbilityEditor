class X2AbilityEffectsEditor_ModifyReactionFire extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ModifyReactionFire');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ModifyReactionFire ModifyReactionFireFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ModifyReactionFireFX = X2Effect_ModifyReactionFire(Effect);

	if (ModifyReactionFireFX == none)
	{
		return;
	}

	if (EffectEdit.SetAllowCrit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowCrit",
			string(ModifyReactionFireFX.bAllowCrit),
			string(EffectEdit.AllowCrit)
		);

		ModifyReactionFireFX.bAllowCrit = EffectEdit.AllowCrit;
	}

	if (EffectEdit.SetReactionModifier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReactionModifier",
			string(ModifyReactionFireFX.ReactionModifier),
			string(EffectEdit.ReactionModifier)
		);

		ModifyReactionFireFX.ReactionModifier = EffectEdit.ReactionModifier;
	}
}
