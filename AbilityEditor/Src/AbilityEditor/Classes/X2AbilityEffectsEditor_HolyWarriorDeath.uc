class X2AbilityEffectsEditor_HolyWarriorDeath extends X2AbilityEffectsEditor_ApplyWeaponDamage;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_HolyWarriorDeath');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_HolyWarriorDeath HolyWarriorDeathFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	HolyWarriorDeathFX = X2Effect_HolyWarriorDeath(Effect);

	if (HolyWarriorDeathFX == none)
	{
		return;
	}

	if (EffectEdit.SetDelayTimeS)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DelayTimeS",
			string(HolyWarriorDeathFX.DelayTimeS),
			string(EffectEdit.DelayTimeS)
		);

		HolyWarriorDeathFX.DelayTimeS = EffectEdit.DelayTimeS;
	}
}
