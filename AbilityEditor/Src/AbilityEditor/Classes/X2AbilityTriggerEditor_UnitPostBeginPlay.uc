class X2AbilityTriggerEditor_UnitPostBeginPlay extends X2AbilityTriggerEditor_Base;

static function bool CanEdit(X2AbilityTrigger Trigger)
{
	return Trigger.IsA('X2AbilityTrigger_UnitPostBeginPlay');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	local X2AbilityTrigger_UnitPostBeginPlay PostBeginPlayTrigger;

	PostBeginPlayTrigger = X2AbilityTrigger_UnitPostBeginPlay(Trigger);

	if (PostBeginPlayTrigger == none)
	{
		return;
	}

	if (TriggerEdit.SetPriority)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".Priority",
			string(PostBeginPlayTrigger.Priority),
			string(TriggerEdit.Priority)
		);

		PostBeginPlayTrigger.Priority = TriggerEdit.Priority;
	}
}
