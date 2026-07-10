class AE_DataStructures extends Object;

enum EStatChangeMode
{
	eSCM_Replace,
	eSCM_Merge
};

enum EAbilityEffectSlot
{
	eAES_Target,
	eAES_MultiTarget,
	eAES_Shooter
};

enum EChargesBonusMode
{
	eCBM_Replace,
	eCBM_Merge
};

enum EAdditionalCooldownEditMode
{
	eACEM_Replace,
	eACEM_Merge
};

enum EAbilityCostEditMode
{
	eACEM_ReplaceAll,
	eACEM_Merge,
	eACEM_AddOnly,
	eACEM_Remove
};

enum EArrayEditMode
{
	eAEM_ReplaceAll,
	eAEM_Merge,
	eAEM_AddOnly,
	eAEM_Remove
};

enum ENameArrayEditMode
{
	eNAEM_Replace,
	eNAEM_Merge,
	eNAEM_AddOnly,
	eNAEM_Remove
};

struct AdditionalCooldownEdit
{
	var name AbilityName;

	var bool SetNumTurns;
	var int NumTurns;

	var bool SetUseAbilityCooldownNumTurns;
	var bool UseAbilityCooldownNumTurns;

	// "AdditionalCooldown_ApplyLarger" or "_ApplySmaller"
	var name ApplyCooldownType;
};

struct BonusChargeEdit
{
	var name AbilityName;
	var bool SetNumCharges;
	var int NumCharges;
};

struct CostEdit
{
	// Class name of the cost to instantiate
	var string Class;

	var EAbilityCostEditMode Mode;

	// Base cost parameters
	var bool SetFreeCost;
	var bool FreeCost;

	// Optional child-class parameters
	var bool SetNumPoints;
	var int NumPoints;

	var bool SetAddWeaponTypicalCost;
	var bool AddWeaponTypicalCost;

	var bool SetConsumeAllPoints;
	var bool ConsumeAllPoints;

	var bool SetMoveCost;
	var bool MoveCost;

	var array<name> AllowedTypes;
	var ENameArrayEditMode AllowedTypesMode;

	var array<name> DoNotConsumeAllEffects;
	var ENameArrayEditMode DoNotConsumeAllEffectsMode;

	var array<name> DoNotConsumeAllSoldierAbilities;
	var ENameArrayEditMode DoNotConsumeAllSoldierAbilitiesMode;

	var array<name> SharedAbilityCharges;
	var ENameArrayEditMode SharedAbilityChargesMode;

	var bool SetFocusAmount;
	var int FocusAmount;

	var bool SetConsumeAllFocus;
	var bool ConsumeAllFocus;

	var bool SetGhostOnlyCost;
	var bool GhostOnlyCost;

	var bool SetNumAmmo;
	var int NumAmmo;

	var bool SetUseLoadedAmmo;
	var bool UseLoadedAmmo;

	var bool SetReturnChargesError;
	var bool ReturnChargesError;

	var bool SetConsumeAllAmmo;
	var bool ConsumeAllAmmo;

	var bool SetNumCharges;
	var int NumCharges;

	var bool SetOnlyOnHit;
	var bool OnlyOnHit;

	var bool SetAlsoExpendChargesOnSharedBondmateAbility;
	var bool AlsoExpendChargesOnSharedBondmateAbility;
};

struct CooldownEdit
{
	// Class name of the cooldown to instantiate
	var string Class;

	// Base cooldown parameters
	var bool SetNumTurns;
	var int NumTurns;

	var bool SetIgnoreOnHit;
	var bool IgnoreOnHit;

	var EAdditionalCooldownEditMode AdditionalCooldownMode;
	var array<AdditionalCooldownEdit> AdditionalCooldowns;

	// Optional child-class parameters
	var bool SetNumTurnsForAI;
	var int NumTurnsForAI;

	var bool SetNumGlobalTurns;
	var int NumGlobalTurns;
};

struct ChargesEdit
{
	// Class name of the charge to instantiate
	var string Class;

	// Base cooldown parameters
	var bool SetInitialCharges;
	var int InitialCharges;

	var EChargesBonusMode BonusChargesMode;
	var array<BonusChargeEdit> BonusCharges;

	var bool RemoveCharges;

	// Optional child-class parameters
	var bool SetStabilize;
	var bool Stabilize;
};

struct AECustomProperty
{
	var name Key;
	var string Value;
};

struct ConditionEdit
{
	// Class name of the condition to target/instantiate
	var string Class;

	// How this entry combines with the existing conditions of the array
	var EArrayEditMode Mode;

	// X2Condition_AbilityProperty
	var ENameArrayEditMode OwnerHasSoldierAbilitiesMode;
	var array<name> OwnerHasSoldierAbilities;

	var bool SetTargetMustBeInValidTiles;
	var bool TargetMustBeInValidTiles;

	// X2Condition_AbilitySourceWeapon
	var bool SetWantsReload;
	var bool WantsReload;

	var bool SetCheckAmmo;
	var bool CheckAmmo;

	var bool SetCheckAmmoData;
	var CheckConfig CheckAmmoData;

	var bool SetNotLoadedAmmoInSecondaryWeapon;
	var bool NotLoadedAmmoInSecondaryWeapon;

	var bool SetMatchGrenadeType;
	var name MatchGrenadeType;

	var bool SetCheckGrenadeFriendlyFire;
	var bool CheckGrenadeFriendlyFire;

	var bool SetCheckAmmoTechLevel;
	var bool CheckAmmoTechLevel;

	var bool SetMatchWeaponTemplate;
	var name MatchWeaponTemplate;

	// X2Condition_DarkEvent
	var bool SetStilettoRounds;
	var bool StilettoRounds;

	// X2Condition_GameplayTag
	var bool SetRequiredGameplayTag;
	var name RequiredGameplayTag;

	var bool SetDisallowGameplayTag;
	var name DisallowGameplayTag;

	// X2Condition_PlayerTurns
	var bool SetNumTurnsCheck;
	var CheckConfig NumTurnsCheck;

	// X2Condition_UnitActionPoints (merged by ActionPointType)
	var ENameArrayEditMode ActionPointChecksMode;
	var array<ActionPointCheck> ActionPointChecks;

	// X2Condition_UnitAlertStatus
	var bool SetRequiredAlertStatusMaximum;
	var int RequiredAlertStatusMaximum;

	var bool SetRequiredAlertStatusMinimum;
	var int RequiredAlertStatusMinimum;

	// X2Condition_UnitEffects and its subclasses (merged by EffectName)
	var ENameArrayEditMode ExcludeEffectsMode;
	var array<EffectReason> ExcludeEffects;

	var ENameArrayEditMode RequireEffectsMode;
	var array<EffectReason> RequireEffects;

	// X2Condition_UnitImmunities
	var ENameArrayEditMode ExcludeDamageTypesMode;
	var array<name> ExcludeDamageTypes;

	var bool SetOnlyOnCharacterTemplate;
	var bool OnlyOnCharacterTemplate;

	// X2Condition_UnitInteractions
	var bool SetInteractionType;
	var UnitInterationType InteractionType;

	// X2Condition_UnitInventory
	var bool SetRelevantSlot;
	var EInventorySlot RelevantSlot;

	var bool SetExcludeWeaponCategory;
	var name ExcludeWeaponCategory;

	var bool SetRequireWeaponCategory;
	var name RequireWeaponCategory;

	// X2Condition_UnitProperty
	var bool SetExcludeAlive;
	var bool ExcludeAlive;

	var bool SetExcludeDead;
	var bool ExcludeDead;

	var bool SetExcludeRobotic;
	var bool ExcludeRobotic;

	var bool SetExcludeOrganic;
	var bool ExcludeOrganic;

	var bool SetExcludeCivilian;
	var bool ExcludeCivilian;

	var bool SetExcludeNonCivilian;
	var bool ExcludeNonCivilian;

	var bool SetExcludeCosmetic;
	var bool ExcludeCosmetic;

	var bool SetExcludeImpaired;
	var bool ExcludeImpaired;

	var bool SetExcludePanicked;
	var bool ExcludePanicked;

	var bool SetExcludeInStasis;
	var bool ExcludeInStasis;

	var bool SetExcludeTurret;
	var bool ExcludeTurret;

	var bool SetExcludePsionic;
	var bool ExcludePsionic;

	var bool SetExcludeNonPsionic;
	var bool ExcludeNonPsionic;

	var bool SetIsAdvent;
	var bool IsAdvent;

	var bool SetExcludeAdvent;
	var bool ExcludeAdvent;

	var bool SetExcludeNoCover;
	var bool ExcludeNoCover;

	var bool SetExcludeNoCoverToSource;
	var bool ExcludeNoCoverToSource;

	var bool SetExcludeFullHealth;
	var bool ExcludeFullHealth;

	var bool SetIsBleedingOut;
	var bool IsBleedingOut;

	var bool SetIsUnspotted;
	var bool IsUnspotted;

	var bool SetCanBeCarried;
	var bool CanBeCarried;

	var bool SetIsOutdoors;
	var bool IsOutdoors;

	var bool SetIsConcealed;
	var bool IsConcealed;

	var bool SetExcludeConcealed;
	var bool ExcludeConcealed;

	var bool SetIsSuperConcealed;
	var bool IsSuperConcealed;

	var bool SetIsImpaired;
	var bool IsImpaired;

	var bool SetHasClearanceToMaxZ;
	var bool HasClearanceToMaxZ;

	var bool SetExcludeAlien;
	var bool ExcludeAlien;

	var bool SetExcludeNonHumanoidAliens;
	var bool ExcludeNonHumanoidAliens;

	var bool SetExcludeStunned;
	var bool ExcludeStunned;

	var bool SetExcludeDazed;
	var bool ExcludeDazed;

	var bool SetExcludeUnableToAct;
	var bool ExcludeUnableToAct;

	var bool SetIsPlayerControlled;
	var bool IsPlayerControlled;

	var bool SetExcludeUnrevealedAI;
	var bool ExcludeUnrevealedAI;

	var bool SetIncludeWeakAgainstTechLikeRobot;
	var bool IncludeWeakAgainstTechLikeRobot;

	var bool SetImpairedIgnoresStuns;
	var bool ImpairedIgnoresStuns;

	var bool SetIsScampering;
	var bool IsScampering;

	var bool SetExcludeDeadFromSpecialDeath;
	var bool ExcludeDeadFromSpecialDeath;

	var bool SetExcludeLargeUnits;
	var bool ExcludeLargeUnits;

	var bool SetImpairedIgnoresImpairingMomentarily;
	var bool ImpairedIgnoresImpairingMomentarily;

	var bool SetMinRank;
	var int MinRank;

	var bool SetMaxRank;
	var int MaxRank;

	var ENameArrayEditMode ExcludeSoldierClassesMode;
	var array<name> ExcludeSoldierClasses;

	var ENameArrayEditMode RequireSoldierClassesMode;
	var array<name> RequireSoldierClasses;

	var bool SetExcludeHostileToSource;
	var bool ExcludeHostileToSource;

	var bool SetExcludeFriendlyToSource;
	var bool ExcludeFriendlyToSource;

	var bool SetTreatMindControlledSquadmateAsHostile;
	var bool TreatMindControlledSquadmateAsHostile;

	var bool SetExcludeSquadmates;
	var bool ExcludeSquadmates;

	var bool SetRequireSquadmates;
	var bool RequireSquadmates;

	var bool SetRequireWithinRange;
	var bool RequireWithinRange;

	var bool SetWithinRange;
	var float WithinRange;

	var bool SetRequireWithinMinRange;
	var bool RequireWithinMinRange;

	var bool SetWithinMinRange;
	var float WithinMinRange;

	var bool SetBeingCarriedBySource;
	var bool BeingCarriedBySource;

	var bool SetRequireUnitSelectedFromHQ;
	var bool RequireUnitSelectedFromHQ;

	var bool SetFailOnNonUnits;
	var bool FailOnNonUnits;

	// X2Condition_UnitStatCheck (merged by StatType)
	var ENameArrayEditMode CheckStatsMode;
	var array<CheckStat> CheckStats;

	// X2Condition_UnitType
	var ENameArrayEditMode IncludeTypesMode;
	var array<name> IncludeTypes;

	var ENameArrayEditMode ExcludeTypesMode;
	var array<name> ExcludeTypes;

	// X2Condition_UnitValue (merged by UnitValue)
	var ENameArrayEditMode CheckValuesMode;
	var array<CheckValue> CheckValues;

	// X2Condition_Visibility
	var bool SetNoEnemyViewers;
	var bool NoEnemyViewers;

	var bool SetRequireMatchCoverType;
	var bool RequireMatchCoverType;

	var bool SetRequireNotMatchCoverType;
	var bool RequireNotMatchCoverType;

	var bool SetTargetCover;
	var ECoverType TargetCover;

	var bool SetCannotPeek;
	var bool CannotPeek;

	var bool SetRequireLOS;
	var bool RequireLOS;

	var bool SetRequireBasicVisibility;
	var bool RequireBasicVisibility;

	var bool SetRequireGameplayVisible;
	var bool RequireGameplayVisible;

	var bool SetAllowSquadsight;
	var bool AllowSquadsight;

	var bool SetActAsSquadsight;
	var bool ActAsSquadsight;

	var bool SetVisibleToAnyAlly;
	var bool VisibleToAnyAlly;

	var bool SetDisablePeeksOnMovement;
	var bool DisablePeeksOnMovement;

	var bool SetExcludeGameplayVisible;
	var bool ExcludeGameplayVisible;

	var ENameArrayEditMode RequireGameplayVisibleTagsMode;
	var array<name> RequireGameplayVisibleTags;

	// X2Condition_BattleState
	var bool SetMissionAborted;
	var bool MissionAborted;

	// X2Condition_BattleState
	var bool SetMissionNotAborted;
	var bool MissionNotAborted;

	// X2Condition_BattleState
	var bool SetCiviliansTargetedByAliens;
	var bool CiviliansTargetedByAliens;

	// X2Condition_BattleState
	var bool SetCiviliansNotTargetedByAliens;
	var bool CiviliansNotTargetedByAliens;

	// X2Condition_BattleState
	var bool SetIncludeTheLostInEngagedCount;
	var bool IncludeTheLostInEngagedCount;

	// X2Condition_BattleState
	var bool SetMinEngagedEnemies;
	var int MinEngagedEnemies;

	// X2Condition_BattleState
	var bool SetMaxEngagedEnemies;
	var int MaxEngagedEnemies;

	// X2Condition_BerserkerDevastatingPunch
	var bool SetFailOnNonUnitTargets;
	var bool FailOnNonUnitTargets;

	// X2Condition_Bondmate
	var bool SetMinBondLevel;
	var int MinBondLevel;

	// X2Condition_Bondmate
	var bool SetMaxBondLevel;
	var int MaxBondLevel;

	// X2Condition_Bondmate
	var bool SetRequiresAdjacency;
	var AdjacencyRequirement RequiresAdjacency;

	// X2Condition_Bondmate
	var bool SetSkipCheckWithSource;
	var bool SkipCheckWithSource;

	// X2Condition_HackingTarget
	var bool SetIntrusionProtocol;
	var bool IntrusionProtocol;

	// X2Condition_HackingTarget
	var bool SetHaywireProtocol;
	var bool HaywireProtocol;

	// X2Condition_HackingTarget, X2Condition_Interactive
	var bool SetRequiredAbilityName;
	var name RequiredAbilityName;

	// X2Condition_HackingTarget
	var bool SetMustBeDoor;
	var bool MustBeDoor;

	// X2Condition_Lootable
	var bool SetRestrictRange;
	var bool RestrictRange;

	// X2Condition_Lootable
	var bool SetLootableRange;
	var int LootableRange;

	// X2Condition_OnGroundTile
	var bool SetNotAFloorTileTag;
	var name NotAFloorTileTag;

	// X2Condition_PanicOnPod
	var bool SetMaxPanicUnitsPerPod;
	var int MaxPanicUnitsPerPod;

	// X2Condition_StasisLanceTarget
	var bool SetHackAbilityName;
	var Name HackAbilityName;

	// X2Condition_Stealth
	var bool SetCheckFlanking;
	var bool CheckFlanking;

	// X2Condition_UnblockedNeighborTile
	var bool SetRequireVisible;
	var bool RequireVisible;

	// X2Condition_MapProperty
	var ENameArrayEditMode AllowedBiomesMode;
	var array<string> AllowedBiomes;

	var array<AECustomProperty> CustomProperties;
};

struct StatChangeEdit
{
	var bool SetStatType;
	var ECharStatType StatType;

	var bool SetStatAmount;
	var float StatAmount;

	var bool SetModOp;
	var EStatModOp ModOp;

	var bool SetApplicationRule;
	var ECharStatModApplicationRule ApplicationRule;
};

struct WeaponDamageValueEdit
{
	var bool SetDamage;
	var int Damage;

	var bool SetSpread;
	var int Spread;

	var bool SetPlusOne;
	var int PlusOne;

	var bool SetCrit;
	var int Crit;

	var bool SetPierce;
	var int Pierce;

	var bool SetRupture;
	var int Rupture;

	var bool SetShred;
	var int Shred;

	var bool SetTag;
	var name Tag;

	var bool SetDamageType;
	var name DamageType;
};

struct EffectEdit
{
	var string Class;

	var EAbilityEffectSlot Slot;
	var EArrayEditMode Mode;

	// Base effect parameters
	var bool SetApplyOnHit;
	var bool ApplyOnHit;

	var bool SetApplyOnMiss;
	var bool ApplyOnMiss;

	var bool SetApplyChance;
	var int ApplyChance;

	var bool SetApplyToWorldOnHit;
	var bool ApplyToWorldOnHit;

	var bool SetApplyToWorldOnMiss;
	var bool ApplyToWorldOnMiss;

	var bool SetUseSourcePlayerState;
	var bool UseSourcePlayerState;

	var bool SetIsImpairing;
	var bool IsImpairing;

	var bool SetIsImpairingMomentarily;
	var bool IsImpairingMomentarily;

	var bool SetBringRemoveVisualizationForward;
	var bool BringRemoveVisualizationForward;

	var bool SetShowImmunity;
	var bool ShowImmunity;

	var bool SetShowImmunityAnyFailure;
	var bool ShowImmunityAnyFailure;

	var bool SetAppliesDamage;
	var bool AppliesDamage;

	var bool SetCanBeRedirected;
	var bool CanBeRedirected;

	var bool SetHideDeathWorldMessage;
	var bool HideDeathWorldMessage;

	var ENameArrayEditMode DamageTypesMode;
	var array<name> DamageTypes;

	// Conditions attached to the effect (X2Effect.TargetConditions)
	var array<ConditionEdit> TargetConditions;

	var bool SetMinStatContestResult;
	var int MinStatContestResult;

	var bool SetMaxStatContestResult;
	var int MaxStatContestResult;

	var bool SetDelayVisualizationSec;
	var float DelayVisualizationSec;

	var bool SetOverrideMissMessage;
	var string OverrideMissMessage;

	// Option child-class parameters
	var bool SetNumTurns;
	var int NumTurns;

	var bool SetInitialShedChance;
	var int InitialShedChance;

	var bool SetPerTurnShedChance;
	var int PerTurnShedChance;

	var bool SetEffectRank;
	var int EffectRank;

	var bool SetEffectHierarchyValue;
	var int EffectHierarchyValue;

	var bool SetVisionArcDegreesOverride;
	var float VisionArcDegreesOverride;

	var bool SetInfiniteDuration;
	var bool InfiniteDuration;

	var bool SetTickWhenApplied;
	var bool TickWhenApplied;

	var bool SetCanTickEveryAction;
	var bool CanTickEveryAction;

	var bool SetConvertTurnsToActions;
	var bool ConvertTurnsToActions;

	var bool SetRemoveWhenSourceDies;
	var bool RemoveWhenSourceDies;

	var bool SetRemoveWhenTargetDies;
	var bool RemoveWhenTargetDies;

	var bool SetRemoveWhenSourceDamaged;
	var bool RemoveWhenSourceDamaged;

	var bool SetRemoveWhenTargetConcealmentBroken;
	var bool RemoveWhenTargetConcealmentBroken;

	var bool SetPersistThroughTacticalGameEnd;
	var bool PersistThroughTacticalGameEnd;

	var bool SetIgnorePlayerCheckOnTick;
	var bool IgnorePlayerCheckOnTick;

	var bool SetUniqueTarget;
	var bool UniqueTarget;

	var bool SetStackOnRefresh;
	var bool StackOnRefresh;

	var bool SetDupeForSameSourceOnly;
	var bool DupeForSameSourceOnly;

	var bool SetEffectForcesBleedout;
	var bool EffectForcesBleedout;

	var bool SetDisplayInUI;
	var bool DisplayInUI;

	var bool SetDisplayInSpecialDamageMessageUI;
	var bool DisplayInSpecialDamageMessageUI;

	var bool SetSourceDisplayInUI;
	var bool SourceDisplayInUI;

	var bool SetCustomIdleOverrideAnim;
	var name CustomIdleOverrideAnim;

	var bool SetEffectName;
	var name EffectName;

	var bool SetAbilitySourceName;
	var name AbilitySourceName;

	var bool SetEffectAppliedEventName;
	var name EffectAppliedEventName;

	var bool SetChanceEventTriggerName;
	var name ChanceEventTriggerName;

	var bool SetVFXSocket;
	var name VFXSocket;

	var bool SetVFXSocketsArrayName;
	var name VFXSocketsArrayName;

	var bool SetFriendlyName;
	var string FriendlyName;

	var bool SetFriendlyDescription;
	var string FriendlyDescription;

	var bool SetIconImage;
	var string IconImage;

	var bool SetSourceFriendlyName;
	var string SourceFriendlyName;

	var bool SetSourceFriendlyDescription;
	var string SourceFriendlyDescription;

	var bool SetSourceIconLabel;
	var string SourceIconLabel;

	var bool SetStatusIcon;
	var string StatusIcon;

	var bool SetVFXTemplateName;
	var string VFXTemplateName;

	var bool SetPersistentPerkName;
	var string PersistentPerkName;

	// X2Effect_ApplyWeaponDamage
	var bool SetExplosiveDamage;
	var bool ExplosiveDamage;

	var bool SetIgnoreBaseDamage;
	var bool IgnoreBaseDamage;

	var bool SetDamageTag;
	var name DamageTag;

	var bool SetAlwaysKillsCivilians;
	var bool AlwaysKillsCivilians;

	var bool SetApplyWorldEffectsForEachTargetLocation;
	var bool ApplyWorldEffectsForEachTargetLocation;

	var bool SetAllowFreeKill;
	var bool AllowFreeKill;

	var bool SetAllowWeaponUpgrade;
	var bool AllowWeaponUpgrade;

	var bool SetBypassShields;
	var bool BypassShields;

	var bool SetIgnoreArmor;
	var bool IgnoreArmor;

	var bool SetBypassSustainEffects;
	var bool BypassSustainEffects;

	var bool SetEnvironmentalDamageAmount;
	var int EnvironmentalDamageAmount;

	var WeaponDamageValueEdit WeaponDamageValue;

	// X2Effect_PersistentStatChange
	var EStatChangeMode StatChangeMode;
	var array<StatChangeEdit> StatChange;

	var bool SetCHLForceReapplyOnRefresh;
	var bool CHLForceReapplyOnRefresh;

	// X2AbilityEffectsEditor_DamageImmunity
	// Maps to X2Effect_DamageImmunity.ImmueTypesAreInclusive (typo is Firaxis's)
	var bool SetImmuneTypesAreInclusive;
	var bool ImmuneTypesAreInclusive;

	var bool SetRemoveAfterAttackCount;
	var int RemoveAfterAttackCount;

	var ENameArrayEditMode ImmuneTypesMode;
	var array<name> ImmuneTypes;

	// X2Effect_GrantActionPoints
	var bool SetNumActionPoints;
	var int NumActionPoints;

	var bool SetPointType;
	var name PointType;

	var bool SetApplyOnlyWhenOut;
	var bool ApplyOnlyWhenOut;

	var bool SetSelectUnit;
	var bool SelectUnit;

	var ENameArrayEditMode SkipWithEffectMode;
	var array<name> SkipWithEffect;

	// X2Effect_RemoveEffects
	var ENameArrayEditMode EffectNamesToRemoveMode;
	var array<name> EffectNamesToRemove;

	var bool SetCleanse;
	var bool Cleanse;

	var bool SetCheckSource;
	var bool CheckSource;

	var bool SetDoNotVisualize;
	var bool DoNotVisualize;

	// X2Effect_SetUnitValue
	var bool SetUnitName;
	var name UnitName;

	var bool SetNewValueToSet;
	var float NewValueToSet;

	var bool SetCleanupType;
	var EUnitValueCleanup CleanupType;

	// X2Effect_BonusArmor
	var bool SetArmorMitigationAmount;
	var int ArmorMitigationAmount;

	// X2Effect_Stunned
	var bool SetStunLevel;
	var int StunLevel;

	var bool SetSkipAnimation;
	var bool SkipAnimation;

	var bool SetStunStartAnimName;
	var name StunStartAnimName;

	var bool SetStunStopAnimName;
	var name StunStopAnimName;

	var bool SetStunnedTriggerName;
	var name StunnedTriggerName;

	// X2Effect_Sustained
	var bool SetSustainedAbilityName;
	var name SustainedAbilityName;

	var bool SetFragileAmount;
	var int FragileAmount;

	var ENameArrayEditMode EffectsToRemoveFromSourceMode;
	var array<name> EffectsToRemoveFromSource;

	var ENameArrayEditMode EffectsToRemoveFromTargetMode;
	var array<name> EffectsToRemoveFromTarget;

	var ENameArrayEditMode RegisterAdditionalEventsLikeImpairMode;
	var array<name> RegisterAdditionalEventsLikeImpair;

	// X2Effect_Vanish
	var bool SetReasonNotVisible;
	var name ReasonNotVisible;

	var bool SetVanishRevealAdditiveAnimName;
	var name VanishRevealAdditiveAnimName;

	var bool SetVanishRevealAnimName;
	var name VanishRevealAnimName;

	var bool SetVanishSyncAnimName;
	var name VanishSyncAnimName;

	// X2Effect_ReserveActionPoints
	var bool SetReserveType;
	var name ReserveType;

	var bool SetNumPoints;
	var int NumPoints;

	// X2Effect_CoveringFire
	var bool SetAbilityToActivate;
	var name AbilityToActivate;

	var bool SetGrantActionPoint;
	var name GrantActionPoint;

	var bool SetMaxPointsPerTurn;
	var int MaxPointsPerTurn;

	var bool SetDirectAttackOnly;
	var bool DirectAttackOnly;

	var bool SetPreEmptiveFire;
	var bool PreEmptiveFire;

	var bool SetOnlyDuringEnemyTurn;
	var bool OnlyDuringEnemyTurn;

	var bool SetUseMultiTargets;
	var bool UseMultiTargets;

	var bool SetOnlyWhenAttackMisses;
	var bool OnlyWhenAttackMisses;

	var bool SetSelfTargeting;
	var bool SelfTargeting;

	var bool SetActivationPercentChance;
	var int ActivationPercentChance;

	// X2Effect_PersistentTraversalChange (merged by Traversal)
	var ENameArrayEditMode TraversalChangesMode;
	var array<TraversalChange> TraversalChanges;

	// X2Effect_Achilles
	var bool SetToHitMin;
	var int ToHitMin;

	// X2Effect_Achilles, X2Effect_AdverseSoldierClasses, X2Effect_Bewildered, X2Effect_Impatient, X2Effect_Nearsighted, X2Effect_Oblivious
	var bool SetDmgMod;
	var float DmgMod;

	// X2Effect_AdverseSoldierClasses
	var ENameArrayEditMode AdverseClassesMode;
	var array<name> AdverseClasses;

	// X2Effect_Amplify
	var bool SetBonusDamageMult;
	var float BonusDamageMult;

	// X2Effect_Amplify
	var bool SetMinBonusDamage;
	var int MinBonusDamage;

	// X2Effect_ApplyBlazingPinionsTargetToWorld
	var bool SetOverrideParticleSystemFill_Name;
	var string OverrideParticleSystemFill_Name;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetDamageTypeTemplateName;
	var name DamageTypeTemplateName;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetPlusNumZTiles;
	var int PlusNumZTiles;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetUseWeaponEnvironmentalDamage;
	var bool UseWeaponEnvironmentalDamage;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetUseWeaponDamageType;
	var bool UseWeaponDamageType;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitSourceTile;
	var bool HitSourceTile;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitTargetTile;
	var bool HitTargetTile;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitAdjacentDestructibles;
	var bool HitAdjacentDestructibles;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetAllowDestructionOfDamageCauseCover;
	var bool AllowDestructionOfDamageCauseCover;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level1;
	var float FireChance_Level1;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level2;
	var float FireChance_Level2;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level3;
	var float FireChance_Level3;

	// X2Effect_ApplyFireToWorld
	var bool SetUseFireChanceLevel;
	var bool UseFireChanceLevel;

	// X2Effect_ApplyFireToWorld
	var bool SetDamageFragileOnly;
	var bool DamageFragileOnly;

	// X2Effect_ApplyFireToWorld
	var bool SetCheckForLOSFromTargetLocation;
	var bool CheckForLOSFromTargetLocation;

	// X2Effect_ApplyMedikitHeal
	var bool SetPerUseHP;
	var int PerUseHP;

	// X2Effect_ApplyMedikitHeal
	var bool SetIncreasedHealProject;
	var name IncreasedHealProject;

	// X2Effect_ApplyMedikitHeal
	var bool SetIncreasedPerUseHP;
	var int IncreasedPerUseHP;

	// X2Effect_APRounds
	var bool SetPierce;
	var int Pierce;

	// X2Effect_APRounds, X2Effect_TalonRounds
	var bool SetCritChance;
	var int CritChance;

	// X2Effect_APRounds, X2Effect_TalonRounds
	var bool SetCritDamage;
	var int CritDamage;

	// X2Effect_Aura
	var ENameArrayEditMode EventsToUpdateMode;
	var array<name> EventsToUpdate;

	// X2Effect_Bewildered
	var bool SetNumHitsForMod;
	var int NumHitsForMod;

	// X2Effect_BlastPadding
	var bool SetExplosiveDamageReduction;
	var float ExplosiveDamageReduction;

	// X2Effect_BloodTrail, X2Effect_HuntersInstinctDamage, X2Effect_VolatileMix
	var bool SetBonusDamage;
	var int BonusDamage;

	// X2Effect_BonusWeaponDamage
	var bool SetBonusDmg;
	var int BonusDmg;

	// X2Effect_Brutal
	var bool SetWillMod;
	var int WillMod;

	// X2Effect_ConditionalDamageModifier
	var bool SetModifyOutgoingDamage;
	var bool ModifyOutgoingDamage;

	// X2Effect_ConditionalDamageModifier
	var bool SetModifyIncomingDamage;
	var bool ModifyIncomingDamage;

	// X2Effect_ConditionalDamageModifier
	var bool SetDamageModifier;
	var float DamageModifier;

	// X2Effect_ConditionalDamageModifier
	var bool SetDamageBonus;
	var int DamageBonus;

	// X2Effect_DelayedAbilityActivation, X2Effect_FaceMultiRoundTarget, X2Effect_TriggerEvent
	var bool SetTriggerEventName;
	var name TriggerEventName;

	// X2Effect_EnableGlobalAbility
	var bool SetGlobalAbility;
	var name GlobalAbility;

	// X2Effect_GenerateCover
	var bool SetCoverType;
	var ECoverForceFlag CoverType;

	// X2Effect_GenerateCover
	var bool SetRemoveWhenMoved;
	var bool RemoveWhenMoved;

	// X2Effect_GenerateCover
	var bool SetRemoveOnOtherActivation;
	var bool RemoveOnOtherActivation;

	// X2Effect_GetOverHere
	var bool SetOverrideStartAnimName;
	var Name OverrideStartAnimName;

	// X2Effect_GetOverHere
	var bool SetOverrideStopAnimName;
	var Name OverrideStopAnimName;

	// X2Effect_GetOverHere
	var bool SetRequireVisibleTile;
	var bool RequireVisibleTile;

	// X2Effect_Groundling
	var bool SetHeightBonus;
	var int HeightBonus;

	// X2Effect_Guardian
	var ENameArrayEditMode AllowedAbilitiesMode;
	var array<name> AllowedAbilities;

	// X2Effect_Guardian
	var bool SetProcChance;
	var int ProcChance;

	// X2Effect_HoloTarget, X2Effect_SmokeGrenade
	var bool SetHitMod;
	var int HitMod;

	// X2Effect_HolyWarriorDeath
	var bool SetDelayTimeS;
	var float DelayTimeS;

	// X2Effect_HomingMine
	var bool SetAbilityToTrigger;
	var name AbilityToTrigger;

	// X2Effect_HuntersInstinctDamage
	var bool SetBonusCritChance;
	var int BonusCritChance;

	// X2Effect_ImmediateAbilityActivation
	var bool SetAbilityName;
	var name AbilityName;

	// X2Effect_ImmediateAbilityActivation
	var bool SetActivateAbilityOnTarget;
	var bool ActivateAbilityOnTarget;

	// X2Effect_ImmediateAbilityActivation
	var bool SetEffectTargetOnly;
	var bool EffectTargetOnly;

	// X2Effect_Implacable
	var bool SetImplacableThisTurnValue;
	var name ImplacableThisTurnValue;

	// X2Effect_IncreaseBondmateCohesion
	var bool SetCohesionAmount;
	var int CohesionAmount;

	// X2Effect_KineticPlating
	var bool SetShieldPerMiss;
	var int ShieldPerMiss;

	// X2Effect_Knockback
	var bool SetKnockbackDistance;
	var int KnockbackDistance;

	// X2Effect_Knockback
	var bool SetKnockbackDestroysNonFragile;
	var bool KnockbackDestroysNonFragile;

	// X2Effect_Knockback
	var bool SetOverrideRagdollFinishTimerSec;
	var float OverrideRagdollFinishTimerSec;

	// X2Effect_Knockback
	var bool SetOnlyOnDeath;
	var bool OnlyOnDeath;

	// X2Effect_LaserSight
	var bool SetBenefitFromEmpoweredUpgrades;
	var bool BenefitFromEmpoweredUpgrades;

	// X2Effect_LaserSight
	var bool SetCritBonus;
	var int CritBonus;

	// X2Effect_LifeSteal
	var bool SetLifeAmountMultiplier;
	var float LifeAmountMultiplier;

	// X2Effect_MarkValidActivationTiles
	var bool SetAbilityToMark;
	var name AbilityToMark;

	// X2Effect_MarkValidActivationTiles
	var bool SetOnlyUseTargetLocation;
	var bool OnlyUseTargetLocation;

	// X2Effect_MarkValidActivationTiles
	var bool SetVisualizeFlagsOnCursor;
	var bool VisualizeFlagsOnCursor;

	// X2Effect_MeleeDamageAdjust
	var bool SetDamageMod;
	var int DamageMod;

	// X2Effect_MeleeDamageAdjust
	var bool SetMeleeDamageTypeName;
	var name MeleeDamageTypeName;

	// X2Effect_MindControl
	var bool SetNumTurnsForAI;
	var int NumTurnsForAI;

	// X2Effect_ModifyInitiativeOrder
	var bool SetRemoveGroupFromInitiativeOrder;
	var bool RemoveGroupFromInitiativeOrder;

	// X2Effect_ModifyInitiativeOrder
	var bool SetAddGroupToInitiativeOrder;
	var bool AddGroupToInitiativeOrder;

	// X2Effect_ModifyReactionFire
	var bool SetAllowCrit;
	var bool AllowCrit;

	// X2Effect_ModifyReactionFire
	var bool SetReactionModifier;
	var int ReactionModifier;

	// X2Effect_ModifyTemplarFocus
	var bool SetModifyFocus;
	var int ModifyFocus;

	// X2Effect_Needle
	var bool SetArmorPierce;
	var int ArmorPierce;

	// X2Effect_Obsessed
	var bool SetObsessedTargetValueName;
	var Name ObsessedTargetValueName;

	// X2Effect_OverrideDeathAnimOnLoad
	var bool SetOverrideAnimNameOnLoad;
	var name OverrideAnimNameOnLoad;

	// X2Effect_PaleHorse
	var bool SetCritBoostPerKill;
	var int CritBoostPerKill;

	// X2Effect_PaleHorse
	var bool SetMaxCritBoost;
	var int MaxCritBoost;

	// X2Effect_ParthenogenicPoison
	var bool SetParthenogenicPoisonType;
	var name ParthenogenicPoisonType;

	// X2Effect_ParthenogenicPoison
	var bool SetParthenogenicPoisonCocoonSpawnedName;
	var name ParthenogenicPoisonCocoonSpawnedName;

	// X2Effect_ParthenogenicPoison, X2Effect_SpawnPsiZombie
	var bool SetAltUnitToSpawnName;
	var name AltUnitToSpawnName;

	// X2Effect_PersistentSquadViewer
	var bool SetUseWeaponRadius;
	var bool UseWeaponRadius;

	// X2Effect_PersistentSquadViewer
	var bool SetViewRadius;
	var float ViewRadius;

	// X2Effect_PersistentSquadViewer
	var bool SetUseSourceLocation;
	var bool UseSourceLocation;

	// X2Effect_PersistentVoidConduit
	var bool SetInitialDamage;
	var int InitialDamage;

	// X2Effect_Possessed
	var bool SetWeaponTemplateName;
	var name WeaponTemplateName;

	// X2Effect_Reaper
	var bool SetReaperActivatedName;
	var name ReaperActivatedName;

	// X2Effect_Reaper
	var bool SetReaperKillName;
	var name ReaperKillName;

	// X2Effect_ReduceCooldowns
	var bool SetAmount;
	var int Amount;

	// X2Effect_ReduceCooldowns
	var bool SetReduceAll;
	var bool ReduceAll;

	// X2Effect_ReduceCooldowns
	var ENameArrayEditMode AbilitiesToTickMode;
	var array<name> AbilitiesToTick;

	// X2Effect_Regeneration
	var bool SetHealAmount;
	var int HealAmount;

	// X2Effect_Regeneration
	var bool SetMaxHealAmount;
	var int MaxHealAmount;

	// X2Effect_Regeneration
	var bool SetHealthRegeneratedName;
	var name HealthRegeneratedName;

	// X2Effect_Regeneration
	var bool SetEventToTriggerOnHeal;
	var name EventToTriggerOnHeal;

	// X2Effect_RemoteStart
	var bool SetUnitDamageMultiplier;
	var float UnitDamageMultiplier;

	// X2Effect_RemoteStart
	var bool SetDamageRadiusMultiplier;
	var float DamageRadiusMultiplier;

	// X2Effect_RemoveEffectsByDamageType
	var ENameArrayEditMode DamageTypesToRemoveMode;
	var array<name> DamageTypesToRemove;

	// X2Effect_ReserveOverwatchPoints
	var ENameArrayEditMode UseAllPointsWithAbilitiesMode;
	var array<name> UseAllPointsWithAbilities;

	// X2Effect_RunBehaviorTree
	var bool SetNumActions;
	var int NumActions;

	// X2Effect_RunBehaviorTree
	var bool SetBehaviorTreeName;
	var name BehaviorTreeName;

	// X2Effect_RunBehaviorTree
	var bool SetInitFromPlayer;
	var bool InitFromPlayer;

	// X2Effect_RunBehaviorTree
	var bool SetSetActionPointCount;
	var int SetActionPointCount;

	// X2Effect_ScanningProtocol
	var bool SetLookAtDuration;
	var float LookAtDuration;

	// X2Effect_Shattered
	var bool SetShatteredTargetValueName;
	var Name ShatteredTargetValueName;

	// X2Effect_SoulSteal
	var bool SetUnitValueToRead;
	var name UnitValueToRead;

	// X2Effect_SpawnDestructible
	var bool SetDestructibleArchetype;
	var string DestructibleArchetype;

	// X2Effect_SpawnDestructible
	var bool SetDestroyOnRemoval;
	var bool DestroyOnRemoval;

	// X2Effect_SpawnDestructible
	var bool SetTargetableBySpawnedTeamOnly;
	var bool TargetableBySpawnedTeamOnly;

	// X2Effect_SpawnPsiZombie
	var bool SetAnimationName;
	var name AnimationName;

	// X2Effect_SpawnPsiZombie
	var bool SetStartAnimationMinDelaySec;
	var float StartAnimationMinDelaySec;

	// X2Effect_SpawnPsiZombie
	var bool SetStartAnimationMaxDelaySec;
	var float StartAnimationMaxDelaySec;

	// X2Effect_SpawnShadowbindUnit
	var bool SetShadowbindUnconciousCheckName;
	var name ShadowbindUnconciousCheckName;

	// X2Effect_SpawnUnit
	var bool SetUnitToSpawnName;
	var name UnitToSpawnName;

	// X2Effect_SpawnUnit
	var bool SetClearTileBlockedByTargetUnitFlag;
	var bool ClearTileBlockedByTargetUnitFlag;

	// X2Effect_SpawnUnit
	var bool SetCopyTargetAppearance;
	var bool CopyTargetAppearance;

	// X2Effect_SpawnUnit
	var bool SetCopySourceAppearance;
	var bool CopySourceAppearance;

	// X2Effect_SpawnUnit
	var bool SetKnockbackAffectsSpawnLocation;
	var bool KnockbackAffectsSpawnLocation;

	// X2Effect_SpawnUnit
	var bool SetAddToSourceGroup;
	var bool AddToSourceGroup;

	// X2Effect_SpawnUnit
	var bool SetCopyReanimatedFromUnit;
	var bool CopyReanimatedFromUnit;

	// X2Effect_SpawnUnit
	var bool SetCopyReanimatedStatsFromUnit;
	var bool CopyReanimatedStatsFromUnit;

	// X2Effect_SpawnUnit
	var bool SetSetProcessedScamperAs;
	var bool SetProcessedScamperAs;

	// X2Effect_Spotted
	var bool SetBecomeUnspotted;
	var bool BecomeUnspotted;

	// X2Effect_Stasis
	var bool SetStunStartAnim;
	var name StunStartAnim;

	// X2Effect_Stasis
	var bool SetStunStopAnim;
	var name StunStopAnim;

	// X2Effect_Stasis
	var bool SetSkipFlyover;
	var bool SkipFlyover;

	// X2Effect_Stasis
	var bool SetStartAnimBlendTime;
	var float StartAnimBlendTime;

	// X2Effect_SuperConcealModifier
	var bool SetConcealAmountScalar;
	var float ConcealAmountScalar;

	// X2Effect_SuperConcealModifier
	var ENameArrayEditMode AbilitiesAffectedFilterMode;
	var array<name> AbilitiesAffectedFilter;

	// X2Effect_SuperConcealModifier
	var ENameArrayEditMode RemoveOnAbilityActivationMode;
	var array<name> RemoveOnAbilityActivation;

	// X2Effect_SuspendMissionTimer
	var bool SetResumeMissionTimer;
	var bool ResumeMissionTimer;

	// X2Effect_TalonRounds
	var bool SetAimMod;
	var int AimMod;

	// X2Effect_TargetDamageDistanceBonus, X2Effect_TargetDamageTypeBonus
	var bool SetBonusDmgFloat;
	var float BonusDmgFloat;

	// X2Effect_TargetDamageDistanceBonus, X2Effect_TargetDamageTypeBonus
	var bool SetBonusModType;
	var EStatModOp BonusModType;

	// X2Effect_TargetDamageDistanceBonus
	var bool SetWithinTileDistance;
	var int WithinTileDistance;

	// X2Effect_TargetDamageDistanceBonus
	var bool SetPrimaryTargetOnly;
	var bool PrimaryTargetOnly;

	// X2Effect_TargetDamageTypeBonus
	var ENameArrayEditMode BonusDamageTypesMode;
	var array<name> BonusDamageTypes;

	// X2Effect_ThreatAssessment
	var bool SetImmediateActionPoint;
	var name ImmediateActionPoint;

	// X2Effect_ToHitModifier
	var bool SetApplyAsTarget;
	var bool ApplyAsTarget;

	// X2Effect_TrackingShotMarkTarget
	var bool SetConeLength;
	var float ConeLength;

	// X2Effect_TrackingShotMarkTarget
	var bool SetConeEndDiameter;
	var float ConeEndDiameter;

	// X2Effect_TriggerEvent
	var bool SetPassTargetAsSource;
	var bool PassTargetAsSource;

	// X2Effect_TurnStartActionPoints
	var bool SetActionPointType;
	var name ActionPointType;

	// X2Effect_TurnStartActionPoints
	var bool SetActionPointsRemoved;
	var bool ActionPointsRemoved;

	// X2Effect_VanishingWind
	var bool SetMovingVanishRevealAdditiveAnimName;
	var name MovingVanishRevealAdditiveAnimName;

	// X2Effect_VoidConduit
	var bool SetDamagePerAction;
	var int DamagePerAction;

	// X2Effect_VoidConduit
	var bool SetHealthReturnMod;
	var float HealthReturnMod;

	// X2Effect_WallBreaking
	var bool SetWallBreakingEffectName;
	var name WallBreakingEffectName;

	// X2Effect_World
	var bool SetCenterTile;
	var bool CenterTile;

	// X2Effect_PersistentStatChangeRestoreDefault
	var ENameArrayEditMode StatTypesToRestoreMode;
	var array<ECharStatType> StatTypesToRestore;

	// X2Effect_ConditionalDamageModifier
	var array<ConditionEdit> ApplyDamageModConditions;

	// X2Effect_LethalWeaponDamage
	var array<ConditionEdit> LethalDamageConditions;

	// X2Effect_ToHitModifier
	var array<ConditionEdit> ToHitConditions;

	// X2Effect_ToHitModifier: replace-only — when non-empty, replaces Modifiers entirely
	var array<EffectHitModifier> EffectHitModifiers;

	var array<AECustomProperty> CustomProperties;
};

struct AbilityEdit
{
	// Ability template name
	var name Ability;

	var bool SetHostility;
	var EAbilityHostility Hostility;

	var bool SetConcealmentRule;
	var EConcealmentRule ConcealmentRule;

	var array<name> AdditionalAbilities;
	var ENameArrayEditMode AdditionalAbilitiesMode;

	var array<name> PrerequisiteAbilities;
	var ENameArrayEditMode PrerequisiteAbilitiesMode;

	var array<name> OverrideAbilities;
	var ENameArrayEditMode OverrideAbilitiesMode;

	var CooldownEdit Cooldown;

	var EAbilityCostEditMode CostMode;
	var array<CostEdit> Costs;

	var ChargesEdit Charges;

	var array<EffectEdit> Effects;

	// Template-level condition arrays
	var array<ConditionEdit> ShooterConditions;
	var array<ConditionEdit> TargetConditions;
	var array<ConditionEdit> MultiTargetConditions;
};

