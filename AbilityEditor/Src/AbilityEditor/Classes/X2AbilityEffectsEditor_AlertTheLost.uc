class X2AbilityEffectsEditor_AlertTheLost extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_AlertTheLost');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_AlertTheLost AlertTheLostEffect;

	AlertTheLostEffect = X2Effect_AlertTheLost(Effect);

	if (AlertTheLostEffect == none)
	{
		return;
	}

	if (EffectEdit.SetAlertRangeMeters)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AlertRangeMeters",
			string(AlertTheLostEffect.AlertRangeMeters),
			string(EffectEdit.AlertRangeMeters)
		);

		AlertTheLostEffect.AlertRangeMeters = EffectEdit.AlertRangeMeters;
	}
}
