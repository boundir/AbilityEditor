class X2AbilityEffectsEditor_BlastPadding extends X2AbilityEffectsEditor_BonusArmor;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_BlastPadding');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_BlastPadding BlastPaddingFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BlastPaddingFX = X2Effect_BlastPadding(Effect);

	if (BlastPaddingFX == none)
	{
		return;
	}

	if (EffectEdit.SetExplosiveDamageReduction)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExplosiveDamageReduction",
			string(BlastPaddingFX.ExplosiveDamageReduction),
			string(EffectEdit.ExplosiveDamageReduction)
		);

		BlastPaddingFX.ExplosiveDamageReduction = EffectEdit.ExplosiveDamageReduction;
	}
}
