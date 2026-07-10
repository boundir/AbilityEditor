class X2AbilityEffectsEditor_HoloTarget extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_HoloTarget');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_HoloTarget HoloTargetFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	HoloTargetFX = X2Effect_HoloTarget(Effect);

	if (HoloTargetFX == none)
	{
		return;
	}

	if (EffectEdit.SetHitMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HitMod",
			string(HoloTargetFX.HitMod),
			string(EffectEdit.HitMod)
		);

		HoloTargetFX.HitMod = EffectEdit.HitMod;
	}
}
