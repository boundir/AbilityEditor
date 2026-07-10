class X2AbilityEffectsEditor_Needle extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Needle');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Needle NeedleFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	NeedleFX = X2Effect_Needle(Effect);

	if (NeedleFX == none)
	{
		return;
	}

	if (EffectEdit.SetArmorPierce)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ArmorPierce",
			string(NeedleFX.ArmorPierce),
			string(EffectEdit.ArmorPierce)
		);

		NeedleFX.ArmorPierce = EffectEdit.ArmorPierce;
	}
}
