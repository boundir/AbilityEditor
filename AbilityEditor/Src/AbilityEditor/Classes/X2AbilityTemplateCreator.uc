class X2AbilityTemplateCreator extends Object;

static function X2AbilityTemplate CreateBlank(name AbilityName, EAbilityCreatePreset Preset)
{
	local X2AbilityTemplate Template;

	Template = new(None, string(AbilityName)) class'X2AbilityTemplate';
	Template.SetTemplateName(AbilityName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	switch (Preset)
	{
		case eACP_Standard:
			Template.BuildNewGameStateFn = class'X2Ability'.static.TypicalAbility_BuildGameState;
			Template.BuildVisualizationFn = class'X2Ability'.static.TypicalAbility_BuildVisualization;
			Template.BuildInterruptGameStateFn = class'X2Ability'.static.TypicalAbility_BuildInterruptGameState;
			break;

		case eACP_MoveEnd:
			Template.BuildNewGameStateFn = class'X2Ability'.static.TypicalMoveEndAbility_BuildGameState;
			Template.BuildVisualizationFn = class'X2Ability'.static.TypicalAbility_BuildVisualization;
			Template.BuildInterruptGameStateFn = class'X2Ability'.static.TypicalMoveEndAbility_BuildInterruptGameState;
			break;

		case eACP_Passive:
			Template.BuildNewGameStateFn = class'X2Ability'.static.TypicalAbility_BuildGameState;
			Template.bIsPassive = true;
			Template.Hostility = eHostility_Neutral;
			Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
			Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_DeadEye';
			Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
			Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');
			Report(AbilityName, "preset eACP_Passive set ToHitCalc to X2AbilityToHitCalc_DeadEye, TargetStyle to X2AbilityTarget_Self and added an X2AbilityTrigger_UnitPostBeginPlay trigger");
			break;
	}

	return Template;
}

static function X2AbilityTemplate CreateClone(name AbilityName, X2AbilityTemplate Source)
{
	local X2AbilityTemplate Template;

	Template = new(None, string(AbilityName)) class'X2AbilityTemplate' (Source);
	Template.SetTemplateName(AbilityName);

	if (Template.bShouldCreateDifficultyVariants)
	{
		Report(AbilityName, "source" @ string(Source.DataName) @ "creates difficulty variants; the copy cannot, it is created after variants are made");
		Template.bShouldCreateDifficultyVariants = false;
	}

	class'X2AbilityEditor_Cloner'.static.DetachTemplate(Template);

	return Template;
}

// Logs everything ValidateTemplate will reject.
static function bool PreValidate(X2AbilityTemplate Template, name AbilityName)
{
	local X2AbilityTemplateManager AbilityManager;
	local string Error;
	local bool Valid;
	local int i;

	if (Template == none)
	{
		return false;
	}

	Valid = true;
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (Template.AbilityTargetStyle == none)
	{
		Report(AbilityName, "has no TargetStyle; the game will RedScreen it at validation. Add TargetStyle=(Class=\"X2AbilityTarget_Single\") or another target style");
		Valid = false;
	}

	if (Template.AbilityTriggers.Length == 0)
	{
		Report(AbilityName, "has no Triggers; the game will RedScreen it at validation. Add Triggers=((Class=\"X2AbilityTrigger_PlayerInput\", Mode=eAEM_Merge))");
		Valid = false;
	}

	for (i = 0; i < Template.AbilityTriggers.Length; ++i)
	{
		if (Template.AbilityTriggers[i].IsA('X2AbilityTrigger_PlayerInput') && Template.BuildVisualizationFn == none)
		{
			Report(AbilityName, "is player-activated but has no visualization function; use Preset=eACP_Standard instead of eACP_Passive");
			Valid = false;
			break;
		}
	}

	if (Template.BuildNewGameStateFn == none)
	{
		Report(AbilityName, "has no BuildNewGameStateFn; the game will RedScreen it at validation");
		Valid = false;
	}

	for (i = 0; i < Template.AdditionalAbilities.Length; ++i)
	{
		if (AbilityManager.FindAbilityTemplate(Template.AdditionalAbilities[i]) == none)
		{
			Report(AbilityName, "AdditionalAbilities names an ability that does not exist:" @ string(Template.AdditionalAbilities[i]));
			Valid = false;
		}
	}

	for (i = 0; i < Template.OverrideAbilities.Length; ++i)
	{
		if (AbilityManager.FindAbilityTemplate(Template.OverrideAbilities[i]) == none)
		{
			Report(AbilityName, "OverrideAbilities names an ability that does not exist:" @ string(Template.OverrideAbilities[i]));
			Valid = false;
		}
	}

	if (Template.AbilityToHitCalc == none)
	{
		Report(AbilityName, "has no ToHitCalc; activating it will fail. Add ToHitCalc=(Class=\"X2AbilityToHitCalc_StandardAim\") or another calc");
	}

	if (!Template.ValidateTemplate(Error))
	{
		Report(AbilityName, "will fail the game's validation:" @ Error);
		Valid = false;
	}

	return Valid;
}

static function Report(name AbilityName, string Message)
{
	`log("AbilityEdit:" @ string(AbilityName) @ Message, class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
}
