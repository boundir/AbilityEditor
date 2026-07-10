class X2AbilityToHitCalcEditor_Helper extends Object;

static function ApplyToHitCalcEdit(X2AbilityTemplate Template, ToHitCalcEdit ToHitCalcEdit)
{
	Template.AbilityToHitCalc = ApplyToSlot(
		Template.DataName,
		"Template.AbilityToHitCalc",
		Template.AbilityToHitCalc,
		ToHitCalcEdit
	);
}

static function ApplyToHitOwnerOnMissCalcEdit(X2AbilityTemplate Template, ToHitCalcEdit ToHitCalcEdit)
{
	Template.AbilityToHitOwnerOnMissCalc = ApplyToSlot(
		Template.DataName,
		"Template.AbilityToHitOwnerOnMissCalc",
		Template.AbilityToHitOwnerOnMissCalc,
		ToHitCalcEdit
	);
}

// Returns the object that should occupy the slot: the existing one (edited in place
// when Class is empty or matches), or a fresh instance of Class.
static function X2AbilityToHitCalc ApplyToSlot(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc Existing,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local X2AbilityToHitCalc ToHitCalc;
	local class<X2AbilityToHitCalc> ToHitCalcClass;

	if (ToHitCalcEdit.Class == "")
	{
		if (Existing != none)
		{
			DispatchToHitCalcEdit(AbilityName, Slot, Existing, ToHitCalcEdit);
		}
		return Existing;
	}

	ToHitCalcClass = LoadToHitCalcClass(ToHitCalcEdit.Class);

	if (ToHitCalcClass == none)
	{
		`log("AbilityEdit: Invalid to-hit calc class:" @ ToHitCalcEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return Existing;
	}

	if (Existing != none && Existing.Class == ToHitCalcClass)
	{
		DispatchToHitCalcEdit(AbilityName, Slot, Existing, ToHitCalcEdit);
		return Existing;
	}

	ToHitCalc = new ToHitCalcClass;
	DispatchToHitCalcEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);
	return ToHitCalc;
}

static function class<X2AbilityToHitCalc> LoadToHitCalcClass(string ClassName)
{
	local class<X2AbilityToHitCalc> ToHitCalcClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityToHitCalc";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	ToHitCalcClass = class<X2AbilityToHitCalc>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (ToHitCalcClass == none)
	{
		`log("AbilityEdit: Failed to load to-hit calc class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return ToHitCalcClass;
}

static function DispatchToHitCalcEdit(
	name AbilityName,
	string Slot,
	X2AbilityToHitCalc ToHitCalc,
	ToHitCalcEdit ToHitCalcEdit
)
{
	local int i;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ToHitCalcEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ToHitCalcEditors[i].static.CanEdit(ToHitCalc))
		{
			class'X2DLCInfo_AbilityEditor'.default.ToHitCalcEditors[i].static.ApplyEdit(AbilityName, Slot, ToHitCalc, ToHitCalcEdit);
			return;
		}
	}
}
