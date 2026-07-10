class X2AbilityEffectsEditor_SetUnitValue extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SetUnitValue');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SetUnitValue SetValueEffect;

	SetValueEffect = X2Effect_SetUnitValue(Effect);

	if (SetValueEffect == none)
	{
		return;
	}

	if (EffectEdit.SetUnitName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".UnitName",
			string(SetValueEffect.UnitName),
			string(EffectEdit.UnitName)
		);

		SetValueEffect.UnitName = EffectEdit.UnitName;
	}

	if (EffectEdit.SetNewValueToSet)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NewValueToSet",
			string(SetValueEffect.NewValueToSet),
			string(EffectEdit.NewValueToSet)
		);

		SetValueEffect.NewValueToSet = EffectEdit.NewValueToSet;
	}

	if (EffectEdit.SetCleanupType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CleanupType",
			string(SetValueEffect.CleanupType),
			string(EffectEdit.CleanupType)
		);

		SetValueEffect.CleanupType = EffectEdit.CleanupType;
	}
}
