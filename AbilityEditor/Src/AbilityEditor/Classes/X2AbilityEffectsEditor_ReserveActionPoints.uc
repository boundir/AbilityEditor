class X2AbilityEffectsEditor_ReserveActionPoints extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ReserveActionPoints');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ReserveActionPoints ReserveEffect;

	ReserveEffect = X2Effect_ReserveActionPoints(Effect);

	if (ReserveEffect == none)
	{
		return;
	}

	if (EffectEdit.SetReserveType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReserveType",
			string(ReserveEffect.ReserveType),
			string(EffectEdit.ReserveType)
		);

		ReserveEffect.ReserveType = EffectEdit.ReserveType;
	}

	if (EffectEdit.SetNumPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumPoints",
			string(ReserveEffect.NumPoints),
			string(EffectEdit.NumPoints)
		);

		ReserveEffect.NumPoints = EffectEdit.NumPoints;
	}
}
