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
		`log("AbilityEdit: Invalid trigger class:" @ TriggerEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return;
	}

	Index = FindTriggerIndex(Triggers, TriggerClass);

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

	if (TriggerClass == none)
	{
		`log("AbilityEdit: Failed to load trigger class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return TriggerClass;
}

static function int FindTriggerIndex(
	array<X2AbilityTrigger> Triggers,
	class<X2AbilityTrigger> TriggerClass
)
{
	local int i;

	for (i = 0; i < Triggers.Length; ++i)
	{
		if (Triggers[i].Class == TriggerClass)
		{
			return i;
		}
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

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors.Length; ++i)
	{
		ExtraEditor = class<X2AbilityTriggerEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraTriggerEditors[i].EditorClass, class'Class'));
		if (ExtraEditor != none && ExtraEditor.static.CanEdit(Trigger))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, Slot, Trigger, TriggerEdit);
			return;
		}
	}

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.TriggerEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.TriggerEditors[i].static.CanEdit(Trigger))
		{
			class'X2DLCInfo_AbilityEditor'.default.TriggerEditors[i].static.ApplyEdit(AbilityName, Slot, Trigger, TriggerEdit);
			return;
		}
	}
}