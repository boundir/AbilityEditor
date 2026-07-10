class X2AbilityEffectsEditor_MarkValidActivationTiles extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_MarkValidActivationTiles');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_MarkValidActivationTiles MarkValidActivationTilesFX;

	MarkValidActivationTilesFX = X2Effect_MarkValidActivationTiles(Effect);

	if (MarkValidActivationTilesFX == none)
	{
		return;
	}

	if (EffectEdit.SetAbilityToMark)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AbilityToMark",
			string(MarkValidActivationTilesFX.AbilityToMark),
			string(EffectEdit.AbilityToMark)
		);

		MarkValidActivationTilesFX.AbilityToMark = EffectEdit.AbilityToMark;
	}

	if (EffectEdit.SetOnlyUseTargetLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OnlyUseTargetLocation",
			string(MarkValidActivationTilesFX.OnlyUseTargetLocation),
			string(EffectEdit.OnlyUseTargetLocation)
		);

		MarkValidActivationTilesFX.OnlyUseTargetLocation = EffectEdit.OnlyUseTargetLocation;
	}

	if (EffectEdit.SetVisualizeFlagsOnCursor)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bVisualizeFlagsOnCursor",
			string(MarkValidActivationTilesFX.bVisualizeFlagsOnCursor),
			string(EffectEdit.VisualizeFlagsOnCursor)
		);

		MarkValidActivationTilesFX.bVisualizeFlagsOnCursor = EffectEdit.VisualizeFlagsOnCursor;
	}
}
