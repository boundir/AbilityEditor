class X2AbilityEffectsEditor_PersistentSquadViewer extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PersistentSquadViewer');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PersistentSquadViewer PersistentSquadViewerFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	PersistentSquadViewerFX = X2Effect_PersistentSquadViewer(Effect);

	if (PersistentSquadViewerFX == none)
	{
		return;
	}

	if (EffectEdit.SetUseWeaponRadius)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseWeaponRadius",
			string(PersistentSquadViewerFX.bUseWeaponRadius),
			string(EffectEdit.UseWeaponRadius)
		);

		PersistentSquadViewerFX.bUseWeaponRadius = EffectEdit.UseWeaponRadius;
	}

	if (EffectEdit.SetViewRadius)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ViewRadius",
			string(PersistentSquadViewerFX.ViewRadius),
			string(EffectEdit.ViewRadius)
		);

		PersistentSquadViewerFX.ViewRadius = EffectEdit.ViewRadius;
	}

	if (EffectEdit.SetUseSourceLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseSourceLocation",
			string(PersistentSquadViewerFX.bUseSourceLocation),
			string(EffectEdit.UseSourceLocation)
		);

		PersistentSquadViewerFX.bUseSourceLocation = EffectEdit.UseSourceLocation;
	}
}
