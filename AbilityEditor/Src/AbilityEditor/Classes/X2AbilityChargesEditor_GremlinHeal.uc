class X2AbilityChargesEditor_GremlinHeal extends X2AbilityChargesEditor;

static function bool CanEdit(X2AbilityCharges AbilityCharges)
{
	return AbilityCharges.IsA('X2AbilityCharges_GremlinHeal');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCharges AbilityCharge, ChargesEdit ChargesEdit)
{
	local X2AbilityCharges_GremlinHeal GremlinHealCharges;

	GremlinHealCharges = X2AbilityCharges_GremlinHeal(AbilityCharge);

	if (ChargesEdit.SetStabilize)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"GremlinHealCharges.bStabilize",
			string(GremlinHealCharges.bStabilize),
			string(ChargesEdit.Stabilize)
		);

		GremlinHealCharges.bStabilize = ChargesEdit.Stabilize;
	}
}
