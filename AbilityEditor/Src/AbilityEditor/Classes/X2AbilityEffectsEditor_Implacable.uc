class X2AbilityEffectsEditor_Implacable extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Implacable');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Implacable ImplacableFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ImplacableFX = X2Effect_Implacable(Effect);

	if (ImplacableFX == none)
	{
		return;
	}

	if (EffectEdit.SetImplacableThisTurnValue)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ImplacableThisTurnValue",
			string(ImplacableFX.ImplacableThisTurnValue),
			string(EffectEdit.ImplacableThisTurnValue)
		);

		ImplacableFX.ImplacableThisTurnValue = EffectEdit.ImplacableThisTurnValue;
	}
}
