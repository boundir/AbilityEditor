class X2AbilityEffectsEditor_Oblivious extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Oblivious');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Oblivious ObliviousFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ObliviousFX = X2Effect_Oblivious(Effect);

	if (ObliviousFX == none)
	{
		return;
	}

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(ObliviousFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		ObliviousFX.DmgMod = EffectEdit.DmgMod;
	}
}
