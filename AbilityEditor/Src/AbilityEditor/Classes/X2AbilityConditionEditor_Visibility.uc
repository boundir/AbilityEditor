class X2AbilityConditionEditor_Visibility extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_Visibility');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_Visibility VisibilityCondition;

	VisibilityCondition = X2Condition_Visibility(Condition);

	if (VisibilityCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetNoEnemyViewers)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bNoEnemyViewers",
			string(VisibilityCondition.bNoEnemyViewers),
			string(ConditionEdit.NoEnemyViewers)
		);

		VisibilityCondition.bNoEnemyViewers = ConditionEdit.NoEnemyViewers;
	}

	if (ConditionEdit.SetRequireMatchCoverType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRequireMatchCoverType",
			string(VisibilityCondition.bRequireMatchCoverType),
			string(ConditionEdit.RequireMatchCoverType)
		);

		VisibilityCondition.bRequireMatchCoverType = ConditionEdit.RequireMatchCoverType;
	}

	if (ConditionEdit.SetRequireNotMatchCoverType)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRequireNotMatchCoverType",
			string(VisibilityCondition.bRequireNotMatchCoverType),
			string(ConditionEdit.RequireNotMatchCoverType)
		);

		VisibilityCondition.bRequireNotMatchCoverType = ConditionEdit.RequireNotMatchCoverType;
	}

	if (ConditionEdit.SetTargetCover)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TargetCover",
			string(VisibilityCondition.TargetCover),
			string(ConditionEdit.TargetCover)
		);

		VisibilityCondition.TargetCover = ConditionEdit.TargetCover;
	}

	if (ConditionEdit.SetCannotPeek)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCannotPeek",
			string(VisibilityCondition.bCannotPeek),
			string(ConditionEdit.CannotPeek)
		);

		VisibilityCondition.bCannotPeek = ConditionEdit.CannotPeek;
	}

	if (ConditionEdit.SetRequireLOS)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRequireLOS",
			string(VisibilityCondition.bRequireLOS),
			string(ConditionEdit.RequireLOS)
		);

		VisibilityCondition.bRequireLOS = ConditionEdit.RequireLOS;
	}

	if (ConditionEdit.SetRequireBasicVisibility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRequireBasicVisibility",
			string(VisibilityCondition.bRequireBasicVisibility),
			string(ConditionEdit.RequireBasicVisibility)
		);

		VisibilityCondition.bRequireBasicVisibility = ConditionEdit.RequireBasicVisibility;
	}

	if (ConditionEdit.SetRequireGameplayVisible)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRequireGameplayVisible",
			string(VisibilityCondition.bRequireGameplayVisible),
			string(ConditionEdit.RequireGameplayVisible)
		);

		VisibilityCondition.bRequireGameplayVisible = ConditionEdit.RequireGameplayVisible;
	}

	if (ConditionEdit.SetAllowSquadsight)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAllowSquadsight",
			string(VisibilityCondition.bAllowSquadsight),
			string(ConditionEdit.AllowSquadsight)
		);

		VisibilityCondition.bAllowSquadsight = ConditionEdit.AllowSquadsight;
	}

	if (ConditionEdit.SetActAsSquadsight)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bActAsSquadsight",
			string(VisibilityCondition.bActAsSquadsight),
			string(ConditionEdit.ActAsSquadsight)
		);

		VisibilityCondition.bActAsSquadsight = ConditionEdit.ActAsSquadsight;
	}

	if (ConditionEdit.SetVisibleToAnyAlly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bVisibleToAnyAlly",
			string(VisibilityCondition.bVisibleToAnyAlly),
			string(ConditionEdit.VisibleToAnyAlly)
		);

		VisibilityCondition.bVisibleToAnyAlly = ConditionEdit.VisibleToAnyAlly;
	}

	if (ConditionEdit.SetDisablePeeksOnMovement)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDisablePeeksOnMovement",
			string(VisibilityCondition.bDisablePeeksOnMovement),
			string(ConditionEdit.DisablePeeksOnMovement)
		);

		VisibilityCondition.bDisablePeeksOnMovement = ConditionEdit.DisablePeeksOnMovement;
	}

	if (ConditionEdit.SetExcludeGameplayVisible)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bExcludeGameplayVisible",
			string(VisibilityCondition.bExcludeGameplayVisible),
			string(ConditionEdit.ExcludeGameplayVisible)
		);

		VisibilityCondition.bExcludeGameplayVisible = ConditionEdit.ExcludeGameplayVisible;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".RequireGameplayVisibleTags",
		VisibilityCondition.RequireGameplayVisibleTags,
		ConditionEdit.RequireGameplayVisibleTags,
		ConditionEdit.RequireGameplayVisibleTagsMode
	);
}
