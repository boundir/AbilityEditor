class X2AbilityEffectsEditor_BloodTrail extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BloodTrail');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BloodTrail BloodTrailFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BloodTrailFX = X2Effect_BloodTrail(Effect);

	if (BloodTrailFX == none)
	{
		return;
	}

	if (EffectEdit.SetBonusDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BonusDamage",
			string(BloodTrailFX.BonusDamage),
			string(EffectEdit.BonusDamage)
		);

		BloodTrailFX.BonusDamage = EffectEdit.BonusDamage;
	}
}
