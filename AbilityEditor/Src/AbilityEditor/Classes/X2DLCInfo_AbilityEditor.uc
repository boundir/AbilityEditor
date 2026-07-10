class X2DLCInfo_AbilityEditor extends X2DownloadableContentInfo config(Engine);

var config bool EnableTrace;
var config bool EnableDebug;
var config(AbilityEditor) array<AbilityEdit> AbilityEdits;

var const array<class<X2AbilityChargesEditor> > ChargesEditors;
var const array<class<X2AbilityCooldownEditor> > CooldownEditors;
var const array<class<X2AbilityCostEditor> > CostEditors;
var const array<class<X2AbilityConditionEditor> > ConditionEditors;

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
}
