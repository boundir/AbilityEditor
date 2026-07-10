class X2AbilityEffectsEditor_AdverseSoldierClasses extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_AdverseSoldierClasses');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_AdverseSoldierClasses AdverseSoldierClassesFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	AdverseSoldierClassesFX = X2Effect_AdverseSoldierClasses(Effect);

	if (AdverseSoldierClassesFX == none)
	{
		return;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".AdverseClasses",
		AdverseSoldierClassesFX.AdverseClasses,
		EffectEdit.AdverseClasses,
		EffectEdit.AdverseClassesMode
	);

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(AdverseSoldierClassesFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		AdverseSoldierClassesFX.DmgMod = EffectEdit.DmgMod;
	}
}
