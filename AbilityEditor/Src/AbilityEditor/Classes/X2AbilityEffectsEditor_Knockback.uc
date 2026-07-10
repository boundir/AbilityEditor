class X2AbilityEffectsEditor_Knockback extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Knockback');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Knockback KnockbackFX;

	KnockbackFX = X2Effect_Knockback(Effect);

	if (KnockbackFX == none)
	{
		return;
	}

	if (EffectEdit.SetKnockbackDistance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".KnockbackDistance",
			string(KnockbackFX.KnockbackDistance),
			string(EffectEdit.KnockbackDistance)
		);

		KnockbackFX.KnockbackDistance = EffectEdit.KnockbackDistance;
	}

	if (EffectEdit.SetKnockbackDestroysNonFragile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bKnockbackDestroysNonFragile",
			string(KnockbackFX.bKnockbackDestroysNonFragile),
			string(EffectEdit.KnockbackDestroysNonFragile)
		);

		KnockbackFX.bKnockbackDestroysNonFragile = EffectEdit.KnockbackDestroysNonFragile;
	}

	if (EffectEdit.SetOverrideRagdollFinishTimerSec)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideRagdollFinishTimerSec",
			string(KnockbackFX.OverrideRagdollFinishTimerSec),
			string(EffectEdit.OverrideRagdollFinishTimerSec)
		);

		KnockbackFX.OverrideRagdollFinishTimerSec = EffectEdit.OverrideRagdollFinishTimerSec;
	}

	if (EffectEdit.SetOnlyOnDeath)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OnlyOnDeath",
			string(KnockbackFX.OnlyOnDeath),
			string(EffectEdit.OnlyOnDeath)
		);

		KnockbackFX.OnlyOnDeath = EffectEdit.OnlyOnDeath;
	}
}
