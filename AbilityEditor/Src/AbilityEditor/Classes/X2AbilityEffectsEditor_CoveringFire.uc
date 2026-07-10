class X2AbilityEffectsEditor_CoveringFire extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_CoveringFire');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_CoveringFire CoveringFireEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	CoveringFireEffect = X2Effect_CoveringFire(Effect);

	if (CoveringFireEffect == none)
	{
		return;
	}

	if (EffectEdit.SetAbilityToActivate)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AbilityToActivate",
			string(CoveringFireEffect.AbilityToActivate),
			string(EffectEdit.AbilityToActivate)
		);

		CoveringFireEffect.AbilityToActivate = EffectEdit.AbilityToActivate;
	}

	if (EffectEdit.SetGrantActionPoint)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".GrantActionPoint",
			string(CoveringFireEffect.GrantActionPoint),
			string(EffectEdit.GrantActionPoint)
		);

		CoveringFireEffect.GrantActionPoint = EffectEdit.GrantActionPoint;
	}

	if (EffectEdit.SetMaxPointsPerTurn)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxPointsPerTurn",
			string(CoveringFireEffect.MaxPointsPerTurn),
			string(EffectEdit.MaxPointsPerTurn)
		);

		CoveringFireEffect.MaxPointsPerTurn = EffectEdit.MaxPointsPerTurn;
	}

	if (EffectEdit.SetDirectAttackOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDirectAttackOnly",
			string(CoveringFireEffect.bDirectAttackOnly),
			string(EffectEdit.DirectAttackOnly)
		);

		CoveringFireEffect.bDirectAttackOnly = EffectEdit.DirectAttackOnly;
	}

	if (EffectEdit.SetPreEmptiveFire)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bPreEmptiveFire",
			string(CoveringFireEffect.bPreEmptiveFire),
			string(EffectEdit.PreEmptiveFire)
		);

		CoveringFireEffect.bPreEmptiveFire = EffectEdit.PreEmptiveFire;
	}

	if (EffectEdit.SetOnlyDuringEnemyTurn)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyDuringEnemyTurn",
			string(CoveringFireEffect.bOnlyDuringEnemyTurn),
			string(EffectEdit.OnlyDuringEnemyTurn)
		);

		CoveringFireEffect.bOnlyDuringEnemyTurn = EffectEdit.OnlyDuringEnemyTurn;
	}

	if (EffectEdit.SetUseMultiTargets)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseMultiTargets",
			string(CoveringFireEffect.bUseMultiTargets),
			string(EffectEdit.UseMultiTargets)
		);

		CoveringFireEffect.bUseMultiTargets = EffectEdit.UseMultiTargets;
	}

	if (EffectEdit.SetOnlyWhenAttackMisses)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyWhenAttackMisses",
			string(CoveringFireEffect.bOnlyWhenAttackMisses),
			string(EffectEdit.OnlyWhenAttackMisses)
		);

		CoveringFireEffect.bOnlyWhenAttackMisses = EffectEdit.OnlyWhenAttackMisses;
	}

	if (EffectEdit.SetSelfTargeting)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSelfTargeting",
			string(CoveringFireEffect.bSelfTargeting),
			string(EffectEdit.SelfTargeting)
		);

		CoveringFireEffect.bSelfTargeting = EffectEdit.SelfTargeting;
	}

	if (EffectEdit.SetActivationPercentChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ActivationPercentChance",
			string(CoveringFireEffect.ActivationPercentChance),
			string(EffectEdit.ActivationPercentChance)
		);

		CoveringFireEffect.ActivationPercentChance = EffectEdit.ActivationPercentChance;
	}
}
