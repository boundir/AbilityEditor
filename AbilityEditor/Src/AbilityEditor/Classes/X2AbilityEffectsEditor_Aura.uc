class X2AbilityEffectsEditor_Aura extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Aura');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Aura AuraFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	AuraFX = X2Effect_Aura(Effect);

	if (AuraFX == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".EventsToUpdate",
		AuraFX.EventsToUpdate,
		EffectEdit.EventsToUpdate,
		EffectEdit.EventsToUpdateMode
	);
}
