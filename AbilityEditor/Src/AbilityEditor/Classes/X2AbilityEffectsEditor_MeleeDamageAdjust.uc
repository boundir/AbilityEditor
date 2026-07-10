class X2AbilityEffectsEditor_MeleeDamageAdjust extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_MeleeDamageAdjust');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_MeleeDamageAdjust MeleeDamageAdjustFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	MeleeDamageAdjustFX = X2Effect_MeleeDamageAdjust(Effect);

	if (MeleeDamageAdjustFX == none)
	{
		return;
	}

	if (EffectEdit.SetDamageMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DamageMod",
			string(MeleeDamageAdjustFX.DamageMod),
			string(EffectEdit.DamageMod)
		);

		MeleeDamageAdjustFX.DamageMod = EffectEdit.DamageMod;
	}

	if (EffectEdit.SetMeleeDamageTypeName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MeleeDamageTypeName",
			string(MeleeDamageAdjustFX.MeleeDamageTypeName),
			string(EffectEdit.MeleeDamageTypeName)
		);

		MeleeDamageAdjustFX.MeleeDamageTypeName = EffectEdit.MeleeDamageTypeName;
	}
}
