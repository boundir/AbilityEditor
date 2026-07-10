class X2AbilityCostEditor_ConsumeItem extends X2AbilityCostEditor;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_ConsumeItem');
}
