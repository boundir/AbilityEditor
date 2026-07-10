class X2AbilityEffectsEditor_Persistent extends X2AbilityEffectsEditor;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_Persistent');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_Persistent PersistentEffect;

	PersistentEffect = X2Effect_Persistent(Effect);

	if (EffectEdit.SetInfiniteDuration)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bInfiniteDuration",
			string(PersistentEffect.bInfiniteDuration),
			string(EffectEdit.InfiniteDuration)
		);

		PersistentEffect.bInfiniteDuration = EffectEdit.InfiniteDuration;
	}

	if (EffectEdit.SetTickWhenApplied)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bTickWhenApplied",
			string(PersistentEffect.bTickWhenApplied),
			string(EffectEdit.TickWhenApplied)
		);

		PersistentEffect.bTickWhenApplied = EffectEdit.TickWhenApplied;
	}

	if (EffectEdit.SetCanTickEveryAction)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCanTickEveryAction",
			string(PersistentEffect.bCanTickEveryAction),
			string(EffectEdit.CanTickEveryAction)
		);

		PersistentEffect.bCanTickEveryAction = EffectEdit.CanTickEveryAction;
	}

	if (EffectEdit.SetConvertTurnsToActions)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bConvertTurnsToActions",
			string(PersistentEffect.bConvertTurnsToActions),
			string(EffectEdit.ConvertTurnsToActions)
		);

		PersistentEffect.bConvertTurnsToActions = EffectEdit.ConvertTurnsToActions;
	}

	if (EffectEdit.SetRemoveWhenSourceDies)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveWhenSourceDies",
			string(PersistentEffect.bRemoveWhenSourceDies),
			string(EffectEdit.RemoveWhenSourceDies)
		);

		PersistentEffect.bRemoveWhenSourceDies = EffectEdit.RemoveWhenSourceDies;
	}

	if (EffectEdit.SetRemoveWhenTargetDies)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveWhenTargetDies",
			string(PersistentEffect.bRemoveWhenTargetDies),
			string(EffectEdit.RemoveWhenTargetDies)
		);

		PersistentEffect.bRemoveWhenTargetDies = EffectEdit.RemoveWhenTargetDies;
	}

	if (EffectEdit.SetRemoveWhenSourceDamaged)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveWhenSourceDamaged",
			string(PersistentEffect.bRemoveWhenSourceDamaged),
			string(EffectEdit.RemoveWhenSourceDamaged)
		);

		PersistentEffect.bRemoveWhenSourceDamaged = EffectEdit.RemoveWhenSourceDamaged;
	}

	if (EffectEdit.SetRemoveWhenTargetConcealmentBroken)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveWhenTargetConcealmentBroken",
			string(PersistentEffect.bRemoveWhenTargetConcealmentBroken),
			string(EffectEdit.RemoveWhenTargetConcealmentBroken)
		);

		PersistentEffect.bRemoveWhenTargetConcealmentBroken = EffectEdit.RemoveWhenTargetConcealmentBroken;
	}

	if (EffectEdit.SetPersistThroughTacticalGameEnd)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bPersistThroughTacticalGameEnd",
			string(PersistentEffect.bPersistThroughTacticalGameEnd),
			string(EffectEdit.PersistThroughTacticalGameEnd)
		);

		PersistentEffect.bPersistThroughTacticalGameEnd = EffectEdit.PersistThroughTacticalGameEnd;
	}

	if (EffectEdit.SetIgnorePlayerCheckOnTick)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIgnorePlayerCheckOnTick",
			string(PersistentEffect.bIgnorePlayerCheckOnTick),
			string(EffectEdit.IgnorePlayerCheckOnTick)
		);

		PersistentEffect.bIgnorePlayerCheckOnTick = EffectEdit.IgnorePlayerCheckOnTick;
	}

	if (EffectEdit.SetUniqueTarget)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUniqueTarget",
			string(PersistentEffect.bUniqueTarget),
			string(EffectEdit.UniqueTarget)
		);

		PersistentEffect.bUniqueTarget = EffectEdit.UniqueTarget;
	}

	if (EffectEdit.SetStackOnRefresh)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bStackOnRefresh",
			string(PersistentEffect.bStackOnRefresh),
			string(EffectEdit.StackOnRefresh)
		);

		PersistentEffect.bStackOnRefresh = EffectEdit.StackOnRefresh;
	}

	if (EffectEdit.SetDupeForSameSourceOnly)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDupeForSameSourceOnly",
			string(PersistentEffect.bDupeForSameSourceOnly),
			string(EffectEdit.DupeForSameSourceOnly)
		);

		PersistentEffect.bDupeForSameSourceOnly = EffectEdit.DupeForSameSourceOnly;
	}

	if (EffectEdit.SetEffectForcesBleedout)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bEffectForcesBleedout",
			string(PersistentEffect.bEffectForcesBleedout),
			string(EffectEdit.EffectForcesBleedout)
		);

		PersistentEffect.bEffectForcesBleedout = EffectEdit.EffectForcesBleedout;
	}

	if (EffectEdit.SetDisplayInUI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDisplayInUI",
			string(PersistentEffect.bDisplayInUI),
			string(EffectEdit.DisplayInUI)
		);

		PersistentEffect.bDisplayInUI = EffectEdit.DisplayInUI;
	}

	if (EffectEdit.SetDisplayInSpecialDamageMessageUI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bDisplayInSpecialDamageMessageUI",
			string(PersistentEffect.bDisplayInSpecialDamageMessageUI),
			string(EffectEdit.DisplayInSpecialDamageMessageUI)
		);

		PersistentEffect.bDisplayInSpecialDamageMessageUI = EffectEdit.DisplayInSpecialDamageMessageUI;
	}

	if (EffectEdit.SetSourceDisplayInUI)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bSourceDisplayInUI",
			string(PersistentEffect.bSourceDisplayInUI),
			string(EffectEdit.SourceDisplayInUI)
		);

		PersistentEffect.bSourceDisplayInUI = EffectEdit.SourceDisplayInUI;
	}

	if (EffectEdit.SetNumTurns)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".iNumTurns",
			string(PersistentEffect.iNumTurns),
			string(EffectEdit.NumTurns)
		);

		PersistentEffect.iNumTurns = EffectEdit.NumTurns;
	}

	if (EffectEdit.SetInitialShedChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".iInitialShedChance",
			string(PersistentEffect.iInitialShedChance),
			string(EffectEdit.InitialShedChance)
		);

		PersistentEffect.iInitialShedChance = EffectEdit.InitialShedChance;
	}

	if (EffectEdit.SetPerTurnShedChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".iPerTurnShedChance",
			string(PersistentEffect.iPerTurnShedChance),
			string(EffectEdit.PerTurnShedChance)
		);

		PersistentEffect.iPerTurnShedChance = EffectEdit.PerTurnShedChance;
	}

	if (EffectEdit.SetEffectRank)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectRank",
			string(PersistentEffect.EffectRank),
			string(EffectEdit.EffectRank)
		);

		PersistentEffect.EffectRank = EffectEdit.EffectRank;
	}

	if (EffectEdit.SetEffectHierarchyValue)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectHierarchyValue",
			string(PersistentEffect.EffectHierarchyValue),
			string(EffectEdit.EffectHierarchyValue)
		);

		PersistentEffect.EffectHierarchyValue = EffectEdit.EffectHierarchyValue;
	}

	if (EffectEdit.SetVisionArcDegreesOverride)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VisionArcDegreesOverride",
			string(PersistentEffect.VisionArcDegreesOverride),
			string(EffectEdit.VisionArcDegreesOverride)
		);

		PersistentEffect.VisionArcDegreesOverride = EffectEdit.VisionArcDegreesOverride;
	}

	if (EffectEdit.SetCustomIdleOverrideAnim)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".CustomIdleOverrideAnim",
			string(PersistentEffect.CustomIdleOverrideAnim),
			string(EffectEdit.CustomIdleOverrideAnim)
		);

		PersistentEffect.CustomIdleOverrideAnim = EffectEdit.CustomIdleOverrideAnim;
	}

	if (EffectEdit.SetEffectName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectName",
			string(PersistentEffect.EffectName),
			string(EffectEdit.EffectName)
		);

		PersistentEffect.EffectName = EffectEdit.EffectName;
	}

	if (EffectEdit.SetAbilitySourceName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".AbilitySourceName",
			string(PersistentEffect.AbilitySourceName),
			string(EffectEdit.AbilitySourceName)
		);

		PersistentEffect.AbilitySourceName = EffectEdit.AbilitySourceName;
	}

	if (EffectEdit.SetEffectAppliedEventName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".EffectAppliedEventName",
			string(PersistentEffect.EffectAppliedEventName),
			string(EffectEdit.EffectAppliedEventName)
		);

		PersistentEffect.EffectAppliedEventName = EffectEdit.EffectAppliedEventName;
	}

	if (EffectEdit.SetChanceEventTriggerName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ChanceEventTriggerName",
			string(PersistentEffect.ChanceEventTriggerName),
			string(EffectEdit.ChanceEventTriggerName)
		);

		PersistentEffect.ChanceEventTriggerName = EffectEdit.ChanceEventTriggerName;
	}

	if (EffectEdit.SetVFXSocket)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VFXSocket",
			string(PersistentEffect.VFXSocket),
			string(EffectEdit.VFXSocket)
		);

		PersistentEffect.VFXSocket = EffectEdit.VFXSocket;
	}

	if (EffectEdit.SetVFXSocketsArrayName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VFXSocketsArrayName",
			string(PersistentEffect.VFXSocketsArrayName),
			string(EffectEdit.VFXSocketsArrayName)
		);

		PersistentEffect.VFXSocketsArrayName = EffectEdit.VFXSocketsArrayName;
	}

	if (EffectEdit.SetFriendlyName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FriendlyName",
			PersistentEffect.FriendlyName,
			EffectEdit.FriendlyName
		);

		PersistentEffect.FriendlyName = EffectEdit.FriendlyName;
	}

	if (EffectEdit.SetFriendlyDescription)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".FriendlyDescription",
			PersistentEffect.FriendlyDescription,
			EffectEdit.FriendlyDescription
		);

		PersistentEffect.FriendlyDescription = EffectEdit.FriendlyDescription;
	}

	if (EffectEdit.SetIconImage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".IconImage",
			PersistentEffect.IconImage,
			EffectEdit.IconImage
		);

		PersistentEffect.IconImage = EffectEdit.IconImage;
	}

	if (EffectEdit.SetSourceFriendlyName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SourceFriendlyName",
			PersistentEffect.SourceFriendlyName,
			EffectEdit.SourceFriendlyName
		);

		PersistentEffect.SourceFriendlyName = EffectEdit.SourceFriendlyName;
	}

	if (EffectEdit.SetSourceFriendlyDescription)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SourceFriendlyDescription",
			PersistentEffect.SourceFriendlyDescription,
			EffectEdit.SourceFriendlyDescription
		);

		PersistentEffect.SourceFriendlyDescription = EffectEdit.SourceFriendlyDescription;
	}

	if (EffectEdit.SetSourceIconLabel)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SourceIconLabel",
			PersistentEffect.SourceIconLabel,
			EffectEdit.SourceIconLabel
		);

		PersistentEffect.SourceIconLabel = EffectEdit.SourceIconLabel;
	}

	if (EffectEdit.SetStatusIcon)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".StatusIcon",
			PersistentEffect.StatusIcon,
			EffectEdit.StatusIcon
		);

		PersistentEffect.StatusIcon = EffectEdit.StatusIcon;
	}

	if (EffectEdit.SetVFXTemplateName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".VFXTemplateName",
			PersistentEffect.VFXTemplateName,
			EffectEdit.VFXTemplateName
		);

		PersistentEffect.VFXTemplateName = EffectEdit.VFXTemplateName;
	}

	if (EffectEdit.SetPersistentPerkName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".PersistentPerkName",
			PersistentEffect.PersistentPerkName,
			EffectEdit.PersistentPerkName
		);

		PersistentEffect.PersistentPerkName = EffectEdit.PersistentPerkName;
	}
}
