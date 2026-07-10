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

// Returns the object that should occupy the slot: the existing one (edited in place
// when Class is empty or matches), or a fresh instance of Class.
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
		`log("AbilityEdit: Invalid target style class:" @ TargetStyleEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
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

	if (TargetStyleClass == none)
	{
		`log("AbilityEdit: Failed to load target style class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

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

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors[i].static.CanEdit(TargetStyle))
		{
			class'X2DLCInfo_AbilityEditor'.default.TargetStyleEditors[i].static.ApplyEdit(AbilityName, Slot, TargetStyle, TargetStyleEdit);
			return;
		}
	}
}
