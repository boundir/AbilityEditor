class X2AbilityEffectsEditor_GetOverHere extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_GetOverHere');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_GetOverHere GetOverHereFX;

	GetOverHereFX = X2Effect_GetOverHere(Effect);

	if (GetOverHereFX == none)
	{
		return;
	}

	if (EffectEdit.SetOverrideStartAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideStartAnimName",
			string(GetOverHereFX.OverrideStartAnimName),
			string(EffectEdit.OverrideStartAnimName)
		);

		GetOverHereFX.OverrideStartAnimName = EffectEdit.OverrideStartAnimName;
	}

	if (EffectEdit.SetOverrideStopAnimName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideStopAnimName",
			string(GetOverHereFX.OverrideStopAnimName),
			string(EffectEdit.OverrideStopAnimName)
		);

		GetOverHereFX.OverrideStopAnimName = EffectEdit.OverrideStopAnimName;
	}

	if (EffectEdit.SetRequireVisibleTile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireVisibleTile",
			string(GetOverHereFX.RequireVisibleTile),
			string(EffectEdit.RequireVisibleTile)
		);

		GetOverHereFX.RequireVisibleTile = EffectEdit.RequireVisibleTile;
	}
}
