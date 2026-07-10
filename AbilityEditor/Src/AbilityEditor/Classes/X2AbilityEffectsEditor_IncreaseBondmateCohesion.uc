class X2AbilityEffectsEditor_IncreaseBondmateCohesion extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_IncreaseBondmateCohesion');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_IncreaseBondmateCohesion IncreaseBondmateCohesionFX;

	IncreaseBondmateCohesionFX = X2Effect_IncreaseBondmateCohesion(Effect);

	if (IncreaseBondmateCohesionFX == none)
	{
		return;
	}

	if (EffectEdit.SetCohesionAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CohesionAmount",
			string(IncreaseBondmateCohesionFX.CohesionAmount),
			string(EffectEdit.CohesionAmount)
		);

		IncreaseBondmateCohesionFX.CohesionAmount = EffectEdit.CohesionAmount;
	}
}
