class X2AbilityMultiTargetStyleEditor_Helper extends Object;

static function ApplyMultiTargetStyleEdit(X2AbilityTemplate Template, MultiTargetStyleEdit MultiTargetStyleEdit)
{
	Template.AbilityMultiTargetStyle = ApplyToSlot(
		Template.DataName,
		"Template.AbilityMultiTargetStyle",
		Template.AbilityMultiTargetStyle,
		MultiTargetStyleEdit
	);
}


// Returns the object that should occupy the slot: the existing one (edited in place
// when Class is empty or matches), or a fresh instance of Class.
static function X2AbilityMultiTargetStyle ApplyToSlot(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle Existing,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local X2AbilityMultiTargetStyle MultiTargetStyle;
	local class<X2AbilityMultiTargetStyle> MultiTargetStyleClass;

	if (MultiTargetStyleEdit.Class == "")
	{
		if (Existing != none)
		{
			DispatchMultiTargetStyleEdit(AbilityName, Slot, Existing, MultiTargetStyleEdit);
		}
		return Existing;
	}

	MultiTargetStyleClass = LoadMultiTargetStyleClass(MultiTargetStyleEdit.Class);

	if (MultiTargetStyleClass == none)
	{
		`log("AbilityEdit: Invalid multi-target style class:" @ MultiTargetStyleEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return Existing;
	}

	if (Existing != none && Existing.Class == MultiTargetStyleClass)
	{
		DispatchMultiTargetStyleEdit(AbilityName, Slot, Existing, MultiTargetStyleEdit);
		return Existing;
	}

	MultiTargetStyle = new MultiTargetStyleClass;
	DispatchMultiTargetStyleEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);
	return MultiTargetStyle;
}

static function class<X2AbilityMultiTargetStyle> LoadMultiTargetStyleClass(string ClassName)
{
	local class<X2AbilityMultiTargetStyle> MultiTargetStyleClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityMultiTargetStyle";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	MultiTargetStyleClass = class<X2AbilityMultiTargetStyle>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (MultiTargetStyleClass == none)
	{
		`log("AbilityEdit: Failed to load multi-target style class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return MultiTargetStyleClass;
}

static function DispatchMultiTargetStyleEdit(
	name AbilityName,
	string Slot,
	X2AbilityMultiTargetStyle MultiTargetStyle,
	MultiTargetStyleEdit MultiTargetStyleEdit
)
{
	local int i;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.MultiTargetStyleEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.MultiTargetStyleEditors[i].static.CanEdit(MultiTargetStyle))
		{
			class'X2DLCInfo_AbilityEditor'.default.MultiTargetStyleEditors[i].static.ApplyEdit(AbilityName, Slot, MultiTargetStyle, MultiTargetStyleEdit);
			return;
		}
	}
}
