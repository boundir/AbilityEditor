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

enum EAbilityCreatePreset
{
	eACP_Standard,
	eACP_MoveEnd,
	eACP_Passive
};

struct AdditionalCooldownEdit
{
	var name AbilityName;

	var bool SetNumTurns;
	// Cooldown applied to that other ability, in turns.
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

	var bool SetFreeCost;
	// Makes the ability cost nothing. The ability must satisfy the requirement to be usable, but using it doesn't consume action point.
	var bool FreeCost;

	var bool SetNumPoints;
	// Action points the ability consumes.
	var int NumPoints;

	var bool SetAddWeaponTypicalCost;
	// Adds the weapon's own typical action cost on top of NumPoints.
	var bool AddWeaponTypicalCost;

	var bool SetConsumeAllPoints;
	// Ends the turn by consuming every remaining action point, rather than just NumPoints.
	var bool ConsumeAllPoints;

	var bool SetMoveCost;
	// Treats the cost as movement, so effects and abilities that key off moving apply.
	var bool MoveCost;

	// Action point types that may pay this cost. Restricting it stops the ability being
	// paid for with, say, a Run-and-Gun point.
	var array<name> AllowedTypes;
	var ENameArrayEditMode AllowedTypesMode;

	// If the user is under any of these effects, ConsumeAllPoints is ignored and the turn does not end.
	var array<name> DoNotConsumeAllEffects;
	var ENameArrayEditMode DoNotConsumeAllEffectsMode;

	// If the user has any of these abilities, ConsumeAllPoints is ignored. This is how Blademaster lets Slash keep the turn going.
	var array<name> DoNotConsumeAllSoldierAbilities;
	var ENameArrayEditMode DoNotConsumeAllSoldierAbilitiesMode;

	// Other abilities whose charges are spent alongside this one, as Skulljack and
	// Skullmine share a pool. Applied when paying, never when checking affordability.
	var array<name> SharedAbilityCharges;
	var ENameArrayEditMode SharedAbilityChargesMode;

	var bool SetFocusAmount;
	// Templar focus consumed.
	var int FocusAmount;

	var bool SetConsumeAllFocus;
	// Spends the user's entire focus pool rather than FocusAmount.
	var bool ConsumeAllFocus;

	var bool SetGhostOnlyCost;
	// Only charges focus to a Ghost, leaving the original Templar's pool untouched.
	var bool GhostOnlyCost;

	var bool SetNumAmmo;
	// Ammo consumed per use. With ConsumeAllAmmo set this becomes the minimum needed to
	// fire, rather than the amount spent.
	var int NumAmmo;

	var bool SetUseLoadedAmmo;
	// Draws from the loaded grenade rather than the weapon's ammo, for grenade-launcher abilities.
	var bool UseLoadedAmmo;

	var bool SetReturnChargesError;
	// Reports a shortfall as "out of charges" instead of "out of ammo", for abilities
	// presented to the player as charge-based.
	var bool ReturnChargesError;

	var bool SetConsumeAllAmmo;
	// Spends the whole magazine. NumAmmo then only sets the minimum required to fire.
	var bool ConsumeAllAmmo;

	var bool SetNumCharges;
	// Charges consumed per use.
	var int NumCharges;

	var bool SetOnlyOnHit;
	// Only spends the charge when the ability hits, so a miss costs nothing.
	var bool OnlyOnHit;

	var bool SetAlsoExpendChargesOnSharedBondmateAbility;
	// Also spends the bondmate's charges of the shared ability.
	var bool AlsoExpendChargesOnSharedBondmateAbility;
};

struct CooldownEdit
{
	// Class name of the cooldown to instantiate
	var string Class;

	var bool SetNumTurns;
	// Turns the ability is unavailable after use.
	var int NumTurns;

	var bool SetIgnoreOnHit;
	// Skips applying the cooldown when the ability hits, so only a miss puts it on cooldown.
	var bool IgnoreOnHit;

	var EAdditionalCooldownEditMode AdditionalCooldownMode;
	// Cooldowns this ability also puts on *other* abilities, keyed by AbilityName. Used
	// where firing one thing should lock out another.
	var array<AdditionalCooldownEdit> AdditionalCooldowns;

	var bool SetNumTurnsForAI;
	// Cooldown used when the unit is AI-controlled, letting XCOM and the enemy run
	// different timings. Only on X2AbilityCooldown_PerPlayerType.
	var int NumTurnsForAI;

	var bool SetNumGlobalTurns;
	// Cooldown applied across every unit on the team, not just the one that used the
	// ability. Only on the global cooldown classes.
	var int NumGlobalTurns;
};

struct ChargesEdit
{
	// Class name of the charge to instantiate
	var string Class;

	var bool SetInitialCharges;
	// Charges the ability starts a mission with.
	var int InitialCharges;

	var EChargesBonusMode BonusChargesMode;
	// Extra charges granted when the unit has another ability, keyed by AbilityName.
	// This is how Restoration adds charges to the medikit heal.
	var array<BonusChargeEdit> BonusCharges;

	var bool RemoveCharges;

	var bool SetStabilize;
	// Whether the charges behave as the stabilise-style pool, on the charge classes that support it.
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
	// Soldier abilities the unit owning the ability must have.
	var array<name> OwnerHasSoldierAbilities;

	var bool SetTargetMustBeInValidTiles;
	// Reject targets standing outside the ability's valid tiles.
	var bool TargetMustBeInValidTiles;

	// X2Condition_AbilitySourceWeapon
	var bool SetWantsReload;
	// Fail with AA_AmmoAlreadyFull when the source weapon's clip is already full.
	var bool WantsReload;

	var bool SetCheckAmmo;
	// Compare the source weapon's ammo against CheckAmmoData.
	var bool CheckAmmo;

	var bool SetCheckAmmoData;
	// The ammo check used when CheckAmmo is true: Value, CheckType, and ValueMin/ValueMax for range checks.
	var CheckConfig CheckAmmoData;

	var bool SetNotLoadedAmmoInSecondaryWeapon;
	// Fail when the source weapon is currently loaded as ammo in the secondary weapon.
	var bool NotLoadedAmmoInSecondaryWeapon;

	var bool SetMatchGrenadeType;
	// Grenade template the source weapon, or its loaded ammo, must be.
	var name MatchGrenadeType;

	var bool SetCheckGrenadeFriendlyFire;
	// Reject friendly targets unless the grenade template allows friendly fire.
	var bool CheckGrenadeFriendlyFire;

	var bool SetCheckAmmoTechLevel;
	// Reject the source ammo when it is not valid for the unit's primary weapon.
	var bool CheckAmmoTechLevel;

	var bool SetMatchWeaponTemplate;
	// Weapon template the source weapon must be, exact match on its DataName.
	var name MatchWeaponTemplate;

	// X2Condition_DarkEvent
	var bool SetStilettoRounds;
	// Pass only while the Stiletto Rounds dark event is active.
	var bool StilettoRounds;

	// X2Condition_GameplayTag
	var bool SetRequiredGameplayTag;
	// Tactical gameplay tag XCOM HQ must carry for the ability to be valid.
	var name RequiredGameplayTag;

	var bool SetDisallowGameplayTag;
	// Tactical gameplay tag that makes the ability invalid while XCOM HQ carries it.
	var name DisallowGameplayTag;

	// X2Condition_GameTime
	var ENameArrayEditMode HourChecksMode;
	// Checks against the current hour of the day; the condition passes when any one of them does. Merge adds checks not already present.
	var array<CheckConfig> HourChecks;

	// X2Condition_PlayerTurns
	var bool SetNumTurnsCheck;
	// Check against the number of turns the target's controlling player has taken.
	var CheckConfig NumTurnsCheck;

	// X2Condition_UnitActionPoints (merged by ActionPointType)
	var ENameArrayEditMode ActionPointChecksMode;
	// Action point checks; passes when any one of them does. Each names an action point type, whether to count reserved points, and the value check.
	var array<ActionPointCheck> ActionPointChecks;

	// X2Condition_UnitAlertStatus
	var bool SetRequiredAlertStatusMaximum;
	// Highest alert level the unit may have. -1 ignores it; the condition fails when both limits are -1.
	var int RequiredAlertStatusMaximum;

	var bool SetRequiredAlertStatusMinimum;
	// Lowest alert level the unit may have. -1 ignores it; the condition fails when both limits are -1.
	var int RequiredAlertStatusMinimum;

	// X2Condition_UnitEffects and its subclasses (merged by EffectName)
	var ENameArrayEditMode ExcludeEffectsMode;
	// Effects that reject the unit when present, each with the failure reason to return.
	var array<EffectReason> ExcludeEffects;

	var ENameArrayEditMode RequireEffectsMode;
	// Effects that must all be present on the unit, each with the failure reason to return.
	var array<EffectReason> RequireEffects;

	// X2Condition_UnitImmunities
	var ENameArrayEditMode ExcludeDamageTypesMode;
	// Damage types; a unit immune to any of them is rejected.
	var array<name> ExcludeDamageTypes;

	var bool SetOnlyOnCharacterTemplate;
	// Consider only the immunities of the unit's character template, not those granted by effects.
	var bool OnlyOnCharacterTemplate;

	// X2Condition_UnitInteractions, X2Condition_Interactive
	var bool SetInteractionType;
	// Kind of interaction point the unit must be next to: eInteractionType_Normal or eInteractionType_Hack.
	var UnitInterationType InteractionType;

	// X2Condition_UnitInventory
	var bool SetRelevantSlot;
	// Inventory slot whose item is checked.
	var EInventorySlot RelevantSlot;

	var bool SetExcludeWeaponCategory;
	// Weapon category that rejects the unit when the item in RelevantSlot has it.
	var name ExcludeWeaponCategory;

	var bool SetRequireWeaponCategory;
	// Weapon category the item in RelevantSlot must have. Fails when the slot is empty.
	var name RequireWeaponCategory;

	// X2Condition_UnitProperty
	var bool SetExcludeAlive;
	// Reject living units.
	var bool ExcludeAlive;

	var bool SetExcludeDead;
	// Reject dead units.
	var bool ExcludeDead;

	var bool SetExcludeRobotic;
	// Reject robotic units.
	var bool ExcludeRobotic;

	var bool SetExcludeOrganic;
	// Reject organic units.
	var bool ExcludeOrganic;

	var bool SetExcludeCivilian;
	// Reject units whose character template is civilian, whatever their team.
	var bool ExcludeCivilian;

	var bool SetExcludeNonCivilian;
	// Reject units whose character template is not civilian, whatever their team.
	var bool ExcludeNonCivilian;

	var bool SetExcludeCosmetic;
	// Reject cosmetic units, such as Gremlins.
	var bool ExcludeCosmetic;

	var bool SetExcludeImpaired;
	// Reject impaired units.
	var bool ExcludeImpaired;

	var bool SetExcludePanicked;
	// Reject panicked units.
	var bool ExcludePanicked;

	var bool SetExcludeInStasis;
	// Reject units in stasis.
	var bool ExcludeInStasis;

	var bool SetExcludeTurret;
	// Reject turrets.
	var bool ExcludeTurret;

	var bool SetExcludePsionic;
	// Reject psionic units.
	var bool ExcludePsionic;

	var bool SetExcludeNonPsionic;
	// Reject non-psionic units.
	var bool ExcludeNonPsionic;

	var bool SetIsAdvent;
	// Require an ADVENT unit.
	var bool IsAdvent;

	var bool SetExcludeAdvent;
	// Reject ADVENT units.
	var bool ExcludeAdvent;

	var bool SetExcludeNoCover;
	// Reject units that are not in cover.
	var bool ExcludeNoCover;

	var bool SetExcludeNoCoverToSource;
	// Reject units with no cover between them and the source.
	var bool ExcludeNoCoverToSource;

	var bool SetExcludeFullHealth;
	// Reject units at full HP, unless a persistent damage effect listed in MedikitHealEffectTypes is on them.
	var bool ExcludeFullHealth;

	var bool SetIsBleedingOut;
	// Require a unit that is bleeding out.
	var bool IsBleedingOut;

	var bool SetIsUnspotted;
	// Require a unit that has not been spotted.
	var bool IsUnspotted;

	var bool SetCanBeCarried;
	// Require a unit that can be carried.
	var bool CanBeCarried;

	var bool SetIsOutdoors;
	// Require a unit standing outdoors.
	var bool IsOutdoors;

	var bool SetIsConcealed;
	// Require a concealed unit.
	var bool IsConcealed;

	var bool SetExcludeConcealed;
	// Reject concealed units. Only applies to the check without a source; visibility rules normally cover this.
	var bool ExcludeConcealed;

	var bool SetIsSuperConcealed;
	// Require a unit in super concealment.
	var bool IsSuperConcealed;

	var bool SetIsImpaired;
	// Require an impaired unit.
	var bool IsImpaired;

	var bool SetHasClearanceToMaxZ;
	// Require open space above the unit up to the map ceiling.
	var bool HasClearanceToMaxZ;

	var bool SetExcludeAlien;
	// Reject alien units.
	var bool ExcludeAlien;

	var bool SetExcludeNonHumanoidAliens;
	// Reject aliens that are not humanoid.
	var bool ExcludeNonHumanoidAliens;

	var bool SetExcludeStunned;
	// Reject stunned units.
	var bool ExcludeStunned;

	var bool SetExcludeDazed;
	// Reject dazed units.
	var bool ExcludeDazed;

	var bool SetExcludeUnableToAct;
	// Reject units that are unable to act.
	var bool ExcludeUnableToAct;

	var bool SetIsPlayerControlled;
	// Require a player-controlled unit.
	var bool IsPlayerControlled;

	var bool SetExcludeUnrevealedAI;
	// Reject AI units that have not been revealed yet.
	var bool ExcludeUnrevealedAI;

	var bool SetIncludeWeakAgainstTechLikeRobot;
	// Treat units flagged as weak against tech as robotic for the robotic checks.
	var bool IncludeWeakAgainstTechLikeRobot;

	var bool SetImpairedIgnoresStuns;
	// Do not count stuns when deciding whether a unit is impaired.
	var bool ImpairedIgnoresStuns;

	var bool SetIsScampering;
	// Require a unit that is currently scampering.
	var bool IsScampering;

	var bool SetExcludeDeadFromSpecialDeath;
	// Reject units killed by a special death.
	var bool ExcludeDeadFromSpecialDeath;

	var bool SetExcludeLargeUnits;
	// Reject units larger than one tile.
	var bool ExcludeLargeUnits;

	var bool SetImpairedIgnoresImpairingMomentarily;
	// Do not count momentary impairment when deciding whether a unit is impaired.
	var bool ImpairedIgnoresImpairingMomentarily;

	var bool SetMinRank;
	// Lowest soldier rank allowed.
	var int MinRank;

	var bool SetMaxRank;
	// Highest soldier rank allowed.
	var int MaxRank;

	var ENameArrayEditMode ExcludeSoldierClassesMode;
	// Soldier classes that reject the unit. Non-soldiers always pass.
	var array<name> ExcludeSoldierClasses;

	var ENameArrayEditMode RequireSoldierClassesMode;
	// Soldier classes the unit must be one of, when non-empty. Non-soldiers always fail.
	var array<name> RequireSoldierClasses;

	var bool SetExcludeHostileToSource;
	// Reject units hostile to the source.
	var bool ExcludeHostileToSource;

	var bool SetExcludeFriendlyToSource;
	// Reject units friendly to the source.
	var bool ExcludeFriendlyToSource;

	var bool SetTreatMindControlledSquadmateAsHostile;
	// Count a mind-controlled squadmate as hostile rather than friendly.
	var bool TreatMindControlledSquadmateAsHostile;

	var bool SetExcludeSquadmates;
	// Reject units on the same team as the source.
	var bool ExcludeSquadmates;

	var bool SetRequireSquadmates;
	// Require the unit to be on the same team as the source.
	var bool RequireSquadmates;

	var bool SetRequireWithinRange;
	// Require the unit to be within WithinRange of the source.
	var bool RequireWithinRange;

	var bool SetWithinRange;
	// Maximum distance between source and target, in Unreal units. A tile is 96.
	var float WithinRange;

	var bool SetRequireWithinMinRange;
	// Require the unit to be within WithinMinRange of the source.
	var bool RequireWithinMinRange;

	var bool SetWithinMinRange;
	// Distance for the minimum-range check, in Unreal units. A tile is 96.
	var float WithinMinRange;

	var bool SetBeingCarriedBySource;
	// Require a unit currently carried by the source.
	var bool BeingCarriedBySource;

	var bool SetRequireUnitSelectedFromHQ;
	// Require a unit that was selected from Headquarters for the mission. XCOM only.
	var bool RequireUnitSelectedFromHQ;

	var bool SetFailOnNonUnits;
	// Fail with AA_NotAUnit on non-unit targets instead of passing them through.
	var bool FailOnNonUnits;

	// X2Condition_UnitStatCheck (merged by StatType)
	var ENameArrayEditMode CheckStatsMode;
	// Stat checks that must all pass: the stat, the value check, and whether to compare as a percentage of the stat's maximum.
	var array<CheckStat> CheckStats;

	// X2Condition_UnitType
	var ENameArrayEditMode IncludeTypesMode;
	// Character groups the unit must belong to, when non-empty. Takes precedence over ExcludeTypes.
	var array<name> IncludeTypes;

	var ENameArrayEditMode ExcludeTypesMode;
	// Character groups that reject the unit. Ignored while IncludeTypes is non-empty.
	var array<name> ExcludeTypes;

	// X2Condition_UnitValue (merged by UnitValue)
	var ENameArrayEditMode CheckValuesMode;
	// Unit value checks that must all pass: the value name, the value check, and an optional failure code to return instead of the default.
	var array<CheckValue> CheckValues;

	// X2Condition_Visibility
	var bool SetNoEnemyViewers;
	// Fail when any enemy can see the target.
	var bool NoEnemyViewers;

	var bool SetRequireMatchCoverType;
	// Require the target to be in the cover type given by TargetCover.
	var bool RequireMatchCoverType;

	var bool SetRequireNotMatchCoverType;
	// Require the target not to be in the cover type given by TargetCover.
	var bool RequireNotMatchCoverType;

	var bool SetTargetCover;
	// Cover type used by RequireMatchCoverType and RequireNotMatchCoverType.
	var ECoverType TargetCover;

	var bool SetCannotPeek;
	// Require the shooter to see the target from its own tile, without peeking.
	var bool CannotPeek;

	var bool SetRequireLOS;
	// Require line of sight.
	var bool RequireLOS;

	var bool SetRequireBasicVisibility;
	// Require line of sight and range.
	var bool RequireBasicVisibility;

	var bool SetRequireGameplayVisible;
	// Require line of sight, range and the situational gameplay-visibility rules.
	var bool RequireGameplayVisible;

	var bool SetAllowSquadsight;
	// Accept any squadmate's view of the target if the unit has Squadsight. Overrides RequireGameplayVisible.
	var bool AllowSquadsight;

	var bool SetActAsSquadsight;
	// Accept any squadmate's view of the target whether or not the unit has Squadsight. Overrides RequireGameplayVisible.
	var bool ActAsSquadsight;

	var bool SetVisibleToAnyAlly;
	// Accept the target when any squadmate can see it, without line of sight from the unit itself. Overrides RequireGameplayVisible.
	var bool VisibleToAnyAlly;

	var bool SetDisablePeeksOnMovement;
	// Forbid peeking once the target has moved.
	var bool DisablePeeksOnMovement;

	var bool SetExcludeGameplayVisible;
	// Fail when the target has gameplay visibility of the source.
	var bool ExcludeGameplayVisible;

	var ENameArrayEditMode RequireGameplayVisibleTagsMode;
	// Visibility tags that must be present on the visibility info, such as concealed or stealthed.
	var array<name> RequireGameplayVisibleTags;

	// X2Condition_BattleState
	var bool SetMissionAborted;
	// Require the mission to have been aborted.
	var bool MissionAborted;

	// X2Condition_BattleState
	var bool SetMissionNotAborted;
	// Require the mission not to have been aborted.
	var bool MissionNotAborted;

	// X2Condition_BattleState
	var bool SetCiviliansTargetedByAliens;
	// Require a mission where aliens target civilians.
	var bool CiviliansTargetedByAliens;

	// X2Condition_BattleState
	var bool SetCiviliansNotTargetedByAliens;
	// Require a mission where aliens do not target civilians.
	var bool CiviliansNotTargetedByAliens;

	// X2Condition_BattleState
	var bool SetIncludeTheLostInEngagedCount;
	// Count the Lost among the engaged enemies.
	var bool IncludeTheLostInEngagedCount;

	// X2Condition_BattleState
	var bool SetMinEngagedEnemies;
	// Fewest engaged enemies required. -1 ignores it.
	var int MinEngagedEnemies;

	// X2Condition_BattleState
	var bool SetMaxEngagedEnemies;
	// Most engaged enemies allowed. -1 ignores it.
	var int MaxEngagedEnemies;

	// X2Condition_BerserkerDevastatingPunch
	var bool SetFailOnNonUnitTargets;
	// Fail with AA_NotAUnit on non-unit targets instead of passing them through.
	var bool FailOnNonUnitTargets;

	// X2Condition_Bondmate
	var bool SetMinBondLevel;
	// Lowest bond level between the two units, inclusive.
	var int MinBondLevel;

	// X2Condition_Bondmate
	var bool SetMaxBondLevel;
	// Highest bond level between the two units, inclusive.
	var int MaxBondLevel;

	// X2Condition_Bondmate
	var bool SetRequiresAdjacency;
	// Whether the bondmates may, must not, or must be adjacent: EAR_AnyAdjacency, EAR_DisallowAdjacency or EAR_RequireAdjacency.
	var AdjacencyRequirement RequiresAdjacency;

	// X2Condition_Bondmate
	var bool SetSkipCheckWithSource;
	// Only check that the source has a bondmate on the mission, not that the target is that bondmate. For self-targeted bondmate abilities.
	var bool SkipCheckWithSource;

	// X2Condition_HackingTarget
	var bool SetIntrusionProtocol;
	// Hack objects at range: needs gameplay visibility of the object instead of an adjacent interaction point.
	var bool IntrusionProtocol;

	// X2Condition_HackingTarget
	var bool SetHaywireProtocol;
	// Target units instead of objects: living, unhacked, robotic enemies the unit sees or has squadsight on.
	var bool HaywireProtocol;

	// X2Condition_HackingTarget, X2Condition_Interactive
	var bool SetRequiredAbilityName;
	// Ability the interactive object must expose. For hacking, empty accepts any object; for a normal interaction it must match exactly.
	var name RequiredAbilityName;

	// X2Condition_HackingTarget
	var bool SetMustBeDoor;
	// Require the object to be a door.
	var bool MustBeDoor;

	// X2Condition_Lootable
	var bool SetRestrictRange;
	// Require the loot to be within LootableRange of the source.
	var bool RestrictRange;

	// X2Condition_Lootable
	var bool SetLootableRange;
	// Maximum distance to the loot, in Unreal units, when RestrictRange is set. A tile is 96.
	var int LootableRange;

	// X2Condition_OnGroundTile
	var bool SetNotAFloorTileTag;
	// Tag of tiles that must not count as ground.
	var name NotAFloorTileTag;

	// X2Condition_PanicOnPod
	var bool SetMaxPanicUnitsPerPod;
	// Most units of an AI pod that may be panicked at once. 0 removes the limit.
	var int MaxPanicUnitsPerPod;

	// X2Condition_StasisLanceTarget
	var bool SetHackAbilityName;
	// Hack ability whose rewards the target must offer, e.g. FinalizeSKULLJACK.
	var Name HackAbilityName;

	// X2Condition_Stealth
	var bool SetCheckFlanking;
	// Fail when any enemy flanks the unit.
	var bool CheckFlanking;

	// X2Condition_UnblockedNeighborTile
	var bool SetRequireVisible;
	// Require a free neighbouring tile the unit could be pulled to, rather than any free neighbouring tile.
	var bool RequireVisible;

	// X2Condition_MapProperty
	var ENameArrayEditMode AllowedBiomesMode;
	// Map biomes the mission must be in, when non-empty.
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

	// Nested tick effects (X2Effect_Persistent.ApplyOnTick)
	//
	// A persistent effect is a state; the thing it actually does each turn lives in a
	// child effect inside its ApplyOnTick array. Burning for example:
	// X2Effect_Burning object only carries duration, while the damage sits in an
	// X2Effect_ApplyWeaponDamage that SetBurnDamage() puts at ApplyOnTick[0].
	//
	// Setting ApplyOnTickClass redirects this whole entry at that child, so every field
	// below applies to it instead of to the parent.
	var string ApplyOnTickClass;
	var int ApplyOnTickIndex;
	var EArrayEditMode ApplyOnTickMode;

	var bool SetApplyOnHit;
	// Whether the effect is applied when the ability hits. Most effects want this true;
	// setting it false is how an effect is made to trigger only on a miss.
	var bool ApplyOnHit;

	var bool SetApplyOnMiss;
	// Whether the effect is applied even when the ability misses.
	var bool ApplyOnMiss;

	var bool SetApplyChance;
	// Percentage chance the effect applies at all, rolled per target. 0 behaves as
	// "always", since the roll is only made when a chance is set.
	var int ApplyChance;

	var bool SetApplyToWorldOnHit;
	// Whether the effect is applied to the world (tiles, cover, environment) on a hit,
	// rather than to a unit. Used by fire, smoke, acid and the other world effects.
	var bool ApplyToWorldOnHit;

	var bool SetApplyToWorldOnMiss;
	// As ApplyToWorldOnHit, but for a miss. Grenades typically set both, so they still
	// affect the ground when they scatter.
	var bool ApplyToWorldOnMiss;

	var bool SetUseSourcePlayerState;
	// Records the source player on the effect when it is applied, so later logic can tell
	// whose effect it was. Needed by effects that behave differently for XCOM and the AI.
	var bool UseSourcePlayerState;

	var bool SetIsImpairing;
	// Marks the effect as impairing the unit, which fires the impairment event and makes
	// the unit report as impaired. This is what stuns, panic and disorientation use.
	var bool IsImpairing;

	var bool SetIsImpairingMomentarily;
	// Fires the impairment event without leaving the unit flagged as impaired afterwards.
	// For effects that interrupt an action but do not linger.
	var bool IsImpairingMomentarily;

	var bool SetBringRemoveVisualizationForward;
	// Moves this effect's removal visualization earlier in the sequence, taking the whole
	// context's visualization with it. Used when a removal must be seen before what follows.
	var bool BringRemoveVisualizationForward;

	var bool SetShowImmunity;
	// Shows a flyover when the target is immune to this effect. Only when the application
	// actually failed because of immunity.
	var bool ShowImmunity;

	var bool SetShowImmunityAnyFailure;
	// Shows the immunity flyover whenever the effect fails to apply for any reason, not
	// only immunity. Broader, and noisier, than ShowImmunity.
	var bool ShowImmunityAnyFailure;

	var bool SetAppliesDamage;
	// Marks the effect as dealing damage, so it counts towards damage statistics and
	// raises the generic ability-damage events. Set it on any custom source of damage.
	var bool AppliesDamage;

	var bool SetCanBeRedirected;
	// Whether the effect is eligible to be redirected onto another target, by Untouchable,
	// Bladestorm parries and similar. Leave false for effects that must hit their target.
	var bool CanBeRedirected;

	var bool SetHideDeathWorldMessage;
	// Suppresses the usual death message when this effect is what kills the unit, for
	// deaths that should read as something other than a normal kill.
	var bool HideDeathWorldMessage;

	var ENameArrayEditMode DamageTypesMode;
	// Damage types this effect counts as. A unit immune to any type listed here resists the
	// effect, and cleansing effects look at these types to decide what they can remove.
	var array<name> DamageTypes;

	// Conditions attached to the effect (X2Effect.TargetConditions)
	var array<ConditionEdit> TargetConditions;

	var bool SetMinStatContestResult;
	// For effects resolved by a stat contest: the contest result must be at least this for
	// the effect to apply. Used to band outcomes, so a stronger roll applies a stronger effect.
	var int MinStatContestResult;

	var bool SetMaxStatContestResult;
	// Upper bound of the same stat-contest band. Ignored when it is below
	// MinStatContestResult.
	var int MaxStatContestResult;

	var bool SetDelayVisualizationSec;
	// Seconds to delay this effect's visualization, for sequencing it against the rest of
	// the ability rather than changing any game state.
	var float DelayVisualizationSec;

	var bool SetOverrideMissMessage;
	// Replaces the usual "Miss" flyover with your own text, for abilities where a miss
	// should read as something else.
	var string OverrideMissMessage;

	var bool SetNumTurns;
	// How many turns the effect lasts. Ignored when InfiniteDuration is true.
	var int NumTurns;

	var bool SetInitialShedChance;
	// Percentage chance the effect is shed immediately on the first tick, before PerTurnShedChance takes over.
	var int InitialShedChance;

	var bool SetPerTurnShedChance;
	// Percentage chance per tick that the effect wears off early. 0 means it only ends
	// when its turns run out.
	var int PerTurnShedChance;

	var bool SetEffectRank;
	// Precedence among effects of the same kind, used by auras so a stronger source
	// wins over a weaker one.
	var int EffectRank;

	var bool SetEffectHierarchyValue;
	// Decides which effect controls the unit’s animation when several apply at once.
	// The higher value wins.
	var int EffectHierarchyValue;

	var bool SetVisionArcDegreesOverride;
	// Narrows the unit’s sight arc to this many degrees. When two effects both set it,
	// the smaller arc applies.
	var float VisionArcDegreesOverride;

	var bool SetInfiniteDuration;
	// The effect never expires on its own. It then only ends through one of the
	// RemoveWhen... rules below, or by something cleansing it.
	var bool InfiniteDuration;

	var bool SetTickWhenApplied;
	// Ticks once the moment it is applied, rather than waiting for the turn to come
	// round. Damage-over-time effects use this to hurt immediately.
	var bool TickWhenApplied;

	var bool SetCanTickEveryAction;
	// Ticks after every action the target takes rather than once a turn, where the
	// character template supports it.
	var bool CanTickEveryAction;

	var bool SetConvertTurnsToActions;
	// When ticking per action, multiplies NumTurns by the actions available per turn,
	// so a "3 turn" effect still lasts roughly three turns.
	var bool ConvertTurnsToActions;

	var bool SetRemoveWhenSourceDies;
	// Removes the effect when whoever applied it dies. Typical for effects sustained
	// by their caster, such as mind control.
	var bool RemoveWhenSourceDies;

	var bool SetRemoveWhenTargetDies;
	// Removes the effect when the affected unit dies, rather than leaving it on the body.
	var bool RemoveWhenTargetDies;

	var bool SetRemoveWhenSourceDamaged;
	// Removes the effect as soon as the source takes damage, for concentration-style
	// effects broken by being hit.
	var bool RemoveWhenSourceDamaged;

	var bool SetRemoveWhenTargetConcealmentBroken;
	// Removes the effect when the target loses concealment. Used by effects that only
	// make sense while hidden.
	var bool RemoveWhenTargetConcealmentBroken;

	var bool SetPersistThroughTacticalGameEnd;
	// Keeps the effect on the unit after it leaves play, until the mission ends. Needed
	// by effects that must still be read when the mission is scored.
	var bool PersistThroughTacticalGameEnd;

	var bool SetIgnorePlayerCheckOnTick;
	// Ticks regardless of whose turn it is. Normally an effect only ticks on its owner’s turn.
	var bool IgnorePlayerCheckOnTick;

	var bool SetUniqueTarget;
	// Only one target may carry this effect from a given source at a time; applying it
	// elsewhere removes the earlier one.
	var bool UniqueTarget;

	var bool SetStackOnRefresh;
	// Re-applying the effect increments a stack counter instead of simply refreshing
	// its duration, so effects that grow with repetition can read the count.
	var bool StackOnRefresh;

	var bool SetDupeForSameSourceOnly;
	// When checking whether the target already has this effect, only consider copies
	// from the same source. Lets several units apply their own instance.
	var bool DupeForSameSourceOnly;

	var bool SetEffectForcesBleedout;
	// A unit reduced to zero health while under this effect bleeds out instead of dying outright.
	var bool EffectForcesBleedout;

	var bool SetDisplayInUI;
	// Whether the effect appears in the unit’s status UI at all. An effect with no
	// FriendlyName set will show as blank.
	var bool DisplayInUI;

	var bool SetDisplayInSpecialDamageMessageUI;
	// Shows FriendlyName in the damage feedback as a distinct source, so its damage
	// reads separately from the weapon’s.
	var bool DisplayInSpecialDamageMessageUI;

	var bool SetSourceDisplayInUI;
	// As DisplayInUI, but for the unit that applied the effect rather than the one carrying it.
	var bool SourceDisplayInUI;

	var bool SetCustomIdleOverrideAnim;
	// Idle animation to play while the effect is active, taking over the unit’s normal idle.
	var name CustomIdleOverrideAnim;

	var bool SetEffectName;
	// Identifier used when deciding how this effect stacks with others, and the name
	// other effects use to find or remove it.
	var name EffectName;

	var bool SetAbilitySourceName;
	// Which ability this is presented as coming from. Controls how a passive buff is
	// coloured in the HUD.
	var name AbilitySourceName;

	var bool SetEffectAppliedEventName;
	// Event fired when the effect is applied, for listeners and triggered abilities to react to.
	var name EffectAppliedEventName;

	var bool SetChanceEventTriggerName;
	// Event fired when the per-turn shed-chance roll succeeds.
	var name ChanceEventTriggerName;

	var bool SetVFXSocket;
	// Socket on the unit’s skeleton to attach the particle system to.
	var name VFXSocket;

	var bool SetVFXSocketsArrayName;
	// Named array of sockets to attach the particle system to, for effects that appear
	// in several places at once. Optional.
	var name VFXSocketsArrayName;

	var bool SetFriendlyName;
	// Name shown in the unit’s status UI.
	var string FriendlyName;

	var bool SetFriendlyDescription;
	// Description shown beneath FriendlyName in the status UI.
	var string FriendlyDescription;

	var bool SetIconImage;
	// Path to the status icon shown in the UI.
	var string IconImage;

	var bool SetSourceFriendlyName;
	// Name shown on the unit that applied the effect, as opposed to the one carrying it.
	var string SourceFriendlyName;

	var bool SetSourceFriendlyDescription;
	// Description shown on the applying unit.
	var string SourceFriendlyDescription;

	var bool SetSourceIconLabel;
	// Short label drawn on the applying unit’s icon.
	var string SourceIconLabel;

	var bool SetStatusIcon;
	// Path to the small status icon used in condensed UI, alongside IconImage.
	var string StatusIcon;

	var bool SetVFXTemplateName;
	// Particle system played on the unit for as long as the effect lasts.
	var string VFXTemplateName;

	var bool SetPersistentPerkName;
	// Perk effect played on the unit while this effect is active.
	var string PersistentPerkName;

	// X2Effect_ApplyWeaponDamage
	var bool SetExplosiveDamage;
	// Counts the damage as explosive, so explosive-specific rules such as Blast Padding apply.
	var bool ExplosiveDamage;

	var bool SetIgnoreBaseDamage;
	// Leave out the weapon's base damage; only the effect's own damage and tagged extra damage apply.
	var bool IgnoreBaseDamage;

	var bool SetDamageTag;
	// Tag selecting one of the weapon's ExtraDamage entries and the upgrade bonus damage with the same tag.
	var name DamageTag;

	var bool SetAlwaysKillsCivilians;
	// Civilian targets die outright regardless of the damage rolled.
	var bool AlwaysKillsCivilians;

	var bool SetApplyWorldEffectsForEachTargetLocation;
	// Apply the ability's world effects at every target location instead of once.
	var bool ApplyWorldEffectsForEachTargetLocation;

	var bool SetAllowFreeKill;
	// Let free-kill weapon upgrades, such as the Repeater, trigger on this damage.
	var bool AllowFreeKill;

	var bool SetAllowWeaponUpgrade;
	// Let weapon upgrades add their bonus damage.
	var bool AllowWeaponUpgrade;

	var bool SetBypassShields;
	// Damage ignores shield HP and goes straight to health.
	var bool BypassShields;

	var bool SetIgnoreArmor;
	// Damage ignores armor.
	var bool IgnoreArmor;

	var bool SetBypassSustainEffects;
	// Damage ignores sustain effects that would otherwise keep the unit alive.
	var bool BypassSustainEffects;

	var bool SetEnvironmentalDamageAmount;
	// Environmental damage dealt to terrain and cover.
	var int EnvironmentalDamageAmount;

	// Damage the effect adds on its own, on top of the weapon: Damage, Spread, Crit, Pierce, Shred, Rupture, PlusOne, DamageType and Tag.
	var WeaponDamageValueEdit WeaponDamageValue;

	// X2Effect_PersistentStatChange
	var EStatChangeMode StatChangeMode;
	// Stat changes applied while the effect lasts, merged by StatType.
	var array<StatChangeEdit> StatChange;

	var bool SetCHLForceReapplyOnRefresh;
	// Re-apply the stat changes when the effect is refreshed. Community Highlander field.
	var bool CHLForceReapplyOnRefresh;

	// X2AbilityEffectsEditor_DamageImmunity
	// Maps to X2Effect_DamageImmunity.ImmueTypesAreInclusive (typo is Firaxis's)
	var bool SetImmuneTypesAreInclusive;
	// true: immune to the listed damage types only. false: immune to every damage type except the listed ones.
	var bool ImmuneTypesAreInclusive;

	var bool SetRemoveAfterAttackCount;
	// Remove the effect after this many attacks against the unit. 0 keeps it.
	var int RemoveAfterAttackCount;

	var ENameArrayEditMode ImmuneTypesMode;
	// Damage types the immunity covers, or excludes when ImmuneTypesAreInclusive is false.
	var array<name> ImmuneTypes;

	// X2Effect_GrantActionPoints
	var bool SetNumActionPoints;
	// Action points granted.
	var int NumActionPoints;

	var bool SetPointType;
	// Type of action point granted, e.g. standard or move.
	var name PointType;

	var bool SetApplyOnlyWhenOut;
	// Grant only when the unit has no standard action points left.
	var bool ApplyOnlyWhenOut;

	var bool SetSelectUnit;
	// Select the unit in the tactical UI once the points are granted.
	var bool SelectUnit;

	var ENameArrayEditMode SkipWithEffectMode;
	// Effects that, when present on the unit, skip the grant.
	var array<name> SkipWithEffect;

	// X2Effect_GrantActionPointsWithRecord (merged by UnitValueName)
	var ENameArrayEditMode RecordUnitValueWithGrantMode;
	// Unit values that accumulate the action points granted, each with its cleanup rule. Merge updates the entry with the same UnitValueName or adds it.
	var array<RecordData> RecordUnitValueWithGrant;

	// X2Effect_RemoveEffects
	var ENameArrayEditMode EffectNamesToRemoveMode;
	// Effect names removed from the target.
	var array<name> EffectNamesToRemove;

	var bool SetCleanse;
	// Remove the effects as a cleanse, so whatever they do on wearing off does not trigger.
	var bool Cleanse;

	var bool SetCheckSource;
	// Match effects whose source is this effect's target, instead of effects whose target it is.
	var bool CheckSource;

	var bool SetDoNotVisualize;
	// Skip the removal visualization, for when another RemoveEffects on the ability already shows it.
	var bool DoNotVisualize;

	// X2Effect_SetUnitValue
	var bool SetUnitName;
	// Unit value written.
	var name UnitName;

	var bool SetNewValueToSet;
	// Value written to the unit value.
	var float NewValueToSet;

	var bool SetCleanupType;
	// When the unit value is cleared: eCleanup_BeginTurn, eCleanup_BeginTactical, eCleanup_Never or eCleanup_BeginTacticalChain.
	var EUnitValueCleanup CleanupType;

	// X2Effect_BonusArmor
	var bool SetArmorMitigationAmount;
	// Armor points granted while the effect lasts.
	var int ArmorMitigationAmount;

	// X2Effect_Stunned
	var bool SetStunLevel;
	// Action points the stun takes away.
	var int StunLevel;

	var bool SetSkipAnimation;
	// Skip the stun animations.
	var bool SkipAnimation;

	var bool SetStunStartAnimName;
	// Animation played when the stun starts, if the unit can play it.
	var name StunStartAnimName;

	var bool SetStunStopAnimName;
	// Animation played when the stun ends.
	var name StunStopAnimName;

	var bool SetStunnedTriggerName;
	// Event fired when the unit is stunned.
	var name StunnedTriggerName;

	// X2Effect_Sustained
	var bool SetSustainedAbilityName;
	// Ability on the source that is fired again once a full turn completes, to keep the effect going.
	var name SustainedAbilityName;

	var bool SetFragileAmount;
	// Damage the source may take in a full turn before the effect breaks. 0 never breaks it.
	var int FragileAmount;

	var ENameArrayEditMode EffectsToRemoveFromSourceMode;
	// Effects removed from the source when this effect ends.
	var array<name> EffectsToRemoveFromSource;

	var ENameArrayEditMode EffectsToRemoveFromTargetMode;
	// Effects removed from the target when this effect ends.
	var array<name> EffectsToRemoveFromTarget;

	var ENameArrayEditMode RegisterAdditionalEventsLikeImpairMode;
	// Extra events on the source that end the effect as if the source had become impaired.
	var array<name> RegisterAdditionalEventsLikeImpair;

	// X2Effect_Vanish
	var bool SetReasonNotVisible;
	// Visibility tag given as the reason the vanished unit cannot be seen.
	var name ReasonNotVisible;

	var bool SetVanishRevealAdditiveAnimName;
	// Additive animation played on reveal when VanishRevealAnimName is empty.
	var name VanishRevealAdditiveAnimName;

	var bool SetVanishRevealAnimName;
	// Animation played when the unit is revealed.
	var name VanishRevealAnimName;

	var bool SetVanishSyncAnimName;
	// Additive animation played when the vanished state is visualized from a save.
	var name VanishSyncAnimName;

	// X2Effect_ReserveActionPoints
	var bool SetReserveType;
	// Type of action point reserved.
	var name ReserveType;

	var bool SetNumPoints;
	// Number of action points reserved.
	var int NumPoints;

	// X2Effect_CoveringFire
	var bool SetAbilityToActivate;
	// Ability fired when the covering fire check matches.
	var name AbilityToActivate;

	var bool SetGrantActionPoint;
	// Reserve action point given to the covering unit when the check matches.
	var name GrantActionPoint;

	var bool SetMaxPointsPerTurn;
	// Most times per turn the action point can be granted. 0 or less removes the limit.
	var int MaxPointsPerTurn;

	var bool SetDirectAttackOnly;
	// Only match when the unit carrying the effect is attacked directly.
	var bool DirectAttackOnly;

	var bool SetPreEmptiveFire;
	// Fire before the attacker's shot resolves instead of after it.
	var bool PreEmptiveFire;

	var bool SetOnlyDuringEnemyTurn;
	// Only fire during the enemy turn.
	var bool OnlyDuringEnemyTurn;

	var bool SetUseMultiTargets;
	// Fire the ability at the covering unit itself and hit its multi-targets, instead of retaliating at the attacker.
	var bool UseMultiTargets;

	var bool SetOnlyWhenAttackMisses;
	// Only fire when the attack missed.
	var bool OnlyWhenAttackMisses;

	var bool SetSelfTargeting;
	// The fired ability targets the covering unit itself.
	var bool SelfTargeting;

	var bool SetActivationPercentChance;
	// Percent chance the ability fires when the check matches. 0 always fires.
	var int ActivationPercentChance;

	// X2Effect_PersistentTraversalChange (merged by Traversal)
	var ENameArrayEditMode TraversalChangesMode;
	// Traversal types switched on or off while the effect lasts, merged by Traversal.
	var array<TraversalChange> TraversalChanges;

	// X2Effect_Achilles
	var bool SetToHitMin;
	// Lowest hit chance at which the damage multiplier applies.
	var int ToHitMin;

	// X2Effect_Achilles, X2Effect_AdverseSoldierClasses, X2Effect_Bewildered, X2Effect_Impatient, X2Effect_Nearsighted, X2Effect_Oblivious
	var bool SetDmgMod;
	// Multiplier applied to the damage when the effect's condition is met.
	var float DmgMod;

	// X2Effect_AdverseSoldierClasses
	var ENameArrayEditMode AdverseClassesMode;
	// Soldier classes whose attacks trigger the damage multiplier.
	var array<name> AdverseClasses;

	// X2Effect_AlertTheLost
	var bool SetAlertRangeMeters;
	// Radius in meters within which Lost are alerted.
	var int AlertRangeMeters;

	// X2Effect_Amplify
	var bool SetBonusDamageMult;
	// Fraction of the damage added as bonus.
	var float BonusDamageMult;

	// X2Effect_Amplify
	var bool SetMinBonusDamage;
	// Smallest bonus damage applied, when the fraction comes out lower.
	var int MinBonusDamage;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem1Tile;
	// Particle system path for an acid pool covering a single tile.
	var string AcidParticleSystem1Tile;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem2Tiles;
	// Particle system path for an acid pool covering two tiles.
	var string AcidParticleSystem2Tiles;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem3TilesLine;
	// Particle system path for an acid pool covering three tiles in a line.
	var string AcidParticleSystem3TilesLine;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem3TilesCorner;
	// Particle system path for an acid pool covering three tiles in a corner.
	var string AcidParticleSystem3TilesCorner;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesLine;
	// Particle system path for an acid pool covering four tiles in a line.
	var string AcidParticleSystem4TilesLine;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesSquare;
	// Particle system path for an acid pool covering a 2x2 square.
	var string AcidParticleSystem4TilesSquare;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesL;
	// Particle system path for an acid pool covering four tiles in an L shape.
	var string AcidParticleSystem4TilesL;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesReverseL;
	// Particle system path for an acid pool covering four tiles in a mirrored L shape.
	var string AcidParticleSystem4TilesReverseL;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesT;
	// Particle system path for an acid pool covering four tiles in a T shape (the game's 4pc_Middle).
	var string AcidParticleSystem4TilesT;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesS;
	// Particle system path for an acid pool covering four tiles in an S shape.
	var string AcidParticleSystem4TilesS;

	// X2Effect_ApplyAcidToWorld
	var bool SetAcidParticleSystem4TilesReverseS;
	// Particle system path for an acid pool covering four tiles in a mirrored S shape.
	var string AcidParticleSystem4TilesReverseS;

	// X2Effect_ApplyBlazingPinionsTargetToWorld
	var bool SetOverrideParticleSystem;
	// Particle system path played on the target instead of the default one. Empty keeps the default.
	var string OverrideParticleSystem;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetDamageTypeTemplateName;
	// Damage type of the environmental damage.
	var name DamageTypeTemplateName;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetPlusNumZTiles;
	// Extra tiles of height hit above the affected tile.
	var int PlusNumZTiles;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetUseWeaponEnvironmentalDamage;
	// Use the source weapon's environmental damage instead of EnvironmentalDamageAmount.
	var bool UseWeaponEnvironmentalDamage;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetUseWeaponDamageType;
	// Use the source weapon's damage type instead of DamageTypeTemplateName.
	var bool UseWeaponDamageType;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitSourceTile;
	// Apply the damage at the source's tile.
	var bool HitSourceTile;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitTargetTile;
	// Apply the damage at the target's tile.
	var bool HitTargetTile;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetHitAdjacentDestructibles;
	// Also damage destructibles adjacent to the hit tile along the damage direction.
	var bool HitAdjacentDestructibles;

	// X2Effect_ApplyDirectionalWorldDamage
	var bool SetAllowDestructionOfDamageCauseCover;
	// When a unit caused the damage, allow it to destroy that unit's own cover, which is normally protected.
	var bool AllowDestructionOfDamageCauseCover;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level1;
	// Weight of a level 1 fire when rolling the intensity of new fires; relative to the other two levels.
	var float FireChance_Level1;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level2;
	// Weight of a level 2 fire when rolling the intensity of new fires; relative to the other two levels.
	var float FireChance_Level2;

	// X2Effect_ApplyFireToWorld
	var bool SetFireChance_Level3;
	// Weight of a level 3 fire when rolling the intensity of new fires; relative to the other two levels.
	var float FireChance_Level3;

	// X2Effect_ApplyFireToWorld
	var bool SetUseFireChanceLevel;
	// Roll the fire intensity from the three FireChance weights instead of using the default.
	var bool UseFireChanceLevel;

	// X2Effect_ApplyFireToWorld
	var bool SetDamageFragileOnly;
	// Only damage fragile objects.
	var bool DamageFragileOnly;

	// X2Effect_ApplyFireToWorld
	var bool SetCheckForLOSFromTargetLocation;
	// Only set tiles on fire that are visible from the target location.
	var bool CheckForLOSFromTargetLocation;

	// X2Effect_ApplyMedikitHeal
	var bool SetPerUseHP;
	// HP healed per application.
	var int PerUseHP;

	// X2Effect_ApplyMedikitHeal
	var bool SetIncreasedHealProject;
	// Research that, once completed, switches the heal to IncreasedPerUseHP.
	var name IncreasedHealProject;

	// X2Effect_ApplyMedikitHeal
	var bool SetIncreasedPerUseHP;
	// HP healed per application once IncreasedHealProject is researched.
	var int IncreasedPerUseHP;

	// X2Effect_ApplyPoisonToWorld
	var bool SetPoisonParticleSystem;
	// Particle system path for a poison cloud tile.
	var string PoisonParticleSystem;

	// X2Effect_ApplySmokeToWorld, X2Effect_ApplySmokeGrenadeToWorld
	var bool SetSmokeParticleSystem;
	// Particle system path for a smoke tile.
	var string SmokeParticleSystem;

	// X2Effect_APRounds
	var bool SetPierce;
	// Armor pierced.
	var int Pierce;

	// X2Effect_APRounds, X2Effect_TalonRounds
	var bool SetCritChance;
	// Crit chance added.
	var int CritChance;

	// X2Effect_APRounds, X2Effect_TalonRounds
	var bool SetCritDamage;
	// Crit damage added.
	var int CritDamage;

	// X2Effect_Aura
	var ENameArrayEditMode EventsToUpdateMode;
	// Events that make the aura re-evaluate which units it covers.
	var array<name> EventsToUpdate;

	// X2Effect_Bewildered
	var bool SetNumHitsForMod;
	// Hits taken in the turn before the damage multiplier applies.
	var int NumHitsForMod;

	// X2Effect_BlastPadding
	var bool SetExplosiveDamageReduction;
	// Fraction of explosive damage removed.
	var float ExplosiveDamageReduction;

	// X2Effect_BloodTrail, X2Effect_HuntersInstinctDamage, X2Effect_VolatileMix
	var bool SetBonusDamage;
	// Bonus damage added when the effect's condition is met.
	var int BonusDamage;

	// X2Effect_BondmateAimAdjust
	var bool SetThreatenedBondmateAimBonus;
	// Aim bonus, from bond level 2, against a target that threatens the bondmate.
	var int ThreatenedBondmateAimBonus;

	// X2Effect_BondmateAimAdjust
	var bool SetBondmateTargetAimBonus;
	// Aim bonus, from bond level 3, against a target the bondmate attacked since last turn.
	var int BondmateTargetAimBonus;

	// X2Effect_BondmateAimAdjust
	var bool SetBondmateTargetCritBonus;
	// Crit bonus, from bond level 3, against a target the bondmate attacked since last turn.
	var int BondmateTargetCritBonus;

	// X2Effect_BondmateBleedout
	var bool SetBleedoutDurationAdjustment;
	// Turns added to the bleedout duration.
	var int BleedoutDurationAdjustment;

	// X2Effect_BonusWeaponDamage
	var bool SetBonusDmg;
	// Bonus damage added to the weapon's damage.
	var int BonusDmg;

	// X2Effect_Brutal
	var bool SetWillMod;
	// Change applied to the target's current Will; negative lowers it.
	var int WillMod;

	// X2Effect_CombatStims, X2Effect_Solace
	var ENameArrayEditMode DamageTypeImmunitiesMode;
	// Damage types the affected unit is immune to while the effect lasts.
	var array<name> DamageTypeImmunities;

	// X2Effect_ConditionalDamageModifier
	var bool SetModifyOutgoingDamage;
	// Apply to damage the unit deals.
	var bool ModifyOutgoingDamage;

	// X2Effect_ConditionalDamageModifier
	var bool SetModifyIncomingDamage;
	// Apply to damage the unit takes.
	var bool ModifyIncomingDamage;

	// X2Effect_ConditionalDamageModifier
	var bool SetDamageModifier;
	// Damage multiplier; 1.0 leaves the damage unchanged.
	var float DamageModifier;

	// X2Effect_ConditionalDamageModifier
	var bool SetDamageBonus;
	// Flat damage added after the multiplier.
	var int DamageBonus;

	// X2Effect_DeadeyeDamage
	var bool SetDamageMultiplier;
	// Extra damage as a fraction of the damage being dealt.
	var float DamageMultiplier;

	// X2Effect_DelayedAbilityActivation, X2Effect_FaceMultiRoundTarget, X2Effect_TriggerEvent
	var bool SetTriggerEventName;
	// Event the effect fires.
	var name TriggerEventName;

	// X2Effect_EnableGlobalAbility
	var bool SetGlobalAbility;
	// Global ability switched on for the rest of the battle.
	var name GlobalAbility;

	// X2Effect_Fortress
	var ENameArrayEditMode DamageImmunitiesMode;
	// Damage types the unit is immune to. The game assumes Fire, Acid and Poison are among them.
	var array<name> DamageImmunities;

	// X2Effect_GenerateCover
	var bool SetCoverType;
	// Cover the unit provides to others: none, low or high (ECoverForceFlag).
	var ECoverForceFlag CoverType;

	// X2Effect_GenerateCover
	var bool SetRemoveWhenMoved;
	// Remove the effect when the unit moves.
	var bool RemoveWhenMoved;

	// X2Effect_GenerateCover
	var bool SetRemoveOnOtherActivation;
	// Remove the effect when the unit activates another ability.
	var bool RemoveOnOtherActivation;

	// X2Effect_GetOverHere
	var bool SetOverrideStartAnimName;
	// Animation played on the pulled unit at the start, when set.
	var Name OverrideStartAnimName;

	// X2Effect_GetOverHere
	var bool SetOverrideStopAnimName;
	// Animation played on the pulled unit at the end, when set.
	var Name OverrideStopAnimName;

	// X2Effect_GetOverHere
	var bool SetRequireVisibleTile;
	// Only pull to a neighbouring tile the target can be bound to; otherwise any free neighbouring tile will do.
	var bool RequireVisibleTile;

	// X2Effect_Groundling
	var bool SetHeightBonus;
	// Extra aim an attacker gets when it has height advantage over the affected unit.
	var int HeightBonus;

	// X2Effect_Guardian
	var ENameArrayEditMode AllowedAbilitiesMode;
	// Abilities that can trigger the extra reaction shot.
	var array<name> AllowedAbilities;

	// X2Effect_Guardian
	var bool SetProcChance;
	// Percent chance of the extra reaction shot.
	var int ProcChance;

	// X2Effect_HoloTarget, X2Effect_SmokeGrenade
	var bool SetHitMod;
	// Hit chance modifier applied.
	var int HitMod;

	// X2Effect_HolyWarriorDeath
	var bool SetDelayTimeS;
	// Seconds before the death is visualized.
	var float DelayTimeS;

	// X2Effect_HomingMine
	var bool SetAbilityToTrigger;
	// Ability fired when the mine goes off.
	var name AbilityToTrigger;

	// X2Effect_HuntersInstinctDamage
	var bool SetBonusCritChance;
	// Crit chance added when the effect's condition is met.
	var int BonusCritChance;

	// X2Effect_ImmediateAbilityActivation
	var bool SetAbilityName;
	// Ability fired by the effect.
	var name AbilityName;

	// X2Effect_ImmediateAbilityActivation
	var bool SetActivateAbilityOnTarget;
	// Find and fire the ability on the target instead of the source.
	var bool ActivateAbilityOnTarget;

	// X2Effect_ImmediateAbilityActivation
	var bool SetEffectTargetOnly;
	// Fire only against the effect's target; false fires against every available target.
	var bool EffectTargetOnly;

	// X2Effect_Implacable
	var bool SetImplacableThisTurnValue;
	// Unit value that records Implacable already triggered this turn.
	var name ImplacableThisTurnValue;

	// X2Effect_IncreaseBondmateCohesion
	var bool SetCohesionAmount;
	// Cohesion added between the unit and its bondmate.
	var int CohesionAmount;

	// X2Effect_KineticPlating
	var bool SetShieldPerMiss;
	// Shield HP gained each time an attack misses the unit.
	var int ShieldPerMiss;

	// X2Effect_Knockback
	var bool SetKnockbackDistance;
	// Distance the unit is knocked back, in meters.
	var int KnockbackDistance;

	// X2Effect_Knockback
	var bool SetKnockbackDestroysNonFragile;
	// Let the knocked-back unit destroy non-fragile objects it hits.
	var bool KnockbackDestroysNonFragile;

	// X2Effect_Knockback
	var bool SetOverrideRagdollFinishTimerSec;
	// Seconds before the ragdoll settles. Negative keeps the default.
	var float OverrideRagdollFinishTimerSec;

	// X2Effect_Knockback
	var bool SetOnlyOnDeath;
	// Only knock back units the attack kills.
	var bool OnlyOnDeath;

	// X2Effect_LaserSight
	var bool SetBenefitFromEmpoweredUpgrades;
	// Increase the crit bonus when XCOM has empowered weapon upgrades. Community Highlander field.
	var bool BenefitFromEmpoweredUpgrades;

	// X2Effect_LaserSight
	var bool SetCritBonus;
	// Crit chance added on top of the distance-based bonus.
	var int CritBonus;

	// X2Effect_LifeSteal
	var bool SetLifeAmountMultiplier;
	// Multiplier on the health stolen. 0 leaves the amount unchanged.
	var float LifeAmountMultiplier;

	// X2Effect_MarkValidActivationTiles
	var bool SetAbilityToMark;
	// Ability whose valid activation tiles are marked.
	var name AbilityToMark;

	// X2Effect_MarkValidActivationTiles
	var bool SetOnlyUseTargetLocation;
	// Mark only the target location, ignoring the ability's multi-target area.
	var bool OnlyUseTargetLocation;

	// X2Effect_MarkValidActivationTiles
	var bool SetVisualizeFlagsOnCursor;
	// Show the marked tiles on the targeting cursor.
	var bool VisualizeFlagsOnCursor;

	// X2Effect_MeleeDamageAdjust
	var bool SetDamageMod;
	// Damage added to attacks of the melee damage type.
	var int DamageMod;

	// X2Effect_MeleeDamageAdjust
	var bool SetMeleeDamageTypeName;
	// Damage type that counts as melee for the adjustment.
	var name MeleeDamageTypeName;

	// X2Effect_MimicBeacon
	var ENameArrayEditMode AbilitiesAllowedToHitMode;
	// Abilities that may still target the mimic beacon.
	var array<name> AbilitiesAllowedToHit;

	// X2Effect_MindControl
	var bool SetNumTurnsForAI;
	// Turns the control lasts when an AI player is the controller. 0 uses the effect's normal duration.
	var int NumTurnsForAI;

	// X2Effect_ModifyInitiativeOrder
	var bool SetRemoveGroupFromInitiativeOrder;
	// Remove the unit's group from the initiative order.
	var bool RemoveGroupFromInitiativeOrder;

	// X2Effect_ModifyInitiativeOrder
	var bool SetAddGroupToInitiativeOrder;
	// Add the unit's group to the initiative order.
	var bool AddGroupToInitiativeOrder;

	// X2Effect_ModifyReactionFire
	var bool SetAllowCrit;
	// Allow reaction fire to crit.
	var bool AllowCrit;

	// X2Effect_ModifyReactionFire
	var bool SetReactionModifier;
	// Aim modifier applied to reaction fire.
	var int ReactionModifier;

	// X2Effect_ModifyStatCheckSuccesses (merged by AbilityName)
	var ENameArrayEditMode AdditionalSuccessModifiersMode;
	// Bonus successes added to a stat check made by the named ability, when the checked unit is the ability's source. Merge updates the entry with the same AbilityName or adds it.
	var array<AdditionalSuccessModifier> AdditionalSuccessModifiers;

	// X2Effect_ModifyTemplarFocus
	var bool SetModifyFocus;
	// Focus points added; negative removes them.
	var int ModifyFocus;

	// X2Effect_Needle
	var bool SetArmorPierce;
	// Armor pierced.
	var int ArmorPierce;

	// X2Effect_Obsessed
	var bool SetObsessedTargetValueName;
	// Unit value holding the object ID of the obsessed-over target.
	var Name ObsessedTargetValueName;

	// X2Effect_OverrideDeathAction
	var bool SetDeathActionClass;
	// Qualified class path of the X2Action that replaces the normal death visualization, e.g. XComGame.X2Action_ExplodingUnitDeathAction. Empty removes the override.
	var string DeathActionClass;

	// X2Effect_OverrideDeathAnimOnLoad
	var bool SetOverrideAnimNameOnLoad;
	// Death animation shown for the unit when a save is loaded.
	var name OverrideAnimNameOnLoad;

	// X2Effect_PaleHorse
	var bool SetCritBoostPerKill;
	// Crit chance gained per kill.
	var int CritBoostPerKill;

	// X2Effect_PaleHorse
	var bool SetMaxCritBoost;
	// Cap on the accumulated crit chance.
	var int MaxCritBoost;

	// X2Effect_ParthenogenicPoison, X2Effect_SpawnPsiZombie
	var bool SetAltUnitToSpawnName;
	// Character template spawned instead of the usual one, when set.
	var name AltUnitToSpawnName;

	// X2Effect_PersistentSquadViewer
	var bool SetUseWeaponRadius;
	// Use the source weapon's radius as the sight radius. Requires a source weapon.
	var bool UseWeaponRadius;

	// X2Effect_PersistentSquadViewer
	var bool SetViewRadius;
	// Sight radius of the viewer.
	var float ViewRadius;

	// X2Effect_PersistentSquadViewer
	var bool SetUseSourceLocation;
	// Place the viewer at the source's location rather than the target's.
	var bool UseSourceLocation;

	// X2Effect_PersistentVoidConduit
	var bool SetInitialDamage;
	// Damage dealt when the effect is applied.
	var int InitialDamage;

	// X2Effect_Possessed
	var bool SetWeaponTemplateName;
	// Item template equipped on the possessed unit.
	var name WeaponTemplateName;

	// X2Effect_ReduceCooldowns
	var bool SetAmount;
	// Turns taken off each cooldown.
	var int Amount;

	// X2Effect_ReduceCooldowns
	var bool SetReduceAll;
	// Clear the cooldowns entirely instead of reducing them by Amount.
	var bool ReduceAll;

	// X2Effect_ReduceCooldowns
	var ENameArrayEditMode AbilitiesToTickMode;
	// Abilities whose cooldowns are reduced. Empty means every ability.
	var array<name> AbilitiesToTick;

	// X2Effect_Regeneration
	var bool SetHealAmount;
	// HP healed per tick.
	var int HealAmount;

	// X2Effect_Regeneration
	var bool SetMaxHealAmount;
	// Total HP the effect may heal, tracked in HealthRegeneratedName. 0 removes the cap.
	var int MaxHealAmount;

	// X2Effect_Regeneration
	var bool SetHealthRegeneratedName;
	// Unit value that accumulates the HP healed so far, for the MaxHealAmount cap.
	var name HealthRegeneratedName;

	// X2Effect_Regeneration
	var bool SetEventToTriggerOnHeal;
	// Event fired after each heal.
	var name EventToTriggerOnHeal;

	// X2Effect_RemoteStart
	var bool SetUnitDamageMultiplier;
	// Multiplier on the damage the detonated object deals to units.
	var float UnitDamageMultiplier;

	// X2Effect_RemoteStart
	var bool SetDamageRadiusMultiplier;
	// Multiplier on the detonation's damage radius.
	var float DamageRadiusMultiplier;

	// X2Effect_RemoveEffectsByDamageType
	var ENameArrayEditMode DamageTypesToRemoveMode;
	// Effects carrying any of these damage types are removed.
	var array<name> DamageTypesToRemove;

	// X2Effect_ReserveOverwatchPoints
	var ENameArrayEditMode UseAllPointsWithAbilitiesMode;
	// Abilities that, when the unit has any of them, reserve as many points as were spent instead of NumPoints.
	var array<name> UseAllPointsWithAbilities;

	// X2Effect_RunBehaviorTree, X2Effect_ChryssalidBurrowedAttack
	var bool SetNumActions;
	// Number of behavior tree actions the unit runs.
	var int NumActions;

	// X2Effect_RunBehaviorTree
	var bool SetBehaviorTreeName;
	// Behavior tree run on the unit.
	var name BehaviorTreeName;

	// X2Effect_RunBehaviorTree
	var bool SetInitFromPlayer;
	// Reset the behavior tree variables on each run as if the player turn were starting.
	var bool InitFromPlayer;

	// X2Effect_RunBehaviorTree
	var bool SetSetActionPointCount;
	// Standard action points given to the unit before the tree runs.
	var int SetActionPointCount;

	// X2Effect_Shattered
	var bool SetShatteredTargetValueName;
	// Unit value holding the object ID of the unit that shattered the target.
	var Name ShatteredTargetValueName;

	// X2Effect_SoulSteal
	var bool SetUnitValueToRead;
	// Unit value read to find how much health to steal.
	var name UnitValueToRead;

	// X2Effect_SpawnDestructible
	var bool SetDestructibleArchetype;
	// Archetype path of the destructible actor spawned.
	var string DestructibleArchetype;

	// X2Effect_SpawnDestructible
	var bool SetDestroyOnRemoval;
	// Destroy the spawned actor when the effect is removed.
	var bool DestroyOnRemoval;

	// X2Effect_SpawnDestructible
	var bool SetTargetableBySpawnedTeamOnly;
	// Only the team that spawned the actor can target it.
	var bool TargetableBySpawnedTeamOnly;

	// X2Effect_SpawnPsiZombie
	var bool SetAnimationName;
	// Reanimation animation played on the corpse.
	var name AnimationName;

	// X2Effect_SpawnPsiZombie
	var bool SetStartAnimationMinDelaySec;
	// Shortest delay, in seconds, before the reanimation animation starts.
	var float StartAnimationMinDelaySec;

	// X2Effect_SpawnPsiZombie
	var bool SetStartAnimationMaxDelaySec;
	// Longest delay, in seconds, before the reanimation animation starts.
	var float StartAnimationMaxDelaySec;

	// X2Effect_SpawnShadowbindUnit
	var bool SetShadowbindUnconciousCheckName;
	// Unit value checked to tell whether the shadowbound unit was unconscious.
	var name ShadowbindUnconciousCheckName;

	// X2Effect_SpawnUnit
	var bool SetUnitToSpawnName;
	// Character template of the unit spawned.
	var name UnitToSpawnName;

	// X2Effect_SpawnUnit
	var bool SetClearTileBlockedByTargetUnitFlag;
	// Spawn on the target's own tile.
	var bool ClearTileBlockedByTargetUnitFlag;

	// X2Effect_SpawnUnit
	var bool SetCopyTargetAppearance;
	// Give the spawned unit the target's appearance. Takes precedence over CopySourceAppearance.
	var bool CopyTargetAppearance;

	// X2Effect_SpawnUnit
	var bool SetCopySourceAppearance;
	// Give the spawned unit the source's appearance.
	var bool CopySourceAppearance;

	// X2Effect_SpawnUnit
	var bool SetKnockbackAffectsSpawnLocation;
	// Spawn where the target ended up after knockback rather than where it was hit.
	var bool KnockbackAffectsSpawnLocation;

	// X2Effect_SpawnUnit
	var bool SetAddToSourceGroup;
	// Put the spawned unit in the source's AI group.
	var bool AddToSourceGroup;

	// X2Effect_SpawnUnit
	var bool SetCopyReanimatedFromUnit;
	// Copy the reanimated unit's inventory and abilities too, not just its appearance.
	var bool CopyReanimatedFromUnit;

	// X2Effect_SpawnUnit
	var bool SetCopyReanimatedStatsFromUnit;
	// Copy the reanimated unit's stats.
	var bool CopyReanimatedStatsFromUnit;

	// X2Effect_SpawnUnit
	var bool SetSetProcessedScamperAs;
	// Mark the spawned unit's group as having already scampered, so it does not reveal and scamper on sight.
	var bool SetProcessedScamperAs;

	// X2Effect_Spotted
	var bool SetBecomeUnspotted;
	// Mark the unit as unspotted instead of spotted.
	var bool BecomeUnspotted;

	// X2Effect_Stasis
	var bool SetStunStartAnim;
	// Animation played when stasis starts.
	var name StunStartAnim;

	// X2Effect_Stasis
	var bool SetStunStopAnim;
	// Animation played when stasis ends.
	var name StunStopAnim;

	// X2Effect_Stasis
	var bool SetSkipFlyover;
	// Skip the flyover text.
	var bool SkipFlyover;

	// X2Effect_Stasis
	var bool SetStartAnimBlendTime;
	// Blend time, in seconds, into the start animation.
	var float StartAnimBlendTime;

	// X2Effect_SuperConcealModifier
	var bool SetConcealAmountScalar;
	// Multiplier on the base chance of losing super concealment, added to the modifier.
	var float ConcealAmountScalar;

	// X2Effect_SuperConcealModifier
	var ENameArrayEditMode AbilitiesAffectedFilterMode;
	// Abilities the modifier applies to. Empty means every ability.
	var array<name> AbilitiesAffectedFilter;

	// X2Effect_SuperConcealModifier
	var ENameArrayEditMode RemoveOnAbilityActivationMode;
	// Abilities whose activation removes the effect.
	var array<name> RemoveOnAbilityActivation;

	// X2Effect_SuspendMissionTimer
	var bool SetResumeMissionTimer;
	// Resume the mission timer instead of suspending it.
	var bool ResumeMissionTimer;

	// X2Effect_TalonRounds
	var bool SetAimMod;
	// Aim added.
	var int AimMod;

	// X2Effect_TargetDamageDistanceBonus, X2Effect_TargetDamageTypeBonus
	var bool SetBonusDmgFloat;
	// Bonus damage: a flat amount with MODOP_Addition, or a multiplier on the damage with MODOP_Multiplication.
	var float BonusDmgFloat;

	// X2Effect_TargetDamageDistanceBonus, X2Effect_TargetDamageTypeBonus
	var bool SetBonusModType;
	// How BonusDmgFloat is applied: MODOP_Addition or MODOP_Multiplication.
	var EStatModOp BonusModType;

	// X2Effect_TargetDamageDistanceBonus
	var bool SetWithinTileDistance;
	// Farthest distance to the target, in tiles, at which the bonus applies.
	var int WithinTileDistance;

	// X2Effect_TargetDamageDistanceBonus
	var bool SetPrimaryTargetOnly;
	// Only apply to the attack's primary target.
	var bool PrimaryTargetOnly;

	// X2Effect_TargetDamageTypeBonus
	var ENameArrayEditMode BonusDamageTypesMode;
	// Damage types the bonus applies to.
	var array<name> BonusDamageTypes;

	// X2Effect_ThreatAssessment
	var bool SetImmediateActionPoint;
	// Reserve action point given to the target as soon as the effect is applied.
	var name ImmediateActionPoint;

	// X2Effect_TemplarFocus (merged by position: entry N is focus level N)
	var ENameArrayEditMode FocusLevelsMode;
	// One entry per focus level from level 0: the stat changes, armor mitigation and bonus weapon damage granted at that level. Merge overwrites the level at the same position or appends it.
	var array<FocusLevelModifiers> FocusLevels;

	// X2Effect_ToHitModifier
	var bool SetApplyAsTarget;
	// Apply the modifiers to attacks against the unit rather than attacks it makes.
	var bool ApplyAsTarget;

	// X2Effect_TrackingShotMarkTarget
	var bool SetConeLength;
	// Length of the marked cone from the source to the target.
	var float ConeLength;

	// X2Effect_TrackingShotMarkTarget
	var bool SetConeEndDiameter;
	// Diameter of the marked cone at its far end.
	var float ConeEndDiameter;

	// X2Effect_TriggerEvent
	var bool SetPassTargetAsSource;
	// Fire the event with the target as its source.
	var bool PassTargetAsSource;

	// X2Effect_TurnStartActionPoints
	var bool SetActionPointType;
	// Type of action point added, or removed, at the start of the turn.
	var name ActionPointType;

	// X2Effect_TurnStartActionPoints
	var bool SetActionPointsRemoved;
	// Remove the action points instead of adding them.
	var bool ActionPointsRemoved;

	// X2Effect_VanishingWind
	var bool SetMovingVanishRevealAdditiveAnimName;
	// Additive animation played on reveal when the unit is revealed while moving.
	var name MovingVanishRevealAdditiveAnimName;

	// X2Effect_VoidConduit
	var bool SetDamagePerAction;
	// Damage dealt for each action point stolen.
	var int DamagePerAction;

	// X2Effect_VoidConduit
	var bool SetHealthReturnMod;
	// Fraction of the damage dealt that is returned to the source as health.
	var float HealthReturnMod;

	// X2Effect_WallBreaking
	var bool SetWallBreakingEffectName;
	// Name of the effect on the unit that grants wall breaking.
	var name WallBreakingEffectName;

	// X2Effect_World
	var bool SetCenterTile;
	// Apply the world effect to the centre tile only.
	var bool CenterTile;

	// X2Effect_PersistentStatChangeRestoreDefault
	var ENameArrayEditMode StatTypesToRestoreMode;
	// Stats reset to their default value while the effect lasts.
	var array<ECharStatType> StatTypesToRestore;

	// X2Effect_ConditionalDamageModifier
	var array<ConditionEdit> ApplyDamageModConditions;

	// X2Effect_LethalWeaponDamage
	var array<ConditionEdit> LethalDamageConditions;

	// X2Effect_ToHitModifier
	var array<ConditionEdit> ToHitConditions;

	// X2Effect_ToHitModifier: replace-only - when non-empty, replaces Modifiers entirely
	var array<EffectHitModifier> EffectHitModifiers;

	var array<AECustomProperty> CustomProperties;
};

struct ToHitCalcEdit
{
	// Class name of the to-hit calc to target/instantiate.
	// Empty = edit the template's existing calc in place.
	var string Class;

	// Replace-only: when non-empty, replaces the calc's HitModifiers array entirely
	var array<ShotModifierInfo> HitModifiers;

	// X2AbilityToHitCalc_StandardAim
	var bool SetIndirectFire;
	// Treats the attack as indirect, like a grenade: it always hits, though crit, dodge and armour mitigation still apply.
	var bool IndirectFire;

	var bool SetMeleeAttack;
	// Treats the attack as melee, which ignores cover and applies the intrinsic melee hit bonus.
	var bool MeleeAttack;

	var bool SetReactionFire;
	// Treats the attack as reaction fire, which takes the reaction penalty and forgoes the flanking bonus.
	var bool ReactionFire;

	var bool SetAllowCrit;
	// Whether crits are built into the hit table at all. Turning it off makes the ability incapable of critting.
	var bool AllowCrit;

	var bool SetHitsAreCrits;
	// Converts every successful hit into a crit after the roll is made.
	var bool HitsAreCrits;

	var bool SetMultiTargetOnly;
	// Guarantees success when the ability has no primary target, for abilities that only ever hit multi-targets.
	var bool MultiTargetOnly;

	var bool SetOnlyMultiHitWithSuccess;
	// Multi-target hits only land if the roll succeeded, as with Faceoff.
	var bool OnlyMultiHitWithSuccess;

	var bool SetGuaranteedHit;
	// Always hits, skipping the normal hit modifiers. Armour mitigation still rolls.
	var bool GuaranteedHit;

	var bool SetIgnoreCoverBonus;
	// Ignores the target's high and low cover bonuses.
	var bool IgnoreCoverBonus;

	var bool SetFinalMultiplier;
	// Scales the final hit chance after everything else. Appears in the shot breakdown attributed to the ability.
	var float FinalMultiplier;

	var bool SetBuiltInHitMod;
	// Flat aim modifier the ability always carries.
	var int BuiltInHitMod;

	var bool SetBuiltInCritMod;
	// Flat crit modifier the ability always carries.
	var int BuiltInCritMod;

	// X2AbilityToHitCalc_PercentChance
	var bool SetPercentToHit;
	// Flat percentage chance to hit, ignoring aim entirely. For abilities whose odds are fixed rather than calculated.
	var int PercentToHit;

	var bool SetNoGameStateOnMiss;
	// Produces no game state at all on a miss, so nothing is recorded or visualised.
	var bool NoGameStateOnMiss;

	// X2AbilityToHitCalc_PercentChancePlusFocus
	var bool SetFocusMultiplier;
	// Percentage points added to the hit chance per point of Templar focus.
	var int FocusMultiplier;

	// X2AbilityToHitCalc_PercentChanceWithBuddyZone
	var bool SetPercentToHitInBuddyZone;
	// Replaces PercentToHit when the target is inside the buddy zone.
	var int PercentToHitInBuddyZone;

	// X2AbilityToHitCalc_Hacking
	var bool SetAlwaysSucceed;
	// Makes the hack always succeed.
	var bool AlwaysSucceed;

	// X2AbilityToHitCalc_RollStat, X2AbilityToHitCalc_RollStatTiers
	var bool SetStatToRoll;
	// Which unit stat the roll is made against.
	var ECharStatType StatToRoll;

	var bool SetBaseChance;
	// Base percentage before the stat is taken into account.
	var int BaseChance;

	// X2AbilityToHitCalc_StatCheck
	var bool SetBaseValue;
	// Base value the stat contest is measured against.
	var int BaseValue;

	// X2AbilityToHitCalc_StatCheck_UnitVsUnit
	var bool SetAttackerStat;
	// Attacker's stat in a unit-versus-unit contest.
	var ECharStatType AttackerStat;

	var bool SetDefenderStat;
	// Defender's stat in a unit-versus-unit contest.
	var ECharStatType DefenderStat;

	var array<AECustomProperty> CustomProperties;
};

struct TargetStyleEdit
{
	// Class name of the target style to target/instantiate.
	// Empty = edit the template's existing style in place.
	var string Class;

	// X2AbilityTarget_Single
	var bool SetOnlyIncludeTargetsInsideWeaponRange;
	// Excludes targets beyond the weapon's range from selection.
	var bool OnlyIncludeTargetsInsideWeaponRange;

	var bool SetAllowInteractiveObjects;
	// Lets the ability target interactive objects such as doors and consoles.
	var bool AllowInteractiveObjects;

	var bool SetAllowDestructibleObjects;
	// Lets the ability target destructible scenery.
	var bool AllowDestructibleObjects;

	var bool SetIncludeSelf;
	// Lets the user target itself.
	var bool IncludeSelf;

	var bool SetShowAOE;
	// Draws the area-of-effect preview while aiming.
	var bool ShowAOE;

	// X2AbilityTarget_Cursor
	var bool SetRestrictToWeaponRange;
	// Limits the cursor to the weapon's range.
	var bool RestrictToWeaponRange;

	var bool SetIncreaseWeaponRange;
	// Extra range in tiles beyond the weapon's own, when restricted to weapon range.
	var int IncreaseWeaponRange;

	var bool SetRestrictToSquadsightRange;
	// Limits the cursor to squadsight range rather than the weapon's.
	var bool RestrictToSquadsightRange;

	var bool SetFixedAbilityRange;
	// Fixed range in tiles, ignoring the weapon entirely.
	var int FixedAbilityRange;

	// X2AbilityTarget_MovingMelee
	var bool SetMovementRangeAdjustment;
	// Tiles added to or removed from how far the unit may move to reach a melee target.
	var int MovementRangeAdjustment;

	var array<AECustomProperty> CustomProperties;
};

struct MultiTargetStyleEdit
{
	// Class name of the multi-target style to target/instantiate.
	// Empty = edit the template's existing style in place.
	var string Class;

	// X2AbilityMultiTargetStyle (shared)
	var bool SetAllowSameTarget;
	// Lets the primary target also be picked up as a multi-target.
	var bool AllowSameTarget;

	var bool SetUseSourceWeaponLocation;
	// Measures the area from the shooter's weapon rather than the unit.
	var bool UseSourceWeaponLocation;

	var bool SetNumTargetsRequired;
	// Minimum targets that must be in the area for the ability to be usable.
	var int NumTargetsRequired;

	// X2AbilityMultiTarget_Radius
	var bool SetUseWeaponRadius;
	// Takes the radius from the weapon. TargetRadius is then added on top.
	var bool UseWeaponRadius;

	var bool SetUseWeaponBlockingCoverFlag;
	// Takes the weapon's setting for whether cover blocks the area.
	var bool UseWeaponBlockingCoverFlag;

	var bool SetIgnoreBlockingCover;
	// Lets the area pass through cover that would otherwise block it.
	var bool IgnoreBlockingCover;

	var bool SetTargetRadius;
	// Radius of the area in metres. Added to the weapon's radius when UseWeaponRadius is set.
	var float TargetRadius;

	var bool SetTargetCoveragePercentage;
	// How much of a tile the area must cover before that tile counts as affected.
	var float TargetCoveragePercentage;

	var bool SetAddPrimaryTargetAsMultiTarget;
	// Moves the primary target into the multi-target list, so it is treated as part of the area rather than separately.
	var bool AddPrimaryTargetAsMultiTarget;

	var bool SetAllowDeadMultiTargetUnits;
	// Includes already-dead units in the area.
	var bool AllowDeadMultiTargetUnits;

	var bool SetExcludeSelfAsTargetIfWithinRadius;
	// Leaves the user out of its own area of effect.
	var bool ExcludeSelfAsTargetIfWithinRadius;

	// merged by RequiredAbility
	var ENameArrayEditMode AbilityBonusRadiiMode;
	// Extra radius granted when the unit has a particular ability, merged by
	// RequiredAbility. Lets a perk widen the blast without a separate ability.
	var array<AbilityGrantedBonusRadius> AbilityBonusRadii;

	// X2AbilityMultiTarget_Cone
	var bool SetConeEndDiameter;
	// Width of the cone at its far end, in metres.
	var float ConeEndDiameter;

	var bool SetConeLength;
	// How far the cone reaches, in metres.
	var float ConeLength;

	var bool SetUseWeaponRangeForLength;
	// Takes the cone's length from the weapon's range instead of ConeLength.
	var bool UseWeaponRangeForLength;

	var bool SetLockShooterZ;
	// Restricts the cone to tiles at the shooter's own height, so it does not spread up or down floors.
	var bool LockShooterZ;

	// merged by RequiredAbility
	var ENameArrayEditMode AbilityBonusConesMode;
	// Extra cone length and width granted by a particular ability, merged by RequiredAbility.
	var array<AbilityGrantedBonusCone> AbilityBonusCones;

	// X2AbilityMultiTarget_Line
	var bool SetTileWidthExtension;
	// Extra tiles of width added to the line.
	var int TileWidthExtension;

	var bool SetSightRangeLimited;
	// Stops the line at the limit of sight.
	var bool SightRangeLimited;

	// merged by RequiredAbility
	var ENameArrayEditMode AbilityBonusWidthsMode;
	// Extra line width granted by a particular ability, merged by RequiredAbility.
	var array<AbilityGrantedBonusWidth> AbilityBonusWidths;

	// X2AbilityMultiTarget_Cylinder
	var bool SetTargetHeight;
	// Height of the cylinder in metres.
	var float TargetHeight;

	var bool SetUseOnlyGroundTiles;
	// Restricts the cylinder to ground-level tiles.
	var bool UseOnlyGroundTiles;

	// X2AbilityMultiTarget_BurstFire
	var bool SetNumExtraShots;
	// Additional shots fired at the same target beyond the first.
	var int NumExtraShots;

	// X2AbilityMultiTarget_AllUnits
	var bool SetOnlyAllyOfType;
	// Restricts targeting to allies of this character type.
	var name OnlyAllyOfType;

	var bool SetAcceptFriendlyUnits;
	// Includes friendly units.
	var bool AcceptFriendlyUnits;

	var bool SetAcceptEnemyUnits;
	// Includes hostile units.
	var bool AcceptEnemyUnits;

	var bool SetOnlyAcceptRoboticUnits;
	// Restricts targeting to robotic units.
	var bool OnlyAcceptRoboticUnits;

	var bool SetOnlyAcceptAlienUnits;
	// Restricts targeting to aliens.
	var bool OnlyAcceptAlienUnits;

	var bool SetOnlyAcceptAdventUnits;
	// Restricts targeting to ADVENT units.
	var bool OnlyAcceptAdventUnits;

	var bool SetRandomlySelectOne;
	// Picks a single target at random from everything that qualified.
	var bool RandomlySelectOne;

	var bool SetDontAcceptNeutralUnits;
	// Leaves civilians and other neutrals out.
	var bool DontAcceptNeutralUnits;

	var bool SetRandomChance;
	// Percentage chance each qualifying unit is actually included.
	var int RandomChance;

	var bool SetUseAbilitySourceAsPrimaryTarget;
	// Treats the ability's user as the primary target.
	var bool UseAbilitySourceAsPrimaryTarget;

	// X2AbilityMultiTarget_ClaymoreRadius
	var bool SetClaymoreEnvironmentalDamage;
	// Environmental damage the claymore blast does to scenery.
	var int ClaymoreEnvironmentalDamage;

	var array<AECustomProperty> CustomProperties;
};

struct TriggerEdit
{
	// Class name of the trigger to target/instantiate within Template.AbilityTriggers
	var string Class;

	// How this entry combines with the existing triggers of the array
	var EArrayEditMode Mode;

	// X2AbilityTrigger_UnitPostBeginPlay
	var bool SetPriority;
	// Order this trigger runs in relative to others on the same event. Lower runs first.
	var int Priority;

	// X2AbilityTrigger_EventListener (ListenerData members; EventFn cannot be set from config)
	var bool SetListenerEventID;
	// Event this listener waits for. The handling function can only be assigned in code,
	// so a listener added purely from config never fires - editing an existing one does.
	var name ListenerEventID;

	var bool SetListenerDeferral;
	// When the listener runs relative to the event being processed.
	var EventListenerDeferral ListenerDeferral;

	var bool SetListenerFilter;
	// Which units the event is accepted from, such as only the source or only the target.
	var AbilityEventFilter ListenerFilter;

	var bool SetListenerPriority;
	// Order among listeners for the same event.
	var int ListenerPriority;

	// X2AbilityTrigger_Event
	var bool SetMethodName;
	// Method on the observer class that the trigger calls.
	var name MethodName;

	// Class path loaded via DynamicLoadObject
	var bool SetEventObserverClass;
	// Class that observes the event. Loaded by name at runtime.
	var string EventObserverClass;

	var array<AECustomProperty> CustomProperties;
};

struct AbilityEventListenerEdit
{
	var name EventID;

	var bool SetDeferral;
	var EventListenerDeferral Deferral;

	var bool SetFilter;
	var AbilityEventFilter Filter;

	var bool SetPriority;
	var int Priority;
};

struct ExtraEditorRegistration
{
	var string EditorClass;
	var int Priority;
};

struct AbilityEdit
{
	// Ability template name
	var name Ability;

	// When true and no ability named Ability exists, a new template is created and registered before the edit is applied.
	var bool Create;

	// Existing ability to deep-copy as the starting point. Empty = blank template built by Preset. If it does not exist, nothing is created.
	var name CloneFrom;

	// Blank creation only: which standard game-state and visualization functions the new ability runs. Ignored when CloneFrom is set.
	var EAbilityCreatePreset Preset;

	var bool SetHostility;
	// Whether the ability is offensive, defensive or neutral. Drives AI targeting and the
	// reticle colour. One of eHostility_Offensive, eHostility_Defensive, eHostility_Neutral.
	var EAbilityHostility Hostility;

	var bool SetConcealmentRule;
	// What happens to the shooter's concealment when the ability is used.
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

	// To-hit calc slots
	var ToHitCalcEdit ToHitCalc;
	var ToHitCalcEdit ToHitOwnerOnMissCalc;

	// Targeting style slots
	var TargetStyleEdit TargetStyle;
	var MultiTargetStyleEdit MultiTargetStyle;

	// Trigger array + event listener edits
	var array<TriggerEdit> Triggers;
	var array<AbilityEventListenerEdit> AbilityEventListenerEdits;

	// --- Template scalars: gameplay ---
	var bool SetCrossClassEligible;
	var bool CrossClassEligible;

	var bool SetIsPassive;
	var bool IsPassive;

	var bool SetUniqueSource;
	var bool UniqueSource;

	var bool SetAllowedByDefault;
	var bool AllowedByDefault;

	var bool SetTriggerChance;
	var float TriggerChance;

	var bool SetSuperConcealmentLoss;
	var int SuperConcealmentLoss;

	var bool SetChosenActivationIncreasePerUse;
	var int ChosenActivationIncreasePerUse;

	var bool SetLostSpawnIncreasePerUse;
	var int LostSpawnIncreasePerUse;

	var bool SetAbilityPointCost;
	var int AbilityPointCost;

	var bool SetDefaultSourceItemSlot;
	var EInventorySlot DefaultSourceItemSlot;

	var bool SetUseThrownGrenadeEffects;
	var bool UseThrownGrenadeEffects;

	var bool SetUseLaunchedGrenadeEffects;
	var bool UseLaunchedGrenadeEffects;

	var bool SetAllowFreeFireWeaponUpgrade;
	var bool AllowFreeFireWeaponUpgrade;

	var bool SetAllowAmmoEffects;
	var bool AllowAmmoEffects;

	var bool SetAllowBonusWeaponEffects;
	var bool AllowBonusWeaponEffects;

	var bool SetSilentAbility;
	var bool SilentAbility;

	var bool SetCannotTeleport;
	var bool CannotTeleport;

	var bool SetPreventsTargetTeleport;
	var bool PreventsTargetTeleport;

	var bool SetFinalizeAbilityName;
	var name FinalizeAbilityName;

	var bool SetCancelAbilityName;
	var name CancelAbilityName;

	var bool SetTwoTurnAttackAbility;
	var name TwoTurnAttackAbility;

	// --- Template scalars: HUD / icons ---
	var bool SetIconImage;
	var string IconImage;

	var bool SetAbilityIconColor;
	var string AbilityIconColor;

	var bool SetAbilityIconBehaviorHUD;
	var EAbilityIconBehavior AbilityIconBehaviorHUD;

	var bool SetShotHUDPriority;
	var int ShotHUDPriority;

	var bool SetDisplayInUITooltip;
	var bool DisplayInUITooltip;

	var bool SetDisplayInUITacticalText;
	var bool DisplayInUITacticalText;

	var bool SetDontDisplayInAbilitySummary;
	var bool DontDisplayInAbilitySummary;

	var bool SetDisplayTargetHitChance;
	var bool DisplayTargetHitChance;

	var bool SetHideOnClassUnlock;
	var bool HideOnClassUnlock;

	var bool SetAbilitySourceName;
	var name AbilitySourceName;

	var bool SetLimitTargetIcons;
	var bool LimitTargetIcons;

	var bool SetBypassAbilityConfirm;
	var bool BypassAbilityConfirm;

	var bool SetUseAmmoAsChargesForHUD;
	var bool UseAmmoAsChargesForHUD;

	var bool SetAmmoAsChargesDivisor;
	var int AmmoAsChargesDivisor;

	var bool SetFriendlyFireWarning;
	var bool FriendlyFireWarning;

	var bool SetFriendlyFireWarningRobotsOnly;
	var bool FriendlyFireWarningRobotsOnly;

	var bool SetCommanderAbility;
	var bool CommanderAbility;

	// --- Template scalars: text ---
	var bool SetFriendlyName;
	// Name shown in the UI. Short text only: the ini cannot carry quotes, commas or parentheses. For prose use a [MyAbility X2AbilityTemplate] section in XComGame.int.
	var string FriendlyName;

	var bool SetLongDescription;
	// Description shown in the ability tooltip and on the promotion screen. Same limits as FriendlyName.
	var string LongDescription;

	var bool SetHelpText;
	// Short help line shown in the tactical HUD tooltip. Same limits as FriendlyName.
	var string HelpText;

	var bool SetFlyOverText;
	// Text of the flyover shown when the ability activates. Same limits as FriendlyName.
	var string FlyOverText;

	// --- Template scalars: targeting and visualization ---
	var bool SetTargetingMethod;
	// Qualified class path of the targeting method, e.g. XComGame.X2TargetingMethod_OverTheShoulder. The class default is X2TargetingMethod_TopDown.
	var string TargetingMethod;

	var bool SetCinescriptCameraType;
	// Cinescript camera played when the ability is visualized, e.g. StandardGunFiring (see DefaultCameras.ini).
	var string CinescriptCameraType;

	var bool SetAbilityConfirmSound;
	// Sound played when the ability is confirmed in the HUD, e.g. TacticalUI_SwordConfirm.
	var string AbilityConfirmSound;

	var bool SetActivationSpeech;
	// Speech line played when the ability activates.
	var name ActivationSpeech;

	var bool SetCustomFireAnim;
	// Animation played instead of the weapon's normal fire animation.
	var name CustomFireAnim;

	var bool SetSkipFireAction;
	// Do not exit cover, fire and re-enter cover when the ability activates.
	var bool SkipFireAction;

	var bool SetShowActivation;
	// Show the ability name over the activating unit when it is used.
	var bool ShowActivation;

	var bool SetSkipMoveStop;
	// Move-then-act abilities only: do not play the stop-moving animation before acting.
	var bool SkipMoveStop;

	var bool SetFrameEvenWhenUnitIsHidden;
	// Frame the camera on the source unit when the ability is used even if the unit is hidden in the fog.
	var bool FrameEvenWhenUnitIsHidden;

	// --- Template name arrays ---
	var ENameArrayEditMode AssociatedPassivesMode;
	var array<name> AssociatedPassives;

	var ENameArrayEditMode PostActivationEventsMode;
	var array<name> PostActivationEvents;

	var ENameArrayEditMode HideIfAvailableMode;
	var array<name> HideIfAvailable;
};

