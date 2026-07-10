class X2AbilityEffectsEditor_ReduceCooldowns extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ReduceCooldowns');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ReduceCooldowns ReduceCooldownsFX;

	ReduceCooldownsFX = X2Effect_ReduceCooldowns(Effect);

	if (ReduceCooldownsFX == none)
	{
		return;
	}

	if (EffectEdit.SetAmount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".Amount",
			string(ReduceCooldownsFX.Amount),
			string(EffectEdit.Amount)
		);

		ReduceCooldownsFX.Amount = EffectEdit.Amount;
	}

	if (EffectEdit.SetReduceAll)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ReduceAll",
			string(ReduceCooldownsFX.ReduceAll),
			string(EffectEdit.ReduceAll)
		);

		ReduceCooldownsFX.ReduceAll = EffectEdit.ReduceAll;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".AbilitiesToTick",
		ReduceCooldownsFX.AbilitiesToTick,
		EffectEdit.AbilitiesToTick,
		EffectEdit.AbilitiesToTickMode
	);
}
