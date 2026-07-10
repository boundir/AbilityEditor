class X2AbilityEffectsEditor_EnableGlobalAbility extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_EnableGlobalAbility');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_EnableGlobalAbility EnableGlobalAbilityFX;

	EnableGlobalAbilityFX = X2Effect_EnableGlobalAbility(Effect);

	if (EnableGlobalAbilityFX == none)
	{
		return;
	}

	if (EffectEdit.SetGlobalAbility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".GlobalAbility",
			string(EnableGlobalAbilityFX.GlobalAbility),
			string(EffectEdit.GlobalAbility)
		);

		EnableGlobalAbilityFX.GlobalAbility = EffectEdit.GlobalAbility;
	}
}
