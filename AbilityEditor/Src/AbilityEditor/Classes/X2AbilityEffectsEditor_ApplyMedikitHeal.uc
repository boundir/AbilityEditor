class X2AbilityEffectsEditor_ApplyMedikitHeal extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyMedikitHeal');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyMedikitHeal ApplyMedikitHealFX;

	ApplyMedikitHealFX = X2Effect_ApplyMedikitHeal(Effect);

	if (ApplyMedikitHealFX == none)
	{
		return;
	}

	if (EffectEdit.SetPerUseHP)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PerUseHP",
			string(ApplyMedikitHealFX.PerUseHP),
			string(EffectEdit.PerUseHP)
		);

		ApplyMedikitHealFX.PerUseHP = EffectEdit.PerUseHP;
	}

	if (EffectEdit.SetIncreasedHealProject)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IncreasedHealProject",
			string(ApplyMedikitHealFX.IncreasedHealProject),
			string(EffectEdit.IncreasedHealProject)
		);

		ApplyMedikitHealFX.IncreasedHealProject = EffectEdit.IncreasedHealProject;
	}

	if (EffectEdit.SetIncreasedPerUseHP)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IncreasedPerUseHP",
			string(ApplyMedikitHealFX.IncreasedPerUseHP),
			string(EffectEdit.IncreasedPerUseHP)
		);

		ApplyMedikitHealFX.IncreasedPerUseHP = EffectEdit.IncreasedPerUseHP;
	}
}
