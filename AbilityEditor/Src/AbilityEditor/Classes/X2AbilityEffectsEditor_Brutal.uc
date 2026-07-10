class X2AbilityEffectsEditor_Brutal extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Brutal');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Brutal BrutalFX;

	BrutalFX = X2Effect_Brutal(Effect);

	if (BrutalFX == none)
	{
		return;
	}

	if (EffectEdit.SetWillMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WillMod",
			string(BrutalFX.WillMod),
			string(EffectEdit.WillMod)
		);

		BrutalFX.WillMod = EffectEdit.WillMod;
	}
}
