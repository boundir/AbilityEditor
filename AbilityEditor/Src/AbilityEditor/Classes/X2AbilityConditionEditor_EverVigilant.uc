class X2AbilityConditionEditor_EverVigilant extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_EverVigilant');
}
