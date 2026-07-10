class X2AbilityEffectsEditor_TalonRounds extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_TalonRounds');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_TalonRounds TalonRoundsFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TalonRoundsFX = X2Effect_TalonRounds(Effect);

	if (TalonRoundsFX == none)
	{
		return;
	}

	if (EffectEdit.SetAimMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AimMod",
			string(TalonRoundsFX.AimMod),
			string(EffectEdit.AimMod)
		);

		TalonRoundsFX.AimMod = EffectEdit.AimMod;
	}

	if (EffectEdit.SetCritChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritChance",
			string(TalonRoundsFX.CritChance),
			string(EffectEdit.CritChance)
		);

		TalonRoundsFX.CritChance = EffectEdit.CritChance;
	}

	if (EffectEdit.SetCritDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritDamage",
			string(TalonRoundsFX.CritDamage),
			string(EffectEdit.CritDamage)
		);

		TalonRoundsFX.CritDamage = EffectEdit.CritDamage;
	}
}
