class X2DLCInfo_AbilityEditor extends X2DownloadableContentInfo config(Engine);

var config bool EnableTrace;
var config bool EnableDebug;
var config(AbilityEditor) array<AbilityEdit> AbilityEdits;

var const array<class<X2AbilityChargesEditor> > ChargesEditors;
var const array<class<X2AbilityCooldownEditor> > CooldownEditors;
var const array<class<X2AbilityCostEditor> > CostEditors;

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
}
