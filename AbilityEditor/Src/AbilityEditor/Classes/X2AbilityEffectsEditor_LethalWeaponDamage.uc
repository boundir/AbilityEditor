class X2AbilityEffectsEditor_LethalWeaponDamage extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_LethalWeaponDamage');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_LethalWeaponDamage LethalFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	LethalFX = X2Effect_LethalWeaponDamage(Effect);

	if (LethalFX == none)
	{
		return;
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		AbilityName,
		Slot $ ".LethalDamageConditions",
		LethalFX.LethalDamageConditions,
		EffectEdit.LethalDamageConditions
	);
}
