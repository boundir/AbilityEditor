// Applies template-level fields of an AbilityEdit directly to the X2AbilityTemplate.
class X2AbilityTemplateEditor extends Object;

static function ApplyTemplateEdit(X2AbilityTemplate Template, AbilityEdit AbilityEdit)
{
	local int i, Index;

	if (AbilityEdit.SetHostility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.Hostility",
			string(Template.Hostility),
			string(AbilityEdit.Hostility)
		);

		Template.Hostility = AbilityEdit.Hostility;
	}

	if (AbilityEdit.SetConcealmentRule)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.ConcealmentRule",
			string(Template.ConcealmentRule),
			string(AbilityEdit.ConcealmentRule)
		);

		Template.ConcealmentRule = AbilityEdit.ConcealmentRule;
	}

	if (AbilityEdit.SetCrossClassEligible)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bCrossClassEligible",
			string(Template.bCrossClassEligible),
			string(AbilityEdit.CrossClassEligible)
		);

		Template.bCrossClassEligible = AbilityEdit.CrossClassEligible;
	}

	if (AbilityEdit.SetIsPassive)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bIsPassive",
			string(Template.bIsPassive),
			string(AbilityEdit.IsPassive)
		);

		Template.bIsPassive = AbilityEdit.IsPassive;
	}

	if (AbilityEdit.SetUniqueSource)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bUniqueSource",
			string(Template.bUniqueSource),
			string(AbilityEdit.UniqueSource)
		);

		Template.bUniqueSource = AbilityEdit.UniqueSource;
	}

	if (AbilityEdit.SetAllowedByDefault)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bAllowedByDefault",
			string(Template.bAllowedByDefault),
			string(AbilityEdit.AllowedByDefault)
		);

		Template.bAllowedByDefault = AbilityEdit.AllowedByDefault;
	}

	if (AbilityEdit.SetTriggerChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.TriggerChance",
			string(Template.TriggerChance),
			string(AbilityEdit.TriggerChance)
		);

		Template.TriggerChance = AbilityEdit.TriggerChance;
	}

	if (AbilityEdit.SetSuperConcealmentLoss)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.SuperConcealmentLoss",
			string(Template.SuperConcealmentLoss),
			string(AbilityEdit.SuperConcealmentLoss)
		);

		Template.SuperConcealmentLoss = AbilityEdit.SuperConcealmentLoss;
	}

	if (AbilityEdit.SetChosenActivationIncreasePerUse)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.ChosenActivationIncreasePerUse",
			string(Template.ChosenActivationIncreasePerUse),
			string(AbilityEdit.ChosenActivationIncreasePerUse)
		);

		Template.ChosenActivationIncreasePerUse = AbilityEdit.ChosenActivationIncreasePerUse;
	}

	if (AbilityEdit.SetLostSpawnIncreasePerUse)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.LostSpawnIncreasePerUse",
			string(Template.LostSpawnIncreasePerUse),
			string(AbilityEdit.LostSpawnIncreasePerUse)
		);

		Template.LostSpawnIncreasePerUse = AbilityEdit.LostSpawnIncreasePerUse;
	}

	if (AbilityEdit.SetAbilityPointCost)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.AbilityPointCost",
			string(Template.AbilityPointCost),
			string(AbilityEdit.AbilityPointCost)
		);

		Template.AbilityPointCost = AbilityEdit.AbilityPointCost;
	}

	if (AbilityEdit.SetDefaultSourceItemSlot)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.DefaultSourceItemSlot",
			string(Template.DefaultSourceItemSlot),
			string(AbilityEdit.DefaultSourceItemSlot)
		);

		Template.DefaultSourceItemSlot = AbilityEdit.DefaultSourceItemSlot;
	}

	if (AbilityEdit.SetUseThrownGrenadeEffects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bUseThrownGrenadeEffects",
			string(Template.bUseThrownGrenadeEffects),
			string(AbilityEdit.UseThrownGrenadeEffects)
		);

		Template.bUseThrownGrenadeEffects = AbilityEdit.UseThrownGrenadeEffects;
	}

	if (AbilityEdit.SetUseLaunchedGrenadeEffects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bUseLaunchedGrenadeEffects",
			string(Template.bUseLaunchedGrenadeEffects),
			string(AbilityEdit.UseLaunchedGrenadeEffects)
		);

		Template.bUseLaunchedGrenadeEffects = AbilityEdit.UseLaunchedGrenadeEffects;
	}

	if (AbilityEdit.SetAllowFreeFireWeaponUpgrade)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bAllowFreeFireWeaponUpgrade",
			string(Template.bAllowFreeFireWeaponUpgrade),
			string(AbilityEdit.AllowFreeFireWeaponUpgrade)
		);

		Template.bAllowFreeFireWeaponUpgrade = AbilityEdit.AllowFreeFireWeaponUpgrade;
	}

	if (AbilityEdit.SetAllowAmmoEffects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bAllowAmmoEffects",
			string(Template.bAllowAmmoEffects),
			string(AbilityEdit.AllowAmmoEffects)
		);

		Template.bAllowAmmoEffects = AbilityEdit.AllowAmmoEffects;
	}

	if (AbilityEdit.SetAllowBonusWeaponEffects)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bAllowBonusWeaponEffects",
			string(Template.bAllowBonusWeaponEffects),
			string(AbilityEdit.AllowBonusWeaponEffects)
		);

		Template.bAllowBonusWeaponEffects = AbilityEdit.AllowBonusWeaponEffects;
	}

	if (AbilityEdit.SetSilentAbility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bSilentAbility",
			string(Template.bSilentAbility),
			string(AbilityEdit.SilentAbility)
		);

		Template.bSilentAbility = AbilityEdit.SilentAbility;
	}

	if (AbilityEdit.SetCannotTeleport)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bCannotTeleport",
			string(Template.bCannotTeleport),
			string(AbilityEdit.CannotTeleport)
		);

		Template.bCannotTeleport = AbilityEdit.CannotTeleport;
	}

	if (AbilityEdit.SetPreventsTargetTeleport)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bPreventsTargetTeleport",
			string(Template.bPreventsTargetTeleport),
			string(AbilityEdit.PreventsTargetTeleport)
		);

		Template.bPreventsTargetTeleport = AbilityEdit.PreventsTargetTeleport;
	}

	if (AbilityEdit.SetFinalizeAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.FinalizeAbilityName",
			string(Template.FinalizeAbilityName),
			string(AbilityEdit.FinalizeAbilityName)
		);

		Template.FinalizeAbilityName = AbilityEdit.FinalizeAbilityName;
	}

	if (AbilityEdit.SetCancelAbilityName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.CancelAbilityName",
			string(Template.CancelAbilityName),
			string(AbilityEdit.CancelAbilityName)
		);

		Template.CancelAbilityName = AbilityEdit.CancelAbilityName;
	}

	if (AbilityEdit.SetTwoTurnAttackAbility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.TwoTurnAttackAbility",
			string(Template.TwoTurnAttackAbility),
			string(AbilityEdit.TwoTurnAttackAbility)
		);

		Template.TwoTurnAttackAbility = AbilityEdit.TwoTurnAttackAbility;
	}

	if (AbilityEdit.SetIconImage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.IconImage",
			Template.IconImage,
			AbilityEdit.IconImage
		);

		Template.IconImage = AbilityEdit.IconImage;
	}

	if (AbilityEdit.SetAbilityIconColor)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.AbilityIconColor",
			Template.AbilityIconColor,
			AbilityEdit.AbilityIconColor
		);

		Template.AbilityIconColor = AbilityEdit.AbilityIconColor;
	}

	if (AbilityEdit.SetAbilityIconBehaviorHUD)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.eAbilityIconBehaviorHUD",
			string(Template.eAbilityIconBehaviorHUD),
			string(AbilityEdit.AbilityIconBehaviorHUD)
		);

		Template.eAbilityIconBehaviorHUD = AbilityEdit.AbilityIconBehaviorHUD;
	}

	if (AbilityEdit.SetShotHUDPriority)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.ShotHUDPriority",
			string(Template.ShotHUDPriority),
			string(AbilityEdit.ShotHUDPriority)
		);

		Template.ShotHUDPriority = AbilityEdit.ShotHUDPriority;
	}

	if (AbilityEdit.SetDisplayInUITooltip)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bDisplayInUITooltip",
			string(Template.bDisplayInUITooltip),
			string(AbilityEdit.DisplayInUITooltip)
		);

		Template.bDisplayInUITooltip = AbilityEdit.DisplayInUITooltip;
	}

	if (AbilityEdit.SetDisplayInUITacticalText)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bDisplayInUITacticalText",
			string(Template.bDisplayInUITacticalText),
			string(AbilityEdit.DisplayInUITacticalText)
		);

		Template.bDisplayInUITacticalText = AbilityEdit.DisplayInUITacticalText;
	}

	if (AbilityEdit.SetDontDisplayInAbilitySummary)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bDontDisplayInAbilitySummary",
			string(Template.bDontDisplayInAbilitySummary),
			string(AbilityEdit.DontDisplayInAbilitySummary)
		);

		Template.bDontDisplayInAbilitySummary = AbilityEdit.DontDisplayInAbilitySummary;
	}

	if (AbilityEdit.SetDisplayTargetHitChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.DisplayTargetHitChance",
			string(Template.DisplayTargetHitChance),
			string(AbilityEdit.DisplayTargetHitChance)
		);

		Template.DisplayTargetHitChance = AbilityEdit.DisplayTargetHitChance;
	}

	if (AbilityEdit.SetHideOnClassUnlock)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bHideOnClassUnlock",
			string(Template.bHideOnClassUnlock),
			string(AbilityEdit.HideOnClassUnlock)
		);

		Template.bHideOnClassUnlock = AbilityEdit.HideOnClassUnlock;
	}

	if (AbilityEdit.SetAbilitySourceName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.AbilitySourceName",
			string(Template.AbilitySourceName),
			string(AbilityEdit.AbilitySourceName)
		);

		Template.AbilitySourceName = AbilityEdit.AbilitySourceName;
	}

	if (AbilityEdit.SetLimitTargetIcons)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bLimitTargetIcons",
			string(Template.bLimitTargetIcons),
			string(AbilityEdit.LimitTargetIcons)
		);

		Template.bLimitTargetIcons = AbilityEdit.LimitTargetIcons;
	}

	if (AbilityEdit.SetBypassAbilityConfirm)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bBypassAbilityConfirm",
			string(Template.bBypassAbilityConfirm),
			string(AbilityEdit.BypassAbilityConfirm)
		);

		Template.bBypassAbilityConfirm = AbilityEdit.BypassAbilityConfirm;
	}

	if (AbilityEdit.SetUseAmmoAsChargesForHUD)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bUseAmmoAsChargesForHUD",
			string(Template.bUseAmmoAsChargesForHUD),
			string(AbilityEdit.UseAmmoAsChargesForHUD)
		);

		Template.bUseAmmoAsChargesForHUD = AbilityEdit.UseAmmoAsChargesForHUD;
	}

	if (AbilityEdit.SetAmmoAsChargesDivisor)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.iAmmoAsChargesDivisor",
			string(Template.iAmmoAsChargesDivisor),
			string(AbilityEdit.AmmoAsChargesDivisor)
		);

		Template.iAmmoAsChargesDivisor = AbilityEdit.AmmoAsChargesDivisor;
	}

	if (AbilityEdit.SetFriendlyFireWarning)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bFriendlyFireWarning",
			string(Template.bFriendlyFireWarning),
			string(AbilityEdit.FriendlyFireWarning)
		);

		Template.bFriendlyFireWarning = AbilityEdit.FriendlyFireWarning;
	}

	if (AbilityEdit.SetFriendlyFireWarningRobotsOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bFriendlyFireWarningRobotsOnly",
			string(Template.bFriendlyFireWarningRobotsOnly),
			string(AbilityEdit.FriendlyFireWarningRobotsOnly)
		);

		Template.bFriendlyFireWarningRobotsOnly = AbilityEdit.FriendlyFireWarningRobotsOnly;
	}

	if (AbilityEdit.SetCommanderAbility)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			Template.DataName,
			"Template.bCommanderAbility",
			string(Template.bCommanderAbility),
			string(AbilityEdit.CommanderAbility)
		);

		Template.bCommanderAbility = AbilityEdit.CommanderAbility;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.AdditionalAbilities",
		Template.AdditionalAbilities,
		AbilityEdit.AdditionalAbilities,
		AbilityEdit.AdditionalAbilitiesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.PrerequisiteAbilities",
		Template.PrerequisiteAbilities,
		AbilityEdit.PrerequisiteAbilities,
		AbilityEdit.PrerequisiteAbilitiesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.OverrideAbilities",
		Template.OverrideAbilities,
		AbilityEdit.OverrideAbilities,
		AbilityEdit.OverrideAbilitiesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.AssociatedPassives",
		Template.AssociatedPassives,
		AbilityEdit.AssociatedPassives,
		AbilityEdit.AssociatedPassivesMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.PostActivationEvents",
		Template.PostActivationEvents,
		AbilityEdit.PostActivationEvents,
		AbilityEdit.PostActivationEventsMode
	);

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		Template.DataName,
		"Template.HideIfAvailable",
		Template.HideIfAvailable,
		AbilityEdit.HideIfAvailable,
		AbilityEdit.HideIfAvailableMode
	);

	// Edit existing AbilityEventListeners entries by EventID (adding is not possible:
	// their EventFn delegate can only be assigned in code).
	for (i = 0; i < AbilityEdit.AbilityEventListenerEdits.Length; ++i)
	{
		Index = FindEventListenerIndex(Template.AbilityEventListeners, AbilityEdit.AbilityEventListenerEdits[i].EventID);

		if (Index == INDEX_NONE)
		{
			`log(string(Template.DataName) @ "AbilityEventListeners has no entry with EventID" @ string(AbilityEdit.AbilityEventListenerEdits[i].EventID), class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			continue;
		}

		if (AbilityEdit.AbilityEventListenerEdits[i].SetDeferral)
		{
			Template.AbilityEventListeners[Index].Deferral = AbilityEdit.AbilityEventListenerEdits[i].Deferral;
		}

		if (AbilityEdit.AbilityEventListenerEdits[i].SetFilter)
		{
			Template.AbilityEventListeners[Index].Filter = AbilityEdit.AbilityEventListenerEdits[i].Filter;
		}

		if (AbilityEdit.AbilityEventListenerEdits[i].SetPriority)
		{
			Template.AbilityEventListeners[Index].Priority = AbilityEdit.AbilityEventListenerEdits[i].Priority;
		}
	}
}

static function int FindEventListenerIndex(const out array<AbilityEventListener> Listeners, name EventID)
{
	local int i;

	for (i = 0; i < Listeners.Length; ++i)
	{
		if (Listeners[i].EventID == EventID)
		{
			return i;
		}
	}

	return INDEX_NONE;
}