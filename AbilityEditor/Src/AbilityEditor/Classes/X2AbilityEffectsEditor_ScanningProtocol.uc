class X2AbilityEffectsEditor_ScanningProtocol extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ScanningProtocol');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ScanningProtocol ScanningProtocolFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ScanningProtocolFX = X2Effect_ScanningProtocol(Effect);

	if (ScanningProtocolFX == none)
	{
		return;
	}

	if (EffectEdit.SetLookAtDuration)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".LookAtDuration",
			string(ScanningProtocolFX.LookAtDuration),
			string(EffectEdit.LookAtDuration)
		);

		ScanningProtocolFX.LookAtDuration = EffectEdit.LookAtDuration;
	}
}
