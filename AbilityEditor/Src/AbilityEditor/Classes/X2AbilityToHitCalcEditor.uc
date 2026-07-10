class X2AbilityToHitCalcEditor extends Object abstract;

static function bool CanEdit(X2AbilityToHitCalc ToHitCalc);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);
	ApplyDerivedEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	// Replace-only: ShotModifierInfo has no natural merge key
	if (ToHitCalcEdit.HitModifiers.Length > 0)
	{
		`log(string(AbilityName) @ Slot $ ".HitModifiers replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		ToHitCalc.HitModifiers = ToHitCalcEdit.HitModifiers;
	}
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
);
