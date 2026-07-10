class X2AbilityConditionEditor_FuseTarget extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_FuseTarget');
}
