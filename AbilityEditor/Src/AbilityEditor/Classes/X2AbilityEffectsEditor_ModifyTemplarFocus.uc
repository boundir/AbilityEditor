class X2AbilityEffectsEditor_ModifyTemplarFocus extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ModifyTemplarFocus');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ModifyTemplarFocus ModifyTemplarFocusFX;

	ModifyTemplarFocusFX = X2Effect_ModifyTemplarFocus(Effect);

	if (ModifyTemplarFocusFX == none)
	{
		return;
	}

	if (EffectEdit.SetModifyFocus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ModifyFocus",
			string(ModifyTemplarFocusFX.ModifyFocus),
			string(EffectEdit.ModifyFocus)
		);

		ModifyTemplarFocusFX.ModifyFocus = EffectEdit.ModifyFocus;
	}
}
