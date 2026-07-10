class X2AbilityEffectsEditor_PersistentStatChange extends X2AbilityEffectsEditor_ModifyStats;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PersistentStatChange');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PersistentStatChange StatChangeEffect;
	local StatChange StatChange;
	local StatChangeEdit StatChangeEdit;
	local int i, Index;

	// Apply the X2Effect_Persistent-level fields (NumTurns, InfiniteDuration, ...)
	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	StatChangeEffect = X2Effect_PersistentStatChange(Effect);

	if (EffectEdit.SetCHLForceReapplyOnRefresh)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bForceReapplyOnRefresh",
			string(StatChangeEffect.bForceReapplyOnRefresh),
			string(EffectEdit.CHLForceReapplyOnRefresh)
		);

		StatChangeEffect.bForceReapplyOnRefresh = EffectEdit.CHLForceReapplyOnRefresh;
	}

	// Length guard: an empty edit must not clear existing stat changes
	if (EffectEdit.StatChange.Length == 0)
	{
		return;
	}

	if (EffectEdit.StatChangeMode == eSCM_Replace)
	{
		`log(string(AbilityName) @ "stat changes replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
		StatChangeEffect.m_aStatChanges.Length = 0;
	}

	for (i = 0; i < EffectEdit.StatChange.Length; ++i)
	{
		StatChangeEdit = EffectEdit.StatChange[i];

		Index = class'X2AbilityEffectsEditor_Helper'.static.FindStatChangeIndex(
			StatChangeEffect.m_aStatChanges,
			StatChangeEdit.StatType
		);

		if (Index == INDEX_NONE)
		{
			StatChange.StatType = eStat_Invalid;
			StatChange.StatAmount = 0;
			StatChange.ModOp = MODOP_Addition;
			StatChange.ApplicationRule = ECSMAR_Additive;

			Index = StatChangeEffect.m_aStatChanges.Length;
			StatChangeEffect.m_aStatChanges.AddItem(StatChange);
		}

		if (StatChangeEdit.SetStatType)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"m_aStatChanges.NumCharges",
				string(StatChangeEffect.m_aStatChanges[Index].StatType),
				string(StatChangeEdit.StatType)
			);

			StatChangeEffect.m_aStatChanges[Index].StatType = StatChangeEdit.StatType;
		}

		if (StatChangeEdit.SetStatAmount)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"m_aStatChanges.StatAmount",
				string(StatChangeEffect.m_aStatChanges[Index].StatAmount),
				string(StatChangeEdit.StatAmount)
			);

			StatChangeEffect.m_aStatChanges[Index].StatAmount = StatChangeEdit.StatAmount;
		}

		if (StatChangeEdit.SetModOp)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"m_aStatChanges.ModOp",
				string(StatChangeEffect.m_aStatChanges[Index].ModOp),
				string(StatChangeEdit.ModOp)
			);

			StatChangeEffect.m_aStatChanges[Index].ModOp = StatChangeEdit.ModOp;
		}

		if (StatChangeEdit.SetApplicationRule)
		{
			class'X2AbilityEditor_Logger'.static.LogInfo(
				AbilityName,
				"m_aStatChanges.ApplicationRule",
				string(StatChangeEffect.m_aStatChanges[Index].ApplicationRule),
				string(StatChangeEdit.ApplicationRule)
			);

			StatChangeEffect.m_aStatChanges[Index].ApplicationRule = StatChangeEdit.ApplicationRule;
		}
	}
}