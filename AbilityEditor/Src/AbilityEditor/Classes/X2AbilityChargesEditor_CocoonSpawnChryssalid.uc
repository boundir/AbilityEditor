class X2AbilityChargesEditor_CocoonSpawnChryssalid extends X2AbilityChargesEditor;

static function bool CanEdit(X2AbilityCharges AbilityCharges)
{
	return AbilityCharges.IsA('X2AbilityCharges_CocoonSpawnChryssalid');
}
