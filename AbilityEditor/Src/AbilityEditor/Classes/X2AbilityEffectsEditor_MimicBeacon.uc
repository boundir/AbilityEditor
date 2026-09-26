class X2AbilityEffectsEditor_MimicBeacon extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_MimicBeacon');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_MimicBeacon MimicBeaconEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	MimicBeaconEffect = X2Effect_MimicBeacon(Effect);

	if (MimicBeaconEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".ABILITIES_ALLOWED_TO_HIT",
		MimicBeaconEffect.ABILITIES_ALLOWED_TO_HIT,
		EffectEdit.AbilitiesAllowedToHit,
		EffectEdit.AbilitiesAllowedToHitMode
	);
}
