class X2AbilityTargetStyleEditor extends Object abstract;

static function bool CanEdit(X2AbilityTargetStyle TargetStyle);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
	ApplyDerivedEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	// X2AbilityTargetStyle itself has no editable fields.
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
);