class X2AbilityEffectsEditor_PersistentVoidConduit extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PersistentVoidConduit');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PersistentVoidConduit PersistentVoidConduitFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	PersistentVoidConduitFX = X2Effect_PersistentVoidConduit(Effect);

	if (PersistentVoidConduitFX == none)
	{
		return;
	}

	if (EffectEdit.SetInitialDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".InitialDamage",
			string(PersistentVoidConduitFX.InitialDamage),
			string(EffectEdit.InitialDamage)
		);

		PersistentVoidConduitFX.InitialDamage = EffectEdit.InitialDamage;
	}
}
