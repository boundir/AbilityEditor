class X2AbilityEffectsEditor_ApplyFireToWorld extends X2AbilityEffectsEditor_World;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ApplyFireToWorld');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ApplyFireToWorld ApplyFireToWorldFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ApplyFireToWorldFX = X2Effect_ApplyFireToWorld(Effect);

	if (ApplyFireToWorldFX == none)
	{
		return;
	}

	if (EffectEdit.SetFireChance_Level1)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FireChance_Level1",
			string(ApplyFireToWorldFX.FireChance_Level1),
			string(EffectEdit.FireChance_Level1)
		);

		ApplyFireToWorldFX.FireChance_Level1 = EffectEdit.FireChance_Level1;
	}

	if (EffectEdit.SetFireChance_Level2)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FireChance_Level2",
			string(ApplyFireToWorldFX.FireChance_Level2),
			string(EffectEdit.FireChance_Level2)
		);

		ApplyFireToWorldFX.FireChance_Level2 = EffectEdit.FireChance_Level2;
	}

	if (EffectEdit.SetFireChance_Level3)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FireChance_Level3",
			string(ApplyFireToWorldFX.FireChance_Level3),
			string(EffectEdit.FireChance_Level3)
		);

		ApplyFireToWorldFX.FireChance_Level3 = EffectEdit.FireChance_Level3;
	}

	if (EffectEdit.SetUseFireChanceLevel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseFireChanceLevel",
			string(ApplyFireToWorldFX.bUseFireChanceLevel),
			string(EffectEdit.UseFireChanceLevel)
		);

		ApplyFireToWorldFX.bUseFireChanceLevel = EffectEdit.UseFireChanceLevel;
	}

	if (EffectEdit.SetDamageFragileOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDamageFragileOnly",
			string(ApplyFireToWorldFX.bDamageFragileOnly),
			string(EffectEdit.DamageFragileOnly)
		);

		ApplyFireToWorldFX.bDamageFragileOnly = EffectEdit.DamageFragileOnly;
	}

	if (EffectEdit.SetCheckForLOSFromTargetLocation)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCheckForLOSFromTargetLocation",
			string(ApplyFireToWorldFX.bCheckForLOSFromTargetLocation),
			string(EffectEdit.CheckForLOSFromTargetLocation)
		);

		ApplyFireToWorldFX.bCheckForLOSFromTargetLocation = EffectEdit.CheckForLOSFromTargetLocation;
	}
}
