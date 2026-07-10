class X2AbilityConditionEditor_Helper extends Object;

// Applies a list of condition edits to a condition array
// (template-level arrays or an effect's TargetConditions).
static function ApplyConditionEdits(
	name AbilityName,
	string Slot,
	out array<X2Condition> Conditions,
	array<ConditionEdit> ConditionEdits
)
{
	local int i;

	for (i = 0; i < ConditionEdits.Length; ++i)
	{
		ApplyConditionEditToArray(AbilityName, Slot, Conditions, ConditionEdits[i]);
	}
}

static function ApplyConditionEditToArray(
	name AbilityName,
	string Slot,
	out array<X2Condition> Conditions,
	ConditionEdit ConditionEdit
)
{
	local class<X2Condition> ConditionClass;
	local X2Condition Condition;
	local int Index;

	ConditionClass = LoadConditionClass(ConditionEdit.Class);

	if (ConditionClass == none)
	{
		`log("AbilityEdit: Invalid condition class:" @ ConditionEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return;
	}

	Index = FindConditionIndex(Conditions, ConditionClass);

	if (ConditionEdit.Mode == eAEM_Remove)
	{
		if (Index != INDEX_NONE)
		{
			`log(string(AbilityName) @ Slot @ "condition removed:" @ string(ConditionClass.Name), class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			Conditions.Remove(Index, 1);
		}
		return;
	}

	if (ConditionEdit.Mode == eAEM_ReplaceAll)
	{
		`log(string(AbilityName) @ Slot @ "conditions cleared", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		Conditions.Length = 0;
		Index = INDEX_NONE;
	}

	if (Index == INDEX_NONE)
	{
		Condition = new ConditionClass;
		Conditions.AddItem(Condition);
	}
	else
	{
		Condition = Conditions[Index];
	}

	DispatchConditionEdit(AbilityName, Slot, Condition, ConditionEdit);
}

static function class<X2Condition> LoadConditionClass(string ClassName)
{
	local class<X2Condition> ConditionClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2Condition";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	ConditionClass = class<X2Condition>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (ConditionClass == none)
	{
		`log("AbilityEdit: Failed to load condition class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return ConditionClass;
}

static function int FindConditionIndex(
	array<X2Condition> Conditions,
	class<X2Condition> ConditionClass
)
{
	local int i;

	for (i = 0; i < Conditions.Length; ++i)
	{
		if (Conditions[i].Class == ConditionClass)
		{
			return i;
		}
	}

	return INDEX_NONE;
}

static function DispatchConditionEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local int i;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ConditionEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ConditionEditors[i].static.CanEdit(Condition))
		{
			class'X2DLCInfo_AbilityEditor'.default.ConditionEditors[i].static.ApplyEdit(
				AbilityName,
				Slot,
				Condition,
				ConditionEdit
			);
			return;
		}
	}
}

// Shared by X2AbilityConditionEditor_UnitEffects and its subclasses.
// Merge/Remove are keyed by EffectName.
static function ApplyEffectReasonArrayEdit(
	name AbilityName,
	string Category,
	out array<EffectReason> Target,
	array<EffectReason> EditValues,
	ENameArrayEditMode Mode
)
{
	local int i, Index;

	if (EditValues.Length == 0)
	{
		return;
	}

	switch (Mode)
	{
		case eNAEM_Replace:
			`log(string(AbilityName) @ Category @ "replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			Target = EditValues;
			break;

		case eNAEM_AddOnly:
			if (Target.Length == 0)
			{
				`log(string(AbilityName) @ Category @ "set", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
				Target = EditValues;
			}
			break;

		case eNAEM_Merge:
			for (i = 0; i < EditValues.Length; ++i)
			{
				Index = FindEffectReasonIndex(Target, EditValues[i].EffectName);

				if (Index == INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						"none",
						string(EditValues[i].EffectName)
					);
					Target.AddItem(EditValues[i]);
				}
				else
				{
					Target[Index] = EditValues[i];
				}
			}
			break;

		case eNAEM_Remove:
			for (i = 0; i < EditValues.Length; ++i)
			{
				Index = FindEffectReasonIndex(Target, EditValues[i].EffectName);

				if (Index != INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						string(EditValues[i].EffectName),
						"none"
					);
					Target.Remove(Index, 1);
				}
			}
			break;
	}
}

static function int FindEffectReasonIndex(const out array<EffectReason> Entries, name EffectName)
{
	local int i;

	for (i = 0; i < Entries.Length; ++i)
	{
		if (Entries[i].EffectName == EffectName)
		{
			return i;
		}
	}

	return INDEX_NONE;
}
