class X2AbilityEffectsEditor_Shattered extends X2AbilityEffectsEditor_PersistentStatChange;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Shattered');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Shattered ShatteredFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ShatteredFX = X2Effect_Shattered(Effect);

	if (ShatteredFX == none)
	{
		return;
	}

	if (EffectEdit.SetShatteredTargetValueName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ShatteredTargetValueName",
			string(ShatteredFX.ShatteredTargetValueName),
			string(EffectEdit.ShatteredTargetValueName)
		);

		ShatteredFX.ShatteredTargetValueName = EffectEdit.ShatteredTargetValueName;
	}
}
