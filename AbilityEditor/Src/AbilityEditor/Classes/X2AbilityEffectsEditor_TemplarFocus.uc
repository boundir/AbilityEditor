class X2AbilityEffectsEditor_TemplarFocus extends X2AbilityEffectsEditor_ModifyStats;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TemplarFocus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TemplarFocus FocusEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	FocusEffect = X2Effect_TemplarFocus(Effect);

	if (FocusEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyFocusLevelModifiersArrayEdit(
		AbilityName,
		Slot $ ".arrFocusModifiers",
		FocusEffect.arrFocusModifiers,
		EffectEdit.FocusLevels,
		EffectEdit.FocusLevelsMode
	);
}
