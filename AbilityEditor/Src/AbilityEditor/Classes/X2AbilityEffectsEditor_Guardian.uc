class X2AbilityEffectsEditor_Guardian extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Guardian');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Guardian GuardianFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	GuardianFX = X2Effect_Guardian(Effect);

	if (GuardianFX == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".AllowedAbilities",
		GuardianFX.AllowedAbilities,
		EffectEdit.AllowedAbilities,
		EffectEdit.AllowedAbilitiesMode
	);

	if (EffectEdit.SetProcChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ProcChance",
			string(GuardianFX.ProcChance),
			string(EffectEdit.ProcChance)
		);

		GuardianFX.ProcChance = EffectEdit.ProcChance;
	}
}
