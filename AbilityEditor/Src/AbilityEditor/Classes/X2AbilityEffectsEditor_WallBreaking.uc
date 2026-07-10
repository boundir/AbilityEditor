class X2AbilityEffectsEditor_WallBreaking extends X2AbilityEffectsEditor_PersistentTraversalChange;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_WallBreaking');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_WallBreaking WallBreakingFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	WallBreakingFX = X2Effect_WallBreaking(Effect);

	if (WallBreakingFX == none)
	{
		return;
	}

	if (EffectEdit.SetWallBreakingEffectName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WallBreakingEffectName",
			string(WallBreakingFX.WallBreakingEffectName),
			string(EffectEdit.WallBreakingEffectName)
		);

		WallBreakingFX.WallBreakingEffectName = EffectEdit.WallBreakingEffectName;
	}
}
