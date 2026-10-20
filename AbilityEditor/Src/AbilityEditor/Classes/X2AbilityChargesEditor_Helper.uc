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

	// No Class: edit the template's own charges (no-op when it has none)
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
		class'X2AbilityEditor_Logger'.static.LogError(string(Template.DataName) @ "Charges names a class that does not exist:" @ ChargesEdit.Class);
		return;
	}

	// Existing charges already of that exact class: edit the template's own copy
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

	return ChargesClass;
}

static function DispatchChargesEdit(name AbilityName, X2AbilityCharges AbilityCharges, ChargesEdit ChargesEdit)
{
	local int i;
	local class<X2AbilityChargesEditor> ExtraEditor;
	local bool IsClaimed;

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityChargesEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCharges))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, AbilityCharges, ChargesEdit);
			IsClaimed = true;
		}
	}

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.ChargesEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ChargesEditors[i] != none &&
			class'X2DLCInfo_AbilityEditor'.default.ChargesEditors[i].static.CanEdit(AbilityCharges))
		{
			class'X2DLCInfo_AbilityEditor'.default.ChargesEditors[i].static.ApplyEdit(AbilityName, AbilityCharges, ChargesEdit);
			IsClaimed = true;
		}
	}

	if (!IsClaimed)
	{
		class'X2AbilityEditor_Logger'.static.LogError(string(AbilityName) @ "has no editor for charges class" @ string(AbilityCharges.Class.Name));
	}

	// Extensions run after the editor that claimed the object, whichever one that was.
	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors.Length; ++i)
	{
		if (!class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityChargesEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraChargesEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCharges))
		{
			ExtraEditor.static.ApplyDerivedEdit(AbilityName, AbilityCharges, ChargesEdit);
		}
	}
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
