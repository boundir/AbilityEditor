class X2AbilityEffectsEditor_RemoveEffectsByDamageType extends X2AbilityEffectsEditor_RemoveEffects;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_RemoveEffectsByDamageType');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffectsByDamageTypeFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	RemoveEffectsByDamageTypeFX = X2Effect_RemoveEffectsByDamageType(Effect);

	if (RemoveEffectsByDamageTypeFX == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".DamageTypesToRemove",
		RemoveEffectsByDamageTypeFX.DamageTypesToRemove,
		EffectEdit.DamageTypesToRemove,
		EffectEdit.DamageTypesToRemoveMode
	);
}
