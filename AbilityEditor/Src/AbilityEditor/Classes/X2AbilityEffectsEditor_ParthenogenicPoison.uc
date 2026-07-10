class X2AbilityEffectsEditor_ParthenogenicPoison extends X2AbilityEffectsEditor_SpawnUnit;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ParthenogenicPoison');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ParthenogenicPoison ParthenogenicPoisonFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ParthenogenicPoisonFX = X2Effect_ParthenogenicPoison(Effect);

	if (ParthenogenicPoisonFX == none)
	{
		return;
	}

	if (EffectEdit.SetParthenogenicPoisonType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ParthenogenicPoisonType",
			string(ParthenogenicPoisonFX.ParthenogenicPoisonType),
			string(EffectEdit.ParthenogenicPoisonType)
		);

		ParthenogenicPoisonFX.ParthenogenicPoisonType = EffectEdit.ParthenogenicPoisonType;
	}

	if (EffectEdit.SetParthenogenicPoisonCocoonSpawnedName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ParthenogenicPoisonCocoonSpawnedName",
			string(ParthenogenicPoisonFX.ParthenogenicPoisonCocoonSpawnedName),
			string(EffectEdit.ParthenogenicPoisonCocoonSpawnedName)
		);

		ParthenogenicPoisonFX.ParthenogenicPoisonCocoonSpawnedName = EffectEdit.ParthenogenicPoisonCocoonSpawnedName;
	}

	if (EffectEdit.SetAltUnitToSpawnName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AltUnitToSpawnName",
			string(ParthenogenicPoisonFX.AltUnitToSpawnName),
			string(EffectEdit.AltUnitToSpawnName)
		);

		ParthenogenicPoisonFX.AltUnitToSpawnName = EffectEdit.AltUnitToSpawnName;
	}
}
