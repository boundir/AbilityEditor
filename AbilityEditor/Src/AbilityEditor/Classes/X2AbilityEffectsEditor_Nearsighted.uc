class X2AbilityEffectsEditor_Nearsighted extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Nearsighted');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Nearsighted NearsightedFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	NearsightedFX = X2Effect_Nearsighted(Effect);

	if (NearsightedFX == none)
	{
		return;
	}

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(NearsightedFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		NearsightedFX.DmgMod = EffectEdit.DmgMod;
	}
}
