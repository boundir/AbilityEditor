class X2AbilityEffectsEditor_Helper extends Object;

static function ApplyEffectEdit(X2AbilityTemplate Template, EffectEdit EffectEdit)
{
	switch (EffectEdit.Slot)
	{
		case eAES_Target:
			ApplyToEffectArray(Template.DataName, "AbilityTargetEffects", Template.AbilityTargetEffects, EffectEdit);
			break;

		case eAES_MultiTarget:
			ApplyToEffectArray(Template.DataName, "AbilityMultiTargetEffects", Template.AbilityMultiTargetEffects, EffectEdit);
			break;

		case eAES_Shooter:
			ApplyToEffectArray(Template.DataName, "AbilityShooterEffects", Template.AbilityShooterEffects, EffectEdit);
			break;
	}
}

static function ApplyToEffectArray(
	name AbilityName,
	string Slot,
	out array<X2Effect> Effects,
	EffectEdit EffectEdit
)
{
	local class<X2Effect> EffectClass;
	local X2Effect Effect;
	local string ClassName;
	local int Index;

	ClassName = EffectEdit.Class;

	if (ClassName == "")
	{
		ClassName = "XComGame.X2Effect";
	}

	EffectClass = LoadEffectClass(ClassName);

	if (EffectClass == none)
	{
		return;
	}

	Index = FindEffectIndex(Effects, EffectClass);

	if (EffectEdit.Mode == eACEM_Remove)
	{
		if (Index != INDEX_NONE)
		{
			Effects.Remove(Index, 1);
		}
		return;
	}

	if (EffectEdit.Mode == eACEM_ReplaceAll)
	{
		Effects.Length = 0;
	}

	if (Index == INDEX_NONE)
	{
		Effect = new EffectClass;
		Effects.AddItem(Effect);
	}
	else
	{
		Effect = Effects[Index];
	}

	DispatchEffectEdit(AbilityName, Slot, Effect, EffectEdit);
}

static function class<X2Effect> LoadEffectClass(string ClassName)
{
	local string QualifiedName;

	if (InStr(ClassName, ".") == INDEX_NONE)
	{
		QualifiedName = "XComGame." $ ClassName;
	}
	else
	{
		QualifiedName = ClassName;
	}

	return class<X2Effect>(
		DynamicLoadObject(QualifiedName, class'Class')
	);
}

static function int FindEffectIndex(
	array<X2Effect> Effects,
	class<X2Effect> EffectClass
)
{
	local int i;

	for (i = 0; i < Effects.Length; ++i)
	{
		if (Effects[i].Class == EffectClass)
		{
			return i;
		}
	}

	return INDEX_NONE;
}

static function DispatchEffectEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local int i;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.EffectsEditors.Length; ++i)
	{
		if (class'X2DLCInfo_AbilityEditor'.default.EffectsEditors[i].static.CanEdit(Effect))
		{
			class'X2DLCInfo_AbilityEditor'.default.EffectsEditors[i].static.ApplyEdit(
				AbilityName,
				Slot,
				Effect,
				EffectEdit
			);
			return;
		}
	}
}

static function int FindStatChangeIndex(out array<StatChange> StatChanges, ECharStatType StatType)
{
	local int i;

	for (i = 0; i < StatChanges.Length; ++i)
	{
		if (StatChanges[i].StatType == StatType)
		{
			return i;
		}
	}

	return INDEX_NONE;
}
