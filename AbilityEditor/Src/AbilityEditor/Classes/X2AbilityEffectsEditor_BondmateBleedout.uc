class X2AbilityEffectsEditor_BondmateBleedout extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BondmateBleedout');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BondmateBleedout BondmateBleedoutEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BondmateBleedoutEffect = X2Effect_BondmateBleedout(Effect);

	if (BondmateBleedoutEffect == none)
	{
		return;
	}

	if (EffectEdit.SetBleedoutDurationAdjustment)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BleedoutDurationAdjustment",
			string(BondmateBleedoutEffect.BleedoutDurationAdjustment),
			string(EffectEdit.BleedoutDurationAdjustment)
		);

		BondmateBleedoutEffect.BleedoutDurationAdjustment = EffectEdit.BleedoutDurationAdjustment;
	}
}
