class X2AbilityEffectsEditor_Stasis extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Stasis');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Stasis StasisFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	StasisFX = X2Effect_Stasis(Effect);

	if (StasisFX == none)
	{
		return;
	}

	if (EffectEdit.SetStunStartAnim)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunStartAnim",
			string(StasisFX.StunStartAnim),
			string(EffectEdit.StunStartAnim)
		);

		StasisFX.StunStartAnim = EffectEdit.StunStartAnim;
	}

	if (EffectEdit.SetStunStopAnim)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StunStopAnim",
			string(StasisFX.StunStopAnim),
			string(EffectEdit.StunStopAnim)
		);

		StasisFX.StunStopAnim = EffectEdit.StunStopAnim;
	}

	if (EffectEdit.SetSkipFlyover)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSkipFlyover",
			string(StasisFX.bSkipFlyover),
			string(EffectEdit.SkipFlyover)
		);

		StasisFX.bSkipFlyover = EffectEdit.SkipFlyover;
	}

	if (EffectEdit.SetStartAnimBlendTime)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StartAnimBlendTime",
			string(StasisFX.StartAnimBlendTime),
			string(EffectEdit.StartAnimBlendTime)
		);

		StasisFX.StartAnimBlendTime = EffectEdit.StartAnimBlendTime;
	}
}
