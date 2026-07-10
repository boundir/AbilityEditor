class X2AbilityCostEditor_Helper extends Object;

static function int FindCostIndex(array<X2AbilityCost> AbilityCosts, class<X2AbilityCost> AbilityCostClass)
{
	local int i;

	for (i = 0; i < AbilityCosts.Length; ++i)
	{
		if (AbilityCosts[i].Class == AbilityCostClass)
		{
			return i;
		}
	}

	return INDEX_NONE;
}

static function RemoveCostByClass(out array<X2AbilityCost> AbilityCosts, class<X2AbilityCost> AbilityCostClass)
{
	local int Index;

	Index = FindCostIndex(AbilityCosts, AbilityCostClass);

	if (Index != INDEX_NONE)
	{
		AbilityCosts.Remove(Index, 1);
	}
}

static function ApplyCostEdit(X2AbilityTemplate Template, AbilityEdit AbilityEdit)
{
	local int i;
	local CostEdit CostEdit;
	local class<X2AbilityCost> CostClass;
	local X2AbilityCost Cost;
	local int Index;

	if (AbilityEdit.Costs.Length == 0)
	{
		return;
	}

	if (AbilityEdit.CostMode == eACEM_ReplaceAll)
	{
		`log(Template.DataName @ "removed all costs", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		Template.AbilityCosts.Length = 0;
	}

	for (i = 0; i < AbilityEdit.Costs.Length; ++i)
	{
		CostEdit = AbilityEdit.Costs[i];

		CostClass = LoadCostClass(CostEdit.Class);

		if (CostClass == none)
		{
			`log("AbilityEdit: Invalid cost class:" @ CostEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			continue;
		}

		Index = FindCostIndex(Template.AbilityCosts, CostClass);

		if (CostEdit.Mode == eACEM_Remove)
		{
			if (Index != INDEX_NONE)
			{
				Template.AbilityCosts.Remove(Index, 1);
			}
			continue;
		}

		if (Index == INDEX_NONE)
		{
			if (CostEdit.Mode == eACEM_AddOnly ||
				CostEdit.Mode == eACEM_Merge ||
				AbilityEdit.CostMode == eACEM_ReplaceAll)
			{
				Cost = InstantiateCost(CostClass);
				Template.AbilityCosts.AddItem(Cost);
			}
			else
			{
				continue;
			}
		}
		else
		{
			Cost = Template.AbilityCosts[Index];
		}

		DispatchCostEdit(Template.DataName, Cost, CostEdit);
	}
}

static function DispatchCostEdit(name AbilityName, X2AbilityCost AbilityCost, CostEdit CostEdit)
{
	local int i;
	local class<X2AbilityCostEditor> ExtraEditor;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors.Length; ++i)
	{
		ExtraEditor = class<X2AbilityCostEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors[i].EditorClass, class'Class'));
		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCost))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, AbilityCost, CostEdit);
			return;
		}
	}

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.CostEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.CostEditors[i].static.CanEdit(AbilityCost))
		{
			class'X2DLCInfo_AbilityEditor'.default.CostEditors[i].static.ApplyEdit(AbilityName, AbilityCost, CostEdit);
			return;
		}
	}

	`log("AbilityCostEdit: No editor for cost class" @ AbilityCost.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
}

static function X2AbilityCost InstantiateCost(class<X2AbilityCost> CostClass)
{
	if (CostClass == none)
	{
		return none;
	}

	return new CostClass;
}

static function class<X2AbilityCost> LoadCostClass(string ClassName)
{
	local class<X2AbilityCost> CostClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityCost";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	CostClass = class<X2AbilityCost>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (CostClass == none)
	{
		`log(
			"AbilityEdit: Failed to load cost class:" @ QualifiedName,
			class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
			'AbilityEditor'
		);
	}

	return CostClass;
}
