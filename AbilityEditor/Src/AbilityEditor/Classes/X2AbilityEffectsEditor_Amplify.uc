class X2AbilityEffectsEditor_Amplify extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Amplify');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Amplify AmplifyFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	AmplifyFX = X2Effect_Amplify(Effect);

	if (AmplifyFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDamageMult)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDamageMult",
			string(AmplifyFX.BonusDamageMult),
			string(EffectEdit.BonusDamageMult)
		);

		AmplifyFX.BonusDamageMult = EffectEdit.BonusDamageMult;
	}

	if (EffectEdit.SetMinBonusDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MinBonusDamage",
			string(AmplifyFX.MinBonusDamage),
			string(EffectEdit.MinBonusDamage)
		);

		AmplifyFX.MinBonusDamage = EffectEdit.MinBonusDamage;
	}
}
