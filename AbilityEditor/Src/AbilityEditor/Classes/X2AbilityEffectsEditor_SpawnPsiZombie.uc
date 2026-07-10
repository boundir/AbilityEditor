class X2AbilityEffectsEditor_SpawnPsiZombie extends X2AbilityEffectsEditor_SpawnUnit;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SpawnPsiZombie');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SpawnPsiZombie SpawnPsiZombieFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SpawnPsiZombieFX = X2Effect_SpawnPsiZombie(Effect);

	if (SpawnPsiZombieFX == none)
	{
		return;
	}

	if (EffectEdit.SetAnimationName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AnimationName",
			string(SpawnPsiZombieFX.AnimationName),
			string(EffectEdit.AnimationName)
		);

		SpawnPsiZombieFX.AnimationName = EffectEdit.AnimationName;
	}

	if (EffectEdit.SetAltUnitToSpawnName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AltUnitToSpawnName",
			string(SpawnPsiZombieFX.AltUnitToSpawnName),
			string(EffectEdit.AltUnitToSpawnName)
		);

		SpawnPsiZombieFX.AltUnitToSpawnName = EffectEdit.AltUnitToSpawnName;
	}

	if (EffectEdit.SetStartAnimationMinDelaySec)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StartAnimationMinDelaySec",
			string(SpawnPsiZombieFX.StartAnimationMinDelaySec),
			string(EffectEdit.StartAnimationMinDelaySec)
		);

		SpawnPsiZombieFX.StartAnimationMinDelaySec = EffectEdit.StartAnimationMinDelaySec;
	}

	if (EffectEdit.SetStartAnimationMaxDelaySec)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StartAnimationMaxDelaySec",
			string(SpawnPsiZombieFX.StartAnimationMaxDelaySec),
			string(EffectEdit.StartAnimationMaxDelaySec)
		);

		SpawnPsiZombieFX.StartAnimationMaxDelaySec = EffectEdit.StartAnimationMaxDelaySec;
	}
}
