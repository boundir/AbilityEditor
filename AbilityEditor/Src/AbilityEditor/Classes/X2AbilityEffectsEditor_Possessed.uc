class X2AbilityEffectsEditor_Possessed extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Possessed');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Possessed PossessedFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	PossessedFX = X2Effect_Possessed(Effect);

	if (PossessedFX == none)
	{
		return;
	}

	if (EffectEdit.SetWeaponTemplateName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WeaponTemplateName",
			string(PossessedFX.WeaponTemplateName),
			string(EffectEdit.WeaponTemplateName)
		);

		PossessedFX.WeaponTemplateName = EffectEdit.WeaponTemplateName;
	}
}
