class X2AbilityTargetStyleEditor_Helper extends Object;

static function ApplyTargetStyleEdit(X2AbilityTemplate Template, TargetStyleEdit TargetStyleEdit)
{
	Template.AbilityTargetStyle = ApplyToSlot(
		Template.DataName,
		"Template.AbilityTargetStyle",
		Template.AbilityTargetStyle,
		TargetStyleEdit
	);
}

// Returns the object that should occupy the slot.
static function X2AbilityTargetStyle ApplyToSlot(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle Existing,
	TargetStyleEdit TargetStyleEdit
)
{
	local X2AbilityTargetStyle TargetStyle;
	local class<X2AbilityTargetStyle> TargetStyleClass;

	if (TargetStyleEdit.Class == "")
	{
		if (Existing != none)
		{
			DispatchTargetStyleEdit(AbilityName, Slot, Existing, TargetStyleEdit);
		}
		return Existing;
	}

	TargetStyleClass = LoadTargetStyleClass(TargetStyleEdit.Class);

	if (TargetStyleClass == none)
	{
		class'X2AbilityEditor_Logger'.static.LogError(string(AbilityName) @ Slot @ "names a target style class that does not exist:" @ TargetStyleEdit.Class);
		return Existing;
	}

	if (Existing != none && Existing.Class == TargetStyleClass)
	{
		DispatchTargetStyleEdit(AbilityName, Slot, Existing, TargetStyleEdit);
		return Existing;
	}

	TargetStyle = new TargetStyleClass;
	DispatchTargetStyleEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
	return TargetStyle;
}

static function class<X2AbilityTargetStyle> LoadTargetStyleClass(string ClassName)
{
	local class<X2AbilityTargetStyle> TargetStyleClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityTargetStyle";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	TargetStyleClass = class<X2AbilityTargetStyle>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	return TargetStyleClass;
}

static function DispatchTargetStyleEdit(
	name AbilityName,
	string Slot,
	X2AbilityTargetStyle TargetStyle,
	TargetStyleEdit TargetStyleEdit
)
{
	local int i;
	local class<X2AbilityTargetStyleEditor> ExtraEditor;
	local bool IsClaimed;

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityTargetStyleEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(TargetStyle))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
			IsClaimed = true;
		}
	}

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors[i] != none &&
			class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors[i].static.CanEdit(TargetStyle))
		{
			class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors[i].static.ApplyEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
			IsClaimed = true;
		}
	}

	// Extensions run after the editor that claimed the object, whichever one that was.
	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors.Length; ++i)
	{
		if (!class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityTargetStyleEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraTargetStyleEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(TargetStyle))
		{
			ExtraEditor.static.ApplyDerivedEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
		}
	}
}