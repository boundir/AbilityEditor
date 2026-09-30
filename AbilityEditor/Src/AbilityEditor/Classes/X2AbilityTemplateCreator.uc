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

	Template.AbilityCooldown = X2AbilityCooldown(CloneObject(Source.AbilityCooldown));
	Template.AbilityCharges = X2AbilityCharges(CloneObject(Source.AbilityCharges));
	Template.AbilityToHitCalc = X2AbilityToHitCalc(CloneObject(Source.AbilityToHitCalc));
	Template.AbilityToHitOwnerOnMissCalc = X2AbilityToHitCalc(CloneObject(Source.AbilityToHitOwnerOnMissCalc));
	Template.AbilityTargetStyle = X2AbilityTargetStyle(CloneObject(Source.AbilityTargetStyle));
	Template.AbilityMultiTargetStyle = X2AbilityMultiTargetStyle(CloneObject(Source.AbilityMultiTargetStyle));
	Template.AbilityPassiveAOEStyle = X2AbilityPassiveAOEStyle(CloneObject(Source.AbilityPassiveAOEStyle));

	CloneCostArray(Template.AbilityCosts);
	CloneTriggerArray(Template.AbilityTriggers);
	CloneConditionArray(Template.AbilityShooterConditions);
	CloneConditionArray(Template.AbilityTargetConditions);
	CloneConditionArray(Template.AbilityMultiTargetConditions);
	CloneEffectArray(Template.AbilityShooterEffects);
	CloneEffectArray(Template.AbilityTargetEffects);
	CloneEffectArray(Template.AbilityMultiTargetEffects);

	return Template;
}

static function Object CloneObject(Object Source)
{
	local class<Object> ObjectClass;

	if (Source == none)
	{
		return none;
	}

	ObjectClass = Source.Class;
	return new(None) ObjectClass (Source);
}

static function CloneCostArray(out array<X2AbilityCost> Costs)
{
	local int i;

	for (i = 0; i < Costs.Length; ++i)
	{
		Costs[i] = X2AbilityCost(CloneObject(Costs[i]));
	}
}

static function CloneTriggerArray(out array<X2AbilityTrigger> Triggers)
{
	local int i;

	for (i = 0; i < Triggers.Length; ++i)
	{
		Triggers[i] = X2AbilityTrigger(CloneObject(Triggers[i]));
	}
}

static function CloneConditionArray(out array<X2Condition> Conditions)
{
	local int i;

	for (i = 0; i < Conditions.Length; ++i)
	{
		Conditions[i] = X2Condition(CloneObject(Conditions[i]));
	}
}

static function CloneEffectArray(out array<X2Effect> Effects)
{
	local int i;

	for (i = 0; i < Effects.Length; ++i)
	{
		Effects[i] = CloneEffect(Effects[i]);
	}
}

// Clones the effect and every object array an editor can write in place, so no edit on the copy reaches the source.
static function X2Effect CloneEffect(X2Effect Source)
{
	local X2Effect Clone;
	local X2Effect_Persistent Persistent;
	local X2Effect_ConditionalDamageModifier ConditionalDamage;
	local X2Effect_ToHitModifier ToHitModifier;
	local X2Effect_LethalWeaponDamage LethalDamage;

	if (Source == none)
	{
		return none;
	}

	Clone = X2Effect(CloneObject(Source));
	CloneConditionArray(Clone.TargetConditions);

	Persistent = X2Effect_Persistent(Clone);

	if (Persistent != none)
	{
		CloneEffectArray(Persistent.ApplyOnTick);
	}

	ConditionalDamage = X2Effect_ConditionalDamageModifier(Clone);

	if (ConditionalDamage != none)
	{
		CloneConditionArray(ConditionalDamage.ApplyDamageModConditions);
	}

	ToHitModifier = X2Effect_ToHitModifier(Clone);

	if (ToHitModifier != none)
	{
		CloneConditionArray(ToHitModifier.ToHitConditions);
	}

	LethalDamage = X2Effect_LethalWeaponDamage(Clone);

	if (LethalDamage != none)
	{
		CloneConditionArray(LethalDamage.LethalDamageConditions);
	}

	return Clone;
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
