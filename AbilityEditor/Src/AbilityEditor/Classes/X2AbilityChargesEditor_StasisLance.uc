class X2AbilityChargesEditor_StasisLance extends X2AbilityChargesEditor;

static function bool CanEdit(X2AbilityCharges AbilityCharges)
{
	return AbilityCharges.IsA('X2AbilityCharges_StasisLance');
}
