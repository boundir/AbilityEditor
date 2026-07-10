class X2AbilityChargesEditor_ScanningProtocol extends X2AbilityChargesEditor;

static function bool CanEdit(X2AbilityCharges AbilityCharges)
{
	return AbilityCharges.IsA('X2AbilityCharges_ScanningProtocol');
}
