// X2Effect_DamageImmunity extends X2Effect_Persistent, so chain the Persistent editor
class X2AbilityEffectsEditor_DamageImmunity extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_DamageImmunity');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_DamageImmunity DamageImmunityEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	DamageImmunityEffect = X2Effect_DamageImmunity(Effect);

	if (EffectEdit.SetImmuneTypesAreInclusive)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ImmueTypesAreInclusive",
			string(DamageImmunityEffect.ImmueTypesAreInclusive),
			string(EffectEdit.ImmuneTypesAreInclusive)
		);

		DamageImmunityEffect.ImmueTypesAreInclusive = EffectEdit.ImmuneTypesAreInclusive;
	}

	if (EffectEdit.SetRemoveAfterAttackCount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RemoveAfterAttackCount",
			string(DamageImmunityEffect.RemoveAfterAttackCount),
			string(EffectEdit.RemoveAfterAttackCount)
		);

		DamageImmunityEffect.RemoveAfterAttackCount = EffectEdit.RemoveAfterAttackCount;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".ImmuneTypes",
		DamageImmunityEffect.ImmuneTypes,
		EffectEdit.ImmuneTypes,
		EffectEdit.ImmuneTypesMode
	);
}
