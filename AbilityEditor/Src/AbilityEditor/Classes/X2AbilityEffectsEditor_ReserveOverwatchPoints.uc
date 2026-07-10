class X2AbilityEffectsEditor_ReserveOverwatchPoints extends X2AbilityEffectsEditor_ReserveActionPoints;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ReserveOverwatchPoints');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ReserveOverwatchPoints ReserveOverwatchPointsFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ReserveOverwatchPointsFX = X2Effect_ReserveOverwatchPoints(Effect);

	if (ReserveOverwatchPointsFX == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".UseAllPointsWithAbilities",
		ReserveOverwatchPointsFX.UseAllPointsWithAbilities,
		EffectEdit.UseAllPointsWithAbilities,
		EffectEdit.UseAllPointsWithAbilitiesMode
	);
}
