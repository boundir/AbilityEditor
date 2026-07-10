class X2DLCInfo_AbilityEditor extends X2DownloadableContentInfo config(Engine);

var config bool EnableTrace;
var config bool EnableDebug;
var config(AbilityEditor) array<AbilityEdit> AbilityEdits;

var const array<class<X2AbilityChargesEditor> > ChargesEditors;
var const array<class<X2AbilityCooldownEditor> > CooldownEditors;
var const array<class<X2AbilityCostEditor> > CostEditors;
var const array<class<X2AbilityConditionEditor> > ConditionEditors;
var const array<class<X2AbilityEffectsEditor> > EffectsEditors;

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate Template;
	local AbilityEdit AbilityEdit;
	local int i;

	// Keep v1 alive
	class'OPTC_Abilities'.static.EditAbilityTemplates();

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

static function ApplyAbilityEdit(X2AbilityTemplate Template, AbilityEdit AbilityEdit)
{
	local int i;

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

	class'X2AbilityChargesEditor_Helper'.static.ApplyChargesEdit(Template, AbilityEdit.Charges);
	class'X2AbilityCooldownEditor_Helper'.static.ApplyCooldownEdit(Template, AbilityEdit.Cooldown);
	class'X2AbilityCostEditor_Helper'.static.ApplyCostEdit(Template, AbilityEdit);

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

	for (i = 0; i < AbilityEdit.Effects.Length; ++i)
	{
		class'X2AbilityEffectsEditor_Helper'.static.ApplyEffectEdit(Template, AbilityEdit.Effects[i]);
	}
}

defaultproperties
{
	ChargesEditors(0) = class'X2AbilityChargesEditor_CocoonSpawnChryssalid'
	ChargesEditors(1) = class'X2AbilityChargesEditor_GremlinHeal'
	ChargesEditors(2) = class'X2AbilityChargesEditor_RevivalProtocol'
	ChargesEditors(3) = class'X2AbilityChargesEditor_ScanningProtocol'
	ChargesEditors(4) = class'X2AbilityChargesEditor_StasisLance'
	ChargesEditors(5) = class'X2AbilityChargesEditor_Base'

	CooldownEditors(0) = class'X2AbilityCooldownEditor_AidProtocol'
	CooldownEditors(1) = class'X2AbilityCooldownEditor_PerPlayerType'
	CooldownEditors(2) = class'X2AbilityCooldownEditor_LocalAndGlobal'
	CooldownEditors(3) = class'X2AbilityCooldownEditor_Global'
	CooldownEditors(4) = class'X2AbilityCooldownEditor_Rend'
	CooldownEditors(5) = class'X2AbilityCooldownEditor_Base'

	CostEditors(0) = class'X2AbilityCostEditor_Ammo'
	CostEditors(1) = class'X2AbilityCostEditor_Charges'
	CostEditors(2) = class'X2AbilityCostEditor_ConsumeItem'
	CostEditors(3) = class'X2AbilityCostEditor_Focus'
	CostEditors(4) = class'X2AbilityCostEditor_ReserveActionPoints'
	CostEditors(5) = class'X2AbilityCostEditor_HeavyWeaponActionPoints'
	CostEditors(6) = class'X2AbilityCostEditor_QuickdrawActionPoints'
	CostEditors(7) = class'X2AbilityCostEditor_ActionPoints'
	CostEditors(8) = class'X2AbilityCostEditor_Base'

	// X2Condition_UnitEffects subclasses must come before X2Condition_UnitEffects.
	ConditionEditors(0) = class'X2AbilityConditionEditor_UnitEffectsApplying'
	ConditionEditors(1) = class'X2AbilityConditionEditor_UnitEffectsOnSource'
	ConditionEditors(2) = class'X2AbilityConditionEditor_UnitEffectsWithAbilitySource'
	ConditionEditors(3) = class'X2AbilityConditionEditor_UnitEffectsWithAbilityTarget'
	ConditionEditors(4) = class'X2AbilityConditionEditor_AbilityProperty'
	ConditionEditors(5) = class'X2AbilityConditionEditor_AbilitySourceWeapon'
	ConditionEditors(6) = class'X2AbilityConditionEditor_BattleState'
	ConditionEditors(7) = class'X2AbilityConditionEditor_BerserkerDevastatingPunch'
	ConditionEditors(8) = class'X2AbilityConditionEditor_Bondmate'
	ConditionEditors(9) = class'X2AbilityConditionEditor_DarkEvent'
	ConditionEditors(10) = class'X2AbilityConditionEditor_EverVigilant'
	ConditionEditors(11) = class'X2AbilityConditionEditor_FuseTarget'
	ConditionEditors(12) = class'X2AbilityConditionEditor_GameplayTag'
	ConditionEditors(13) = class'X2AbilityConditionEditor_HackingTarget'
	ConditionEditors(14) = class'X2AbilityConditionEditor_Interactive'
	ConditionEditors(15) = class'X2AbilityConditionEditor_Lootable'
	ConditionEditors(16) = class'X2AbilityConditionEditor_MapProperty'
	ConditionEditors(17) = class'X2AbilityConditionEditor_OnGroundTile'
	ConditionEditors(18) = class'X2AbilityConditionEditor_PanicOnPod'
	ConditionEditors(19) = class'X2AbilityConditionEditor_PlayerTurns'
	ConditionEditors(20) = class'X2AbilityConditionEditor_StasisLanceTarget'
	ConditionEditors(21) = class'X2AbilityConditionEditor_StasisTarget'
	ConditionEditors(22) = class'X2AbilityConditionEditor_Stealth'
	ConditionEditors(23) = class'X2AbilityConditionEditor_UnblockedNeighborTile'
	ConditionEditors(24) = class'X2AbilityConditionEditor_UnitActionPoints'
	ConditionEditors(25) = class'X2AbilityConditionEditor_UnitAlertStatus'
	ConditionEditors(26) = class'X2AbilityConditionEditor_UnitEffects'
	ConditionEditors(27) = class'X2AbilityConditionEditor_UnitImmunities'
	ConditionEditors(28) = class'X2AbilityConditionEditor_UnitInEvacZone'
	ConditionEditors(29) = class'X2AbilityConditionEditor_UnitInteractions'
	ConditionEditors(30) = class'X2AbilityConditionEditor_UnitInventory'
	ConditionEditors(31) = class'X2AbilityConditionEditor_UnitProperty'
	ConditionEditors(32) = class'X2AbilityConditionEditor_UnitStatCheck'
	ConditionEditors(33) = class'X2AbilityConditionEditor_UnitType'
	ConditionEditors(34) = class'X2AbilityConditionEditor_UnitValue'
	ConditionEditors(35) = class'X2AbilityConditionEditor_Visibility'
	ConditionEditors(36) = class'X2AbilityConditionEditor_Base'

	// Order matters: first CanEdit match wins, so a class must come before its parents.
	EffectsEditors(0) = class'X2AbilityEffectsEditor_Obsessed'
	EffectsEditors(1) = class'X2AbilityEffectsEditor_Shattered'
	EffectsEditors(2) = class'X2AbilityEffectsEditor_VanishingWind'
	EffectsEditors(3) = class'X2AbilityEffectsEditor_KineticPlating'
	EffectsEditors(4) = class'X2AbilityEffectsEditor_Vanish'
	EffectsEditors(5) = class'X2AbilityEffectsEditor_BlastPadding'
	EffectsEditors(6) = class'X2AbilityEffectsEditor_KillUnit'
	EffectsEditors(7) = class'X2AbilityEffectsEditor_ParthenogenicPoison'
	EffectsEditors(8) = class'X2AbilityEffectsEditor_PersistentStatChange'
	EffectsEditors(9) = class'X2AbilityEffectsEditor_PersistentStatChangeRestoreDefault'
	EffectsEditors(10) = class'X2AbilityEffectsEditor_SpawnPsiZombie'
	EffectsEditors(11) = class'X2AbilityEffectsEditor_SpawnShadowbindUnit'
	EffectsEditors(12) = class'X2AbilityEffectsEditor_ThreatAssessment'
	EffectsEditors(13) = class'X2AbilityEffectsEditor_WallBreaking'
	EffectsEditors(14) = class'X2AbilityEffectsEditor_Achilles'
	EffectsEditors(15) = class'X2AbilityEffectsEditor_AdverseSoldierClasses'
	EffectsEditors(16) = class'X2AbilityEffectsEditor_Amplify'
	EffectsEditors(17) = class'X2AbilityEffectsEditor_ApplyBlazingPinionsTargetToWorld'
	EffectsEditors(18) = class'X2AbilityEffectsEditor_ApplyFireToWorld'
	EffectsEditors(19) = class'X2AbilityEffectsEditor_APRounds'
	EffectsEditors(20) = class'X2AbilityEffectsEditor_Aura'
	EffectsEditors(21) = class'X2AbilityEffectsEditor_Bewildered'
	EffectsEditors(22) = class'X2AbilityEffectsEditor_BloodTrail'
	EffectsEditors(23) = class'X2AbilityEffectsEditor_BonusArmor'
	EffectsEditors(24) = class'X2AbilityEffectsEditor_BonusWeaponDamage'
	EffectsEditors(25) = class'X2AbilityEffectsEditor_ConditionalDamageModifier'
	EffectsEditors(26) = class'X2AbilityEffectsEditor_CoveringFire'
	EffectsEditors(27) = class'X2AbilityEffectsEditor_DamageImmunity'
	EffectsEditors(28) = class'X2AbilityEffectsEditor_DelayedAbilityActivation'
	EffectsEditors(29) = class'X2AbilityEffectsEditor_FaceMultiRoundTarget'
	EffectsEditors(30) = class'X2AbilityEffectsEditor_GenerateCover'
	EffectsEditors(31) = class'X2AbilityEffectsEditor_Groundling'
	EffectsEditors(32) = class'X2AbilityEffectsEditor_Guardian'
	EffectsEditors(33) = class'X2AbilityEffectsEditor_HoloTarget'
	EffectsEditors(34) = class'X2AbilityEffectsEditor_HolyWarriorDeath'
	EffectsEditors(35) = class'X2AbilityEffectsEditor_HomingMine'
	EffectsEditors(36) = class'X2AbilityEffectsEditor_HuntersInstinctDamage'
	EffectsEditors(37) = class'X2AbilityEffectsEditor_ImmediateAbilityActivation'
	EffectsEditors(38) = class'X2AbilityEffectsEditor_Impatient'
	EffectsEditors(39) = class'X2AbilityEffectsEditor_Implacable'
	EffectsEditors(40) = class'X2AbilityEffectsEditor_LaserSight'
	EffectsEditors(41) = class'X2AbilityEffectsEditor_MeleeDamageAdjust'
	EffectsEditors(42) = class'X2AbilityEffectsEditor_MindControl'
	EffectsEditors(43) = class'X2AbilityEffectsEditor_ModifyReactionFire'
	EffectsEditors(44) = class'X2AbilityEffectsEditor_ModifyStats'
	EffectsEditors(45) = class'X2AbilityEffectsEditor_Nearsighted'
	EffectsEditors(46) = class'X2AbilityEffectsEditor_Needle'
	EffectsEditors(47) = class'X2AbilityEffectsEditor_Oblivious'
	EffectsEditors(48) = class'X2AbilityEffectsEditor_OverrideDeathAnimOnLoad'
	EffectsEditors(49) = class'X2AbilityEffectsEditor_PaleHorse'
	EffectsEditors(50) = class'X2AbilityEffectsEditor_PersistentSquadViewer'
	EffectsEditors(51) = class'X2AbilityEffectsEditor_PersistentTraversalChange'
	EffectsEditors(52) = class'X2AbilityEffectsEditor_PersistentVoidConduit'
	EffectsEditors(53) = class'X2AbilityEffectsEditor_Possessed'
	EffectsEditors(54) = class'X2AbilityEffectsEditor_Reaper'
	EffectsEditors(55) = class'X2AbilityEffectsEditor_Regeneration'
	EffectsEditors(56) = class'X2AbilityEffectsEditor_RemoveEffectsByDamageType'
	EffectsEditors(57) = class'X2AbilityEffectsEditor_ReserveOverwatchPoints'
	EffectsEditors(58) = class'X2AbilityEffectsEditor_RunBehaviorTree'
	EffectsEditors(59) = class'X2AbilityEffectsEditor_ScanningProtocol'
	EffectsEditors(60) = class'X2AbilityEffectsEditor_SmokeGrenade'
	EffectsEditors(61) = class'X2AbilityEffectsEditor_SpawnDestructible'
	EffectsEditors(62) = class'X2AbilityEffectsEditor_SpawnUnit'
	EffectsEditors(63) = class'X2AbilityEffectsEditor_Stasis'
	EffectsEditors(64) = class'X2AbilityEffectsEditor_Stunned'
	EffectsEditors(65) = class'X2AbilityEffectsEditor_SuperConcealModifier'
	EffectsEditors(66) = class'X2AbilityEffectsEditor_Sustain'
	EffectsEditors(67) = class'X2AbilityEffectsEditor_Sustained'
	EffectsEditors(68) = class'X2AbilityEffectsEditor_TalonRounds'
	EffectsEditors(69) = class'X2AbilityEffectsEditor_TargetDamageDistanceBonus'
	EffectsEditors(70) = class'X2AbilityEffectsEditor_TargetDamageTypeBonus'
	EffectsEditors(71) = class'X2AbilityEffectsEditor_ToHitModifier'
	EffectsEditors(72) = class'X2AbilityEffectsEditor_TrackingShotMarkTarget'
	EffectsEditors(73) = class'X2AbilityEffectsEditor_TurnStartActionPoints'
	EffectsEditors(74) = class'X2AbilityEffectsEditor_VolatileMix'
	EffectsEditors(75) = class'X2AbilityEffectsEditor_ApplyDirectionalWorldDamage'
	EffectsEditors(76) = class'X2AbilityEffectsEditor_ApplyMedikitHeal'
	EffectsEditors(77) = class'X2AbilityEffectsEditor_ApplyWeaponDamage'
	EffectsEditors(78) = class'X2AbilityEffectsEditor_Brutal'
	EffectsEditors(79) = class'X2AbilityEffectsEditor_EnableGlobalAbility'
	EffectsEditors(80) = class'X2AbilityEffectsEditor_GetOverHere'
	EffectsEditors(81) = class'X2AbilityEffectsEditor_GrantActionPoints'
	EffectsEditors(82) = class'X2AbilityEffectsEditor_IncreaseBondmateCohesion'
	EffectsEditors(83) = class'X2AbilityEffectsEditor_Knockback'
	EffectsEditors(84) = class'X2AbilityEffectsEditor_LifeSteal'
	EffectsEditors(85) = class'X2AbilityEffectsEditor_MarkValidActivationTiles'
	EffectsEditors(86) = class'X2AbilityEffectsEditor_ModifyInitiativeOrder'
	EffectsEditors(87) = class'X2AbilityEffectsEditor_ModifyTemplarFocus'
	EffectsEditors(88) = class'X2AbilityEffectsEditor_LethalWeaponDamage'
	EffectsEditors(89) = class'X2AbilityEffectsEditor_Persistent'
	EffectsEditors(90) = class'X2AbilityEffectsEditor_ReduceCooldowns'
	EffectsEditors(91) = class'X2AbilityEffectsEditor_RemoteStart'
	EffectsEditors(92) = class'X2AbilityEffectsEditor_RemoveEffects'
	EffectsEditors(93) = class'X2AbilityEffectsEditor_ReserveActionPoints'
	EffectsEditors(94) = class'X2AbilityEffectsEditor_SetUnitValue'
	EffectsEditors(95) = class'X2AbilityEffectsEditor_SoulSteal'
	EffectsEditors(96) = class'X2AbilityEffectsEditor_Spotted'
	EffectsEditors(97) = class'X2AbilityEffectsEditor_SuspendMissionTimer'
	EffectsEditors(98) = class'X2AbilityEffectsEditor_TriggerEvent'
	EffectsEditors(99) = class'X2AbilityEffectsEditor_VoidConduit'
	EffectsEditors(100) = class'X2AbilityEffectsEditor_World'
	EffectsEditors(101) = class'X2AbilityEffectsEditor_Base'
}
