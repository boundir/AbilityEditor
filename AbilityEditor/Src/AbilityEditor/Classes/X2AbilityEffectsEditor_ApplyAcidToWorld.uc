class X2AbilityEffectsEditor_ApplyAcidToWorld extends X2AbilityEffectsEditor_World;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyAcidToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyAcidToWorld ApplyAcidToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplyAcidToWorldFX = X2Effect_ApplyAcidToWorld(Effect);

	if (ApplyAcidToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetAcidParticleSystem1Tile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_1pc",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_1pc,
			EffectEdit.AcidParticleSystem1Tile
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_1pc = EffectEdit.AcidParticleSystem1Tile;
	}

	if (EffectEdit.SetAcidParticleSystem2Tiles)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_2pc",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_2pc,
			EffectEdit.AcidParticleSystem2Tiles
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_2pc = EffectEdit.AcidParticleSystem2Tiles;
	}

	if (EffectEdit.SetAcidParticleSystem3TilesLine)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_3pc_Long",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_3pc_Long,
			EffectEdit.AcidParticleSystem3TilesLine
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_3pc_Long = EffectEdit.AcidParticleSystem3TilesLine;
	}

	if (EffectEdit.SetAcidParticleSystem3TilesCorner)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_3pc_Corner",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_3pc_Corner,
			EffectEdit.AcidParticleSystem3TilesCorner
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_3pc_Corner = EffectEdit.AcidParticleSystem3TilesCorner;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesLine)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_Long",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Long,
			EffectEdit.AcidParticleSystem4TilesLine
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Long = EffectEdit.AcidParticleSystem4TilesLine;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesSquare)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_Square",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Square,
			EffectEdit.AcidParticleSystem4TilesSquare
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Square = EffectEdit.AcidParticleSystem4TilesSquare;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesL)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_L",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_L,
			EffectEdit.AcidParticleSystem4TilesL
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_L = EffectEdit.AcidParticleSystem4TilesL;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesReverseL)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_Reverse_L",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Reverse_L,
			EffectEdit.AcidParticleSystem4TilesReverseL
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Reverse_L = EffectEdit.AcidParticleSystem4TilesReverseL;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesT)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_Middle",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Middle,
			EffectEdit.AcidParticleSystem4TilesT
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Middle = EffectEdit.AcidParticleSystem4TilesT;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesS)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_S",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_S,
			EffectEdit.AcidParticleSystem4TilesS
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_S = EffectEdit.AcidParticleSystem4TilesS;
	}

	if (EffectEdit.SetAcidParticleSystem4TilesReverseS)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AcidParticleSystemFill_Name_4pc_Reverse_S",
			ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Reverse_S,
			EffectEdit.AcidParticleSystem4TilesReverseS
		);

		ApplyAcidToWorldFX.AcidParticleSystemFill_Name_4pc_Reverse_S = EffectEdit.AcidParticleSystem4TilesReverseS;
	}
}
