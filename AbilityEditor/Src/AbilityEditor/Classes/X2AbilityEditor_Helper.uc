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
