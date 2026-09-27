class X2AbilityEffectsEditor_ChryssalidBurrowedAttack extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ChryssalidBurrowedAttack');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ChryssalidBurrowedAttack BurrowedAttackEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	BurrowedAttackEffect = X2Effect_ChryssalidBurrowedAttack(Effect);

	if (BurrowedAttackEffect == none)
	{
		return;
	}

	if (EffectEdit.SetNumActions)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumActions",
			string(BurrowedAttackEffect.NumActions),
			string(EffectEdit.NumActions)
		);

		BurrowedAttackEffect.NumActions = EffectEdit.NumActions;
	}
}
