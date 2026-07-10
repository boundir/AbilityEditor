class X2AbilityCooldownEditor extends Object abstract;

static function bool CanEdit(X2AbilityCooldown AbilityCooldown);

static function ApplyEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
    ApplyBaseEdit(AbilityName, AbilityCooldown, CooldownEdit);
    ApplyDerivedEdit(AbilityName, AbilityCooldown, CooldownEdit);
}

static function ApplyBaseEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
	local int i, Index;
	local AdditionalCooldownInfo CooldownInfo;
	local AdditionalCooldownEdit CooldownEditInfo;

	if (CooldownEdit.SetNumTurns)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AbilityCooldown.iNumTurns",
			string(AbilityCooldown.iNumTurns),
			string(CooldownEdit.NumTurns)
		);

		AbilityCooldown.iNumTurns = CooldownEdit.NumTurns;
	}

	if (CooldownEdit.SetIgnoreOnHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			"AbilityCooldown.bDoNotApplyOnHit",
			string(AbilityCooldown.bDoNotApplyOnHit),
			string(CooldownEdit.IgnoreOnHit)
		);

		AbilityCooldown.bDoNotApplyOnHit = CooldownEdit.IgnoreOnHit;
	}

	if (CooldownEdit.AdditionalCooldowns.Length == 0)
	{
		return;
	}

	if (CooldownEdit.AdditionalCooldownMode == eACEM_Replace)
	{
		`log(string(AbilityName) @ "AditionalAbilityCooldowns removed", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		AbilityCooldown.AditionalAbilityCooldowns.Length = 0;
	}

	for (i = 0; i < CooldownEdit.AdditionalCooldowns.Length; ++i)
	{
		CooldownEditInfo = CooldownEdit.AdditionalCooldowns[i];

		Index = class'X2AbilityCooldownEditor_Helper'.static.FindAdditionalCooldownIndex(
			AbilityCooldown.AditionalAbilityCooldowns,
			CooldownEditInfo.AbilityName
		);

		if (Index == INDEX_NONE)
		{
			CooldownInfo.AbilityName = CooldownEditInfo.AbilityName;
			CooldownInfo.NumTurns = 0;
			CooldownInfo.bUseAbilityCooldownNumTurns = false;
			CooldownInfo.ApplyCooldownType = AbilityCooldown.AdditionalCooldown_ApplyLarger;

			Index = AbilityCooldown.AditionalAbilityCooldowns.Length;

			`log(
				string(AbilityName) @ "AbilityCooldown.AditionalAbilityCooldowns adding additional cooldown with ability" @ string(CooldownInfo.AbilityName),
				class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
				'AbilityEditor'
			);
			AbilityCooldown.AditionalAbilityCooldowns.AddItem(CooldownInfo);
		}

		if (CooldownEditInfo.SetNumTurns)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"AditionalAbilityCooldowns.NumTurns",
				string(AbilityCooldown.AditionalAbilityCooldowns[Index].NumTurns),
				string(CooldownEditInfo.NumTurns)
			);

			AbilityCooldown.AditionalAbilityCooldowns[Index].NumTurns = CooldownEditInfo.NumTurns;
		}

		if (CooldownEditInfo.SetUseAbilityCooldownNumTurns)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"AditionalAbilityCooldowns.bUseAbilityCooldownNumTurns",
				string(AbilityCooldown.AditionalAbilityCooldowns[Index].bUseAbilityCooldownNumTurns),
				string(CooldownEditInfo.UseAbilityCooldownNumTurns)
			);

			AbilityCooldown.AditionalAbilityCooldowns[Index].bUseAbilityCooldownNumTurns = CooldownEditInfo.UseAbilityCooldownNumTurns;
		}

		if (CooldownEditInfo.ApplyCooldownType != '')
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"AditionalAbilityCooldowns.bUseAbilityCooldownNumTurns",
				string(AbilityCooldown.AditionalAbilityCooldowns[Index].ApplyCooldownType),
				string(CooldownEditInfo.ApplyCooldownType)
			);

			AbilityCooldown.AditionalAbilityCooldowns[Index].ApplyCooldownType = CooldownEditInfo.ApplyCooldownType;
		}
	}
}

static function ApplyDerivedEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
}
