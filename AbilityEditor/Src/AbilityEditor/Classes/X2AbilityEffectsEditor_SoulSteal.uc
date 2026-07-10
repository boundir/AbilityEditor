class X2AbilityEffectsEditor_SoulSteal extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SoulSteal');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SoulSteal SoulStealFX;

	SoulStealFX = X2Effect_SoulSteal(Effect);

	if (SoulStealFX == none)
	{
		return;
	}

	if (EffectEdit.SetUnitValueToRead)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".UnitValueToRead",
			string(SoulStealFX.UnitValueToRead),
			string(EffectEdit.UnitValueToRead)
		);

		SoulStealFX.UnitValueToRead = EffectEdit.UnitValueToRead;
	}
}
