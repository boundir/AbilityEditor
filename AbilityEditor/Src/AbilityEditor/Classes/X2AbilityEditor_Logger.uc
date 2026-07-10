class X2AbilityEditor_Logger extends Object;

static function LogInfo(
	name AbilityName,
	string Path,
	string OldValue,
	string NewValue
)
{
	`log(
		string(AbilityName) @
		Path @
		"changed from" @ OldValue @
		"to" @ NewValue,
		class'X2DLCInfo_AbilityEditor'.default.EnableDebug,
		'AbilityEditor'
	);
}

static function string JoinNameArray(array<name> Values, optional string Separator)
{
	local string Result;
	local int i;

	if (Separator == "")
	{
		Separator = ", ";
	}

	for (i = 0; i < Values.Length; ++i)
	{
		if (i > 0)
		{
			Result $= Separator;
		}

		Result $= string(Values[i]);
	}

	return "[" $ Result $ "]";
}
