class X2AbilityEffectsEditor_SpawnDestructible extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_SpawnDestructible');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_SpawnDestructible SpawnDestructibleFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	SpawnDestructibleFX = X2Effect_SpawnDestructible(Effect);

	if (SpawnDestructibleFX == none)
	{
		return;
	}

	if (EffectEdit.SetDestructibleArchetype)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DestructibleArchetype",
			SpawnDestructibleFX.DestructibleArchetype,
			EffectEdit.DestructibleArchetype
		);

		SpawnDestructibleFX.DestructibleArchetype = EffectEdit.DestructibleArchetype;
	}

	if (EffectEdit.SetDestroyOnRemoval)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDestroyOnRemoval",
			string(SpawnDestructibleFX.bDestroyOnRemoval),
			string(EffectEdit.DestroyOnRemoval)
		);

		SpawnDestructibleFX.bDestroyOnRemoval = EffectEdit.DestroyOnRemoval;
	}

	if (EffectEdit.SetTargetableBySpawnedTeamOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bTargetableBySpawnedTeamOnly",
			string(SpawnDestructibleFX.bTargetableBySpawnedTeamOnly),
			string(EffectEdit.TargetableBySpawnedTeamOnly)
		);

		SpawnDestructibleFX.bTargetableBySpawnedTeamOnly = EffectEdit.TargetableBySpawnedTeamOnly;
	}
}
