class X2AbilityConditionEditor extends Object abstract;

static function bool CanEdit(X2Condition Condition);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, Condition, ConditionEdit);
	ApplyDerivedEdit(AbilityName, Slot, Condition, ConditionEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	// X2Condition itself has no editable fields.
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
);
