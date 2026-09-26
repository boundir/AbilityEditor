class X2DLCInfo_AbilityEditor extends X2DownloadableContentInfo config(Engine);

var config bool EnableTrace;
var config bool EnableDebug;
var config(AbilityEditor) array<AbilityEdit> AbilityEdits;

var const array<class<X2AbilityChargesEditor> > ChargesEditors;
var const array<class<X2AbilityCooldownEditor> > CooldownEditors;
var const array<class<X2AbilityCostEditor> > CostEditors;
var const array<class<X2AbilityConditionEditor> > ConditionEditors;
var const array<class<X2AbilityEffectsEditor> > EffectsEditors;
var const array<class<X2AbilityToHitCalcEditor> > ToHitCalcEditors;
var const array<class<X2AbilityTargetStyleEditor> > TargetStyleEditors;
var const array<class<X2AbilityMultiTargetStyleEditor> > MultiTargetStyleEditors;
var const array<class<X2AbilityTriggerEditor> > TriggerEditors;

// Bridge-mod registration: other mods append editor classes here from their own config.
// Extras are dispatched BEFORE the built-in editors, sorted by Priority (descending).
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraEffectsEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraConditionEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraCostEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraCooldownEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraChargesEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraToHitCalcEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraTargetStyleEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraMultiTargetStyleEditors;
var config(AbilityEditor) array<ExtraEditorRegistration> ExtraTriggerEditors;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate Template;
	local AbilityEdit AbilityEdit;
	local int i;

	// Keep v1 alive
	class'OPTC_Abilities'.static.EditAbilityTemplates();

	ResolveExtraEditors();

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	for (i = 0; i < default.AbilityEdits.Length; ++i)
	{
		AbilityEdit = default.AbilityEdits[i];

		Template = AbilityManager.FindAbilityTemplate(AbilityEdit.Ability);

		if (Template == none)
		{
			`log("AbilityEdit: Ability not found:" @ AbilityEdit.Ability, default.EnableDebug, 'AbilityEditor');
			continue;
		}

		ApplyAbilityEdit(Template, AbilityEdit);
	}
}

// Sorts the Extra*Editors config registrations (bridge mods) by Priority descending and
// logs any class that fails to load. Dispatchers resolve the classes on demand.
static function ResolveExtraEditors()
{
	default.ExtraEffectsEditors = SortRegistrations(default.ExtraEffectsEditors);
	ValidateRegistrations(default.ExtraEffectsEditors);

	default.ExtraConditionEditors = SortRegistrations(default.ExtraConditionEditors);
	ValidateRegistrations(default.ExtraConditionEditors);

	default.ExtraCostEditors = SortRegistrations(default.ExtraCostEditors);
	ValidateRegistrations(default.ExtraCostEditors);

	default.ExtraCooldownEditors = SortRegistrations(default.ExtraCooldownEditors);
	ValidateRegistrations(default.ExtraCooldownEditors);

	default.ExtraChargesEditors = SortRegistrations(default.ExtraChargesEditors);
	ValidateRegistrations(default.ExtraChargesEditors);

	default.ExtraToHitCalcEditors = SortRegistrations(default.ExtraToHitCalcEditors);
	ValidateRegistrations(default.ExtraToHitCalcEditors);

	default.ExtraTargetStyleEditors = SortRegistrations(default.ExtraTargetStyleEditors);
	ValidateRegistrations(default.ExtraTargetStyleEditors);

	default.ExtraMultiTargetStyleEditors = SortRegistrations(default.ExtraMultiTargetStyleEditors);
	ValidateRegistrations(default.ExtraMultiTargetStyleEditors);

	default.ExtraTriggerEditors = SortRegistrations(default.ExtraTriggerEditors);
	ValidateRegistrations(default.ExtraTriggerEditors);
}

static function ValidateRegistrations(array<ExtraEditorRegistration> Registrations)
{
	local int i;

	for (i = 0; i < Registrations.Length; ++i)
	{
		LoadEditorClass(Registrations[i].EditorClass);
	}
}
static function array<ExtraEditorRegistration> SortRegistrations(array<ExtraEditorRegistration> Registrations)
{
	local array<ExtraEditorRegistration> Sorted;
	local int i, j;

	for (i = 0; i < Registrations.Length; ++i)
	{
		for (j = 0; j < Sorted.Length; ++j)
		{
			if (Registrations[i].Priority > Sorted[j].Priority)
			{
				break;
			}
		}
		Sorted.InsertItem(j, Registrations[i]);
	}

	return Sorted;
}

static function class<Object> LoadEditorClass(string ClassName)
{
	local class<Object> EditorClass;

	EditorClass = class<Object>(DynamicLoadObject(ClassName, class'Class'));

	if (EditorClass == none)
	{
		`log("AbilityEdit: Failed to load extra editor class:" @ ClassName, default.EnableDebug, 'AbilityEditor');
	}

	return EditorClass;
}

static function ApplyAbilityEdit(X2AbilityTemplate Template, AbilityEdit AbilityEdit)
{
	local int i;

	class'X2AbilityTemplateEditor'.static.ApplyTemplateEdit(Template, AbilityEdit);

	class'X2AbilityChargesEditor_Helper'.static.ApplyChargesEdit(Template, AbilityEdit.Charges);
	class'X2AbilityCooldownEditor_Helper'.static.ApplyCooldownEdit(Template, AbilityEdit.Cooldown);
	class'X2AbilityCostEditor_Helper'.static.ApplyCostEdit(Template, AbilityEdit);

	for (i = 0; i < AbilityEdit.Effects.Length; ++i)
	{
		class'X2AbilityEffectsEditor_Helper'.static.ApplyEffectEdit(Template, AbilityEdit.Effects[i]);
	}

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		Template.DataName,
		"Template.AbilityShooterConditions",
		Template.AbilityShooterConditions,
		AbilityEdit.ShooterConditions
	);

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		Template.DataName,
		"Template.AbilityTargetConditions",
		Template.AbilityTargetConditions,
		AbilityEdit.TargetConditions
	);

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		Template.DataName,
		"Template.AbilityMultiTargetConditions",
		Template.AbilityMultiTargetConditions,
		AbilityEdit.MultiTargetConditions
	);

	class'X2AbilityToHitCalcEditor_Helper'.static.ApplyToHitCalcEdit(Template, AbilityEdit.ToHitCalc);
	class'X2AbilityToHitCalcEditor_Helper'.static.ApplyToHitOwnerOnMissCalcEdit(Template, AbilityEdit.ToHitOwnerOnMissCalc);
	class'X2AbilityTargetStyleEditor_Helper'.static.ApplyTargetStyleEdit(Template, AbilityEdit.TargetStyle);
	class'X2AbilityMultiTargetStyleEditor_Helper'.static.ApplyMultiTargetStyleEdit(Template, AbilityEdit.MultiTargetStyle);
	class'X2AbilityTriggerEditor_Helper'.static.ApplyTriggerEdits(Template, AbilityEdit.Triggers);
}

defaultproperties
{
	ChargesEditors.Add(class'X2AbilityChargesEditor_CocoonSpawnChryssalid')
	ChargesEditors.Add(class'X2AbilityChargesEditor_GremlinHeal')
	ChargesEditors.Add(class'X2AbilityChargesEditor_RevivalProtocol')
	ChargesEditors.Add(class'X2AbilityChargesEditor_ScanningProtocol')
	ChargesEditors.Add(class'X2AbilityChargesEditor_StasisLance')
	ChargesEditors.Add(class'X2AbilityChargesEditor_Base')

	CooldownEditors.Add(class'X2AbilityCooldownEditor_AidProtocol')
	CooldownEditors.Add(class'X2AbilityCooldownEditor_PerPlayerType')
	CooldownEditors.Add(class'X2AbilityCooldownEditor_LocalAndGlobal')
	CooldownEditors.Add(class'X2AbilityCooldownEditor_Global')
	CooldownEditors.Add(class'X2AbilityCooldownEditor_Rend')
	CooldownEditors.Add(class'X2AbilityCooldownEditor_Base')

	CostEditors.Add(class'X2AbilityCostEditor_Ammo')
	CostEditors.Add(class'X2AbilityCostEditor_Charges')
	CostEditors.Add(class'X2AbilityCostEditor_ConsumeItem')
	CostEditors.Add(class'X2AbilityCostEditor_Focus')
	CostEditors.Add(class'X2AbilityCostEditor_ReserveActionPoints')
	CostEditors.Add(class'X2AbilityCostEditor_HeavyWeaponActionPoints')
	CostEditors.Add(class'X2AbilityCostEditor_QuickdrawActionPoints')
	CostEditors.Add(class'X2AbilityCostEditor_ActionPoints')
	CostEditors.Add(class'X2AbilityCostEditor_Base')

	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitEffectsApplying')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitEffectsOnSource')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitEffectsWithAbilitySource')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitEffectsWithAbilityTarget')
	ConditionEditors.Add(class'X2AbilityConditionEditor_AbilityProperty')
	ConditionEditors.Add(class'X2AbilityConditionEditor_AbilitySourceWeapon')
	ConditionEditors.Add(class'X2AbilityConditionEditor_BattleState')
	ConditionEditors.Add(class'X2AbilityConditionEditor_BerserkerDevastatingPunch')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Bondmate')
	ConditionEditors.Add(class'X2AbilityConditionEditor_DarkEvent')
	ConditionEditors.Add(class'X2AbilityConditionEditor_EverVigilant')
	ConditionEditors.Add(class'X2AbilityConditionEditor_FuseTarget')
	ConditionEditors.Add(class'X2AbilityConditionEditor_GameplayTag')
	ConditionEditors.Add(class'X2AbilityConditionEditor_HackingTarget')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Interactive')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Lootable')
	ConditionEditors.Add(class'X2AbilityConditionEditor_MapProperty')
	ConditionEditors.Add(class'X2AbilityConditionEditor_OnGroundTile')
	ConditionEditors.Add(class'X2AbilityConditionEditor_PanicOnPod')
	ConditionEditors.Add(class'X2AbilityConditionEditor_PlayerTurns')
	ConditionEditors.Add(class'X2AbilityConditionEditor_StasisLanceTarget')
	ConditionEditors.Add(class'X2AbilityConditionEditor_StasisTarget')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Stealth')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnblockedNeighborTile')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitActionPoints')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitAlertStatus')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitEffects')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitImmunities')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitInEvacZone')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitInteractions')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitInventory')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitProperty')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitStatCheck')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitType')
	ConditionEditors.Add(class'X2AbilityConditionEditor_UnitValue')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Visibility')
	ConditionEditors.Add(class'X2AbilityConditionEditor_Base')

	EffectsEditors.Add(class'X2AbilityEffectsEditor_Obsessed')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Shattered')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_VanishingWind')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_KineticPlating')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Vanish')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BlastPadding')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_KillUnit')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ParthenogenicPoison')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PersistentStatChange')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PersistentStatChangeRestoreDefault')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SpawnPsiZombie')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SpawnShadowbindUnit')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ThreatAssessment')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_WallBreaking')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Achilles')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_AdverseSoldierClasses')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Amplify')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ApplyBlazingPinionsTargetToWorld')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ApplyFireToWorld')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_APRounds')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Aura')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Bewildered')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BloodTrail')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BondmateAimAdjust')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BondmateBleedout')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_CombatStims')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BonusArmor')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_BonusWeaponDamage')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ChryssalidBurrowedAttack')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ConditionalDamageModifier')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_CoveringFire')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_DamageImmunity')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_DelayedAbilityActivation')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_FaceMultiRoundTarget')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_GenerateCover')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Groundling')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Guardian')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_HoloTarget')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_HolyWarriorDeath')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_HomingMine')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_HuntersInstinctDamage')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ImmediateAbilityActivation')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Impatient')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Implacable')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_LaserSight')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_MeleeDamageAdjust')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_MimicBeacon')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_MindControl')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ModifyReactionFire')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ModifyStats')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Nearsighted')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Needle')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Oblivious')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_OverrideDeathAnimOnLoad')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PaleHorse')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PersistentSquadViewer')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PersistentTraversalChange')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_PersistentVoidConduit')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Possessed')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Reaper')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Regeneration')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_RemoveEffectsByDamageType')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ReserveOverwatchPoints')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_RunBehaviorTree')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ScanningProtocol')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SmokeGrenade')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Solace')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SpawnDestructible')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SpawnUnit')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Stasis')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Stunned')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SuperConcealModifier')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Sustain')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Sustained')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TalonRounds')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TargetDamageDistanceBonus')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TargetDamageTypeBonus')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ToHitModifier')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TrackingShotMarkTarget')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TurnStartActionPoints')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_VolatileMix')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ApplyDirectionalWorldDamage')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ApplyMedikitHeal')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ApplyWeaponDamage')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Brutal')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_EnableGlobalAbility')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_GetOverHere')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_GrantActionPoints')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_IncreaseBondmateCohesion')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Knockback')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_LifeSteal')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_MarkValidActivationTiles')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ModifyInitiativeOrder')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ModifyTemplarFocus')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_LethalWeaponDamage')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Persistent')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ReduceCooldowns')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_RemoteStart')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_RemoveEffects')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_ReserveActionPoints')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SetUnitValue')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SoulSteal')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Spotted')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_SuspendMissionTimer')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_TriggerEvent')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_VoidConduit')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_World')
	EffectsEditors.Add(class'X2AbilityEffectsEditor_Base')

	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_StatCheck_UnitVsUnit')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_PercentChancePlusFocus')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_PercentChanceWithBuddyZone')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_StandardAim')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_PercentChance')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_Hacking')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_RollStat')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_RollStatTiers')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_StatCheck')
	ToHitCalcEditors.Add(class'X2AbilityToHitCalcEditor_Base')

	TargetStyleEditors.Add(class'X2AbilityTargetStyleEditor_MovingMelee')
	TargetStyleEditors.Add(class'X2AbilityTargetStyleEditor_Single')
	TargetStyleEditors.Add(class'X2AbilityTargetStyleEditor_Cursor')
	TargetStyleEditors.Add(class'X2AbilityTargetStyleEditor_Base')

	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_Cone')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_Cylinder')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_AllUnits')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_ClaymoreRadius')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_Radius')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_Line')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_BurstFire')
	MultiTargetStyleEditors.Add(class'X2AbilityMultiTargetStyleEditor_Base')

	TriggerEditors.Add(class'X2AbilityTriggerEditor_UnitPostBeginPlay')
	TriggerEditors.Add(class'X2AbilityTriggerEditor_EventListener')
	TriggerEditors.Add(class'X2AbilityTriggerEditor_Event')
	TriggerEditors.Add(class'X2AbilityTriggerEditor_Base')
}
