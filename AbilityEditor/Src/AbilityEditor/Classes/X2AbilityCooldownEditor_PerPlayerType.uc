// X2AbilityCooldown_PerPlayerType extends X2AbilityCooldown_LocalAndGlobal, so chain that editor
class X2AbilityCooldownEditor_PerPlayerType extends X2AbilityCooldownEditor_LocalAndGlobal;

static function bool CanEdit(X2AbilityCooldown AbilityCooldown)
{
	return AbilityCooldown.IsA('X2AbilityCooldown_PerPlayerType');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
	local X2AbilityCooldown_PerPlayerType PerPlayerTypeCooldown;

	super.ApplyDerivedEdit(AbilityName, AbilityCooldown, CooldownEdit);

	PerPlayerTypeCooldown = X2AbilityCooldown_PerPlayerType(AbilityCooldown);

	if (CooldownEdit.SetNumTurnsForAI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"PerPlayerTypeCooldown.iNumTurnsForAI",
			string(PerPlayerTypeCooldown.iNumTurnsForAI),
			string(CooldownEdit.NumTurnsForAI)
		);

		PerPlayerTypeCooldown.iNumTurnsForAI = CooldownEdit.NumTurnsForAI;
	}
}
