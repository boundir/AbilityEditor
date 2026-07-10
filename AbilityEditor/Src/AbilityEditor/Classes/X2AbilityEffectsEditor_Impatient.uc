class X2AbilityEffectsEditor_Impatient extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Impatient');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Impatient ImpatientFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	ImpatientFX = X2Effect_Impatient(Effect);

	if (ImpatientFX == none)
	{
		return;
	}

	if (EffectEdit.SetDmgMod)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DmgMod",
			string(ImpatientFX.DmgMod),
			string(EffectEdit.DmgMod)
		);

		ImpatientFX.DmgMod = EffectEdit.DmgMod;
	}
}
