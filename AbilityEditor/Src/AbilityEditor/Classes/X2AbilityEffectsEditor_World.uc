class X2AbilityEffectsEditor_World extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_World');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_World WorldFX;

	WorldFX = X2Effect_World(Effect);

	if (WorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetCenterTile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCenterTile",
			string(WorldFX.bCenterTile),
			string(EffectEdit.CenterTile)
		);

		WorldFX.bCenterTile = EffectEdit.CenterTile;
	}
}
