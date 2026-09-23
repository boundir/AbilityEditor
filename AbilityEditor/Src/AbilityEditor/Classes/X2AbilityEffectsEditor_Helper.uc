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

	if (EffectEdit.ApplyOnTickClass != "")
	{
		Effect = ResolveTickChild(AbilityName, Effect, EffectEdit, Slot);

		if (Effect == none)
		{
			return;
		}
	}

	DispatchEffectEdit(AbilityName, Slot, Effect, EffectEdit);
}

static function X2Effect ResolveTickChild(
	name AbilityName,
	X2Effect ParentEffect,
	EffectEdit EffectEdit,
	out string Slot
)
{
	local X2Effect_Persistent Persistent;
	local class<X2Effect> ChildClass;
	local X2Effect Child;
	local string ParentSlot;
	local int i, Matches, Found;

	ParentSlot = Slot;
	Persistent = X2Effect_Persistent(ParentEffect);

	if (Persistent == none)
	{
		`log(
			"AbilityEdit:" @ string(AbilityName) @ ParentSlot @
			"ApplyOnTickClass is set but" @ string(ParentEffect.Class.Name) @
			"is not an X2Effect_Persistent, so it has no ApplyOnTick list",
			class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
			'AbilityEditor'
		);
		return none;
	}

	ChildClass = LoadEffectClass(EffectEdit.ApplyOnTickClass);

	if (ChildClass == none)
	{
		return none;
	}

	Found = INDEX_NONE;
	Matches = 0;

	for (i = 0; i < Persistent.ApplyOnTick.Length; ++i)
	{
		if (Persistent.ApplyOnTick[i].Class == ChildClass)
		{
			if (Matches == EffectEdit.ApplyOnTickIndex)
			{
				Found = i;
				break;
			}

			Matches++;
		}
	}

	if (EffectEdit.ApplyOnTickMode == eAEM_Remove)
	{
		if (Found != INDEX_NONE)
		{
			`log(
				string(AbilityName) @ ParentSlot $ ".ApplyOnTick[" $ Found $ "]" @
				"removed:" @ string(ChildClass.Name),
				class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
				'AbilityEditor'
			);
			Persistent.ApplyOnTick.Remove(Found, 1);
		}
		return none;
	}

	if (EffectEdit.ApplyOnTickMode == eAEM_ReplaceAll)
	{
		Persistent.ApplyOnTick.Length = 0;
		Found = INDEX_NONE;
	}

	if (Found == INDEX_NONE)
	{
		Child = new ChildClass;
		Persistent.ApplyOnTick.AddItem(Child);
		Found = Persistent.ApplyOnTick.Length - 1;
	}
	else
	{
		Child = Persistent.ApplyOnTick[Found];
	}

	Slot = ParentSlot $ ".ApplyOnTick[" $ Found $ "]";

	return Child;
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
	local class<X2AbilityEffectsEditor> ExtraEditor;

	for (i = 0; i < class'X2DLCInfo_AbilityEditor'.default.ExtraEffectsEditors.Length; ++i)
	{
		ExtraEditor = class<X2AbilityEffectsEditor>(DynamicLoadObject(class'X2DLCInfo_AbilityEditor'.default.ExtraEffectsEditors[i].EditorClass, class'Class'));
		if (ExtraEditor != none && ExtraEditor.static.CanEdit(Effect))
		{
			ExtraEditor.static.ApplyEdit(
				AbilityName,
				Slot,
				Effect,
				EffectEdit
			);
			return;
		}
	}

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
