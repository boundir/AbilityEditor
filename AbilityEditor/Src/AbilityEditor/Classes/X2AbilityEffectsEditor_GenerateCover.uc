class X2AbilityEffectsEditor_GenerateCover extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_GenerateCover');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_GenerateCover GenerateCoverFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	GenerateCoverFX = X2Effect_GenerateCover(Effect);

	if (GenerateCoverFX == none)
	{
		return;
	}

	if (EffectEdit.SetCoverType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CoverType",
			string(GenerateCoverFX.CoverType),
			string(EffectEdit.CoverType)
		);

		GenerateCoverFX.CoverType = EffectEdit.CoverType;
	}

	if (EffectEdit.SetRemoveWhenMoved)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveWhenMoved",
			string(GenerateCoverFX.bRemoveWhenMoved),
			string(EffectEdit.RemoveWhenMoved)
		);

		GenerateCoverFX.bRemoveWhenMoved = EffectEdit.RemoveWhenMoved;
	}

	if (EffectEdit.SetRemoveOnOtherActivation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveOnOtherActivation",
			string(GenerateCoverFX.bRemoveOnOtherActivation),
			string(EffectEdit.RemoveOnOtherActivation)
		);

		GenerateCoverFX.bRemoveOnOtherActivation = EffectEdit.RemoveOnOtherActivation;
	}
}
