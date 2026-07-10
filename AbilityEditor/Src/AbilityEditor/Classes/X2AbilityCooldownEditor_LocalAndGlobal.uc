class X2AbilityCooldownEditor_LocalAndGlobal extends X2AbilityCooldownEditor;

static function bool CanEdit(X2AbilityCooldown AbilityCooldown)
{
	return AbilityCooldown.IsA('X2AbilityCooldown_LocalAndGlobal');
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
	local X2AbilityCooldown_LocalAndGlobal LocalAndGlobalCooldown;

	LocalAndGlobalCooldown = X2AbilityCooldown_LocalAndGlobal(AbilityCooldown);

	if (CooldownEdit.SetNumGlobalTurns)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"LocalAndGlobalCooldown.NumGlobalTurns",
			string(LocalAndGlobalCooldown.NumGlobalTurns),
			string(CooldownEdit.NumGlobalTurns)
		);

		LocalAndGlobalCooldown.NumGlobalTurns = CooldownEdit.NumGlobalTurns;
	}
}
