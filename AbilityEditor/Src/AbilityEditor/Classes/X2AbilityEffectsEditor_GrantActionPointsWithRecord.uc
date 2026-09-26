class X2AbilityEffectsEditor_GrantActionPointsWithRecord extends X2AbilityEffectsEditor_GrantActionPoints;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_GrantActionPointsWithRecord');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_GrantActionPointsWithRecord GrantEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	GrantEffect = X2Effect_GrantActionPointsWithRecord(Effect);

	if (GrantEffect == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyRecordDataArrayEdit(
		AbilityName,
		Slot $ ".RecordUnitValueWithGrant",
		GrantEffect.RecordUnitValueWithGrant,
		EffectEdit.RecordUnitValueWithGrant,
		EffectEdit.RecordUnitValueWithGrantMode
	);
}
