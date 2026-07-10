class X2AbilityEffectsEditor_HomingMine extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_HomingMine');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_HomingMine HomingMineFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	HomingMineFX = X2Effect_HomingMine(Effect);

	if (HomingMineFX == none)
	{
		return;
	}

	if (EffectEdit.SetAbilityToTrigger)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AbilityToTrigger",
			string(HomingMineFX.AbilityToTrigger),
			string(EffectEdit.AbilityToTrigger)
		);

		HomingMineFX.AbilityToTrigger = EffectEdit.AbilityToTrigger;
	}
}
