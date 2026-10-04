class X2AbilityEditor_Cloner extends Object;

struct CloneMapping
{
	var Object Source;
	var Object Clone;
};

// Gives the template a private copy of every object it references.
static function int DetachTemplate(X2AbilityTemplate Template)
{
	local array<CloneMapping> Seen;

	Template.AbilityCooldown = X2AbilityCooldown(CloneObject(Template.AbilityCooldown, Seen));
	Template.AbilityCharges = X2AbilityCharges(CloneObject(Template.AbilityCharges, Seen));
	Template.AbilityToHitCalc = X2AbilityToHitCalc(CloneObject(Template.AbilityToHitCalc, Seen));
	Template.AbilityToHitOwnerOnMissCalc = X2AbilityToHitCalc(CloneObject(Template.AbilityToHitOwnerOnMissCalc, Seen));
	Template.AbilityTargetStyle = X2AbilityTargetStyle(CloneObject(Template.AbilityTargetStyle, Seen));
	Template.AbilityMultiTargetStyle = X2AbilityMultiTargetStyle(CloneObject(Template.AbilityMultiTargetStyle, Seen));
	Template.AbilityPassiveAOEStyle = X2AbilityPassiveAOEStyle(CloneObject(Template.AbilityPassiveAOEStyle, Seen));

	CloneCostArray(Template.AbilityCosts, Seen);
	CloneTriggerArray(Template.AbilityTriggers, Seen);
	CloneConditionArray(Template.AbilityShooterConditions, Seen);
	CloneConditionArray(Template.AbilityTargetConditions, Seen);
	CloneConditionArray(Template.AbilityMultiTargetConditions, Seen);
	CloneEffectArray(Template.AbilityShooterEffects, Seen);
	CloneEffectArray(Template.AbilityTargetEffects, Seen);
	CloneEffectArray(Template.AbilityMultiTargetEffects, Seen);

	return Seen.Length;
}

static function Object CloneObject(Object Source, out array<CloneMapping> Seen)
{
	local class<Object> ObjectClass;
	local CloneMapping Mapping;
	local Object Existing;

	if (Source == none)
	{
		return none;
	}

	Existing = FindClone(Source, Seen);

	if (Existing != none)
	{
		return Existing;
	}

	ObjectClass = Source.Class;
	Mapping.Source = Source;
	Mapping.Clone = new(None) ObjectClass (Source);
	Seen.AddItem(Mapping);

	return Mapping.Clone;
}

static function Object FindClone(Object Source, const out array<CloneMapping> Seen)
{
	local int i;

	for (i = 0; i < Seen.Length; ++i)
	{
		if (Seen[i].Source == Source)
		{
			return Seen[i].Clone;
		}
	}

	return none;
}

static function CloneCostArray(out array<X2AbilityCost> Costs, out array<CloneMapping> Seen)
{
	local int i;

	for (i = 0; i < Costs.Length; ++i)
	{
		Costs[i] = X2AbilityCost(CloneObject(Costs[i], Seen));
	}
}

static function CloneTriggerArray(out array<X2AbilityTrigger> Triggers, out array<CloneMapping> Seen)
{
	local int i;

	for (i = 0; i < Triggers.Length; ++i)
	{
		Triggers[i] = X2AbilityTrigger(CloneObject(Triggers[i], Seen));
	}
}

static function CloneConditionArray(out array<X2Condition> Conditions, out array<CloneMapping> Seen)
{
	local int i;

	for (i = 0; i < Conditions.Length; ++i)
	{
		Conditions[i] = X2Condition(CloneObject(Conditions[i], Seen));
	}
}

static function CloneEffectArray(out array<X2Effect> Effects, out array<CloneMapping> Seen)
{
	local int i;

	for (i = 0; i < Effects.Length; ++i)
	{
		Effects[i] = CloneEffect(Effects[i], Seen);
	}
}

// Clones the effect and every object array an editor can write, so no edit on the copy reaches the source.
static function X2Effect CloneEffect(X2Effect Source, out array<CloneMapping> Seen)
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

	Clone = X2Effect(FindClone(Source, Seen));

	if (Clone != none)
	{
		return Clone;
	}

	Clone = X2Effect(CloneObject(Source, Seen));
	CloneConditionArray(Clone.TargetConditions, Seen);

	Persistent = X2Effect_Persistent(Clone);

	if (Persistent != none)
	{
		CloneEffectArray(Persistent.ApplyOnTick, Seen);
	}

	ConditionalDamage = X2Effect_ConditionalDamageModifier(Clone);

	if (ConditionalDamage != none)
	{
		CloneConditionArray(ConditionalDamage.ApplyDamageModConditions, Seen);
	}

	ToHitModifier = X2Effect_ToHitModifier(Clone);

	if (ToHitModifier != none)
	{
		CloneConditionArray(ToHitModifier.ToHitConditions, Seen);
	}

	LethalDamage = X2Effect_LethalWeaponDamage(Clone);

	if (LethalDamage != none)
	{
		CloneConditionArray(LethalDamage.LethalDamageConditions, Seen);
	}

	return Clone;
}
