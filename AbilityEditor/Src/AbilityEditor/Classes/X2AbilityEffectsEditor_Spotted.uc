class X2AbilityEffectsEditor_Spotted extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Spotted');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Spotted SpottedFX;

	SpottedFX = X2Effect_Spotted(Effect);

	if (SpottedFX == none)
	{
		return;
	}

	if (EffectEdit.SetBecomeUnspotted)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".m_bBecomeUnspotted",
			string(SpottedFX.m_bBecomeUnspotted),
			string(EffectEdit.BecomeUnspotted)
		);

		SpottedFX.m_bBecomeUnspotted = EffectEdit.BecomeUnspotted;
	}
}
