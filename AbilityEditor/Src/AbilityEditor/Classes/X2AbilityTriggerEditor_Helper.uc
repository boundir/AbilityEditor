class X2AbilityTriggerEditor_Helper extends Object;

static function ApplyTriggerEdits(X2AbilityTemplate Template, array<TriggerEdit> TriggerEdits)
{
	local int i;

	for (i = 0; i < TriggerEdits.Length; ++i)
	{
		ApplyTriggerEditToArray(Template.DataName, Template.AbilityTriggers, TriggerEdits[i]);
	}
}

static function ApplyTriggerEditToArray(
	name AbilityName,
	out array<X2AbilityTrigger> Triggers,
	TriggerEdit TriggerEdit
)
{
	local class<X2AbilityTrigger> TriggerClass;
	local X2AbilityTrigger Trigger;
	local int Index;

	TriggerClass = LoadTriggerClass(TriggerEdit.Class);

	if (TriggerClass == none)
	{
		class'X2AbilityEditor_Logger'.static.LogError(string(AbilityName) @ "Triggers names a trigger class that does not exist:" @ TriggerEdit.Class);
		return;
	}

	Index = FindTriggerIndex(Triggers, TriggerClass, TriggerEdit.Index, TriggerEdit.MatchEventID);

	if (Index == INDEX_NONE && (TriggerEdit.Index > 0 || TriggerEdit.MatchEventID != ''))
	{
		class'X2AbilityEditor_Logger'.static.LogError(string(AbilityName) @ "Template.AbilityTriggers has no" @ string(TriggerClass.Name) @ "matching Index" @ TriggerEdit.Index @ "MatchEventID" @ string(TriggerEdit.MatchEventID) $ "; Merge adds a new one, Remove does nothing");
	}

	if (TriggerEdit.Mode == eAEM_Remove)
	{
		if (Index != INDEX_NONE)
		{
			`log(string(AbilityName) @ "Template.AbilityTriggers trigger removed:" @ string(TriggerClass.Name), class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			Triggers.Remove(Index, 1);
		}
		return;
	}

	if (TriggerEdit.Mode == eAEM_ReplaceAll)
	{
		`log(string(AbilityName) @ "Template.AbilityTriggers cleared", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		Triggers.Length = 0;
		Index = INDEX_NONE;
	}

	if (Index == INDEX_NONE)
	{
		Trigger = new TriggerClass;
		Triggers.AddItem(Trigger);
	}
	else
	{
		Trigger = Triggers[Index];
	}

	DispatchTriggerEdit(AbilityName, "Template.AbilityTriggers", Trigger, TriggerEdit);
}

static function class<X2AbilityTrigger> LoadTriggerClass(string ClassName)
{
	local class<X2AbilityTrigger> TriggerClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityTrigger";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	TriggerClass = class<X2AbilityTrigger>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	return TriggerClass;
}

// The Nth trigger of the class, or the event listener whose EventID matches when one is given.
static function int FindTriggerIndex(
	array<X2AbilityTrigger> Triggers,
	class<X2AbilityTrigger> TriggerClass,
	optional int MatchIndex,
	optional name MatchEventID
)
{
	local X2AbilityTrigger_EventListener Listener;
	local int i, Matches;

	for (i = 0; i < Triggers.Length; ++i)
	{
		if (Triggers[i].Class != TriggerClass)
		{
			continue;
		}

		if (MatchEventID != '')
		{
			Listener = X2AbilityTrigger_EventListener(Triggers[i]);

			if (Listener != none && Listener.ListenerData.EventID == MatchEventID)
			{
				return i;
			}

			continue;
		}

		if (Matches == MatchIndex)
		{
			return i;
		}

		Matches++;
	}

	return INDEX_NONE;
}

static function DispatchTriggerEdit(
	name AbilityName,
	string Slot,
	X2AbilityTrigger Trigger,
	TriggerEdit TriggerEdit
)
{
	local int i;
	local class<X2AbilityTriggerEditor> ExtraEditor;
	local bool IsClaimed;

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityTriggerEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(Trigger))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, Slot, Trigger, TriggerEdit);
			IsClaimed = true;
		}
	}

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.TriggerEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.TriggerEditors[i] != none &&
			class'X2DLCInfo_AbilityEditor'.default.TriggerEditors[i].static.CanEdit(Trigger))
		{
			class'X2DLCInfo_AbilityEditor'.default.TriggerEditors[i].static.ApplyEdit(AbilityName, Slot, Trigger, TriggerEdit);
			IsClaimed = true;
		}
	}

	// Extensions run after the editor that claimed the object, whichever one that was.
	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors.Length; ++i)
	{
		if (!class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityTriggerEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(Trigger))
		{
			ExtraEditor.static.ApplyDerivedEdit(AbilityName, Slot, Trigger, TriggerEdit);
		}
	}
}