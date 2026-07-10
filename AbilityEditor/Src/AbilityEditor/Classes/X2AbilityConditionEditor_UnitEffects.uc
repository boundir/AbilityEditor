class X2AbilityConditionEditor_UnitEffects extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitEffects');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitEffects EffectsCondition;

	EffectsCondition = X2Condition_UnitEffects(Condition);

	if (EffectsCondition == none)
	{
		return;
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyEffectReasonArrayEdit(
		AbilityName,
		Slot $ ".ExcludeEffects",
		EffectsCondition.ExcludeEffects,
		ConditionEdit.ExcludeEffects,
		ConditionEdit.ExcludeEffectsMode
	);

	class'X2AbilityConditionEditor_Helper'.static.ApplyEffectReasonArrayEdit(
		AbilityName,
		Slot $ ".RequireEffects",
		EffectsCondition.RequireEffects,
		ConditionEdit.RequireEffects,
		ConditionEdit.RequireEffectsMode
	);
}
