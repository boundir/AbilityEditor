class X2AbilityTriggerEditor_Event extends X2AbilityTriggerEditor_Base;

static function bool CanEdit(X2AbilityTrigger Trigger)
{
	return Trigger.IsA('X2AbilityTrigger_Event');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	local X2AbilityTrigger_Event EventTrigger;

	EventTrigger = X2AbilityTrigger_Event(Trigger);

	if (EventTrigger == none)
	{
		return;
	}

	if (TriggerEdit.SetMethodName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MethodName",
			string(EventTrigger.MethodName),
			string(TriggerEdit.MethodName)
		);

		EventTrigger.MethodName = TriggerEdit.MethodName;
	}

	if (TriggerEdit.SetEventObserverClass)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EventObserverClass",
			string(EventTrigger.EventObserverClass),
			TriggerEdit.EventObserverClass
		);

		EventTrigger.EventObserverClass = class<Object>(DynamicLoadObject(TriggerEdit.EventObserverClass, class'Class'));
	}
}
