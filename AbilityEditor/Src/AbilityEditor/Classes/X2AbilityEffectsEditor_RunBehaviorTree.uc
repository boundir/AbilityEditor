class X2AbilityEffectsEditor_RunBehaviorTree extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_RunBehaviorTree');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_RunBehaviorTree RunBehaviorTreeFX;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	RunBehaviorTreeFX = X2Effect_RunBehaviorTree(Effect);

	if (RunBehaviorTreeFX == none)
	{
		return;
	}

	if (EffectEdit.SetNumActions)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".NumActions",
			string(RunBehaviorTreeFX.NumActions),
			string(EffectEdit.NumActions)
		);

		RunBehaviorTreeFX.NumActions = EffectEdit.NumActions;
	}

	if (EffectEdit.SetBehaviorTreeName)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".BehaviorTreeName",
			string(RunBehaviorTreeFX.BehaviorTreeName),
			string(EffectEdit.BehaviorTreeName)
		);

		RunBehaviorTreeFX.BehaviorTreeName = EffectEdit.BehaviorTreeName;
	}

	if (EffectEdit.SetInitFromPlayer)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bInitFromPlayer",
			string(RunBehaviorTreeFX.bInitFromPlayer),
			string(EffectEdit.InitFromPlayer)
		);

		RunBehaviorTreeFX.bInitFromPlayer = EffectEdit.InitFromPlayer;
	}

	if (EffectEdit.SetSetActionPointCount)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".SetActionPointCount",
			string(RunBehaviorTreeFX.SetActionPointCount),
			string(EffectEdit.SetActionPointCount)
		);

		RunBehaviorTreeFX.SetActionPointCount = EffectEdit.SetActionPointCount;
	}
}
