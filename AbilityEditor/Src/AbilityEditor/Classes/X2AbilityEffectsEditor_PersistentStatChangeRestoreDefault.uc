class X2AbilityEffectsEditor_PersistentStatChangeRestoreDefault extends X2AbilityEffectsEditor_ModifyStats;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PersistentStatChangeRestoreDefault');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PersistentStatChangeRestoreDefault RestoreFX;
	local int i, Index;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	RestoreFX = X2Effect_PersistentStatChangeRestoreDefault(Effect);

	if (RestoreFX == none)
	{
		return;
	}

	if (EffectEdit.StatTypesToRestore.Length > 0)
	{
		if (EffectEdit.StatTypesToRestoreMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".StatTypesToRestore replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			RestoreFX.StatTypesToRestore = EffectEdit.StatTypesToRestore;
		}
		else if (EffectEdit.StatTypesToRestoreMode == eNAEM_AddOnly)
		{
			if (RestoreFX.StatTypesToRestore.Length == 0)
			{
				RestoreFX.StatTypesToRestore = EffectEdit.StatTypesToRestore;
			}
		}
		else if (EffectEdit.StatTypesToRestoreMode == eNAEM_Merge)
		{
			for (i = 0; i < EffectEdit.StatTypesToRestore.Length; ++i)
			{
				if (RestoreFX.StatTypesToRestore.Find(EffectEdit.StatTypesToRestore[i]) == INDEX_NONE)
				{
					RestoreFX.StatTypesToRestore.AddItem(EffectEdit.StatTypesToRestore[i]);
				}
			}
		}
		else if (EffectEdit.StatTypesToRestoreMode == eNAEM_Remove)
		{
			for (i = 0; i < EffectEdit.StatTypesToRestore.Length; ++i)
			{
				Index = RestoreFX.StatTypesToRestore.Find(EffectEdit.StatTypesToRestore[i]);

				if (Index != INDEX_NONE)
				{
					RestoreFX.StatTypesToRestore.Remove(Index, 1);
				}
			}
		}
	}
}
