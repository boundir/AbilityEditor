class X2AbilityChargesEditor_Helper extends Object;

static function ApplyChargesEdit(X2AbilityTemplate Template, ChargesEdit ChargesEdit)
{
	local X2AbilityCharges AbilityCharges;
	local class<X2AbilityCharges> ChargesClass;

	if (ChargesEdit.RemoveCharges)
	{
		`log(string(Template.DataName) @ "charges removed", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		Template.AbilityCharges = none;
		return;
	}

	// No Class: edit the template's existing charges in place (no-op when it has none)
	if (ChargesEdit.Class == "")
	{
		if (Template.AbilityCharges != none)
		{
			DispatchChargesEdit(Template.DataName, Template.AbilityCharges, ChargesEdit);
		}
		return;
	}

	ChargesClass = LoadChargesClass(ChargesEdit.Class);

	if (ChargesClass == none)
	{
		`log("AbilityEdit: Invalid Charges class:" @ ChargesEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return;
	}

	// Existing charges already of that exact class: edit in place
	if (Template.AbilityCharges != none && Template.AbilityCharges.Class == ChargesClass)
	{
		DispatchChargesEdit(Template.DataName, Template.AbilityCharges, ChargesEdit);
		return;
	}

	AbilityCharges = new ChargesClass;
	DispatchChargesEdit(Template.DataName, AbilityCharges, ChargesEdit);
	Template.AbilityCharges = AbilityCharges;
}

static function class<X2AbilityCharges> LoadChargesClass(string ClassName)
{
	local class<X2AbilityCharges> ChargesClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityCharges";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	ChargesClass = class<X2AbilityCharges>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (ChargesClass == none)
	{
		`log("AbilityEdit: Failed to load charges class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return ChargesClass;
}


static function DispatchChargesEdit(name AbilityName, X2AbilityCharges AbilityCharges, ChargesEdit ChargesEdit)
{
	local int i;
	local class<X2AbilityChargesEditor> ExtraEditor;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors.Length; ++i)
	{
		ExtraEditor = class<X2AbilityChargesEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors[i].EditorClass, class'Class'));
		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCharges))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, AbilityCharges, ChargesEdit);
			return;
		}
	}

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ChargesEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ChargesEditors[i].static.CanEdit(AbilityCharges))
		{
			class'X2DLCInfo_AbilityEditor'.default.ChargesEditors[i].static.ApplyEdit(AbilityName, AbilityCharges, ChargesEdit);
			return;
		}
	}

	`log("AbilityEdit: No editor for Charges class" @ AbilityCharges.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
}

static function int FindBonusChargeIndex(const out array<X2AbilityCharges.BonusCharge> BonusCharges, name AbilityName)
{
	local int i;

	for (i = 0; i < BonusCharges.Length; ++i)
	{
		if (BonusCharges[i].AbilityName == AbilityName)
		{
			return i;
		}
	}

	return INDEX_NONE;
}
