class X2AbilityEffectsEditor_SpawnUnit extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SpawnUnit');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SpawnUnit SpawnUnitFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SpawnUnitFX = X2Effect_SpawnUnit(Effect);

	if (SpawnUnitFX == none)
	{
		return;
	}

	if (EffectEdit.SetUnitToSpawnName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".UnitToSpawnName",
			string(SpawnUnitFX.UnitToSpawnName),
			string(EffectEdit.UnitToSpawnName)
		);

		SpawnUnitFX.UnitToSpawnName = EffectEdit.UnitToSpawnName;
	}

	if (EffectEdit.SetClearTileBlockedByTargetUnitFlag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bClearTileBlockedByTargetUnitFlag",
			string(SpawnUnitFX.bClearTileBlockedByTargetUnitFlag),
			string(EffectEdit.ClearTileBlockedByTargetUnitFlag)
		);

		SpawnUnitFX.bClearTileBlockedByTargetUnitFlag = EffectEdit.ClearTileBlockedByTargetUnitFlag;
	}

	if (EffectEdit.SetCopyTargetAppearance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCopyTargetAppearance",
			string(SpawnUnitFX.bCopyTargetAppearance),
			string(EffectEdit.CopyTargetAppearance)
		);

		SpawnUnitFX.bCopyTargetAppearance = EffectEdit.CopyTargetAppearance;
	}

	if (EffectEdit.SetCopySourceAppearance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCopySourceAppearance",
			string(SpawnUnitFX.bCopySourceAppearance),
			string(EffectEdit.CopySourceAppearance)
		);

		SpawnUnitFX.bCopySourceAppearance = EffectEdit.CopySourceAppearance;
	}

	if (EffectEdit.SetKnockbackAffectsSpawnLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bKnockbackAffectsSpawnLocation",
			string(SpawnUnitFX.bKnockbackAffectsSpawnLocation),
			string(EffectEdit.KnockbackAffectsSpawnLocation)
		);

		SpawnUnitFX.bKnockbackAffectsSpawnLocation = EffectEdit.KnockbackAffectsSpawnLocation;
	}

	if (EffectEdit.SetAddToSourceGroup)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAddToSourceGroup",
			string(SpawnUnitFX.bAddToSourceGroup),
			string(EffectEdit.AddToSourceGroup)
		);

		SpawnUnitFX.bAddToSourceGroup = EffectEdit.AddToSourceGroup;
	}

	if (EffectEdit.SetCopyReanimatedFromUnit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCopyReanimatedFromUnit",
			string(SpawnUnitFX.bCopyReanimatedFromUnit),
			string(EffectEdit.CopyReanimatedFromUnit)
		);

		SpawnUnitFX.bCopyReanimatedFromUnit = EffectEdit.CopyReanimatedFromUnit;
	}

	if (EffectEdit.SetCopyReanimatedStatsFromUnit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCopyReanimatedStatsFromUnit",
			string(SpawnUnitFX.bCopyReanimatedStatsFromUnit),
			string(EffectEdit.CopyReanimatedStatsFromUnit)
		);

		SpawnUnitFX.bCopyReanimatedStatsFromUnit = EffectEdit.CopyReanimatedStatsFromUnit;
	}

	if (EffectEdit.SetSetProcessedScamperAs)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSetProcessedScamperAs",
			string(SpawnUnitFX.bSetProcessedScamperAs),
			string(EffectEdit.SetProcessedScamperAs)
		);

		SpawnUnitFX.bSetProcessedScamperAs = EffectEdit.SetProcessedScamperAs;
	}
}
