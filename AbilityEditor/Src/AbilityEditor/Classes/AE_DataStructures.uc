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

	// Template-level condition arrays
	var array<ConditionEdit> ShooterConditions;
	var array<ConditionEdit> TargetConditions;
	var array<ConditionEdit> MultiTargetConditions;
};

