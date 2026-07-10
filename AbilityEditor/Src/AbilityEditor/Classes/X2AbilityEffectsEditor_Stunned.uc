class X2AbilityEffectsEditor_Stunned extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Stunned');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Stunned StunnedEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	StunnedEffect = X2Effect_Stunned(Effect);

	if (StunnedEffect == none)
	{
		return;
	}

	if (EffectEdit.SetStunLevel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunLevel",
			string(StunnedEffect.StunLevel),
			string(EffectEdit.StunLevel)
		);

		StunnedEffect.StunLevel = EffectEdit.StunLevel;
	}

	if (EffectEdit.SetSkipAnimation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSkipAnimation",
			string(StunnedEffect.bSkipAnimation),
			string(EffectEdit.SkipAnimation)
		);

		StunnedEffect.bSkipAnimation = EffectEdit.SkipAnimation;
	}

	if (EffectEdit.SetStunStartAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunStartAnimName",
			string(StunnedEffect.StunStartAnimName),
			string(EffectEdit.StunStartAnimName)
		);

		StunnedEffect.StunStartAnimName = EffectEdit.StunStartAnimName;
	}

	if (EffectEdit.SetStunStopAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunStopAnimName",
			string(StunnedEffect.StunStopAnimName),
			string(EffectEdit.StunStopAnimName)
		);

		StunnedEffect.StunStopAnimName = EffectEdit.StunStopAnimName;
	}

	if (EffectEdit.SetStunnedTriggerName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunnedTriggerName",
			string(StunnedEffect.StunnedTriggerName),
			string(EffectEdit.StunnedTriggerName)
		);

		StunnedEffect.StunnedTriggerName = EffectEdit.StunnedTriggerName;
	}
}
