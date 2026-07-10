class X2AbilityTriggerEditor_EventListener extends X2AbilityTriggerEditor_Base;

static function bool CanEdit(X2AbilityTrigger Trigger)
{
	return Trigger.IsA('X2AbilityTrigger_EventListener');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	local X2AbilityTrigger_EventListener ListenerTrigger;

	ListenerTrigger = X2AbilityTrigger_EventListener(Trigger);

	if (ListenerTrigger == none)
	{
		return;
	}

	if (TriggerEdit.SetListenerEventID)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ListenerData.EventID",
			string(ListenerTrigger.ListenerData.EventID),
			string(TriggerEdit.ListenerEventID)
		);

		ListenerTrigger.ListenerData.EventID = TriggerEdit.ListenerEventID;
	}

	if (TriggerEdit.SetListenerDeferral)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ListenerData.Deferral",
			string(ListenerTrigger.ListenerData.Deferral),
			string(TriggerEdit.ListenerDeferral)
		);

		ListenerTrigger.ListenerData.Deferral = TriggerEdit.ListenerDeferral;
	}

	if (TriggerEdit.SetListenerFilter)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ListenerData.Filter",
			string(ListenerTrigger.ListenerData.Filter),
			string(TriggerEdit.ListenerFilter)
		);

		ListenerTrigger.ListenerData.Filter = TriggerEdit.ListenerFilter;
	}

	if (TriggerEdit.SetListenerPriority)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ListenerData.Priority",
			string(ListenerTrigger.ListenerData.Priority),
			string(TriggerEdit.ListenerPriority)
		);

		ListenerTrigger.ListenerData.Priority = TriggerEdit.ListenerPriority;
	}
}
