class X2AbilityEffectsEditor_GrantActionPoints extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_GrantActionPoints');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_GrantActionPoints GrantEffect;

	GrantEffect = X2Effect_GrantActionPoints(Effect);

	if (GrantEffect == none)
	{
		return;
	}

	if (EffectEdit.SetNumActionPoints)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumActionPoints",
			string(GrantEffect.NumActionPoints),
			string(EffectEdit.NumActionPoints)
		);

		GrantEffect.NumActionPoints = EffectEdit.NumActionPoints;
	}

	if (EffectEdit.SetPointType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PointType",
			string(GrantEffect.PointType),
			string(EffectEdit.PointType)
		);

		GrantEffect.PointType = EffectEdit.PointType;
	}

	if (EffectEdit.SetApplyOnlyWhenOut)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyOnlyWhenOut",
			string(GrantEffect.bApplyOnlyWhenOut),
			string(EffectEdit.ApplyOnlyWhenOut)
		);

		GrantEffect.bApplyOnlyWhenOut = EffectEdit.ApplyOnlyWhenOut;
	}

	if (EffectEdit.SetSelectUnit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSelectUnit",
			string(GrantEffect.bSelectUnit),
			string(EffectEdit.SelectUnit)
		);

		GrantEffect.bSelectUnit = EffectEdit.SelectUnit;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".SkipWithEffect",
		GrantEffect.SkipWithEffect,
		EffectEdit.SkipWithEffect,
		EffectEdit.SkipWithEffectMode
	);
}
