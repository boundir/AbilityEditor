class X2AbilityConditionEditor_OnGroundTile extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_OnGroundTile');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_OnGroundTile OnGroundTileCond;

	OnGroundTileCond = X2Condition_OnGroundTile(Condition);

	if (OnGroundTileCond == none)
	{
		return;
	}

	if (ConditionEdit.SetNotAFloorTileTag)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NotAFloorTileTag",
			string(OnGroundTileCond.NotAFloorTileTag),
			string(ConditionEdit.NotAFloorTileTag)
		);

		OnGroundTileCond.NotAFloorTileTag = ConditionEdit.NotAFloorTileTag;
	}
}
