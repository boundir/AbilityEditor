class X2AbilityConditionEditor_UnitEffectsOnSource extends X2AbilityConditionEditor_UnitEffects;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitEffectsOnSource');
}
