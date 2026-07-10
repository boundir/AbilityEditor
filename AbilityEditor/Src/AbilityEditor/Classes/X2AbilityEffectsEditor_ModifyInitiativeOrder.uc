class X2AbilityEffectsEditor_ModifyInitiativeOrder extends X2AbilityEffectsEditor_Base;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ModifyInitiativeOrder');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_ModifyInitiativeOrder ModifyInitiativeOrderFX;

	ModifyInitiativeOrderFX = X2Effect_ModifyInitiativeOrder(Effect);

	if (ModifyInitiativeOrderFX == none)
	{
		return;
	}

	if (EffectEdit.SetRemoveGroupFromInitiativeOrder)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bRemoveGroupFromInitiativeOrder",
			string(ModifyInitiativeOrderFX.bRemoveGroupFromInitiativeOrder),
			string(EffectEdit.RemoveGroupFromInitiativeOrder)
		);

		ModifyInitiativeOrderFX.bRemoveGroupFromInitiativeOrder = EffectEdit.RemoveGroupFromInitiativeOrder;
	}

	if (EffectEdit.SetAddGroupToInitiativeOrder)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAddGroupToInitiativeOrder",
			string(ModifyInitiativeOrderFX.bAddGroupToInitiativeOrder),
			string(EffectEdit.AddGroupToInitiativeOrder)
		);

		ModifyInitiativeOrderFX.bAddGroupToInitiativeOrder = EffectEdit.AddGroupToInitiativeOrder;
	}
}
