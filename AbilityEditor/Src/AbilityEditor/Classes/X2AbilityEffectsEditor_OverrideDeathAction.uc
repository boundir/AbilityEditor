class X2AbilityEffectsEditor_OverrideDeathAction extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_OverrideDeathAction');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_OverrideDeathAction DeathActionEffect;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	DeathActionEffect = X2Effect_OverrideDeathAction(Effect);

	if (DeathActionEffect == none)
	{
		return;
	}

	if (EffectEdit.SetDeathActionClass)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DeathActionClass",
			PathName(DeathActionEffect.DeathActionClass),
			EffectEdit.DeathActionClass
		);

		DeathActionEffect.DeathActionClass = class<X2Action>(DynamicLoadObject(EffectEdit.DeathActionClass, class'Class'));

		if (DeathActionEffect.DeathActionClass == none && EffectEdit.DeathActionClass != "")
		{
			`log(
				"AbilityEdit:" @ string(AbilityName) @ Slot $ ".DeathActionClass" @
				"could not load class" @ EffectEdit.DeathActionClass,
				class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
				'AbilityEditor'
			);
		}
	}
}
