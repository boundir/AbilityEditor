class X2AbilityConditionEditor_UnitProperty extends X2AbilityConditionEditor_Base;

static function bool CanEdit(X2Condition Condition)
{
	return Condition.IsA('X2Condition_UnitProperty');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Condition Condition,
	ConditionEdit ConditionEdit
)
{
	local X2Condition_UnitProperty PropertyCondition;

	PropertyCondition = X2Condition_UnitProperty(Condition);

	if (PropertyCondition == none)
	{
		return;
	}

	if (ConditionEdit.SetExcludeAlive)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeAlive",
			string(PropertyCondition.ExcludeAlive),
			string(ConditionEdit.ExcludeAlive)
		);

		PropertyCondition.ExcludeAlive = ConditionEdit.ExcludeAlive;
	}

	if (ConditionEdit.SetExcludeDead)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeDead",
			string(PropertyCondition.ExcludeDead),
			string(ConditionEdit.ExcludeDead)
		);

		PropertyCondition.ExcludeDead = ConditionEdit.ExcludeDead;
	}

	if (ConditionEdit.SetExcludeRobotic)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeRobotic",
			string(PropertyCondition.ExcludeRobotic),
			string(ConditionEdit.ExcludeRobotic)
		);

		PropertyCondition.ExcludeRobotic = ConditionEdit.ExcludeRobotic;
	}

	if (ConditionEdit.SetExcludeOrganic)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeOrganic",
			string(PropertyCondition.ExcludeOrganic),
			string(ConditionEdit.ExcludeOrganic)
		);

		PropertyCondition.ExcludeOrganic = ConditionEdit.ExcludeOrganic;
	}

	if (ConditionEdit.SetExcludeCivilian)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeCivilian",
			string(PropertyCondition.ExcludeCivilian),
			string(ConditionEdit.ExcludeCivilian)
		);

		PropertyCondition.ExcludeCivilian = ConditionEdit.ExcludeCivilian;
	}

	if (ConditionEdit.SetExcludeNonCivilian)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeNonCivilian",
			string(PropertyCondition.ExcludeNonCivilian),
			string(ConditionEdit.ExcludeNonCivilian)
		);

		PropertyCondition.ExcludeNonCivilian = ConditionEdit.ExcludeNonCivilian;
	}

	if (ConditionEdit.SetExcludeCosmetic)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeCosmetic",
			string(PropertyCondition.ExcludeCosmetic),
			string(ConditionEdit.ExcludeCosmetic)
		);

		PropertyCondition.ExcludeCosmetic = ConditionEdit.ExcludeCosmetic;
	}

	if (ConditionEdit.SetExcludeImpaired)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeImpaired",
			string(PropertyCondition.ExcludeImpaired),
			string(ConditionEdit.ExcludeImpaired)
		);

		PropertyCondition.ExcludeImpaired = ConditionEdit.ExcludeImpaired;
	}

	if (ConditionEdit.SetExcludePanicked)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludePanicked",
			string(PropertyCondition.ExcludePanicked),
			string(ConditionEdit.ExcludePanicked)
		);

		PropertyCondition.ExcludePanicked = ConditionEdit.ExcludePanicked;
	}

	if (ConditionEdit.SetExcludeInStasis)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeInStasis",
			string(PropertyCondition.ExcludeInStasis),
			string(ConditionEdit.ExcludeInStasis)
		);

		PropertyCondition.ExcludeInStasis = ConditionEdit.ExcludeInStasis;
	}

	if (ConditionEdit.SetExcludeTurret)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeTurret",
			string(PropertyCondition.ExcludeTurret),
			string(ConditionEdit.ExcludeTurret)
		);

		PropertyCondition.ExcludeTurret = ConditionEdit.ExcludeTurret;
	}

	if (ConditionEdit.SetExcludePsionic)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludePsionic",
			string(PropertyCondition.ExcludePsionic),
			string(ConditionEdit.ExcludePsionic)
		);

		PropertyCondition.ExcludePsionic = ConditionEdit.ExcludePsionic;
	}

	if (ConditionEdit.SetExcludeNonPsionic)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeNonPsionic",
			string(PropertyCondition.ExcludeNonPsionic),
			string(ConditionEdit.ExcludeNonPsionic)
		);

		PropertyCondition.ExcludeNonPsionic = ConditionEdit.ExcludeNonPsionic;
	}

	if (ConditionEdit.SetIsAdvent)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsAdvent",
			string(PropertyCondition.IsAdvent),
			string(ConditionEdit.IsAdvent)
		);

		PropertyCondition.IsAdvent = ConditionEdit.IsAdvent;
	}

	if (ConditionEdit.SetExcludeAdvent)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeAdvent",
			string(PropertyCondition.ExcludeAdvent),
			string(ConditionEdit.ExcludeAdvent)
		);

		PropertyCondition.ExcludeAdvent = ConditionEdit.ExcludeAdvent;
	}

	if (ConditionEdit.SetExcludeNoCover)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeNoCover",
			string(PropertyCondition.ExcludeNoCover),
			string(ConditionEdit.ExcludeNoCover)
		);

		PropertyCondition.ExcludeNoCover = ConditionEdit.ExcludeNoCover;
	}

	if (ConditionEdit.SetExcludeNoCoverToSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeNoCoverToSource",
			string(PropertyCondition.ExcludeNoCoverToSource),
			string(ConditionEdit.ExcludeNoCoverToSource)
		);

		PropertyCondition.ExcludeNoCoverToSource = ConditionEdit.ExcludeNoCoverToSource;
	}

	if (ConditionEdit.SetExcludeFullHealth)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeFullHealth",
			string(PropertyCondition.ExcludeFullHealth),
			string(ConditionEdit.ExcludeFullHealth)
		);

		PropertyCondition.ExcludeFullHealth = ConditionEdit.ExcludeFullHealth;
	}

	if (ConditionEdit.SetIsBleedingOut)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsBleedingOut",
			string(PropertyCondition.IsBleedingOut),
			string(ConditionEdit.IsBleedingOut)
		);

		PropertyCondition.IsBleedingOut = ConditionEdit.IsBleedingOut;
	}

	if (ConditionEdit.SetIsUnspotted)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsUnspotted",
			string(PropertyCondition.IsUnspotted),
			string(ConditionEdit.IsUnspotted)
		);

		PropertyCondition.IsUnspotted = ConditionEdit.IsUnspotted;
	}

	if (ConditionEdit.SetCanBeCarried)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CanBeCarried",
			string(PropertyCondition.CanBeCarried),
			string(ConditionEdit.CanBeCarried)
		);

		PropertyCondition.CanBeCarried = ConditionEdit.CanBeCarried;
	}

	if (ConditionEdit.SetIsOutdoors)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsOutdoors",
			string(PropertyCondition.IsOutdoors),
			string(ConditionEdit.IsOutdoors)
		);

		PropertyCondition.IsOutdoors = ConditionEdit.IsOutdoors;
	}

	if (ConditionEdit.SetIsConcealed)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsConcealed",
			string(PropertyCondition.IsConcealed),
			string(ConditionEdit.IsConcealed)
		);

		PropertyCondition.IsConcealed = ConditionEdit.IsConcealed;
	}

	if (ConditionEdit.SetExcludeConcealed)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeConcealed",
			string(PropertyCondition.ExcludeConcealed),
			string(ConditionEdit.ExcludeConcealed)
		);

		PropertyCondition.ExcludeConcealed = ConditionEdit.ExcludeConcealed;
	}

	if (ConditionEdit.SetIsSuperConcealed)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsSuperConcealed",
			string(PropertyCondition.IsSuperConcealed),
			string(ConditionEdit.IsSuperConcealed)
		);

		PropertyCondition.IsSuperConcealed = ConditionEdit.IsSuperConcealed;
	}

	if (ConditionEdit.SetIsImpaired)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsImpaired",
			string(PropertyCondition.IsImpaired),
			string(ConditionEdit.IsImpaired)
		);

		PropertyCondition.IsImpaired = ConditionEdit.IsImpaired;
	}

	if (ConditionEdit.SetHasClearanceToMaxZ)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".HasClearanceToMaxZ",
			string(PropertyCondition.HasClearanceToMaxZ),
			string(ConditionEdit.HasClearanceToMaxZ)
		);

		PropertyCondition.HasClearanceToMaxZ = ConditionEdit.HasClearanceToMaxZ;
	}

	if (ConditionEdit.SetExcludeAlien)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeAlien",
			string(PropertyCondition.ExcludeAlien),
			string(ConditionEdit.ExcludeAlien)
		);

		PropertyCondition.ExcludeAlien = ConditionEdit.ExcludeAlien;
	}

	if (ConditionEdit.SetExcludeNonHumanoidAliens)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeNonHumanoidAliens",
			string(PropertyCondition.ExcludeNonHumanoidAliens),
			string(ConditionEdit.ExcludeNonHumanoidAliens)
		);

		PropertyCondition.ExcludeNonHumanoidAliens = ConditionEdit.ExcludeNonHumanoidAliens;
	}

	if (ConditionEdit.SetExcludeStunned)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeStunned",
			string(PropertyCondition.ExcludeStunned),
			string(ConditionEdit.ExcludeStunned)
		);

		PropertyCondition.ExcludeStunned = ConditionEdit.ExcludeStunned;
	}

	if (ConditionEdit.SetExcludeDazed)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeDazed",
			string(PropertyCondition.ExcludeDazed),
			string(ConditionEdit.ExcludeDazed)
		);

		PropertyCondition.ExcludeDazed = ConditionEdit.ExcludeDazed;
	}

	if (ConditionEdit.SetExcludeUnableToAct)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeUnableToAct",
			string(PropertyCondition.ExcludeUnableToAct),
			string(ConditionEdit.ExcludeUnableToAct)
		);

		PropertyCondition.ExcludeUnableToAct = ConditionEdit.ExcludeUnableToAct;
	}

	if (ConditionEdit.SetIsPlayerControlled)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsPlayerControlled",
			string(PropertyCondition.IsPlayerControlled),
			string(ConditionEdit.IsPlayerControlled)
		);

		PropertyCondition.IsPlayerControlled = ConditionEdit.IsPlayerControlled;
	}

	if (ConditionEdit.SetExcludeUnrevealedAI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeUnrevealedAI",
			string(PropertyCondition.ExcludeUnrevealedAI),
			string(ConditionEdit.ExcludeUnrevealedAI)
		);

		PropertyCondition.ExcludeUnrevealedAI = ConditionEdit.ExcludeUnrevealedAI;
	}

	if (ConditionEdit.SetIncludeWeakAgainstTechLikeRobot)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IncludeWeakAgainstTechLikeRobot",
			string(PropertyCondition.IncludeWeakAgainstTechLikeRobot),
			string(ConditionEdit.IncludeWeakAgainstTechLikeRobot)
		);

		PropertyCondition.IncludeWeakAgainstTechLikeRobot = ConditionEdit.IncludeWeakAgainstTechLikeRobot;
	}

	if (ConditionEdit.SetImpairedIgnoresStuns)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ImpairedIgnoresStuns",
			string(PropertyCondition.ImpairedIgnoresStuns),
			string(ConditionEdit.ImpairedIgnoresStuns)
		);

		PropertyCondition.ImpairedIgnoresStuns = ConditionEdit.ImpairedIgnoresStuns;
	}

	if (ConditionEdit.SetIsScampering)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IsScampering",
			string(PropertyCondition.IsScampering),
			string(ConditionEdit.IsScampering)
		);

		PropertyCondition.IsScampering = ConditionEdit.IsScampering;
	}

	if (ConditionEdit.SetExcludeDeadFromSpecialDeath)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeDeadFromSpecialDeath",
			string(PropertyCondition.ExcludeDeadFromSpecialDeath),
			string(ConditionEdit.ExcludeDeadFromSpecialDeath)
		);

		PropertyCondition.ExcludeDeadFromSpecialDeath = ConditionEdit.ExcludeDeadFromSpecialDeath;
	}

	if (ConditionEdit.SetExcludeLargeUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeLargeUnits",
			string(PropertyCondition.ExcludeLargeUnits),
			string(ConditionEdit.ExcludeLargeUnits)
		);

		PropertyCondition.ExcludeLargeUnits = ConditionEdit.ExcludeLargeUnits;
	}

	if (ConditionEdit.SetImpairedIgnoresImpairingMomentarily)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ImpairedIgnoresImpairingMomentarily",
			string(PropertyCondition.ImpairedIgnoresImpairingMomentarily),
			string(ConditionEdit.ImpairedIgnoresImpairingMomentarily)
		);

		PropertyCondition.ImpairedIgnoresImpairingMomentarily = ConditionEdit.ImpairedIgnoresImpairingMomentarily;
	}

	if (ConditionEdit.SetExcludeHostileToSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeHostileToSource",
			string(PropertyCondition.ExcludeHostileToSource),
			string(ConditionEdit.ExcludeHostileToSource)
		);

		PropertyCondition.ExcludeHostileToSource = ConditionEdit.ExcludeHostileToSource;
	}

	if (ConditionEdit.SetExcludeFriendlyToSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeFriendlyToSource",
			string(PropertyCondition.ExcludeFriendlyToSource),
			string(ConditionEdit.ExcludeFriendlyToSource)
		);

		PropertyCondition.ExcludeFriendlyToSource = ConditionEdit.ExcludeFriendlyToSource;
	}

	if (ConditionEdit.SetTreatMindControlledSquadmateAsHostile)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".TreatMindControlledSquadmateAsHostile",
			string(PropertyCondition.TreatMindControlledSquadmateAsHostile),
			string(ConditionEdit.TreatMindControlledSquadmateAsHostile)
		);

		PropertyCondition.TreatMindControlledSquadmateAsHostile = ConditionEdit.TreatMindControlledSquadmateAsHostile;
	}

	if (ConditionEdit.SetExcludeSquadmates)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ExcludeSquadmates",
			string(PropertyCondition.ExcludeSquadmates),
			string(ConditionEdit.ExcludeSquadmates)
		);

		PropertyCondition.ExcludeSquadmates = ConditionEdit.ExcludeSquadmates;
	}

	if (ConditionEdit.SetRequireSquadmates)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireSquadmates",
			string(PropertyCondition.RequireSquadmates),
			string(ConditionEdit.RequireSquadmates)
		);

		PropertyCondition.RequireSquadmates = ConditionEdit.RequireSquadmates;
	}

	if (ConditionEdit.SetRequireWithinRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireWithinRange",
			string(PropertyCondition.RequireWithinRange),
			string(ConditionEdit.RequireWithinRange)
		);

		PropertyCondition.RequireWithinRange = ConditionEdit.RequireWithinRange;
	}

	if (ConditionEdit.SetRequireWithinMinRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireWithinMinRange",
			string(PropertyCondition.RequireWithinMinRange),
			string(ConditionEdit.RequireWithinMinRange)
		);

		PropertyCondition.RequireWithinMinRange = ConditionEdit.RequireWithinMinRange;
	}

	if (ConditionEdit.SetBeingCarriedBySource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BeingCarriedBySource",
			string(PropertyCondition.BeingCarriedBySource),
			string(ConditionEdit.BeingCarriedBySource)
		);

		PropertyCondition.BeingCarriedBySource = ConditionEdit.BeingCarriedBySource;
	}

	if (ConditionEdit.SetRequireUnitSelectedFromHQ)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".RequireUnitSelectedFromHQ",
			string(PropertyCondition.RequireUnitSelectedFromHQ),
			string(ConditionEdit.RequireUnitSelectedFromHQ)
		);

		PropertyCondition.RequireUnitSelectedFromHQ = ConditionEdit.RequireUnitSelectedFromHQ;
	}

	if (ConditionEdit.SetFailOnNonUnits)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FailOnNonUnits",
			string(PropertyCondition.FailOnNonUnits),
			string(ConditionEdit.FailOnNonUnits)
		);

		PropertyCondition.FailOnNonUnits = ConditionEdit.FailOnNonUnits;
	}

	if (ConditionEdit.SetMinRank)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MinRank",
			string(PropertyCondition.MinRank),
			string(ConditionEdit.MinRank)
		);

		PropertyCondition.MinRank = ConditionEdit.MinRank;
	}

	if (ConditionEdit.SetMaxRank)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxRank",
			string(PropertyCondition.MaxRank),
			string(ConditionEdit.MaxRank)
		);

		PropertyCondition.MaxRank = ConditionEdit.MaxRank;
	}

	if (ConditionEdit.SetWithinRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WithinRange",
			string(PropertyCondition.WithinRange),
			string(ConditionEdit.WithinRange)
		);

		PropertyCondition.WithinRange = ConditionEdit.WithinRange;
	}

	if (ConditionEdit.SetWithinMinRange)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".WithinMinRange",
			string(PropertyCondition.WithinMinRange),
			string(ConditionEdit.WithinMinRange)
		);

		PropertyCondition.WithinMinRange = ConditionEdit.WithinMinRange;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".ExcludeSoldierClasses",
		PropertyCondition.ExcludeSoldierClasses,
		ConditionEdit.ExcludeSoldierClasses,
		ConditionEdit.ExcludeSoldierClassesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".RequireSoldierClasses",
		PropertyCondition.RequireSoldierClasses,
		ConditionEdit.RequireSoldierClasses,
		ConditionEdit.RequireSoldierClassesMode
	);
}
