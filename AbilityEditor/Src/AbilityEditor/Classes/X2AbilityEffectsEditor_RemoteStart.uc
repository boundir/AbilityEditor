class X2AbilityEffectsEditor_RemoteStart extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_RemoteStart');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_RemoteStart RemoteStartFX;

	RemoteStartFX = X2Effect_RemoteStart(Effect);

	if (RemoteStartFX == none)
	{
		return;
	}

	if (EffectEdit.SetUnitDamageMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".UnitDamageMultiplier",
			string(RemoteStartFX.UnitDamageMultiplier),
			string(EffectEdit.UnitDamageMultiplier)
		);

		RemoteStartFX.UnitDamageMultiplier = EffectEdit.UnitDamageMultiplier;
	}

	if (EffectEdit.SetDamageRadiusMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageRadiusMultiplier",
			string(RemoteStartFX.DamageRadiusMultiplier),
			string(EffectEdit.DamageRadiusMultiplier)
		);

		RemoteStartFX.DamageRadiusMultiplier = EffectEdit.DamageRadiusMultiplier;
	}
}
