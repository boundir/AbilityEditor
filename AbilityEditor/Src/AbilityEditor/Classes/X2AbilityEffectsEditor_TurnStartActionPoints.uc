class X2AbilityEffectsEditor_TurnStartActionPoints extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TurnStartActionPoints');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TurnStartActionPoints TurnStartActionPointsFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TurnStartActionPointsFX = X2Effect_TurnStartActionPoints(Effect);

	if (TurnStartActionPointsFX == none)
	{
		return;
	}

	if (EffectEdit.SetActionPointType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ActionPointType",
			string(TurnStartActionPointsFX.ActionPointType),
			string(EffectEdit.ActionPointType)
		);

		TurnStartActionPointsFX.ActionPointType = EffectEdit.ActionPointType;
	}

	if (EffectEdit.SetNumActionPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumActionPoints",
			string(TurnStartActionPointsFX.NumActionPoints),
			string(EffectEdit.NumActionPoints)
		);

		TurnStartActionPointsFX.NumActionPoints = EffectEdit.NumActionPoints;
	}

	if (EffectEdit.SetActionPointsRemoved)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bActionPointsRemoved",
			string(TurnStartActionPointsFX.bActionPointsRemoved),
			string(EffectEdit.ActionPointsRemoved)
		);

		TurnStartActionPointsFX.bActionPointsRemoved = EffectEdit.ActionPointsRemoved;
	}
}
