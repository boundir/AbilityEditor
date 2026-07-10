class X2AbilityToHitCalcEditor_StandardAim extends X2AbilityToHitCalcEditor_Base;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc)
{
	return ToHitCalc.IsA('X2AbilityToHitCalc_StandardAim');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc_StandardAim StandardAimCalc;

	StandardAimCalc = X2AbilityToHitCalc_StandardAim(ToHitCalc);

	if (StandardAimCalc == none)
	{
		return;
	}

	if (ToHitCalcEdit.SetIndirectFire)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIndirectFire",
			string(StandardAimCalc.bIndirectFire),
			string(ToHitCalcEdit.IndirectFire)
		);

		StandardAimCalc.bIndirectFire = ToHitCalcEdit.IndirectFire;
	}

	if (ToHitCalcEdit.SetMeleeAttack)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bMeleeAttack",
			string(StandardAimCalc.bMeleeAttack),
			string(ToHitCalcEdit.MeleeAttack)
		);

		StandardAimCalc.bMeleeAttack = ToHitCalcEdit.MeleeAttack;
	}

	if (ToHitCalcEdit.SetReactionFire)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bReactionFire",
			string(StandardAimCalc.bReactionFire),
			string(ToHitCalcEdit.ReactionFire)
		);

		StandardAimCalc.bReactionFire = ToHitCalcEdit.ReactionFire;
	}

	if (ToHitCalcEdit.SetAllowCrit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowCrit",
			string(StandardAimCalc.bAllowCrit),
			string(ToHitCalcEdit.AllowCrit)
		);

		StandardAimCalc.bAllowCrit = ToHitCalcEdit.AllowCrit;
	}

	if (ToHitCalcEdit.SetHitsAreCrits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHitsAreCrits",
			string(StandardAimCalc.bHitsAreCrits),
			string(ToHitCalcEdit.HitsAreCrits)
		);

		StandardAimCalc.bHitsAreCrits = ToHitCalcEdit.HitsAreCrits;
	}

	if (ToHitCalcEdit.SetMultiTargetOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bMultiTargetOnly",
			string(StandardAimCalc.bMultiTargetOnly),
			string(ToHitCalcEdit.MultiTargetOnly)
		);

		StandardAimCalc.bMultiTargetOnly = ToHitCalcEdit.MultiTargetOnly;
	}

	if (ToHitCalcEdit.SetOnlyMultiHitWithSuccess)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bOnlyMultiHitWithSuccess",
			string(StandardAimCalc.bOnlyMultiHitWithSuccess),
			string(ToHitCalcEdit.OnlyMultiHitWithSuccess)
		);

		StandardAimCalc.bOnlyMultiHitWithSuccess = ToHitCalcEdit.OnlyMultiHitWithSuccess;
	}

	if (ToHitCalcEdit.SetGuaranteedHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bGuaranteedHit",
			string(StandardAimCalc.bGuaranteedHit),
			string(ToHitCalcEdit.GuaranteedHit)
		);

		StandardAimCalc.bGuaranteedHit = ToHitCalcEdit.GuaranteedHit;
	}

	if (ToHitCalcEdit.SetIgnoreCoverBonus)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIgnoreCoverBonus",
			string(StandardAimCalc.bIgnoreCoverBonus),
			string(ToHitCalcEdit.IgnoreCoverBonus)
		);

		StandardAimCalc.bIgnoreCoverBonus = ToHitCalcEdit.IgnoreCoverBonus;
	}

	if (ToHitCalcEdit.SetFinalMultiplier)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FinalMultiplier",
			string(StandardAimCalc.FinalMultiplier),
			string(ToHitCalcEdit.FinalMultiplier)
		);

		StandardAimCalc.FinalMultiplier = ToHitCalcEdit.FinalMultiplier;
	}

	if (ToHitCalcEdit.SetBuiltInHitMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BuiltInHitMod",
			string(StandardAimCalc.BuiltInHitMod),
			string(ToHitCalcEdit.BuiltInHitMod)
		);

		StandardAimCalc.BuiltInHitMod = ToHitCalcEdit.BuiltInHitMod;
	}

	if (ToHitCalcEdit.SetBuiltInCritMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BuiltInCritMod",
			string(StandardAimCalc.BuiltInCritMod),
			string(ToHitCalcEdit.BuiltInCritMod)
		);

		StandardAimCalc.BuiltInCritMod = ToHitCalcEdit.BuiltInCritMod;
	}
}
