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
};

