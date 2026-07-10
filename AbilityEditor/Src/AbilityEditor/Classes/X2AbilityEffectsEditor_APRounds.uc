class X2AbilityEffectsEditor_APRounds extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_APRounds');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_APRounds APRoundsFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	APRoundsFX = X2Effect_APRounds(Effect);

	if (APRoundsFX == none)
	{
		return;
	}

	if (EffectEdit.SetPierce)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".Pierce",
			string(APRoundsFX.Pierce),
			string(EffectEdit.Pierce)
		);

		APRoundsFX.Pierce = EffectEdit.Pierce;
	}

	if (EffectEdit.SetCritChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritChance",
			string(APRoundsFX.CritChance),
			string(EffectEdit.CritChance)
		);

		APRoundsFX.CritChance = EffectEdit.CritChance;
	}

	if (EffectEdit.SetCritDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CritDamage",
			string(APRoundsFX.CritDamage),
			string(EffectEdit.CritDamage)
		);

		APRoundsFX.CritDamage = EffectEdit.CritDamage;
	}
}
