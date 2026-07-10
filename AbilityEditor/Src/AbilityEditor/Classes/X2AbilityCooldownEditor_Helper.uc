class X2AbilityCooldownEditor_Helper extends Object;

static function ApplyCooldownEdit(X2AbilityTemplate Template, CooldownEdit AbilityEdit)
{
	local X2AbilityCooldown AbilityCooldown;
	local class<X2AbilityCooldown> CooldownClass;

	// No Class: edit the template's existing cooldown in place (no-op when it has none)
	if (AbilityEdit.Class == "")
	{
		if (Template.AbilityCooldown != none)
		{
			DispatchCooldownEdit(Template.DataName, Template.AbilityCooldown, AbilityEdit);
		}
		return;
	}

	CooldownClass = LoadCooldownClass(AbilityEdit.Class);

	if (CooldownClass == none)
	{
		`log("AbilityEdit: Invalid cooldown class:" @ AbilityEdit.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		return;
	}

	// Existing cooldown already of that exact class: edit in place
	if (Template.AbilityCooldown != none && Template.AbilityCooldown.Class == CooldownClass)
	{
		DispatchCooldownEdit(Template.DataName, Template.AbilityCooldown, AbilityEdit);
		return;
	}

	AbilityCooldown = new CooldownClass;
	DispatchCooldownEdit(Template.DataName, AbilityCooldown, AbilityEdit);
	Template.AbilityCooldown = AbilityCooldown;
}

static function class<X2AbilityCooldown> LoadCooldownClass(string ClassName)
{
	local class<X2AbilityCooldown> CooldownClass;
	local string QualifiedName;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2AbilityCooldown";
	}

	QualifiedName = ClassName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}

	CooldownClass = class<X2AbilityCooldown>(
		DynamicLoadObject(QualifiedName, class'Class')
	);

	if (CooldownClass == none)
	{
		`log("AbilityEdit: Failed to load cooldown class:" @ QualifiedName, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
	}

	return CooldownClass;
}


static function DispatchCooldownEdit(name AbilityName, X2AbilityCooldown AbilityCooldown, CooldownEdit CooldownEdit)
{
	local int i;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.CooldownEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.CooldownEditors[i].static.CanEdit(AbilityCooldown))
		{
			class'X2DLCInfo_AbilityEditor'.default.CooldownEditors[i].static.ApplyEdit(AbilityName, AbilityCooldown, CooldownEdit);
			return;
		}
	}

	`log("AbilityEdit: No editor for cooldown class" @ AbilityCooldown.Class, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
}

static function int FindAdditionalCooldownIndex(out array<AdditionalCooldownInfo> CooldownInfos, name AbilityName)
{
	local int i;

	for (i = 0; i < CooldownInfos.Length; ++i)
	{
		if (CooldownInfos[i].AbilityName == AbilityName)
		{
			return i;
		}
	}

	return INDEX_NONE;
}
