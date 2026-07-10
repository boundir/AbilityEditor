class X2AbilityCostEditor_QuickdrawActionPoints extends X2AbilityCostEditor_ActionPoints;

static function bool CanEdit(X2AbilityCost AbilityCost)
{
	return AbilityCost.IsA('X2AbilityCost_QuickdrawActionPoints');
}
