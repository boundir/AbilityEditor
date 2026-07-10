class X2AbilityEffectsEditor_SmokeGrenade extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SmokeGrenade');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SmokeGrenade SmokeGrenadeFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SmokeGrenadeFX = X2Effect_SmokeGrenade(Effect);

	if (SmokeGrenadeFX == none)
	{
		return;
	}

	if (EffectEdit.SetHitMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HitMod",
			string(SmokeGrenadeFX.HitMod),
			string(EffectEdit.HitMod)
		);

		SmokeGrenadeFX.HitMod = EffectEdit.HitMod;
	}
}
