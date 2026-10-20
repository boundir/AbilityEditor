class X2AbilityCostEditor_Helper extends Object;

// The Nth cost of the class.
static function int FindCostIndex(array<X2AbilityCost> AbilityCosts, class<X2AbilityCost> AbilityCostClass, optional int MatchIndex)
{
	local int i, Matches;

	for (i = 0; i < AbilityCosts.Length; ++i)
	{
		if (AbilityCosts[i].Class != AbilityCostClass)
		{
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
			class'X2AbilityEditor_Logger'.static.LogError(string(Template.DataName) @ "Costs names a cost class that does not exist:" @ CostEdit.Class);
			continue;
		}

		Index = FindCostIndex(Template.AbilityCosts, CostClass, CostEdit.Index);

		if (Index == INDEX_NONE && CostEdit.Index > 0)
		{
			class'X2AbilityEditor_Logger'.static.LogError(string(Template.DataName) @ "Template.AbilityCosts has no" @ string(CostClass.Name) @ "matching Index" @ CostEdit.Index $ "; Merge adds a new one, Remove does nothing");
		}

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
	local bool IsClaimed;

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityCostEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCost))
		{
			ExtraEditor.static.ApplyEdit(AbilityName, AbilityCost, CostEdit);
			IsClaimed = true;
		}
	}

	for (i = 0; !IsClaimed && i < class'X2DLCInfo_AbilityEditor'.default.CostEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.CostEditors[i] != none &&
			class'X2DLCInfo_AbilityEditor'.default.CostEditors[i].static.CanEdit(AbilityCost))
		{
			class'X2DLCInfo_AbilityEditor'.default.CostEditors[i].static.ApplyEdit(AbilityName, AbilityCost, CostEdit);
			IsClaimed = true;
		}
	}

	if (!IsClaimed)
	{
		class'X2AbilityEditor_Logger'.static.LogError(string(AbilityName) @ "has no editor for cost class" @ string(AbilityCost.Class.Name));
	}

	// Extensions run after the editor that claimed the object, whichever one that was.
	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors.Length; ++i)
	{
		if (!class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors[i].RunAfter)
		{
			continue;
		}

		ExtraEditor = class<X2AbilityCostEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraCostEditors[i].EditorClass, class'Class'));

		if (ExtraEditor != none && ExtraEditor.static.CanEdit(AbilityCost))
		{
			ExtraEditor.static.ApplyDerivedEdit(AbilityName, AbilityCost, CostEdit);
		}
	}
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

	return CostClass;
}
