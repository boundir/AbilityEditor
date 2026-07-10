class X2AbilityConditionEditor_UnblockedNeighborTile extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnblockedNeighborTile');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnblockedNeighborTile UnblockedNeighborTileCond;

	UnblockedNeighborTileCond = X2Condition_UnblockedNeighborTile(Condition);

	if (UnblockedNeighborTileCond == none)
	{
		return;
	}

	if (ConditionEdit.SetRequireVisible)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireVisible",
			string(UnblockedNeighborTileCond.RequireVisible),
			string(ConditionEdit.RequireVisible)
		);

		UnblockedNeighborTileCond.RequireVisible = ConditionEdit.RequireVisible;
	}
}
