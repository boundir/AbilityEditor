class X2AbilityEditor_Helper extends Object;

static function ApplyNameArrayEdit(name AbilityName, string Category, out array<name> Target, array<name> EditValues, ENameArrayEditMode Mode)
{
	local int i, Index;

	if (EditValues.Length == 0)
	{
		return;
	}

	switch (Mode)
	{
		case eNAEM_Replace:
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				Category,
				class'X2AbilityEditor_Logger'.static.JoinNameArray(Target),
				class'X2AbilityEditor_Logger'.static.JoinNameArray(EditValues)
			);
			Target = EditValues;
			break;

		case eNAEM_AddOnly:
			if (Target.Length == 0)
			{
				class'X2AbilityEditor_Logger'.static.LogInfo(
					AbilityName,
					Category,
					class'X2AbilityEditor_Logger'.static.JoinNameArray(Target),
					class'X2AbilityEditor_Logger'.static.JoinNameArray(EditValues)
				);
				Target = EditValues;
			}
			break;

		case eNAEM_Merge:
			for (i = 0; i < EditValues.Length; ++i)
			{
				Index = Target.Find(EditValues[i]);

				if (Index == INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						"none",
						string(EditValues[i])
					);
					Target.AddItem(EditValues[i]);
				}
			}
			break;

		case eNAEM_Remove:
			for (i = 0; i < EditValues.Length; ++i)
			{
				Index = Target.Find(EditValues[i]);

				if (Index != INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						string(EditValues[i]),
						"none"
					);
					Target.Remove(Index, 1);
				}
			}
			break;
	}
}

// Merge/Remove are keyed by UnitValueName.
static function ApplyRecordDataArrayEdit(
	name AbilityName,
	string Category,
	out array<RecordData> Target,
	array<RecordData> EditValues,
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
				Index = FindRecordDataIndex(Target, EditValues[i].UnitValueName);

				if (Index == INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						"none",
						string(EditValues[i].UnitValueName)
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
				Index = FindRecordDataIndex(Target, EditValues[i].UnitValueName);

				if (Index != INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						string(EditValues[i].UnitValueName),
						"none"
					);
					Target.Remove(Index, 1);
				}
			}
			break;
	}
}

static function int FindRecordDataIndex(const out array<RecordData> Entries, name UnitValueName)
{
	local int i;

	for (i = 0; i < Entries.Length; ++i)
	{
		if (Entries[i].UnitValueName == UnitValueName)
		{
			return i;
		}
	}

	return INDEX_NONE;
}

// Merge/Remove are keyed by AbilityName.
static function ApplyAdditionalSuccessModifierArrayEdit(
	name AbilityName,
	string Category,
	out array<AdditionalSuccessModifier> Target,
	array<AdditionalSuccessModifier> EditValues,
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
				Index = FindAdditionalSuccessModifierIndex(Target, EditValues[i].AbilityName);

				if (Index == INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						"none",
						string(EditValues[i].AbilityName)
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
				Index = FindAdditionalSuccessModifierIndex(Target, EditValues[i].AbilityName);

				if (Index != INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						string(EditValues[i].AbilityName),
						"none"
					);
					Target.Remove(Index, 1);
				}
			}
			break;
	}
}

static function int FindAdditionalSuccessModifierIndex(const out array<AdditionalSuccessModifier> Entries, name AbilityName)
{
	local int i;

	for (i = 0; i < Entries.Length; ++i)
	{
		if (Entries[i].AbilityName == AbilityName)
		{
			return i;
		}
	}

	return INDEX_NONE;
}

// Merge is positional: entry N overwrites focus level N, or appends it. Remove has no key to act on.
static function ApplyFocusLevelModifiersArrayEdit(
	name AbilityName,
	string Category,
	out array<FocusLevelModifiers> Target,
	array<FocusLevelModifiers> EditValues,
	ENameArrayEditMode Mode
)
{
	local int i;

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
				if (i < Target.Length)
				{
					`log(string(AbilityName) @ Category $ "[" $ i $ "]" @ "replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
					Target[i] = EditValues[i];
				}
				else
				{
					`log(string(AbilityName) @ Category $ "[" $ i $ "]" @ "added", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
					Target.AddItem(EditValues[i]);
				}
			}
			break;

		case eNAEM_Remove:
			`log(string(AbilityName) @ Category @ "eNAEM_Remove is not supported for focus levels; use eNAEM_Replace", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			break;
	}
}

// Same semantics as ApplyNameArrayEdit, for string arrays.
static function ApplyStringArrayEdit(name AbilityName, string Category, out array<string> Target, array<string> EditValues, ENameArrayEditMode Mode)
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
				Index = Target.Find(EditValues[i]);

				if (Index == INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						"none",
						EditValues[i]
					);
					Target.AddItem(EditValues[i]);
				}
			}
			break;

		case eNAEM_Remove:
			for (i = 0; i < EditValues.Length; ++i)
			{
				Index = Target.Find(EditValues[i]);

				if (Index != INDEX_NONE)
				{
					class'X2AbilityEditor_Logger'.static.LogInfo(
						AbilityName,
						Category,
						EditValues[i],
						"none"
					);
					Target.Remove(Index, 1);
				}
			}
			break;
	}
}
