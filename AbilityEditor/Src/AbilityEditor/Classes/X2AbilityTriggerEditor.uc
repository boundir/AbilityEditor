class X2AbilityTriggerEditor extends Object abstract;

static function bool CanEdit(X2AbilityTrigger Trigger);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, Trigger, TriggerEdit);
	ApplyDerivedEdit(AbilityName, Slot, Trigger, TriggerEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	// X2AbilityTrigger itself has no editable fields.
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
);