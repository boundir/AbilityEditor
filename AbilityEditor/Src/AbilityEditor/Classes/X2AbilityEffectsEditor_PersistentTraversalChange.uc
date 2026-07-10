class X2AbilityEffectsEditor_PersistentTraversalChange extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_PersistentTraversalChange');
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	local X2Effect_PersistentTraversalChange TraversalEffect;
	local int i, j, Index;

	super.ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);

	TraversalEffect = X2Effect_PersistentTraversalChange(Effect);

	if (TraversalEffect == none)
	{
		return;
	}

	if (EffectEdit.TraversalChanges.Length > 0)
	{
		if (EffectEdit.TraversalChangesMode == eNAEM_Replace)
		{
			`log(string(AbilityName) @ Slot $ ".aTraversalChanges replaced", class'X2DLCInfo_AbilityEditor'.default.EnableDebug, 'AbilityEditor');
			TraversalEffect.aTraversalChanges = EffectEdit.TraversalChanges;
		}
		else if (EffectEdit.TraversalChangesMode == eNAEM_AddOnly)
		{
			if (TraversalEffect.aTraversalChanges.Length == 0)
			{
				TraversalEffect.aTraversalChanges = EffectEdit.TraversalChanges;
			}
		}
		else if (EffectEdit.TraversalChangesMode == eNAEM_Merge)
		{
			for (i = 0; i < EffectEdit.TraversalChanges.Length; ++i)
			{
				Index = INDEX_NONE;
				for (j = 0; j < TraversalEffect.aTraversalChanges.Length; ++j)
				{
					if (TraversalEffect.aTraversalChanges[j].Traversal == EffectEdit.TraversalChanges[i].Traversal)
					{
						Index = j;
						break;
					}
				}

				if (Index == INDEX_NONE)
				{
					TraversalEffect.aTraversalChanges.AddItem(EffectEdit.TraversalChanges[i]);
				}
				else
				{
					TraversalEffect.aTraversalChanges[Index] = EffectEdit.TraversalChanges[i];
				}
			}
		}
		else if (EffectEdit.TraversalChangesMode == eNAEM_Remove)
		{
			for (i = 0; i < EffectEdit.TraversalChanges.Length; ++i)
			{
				for (j = TraversalEffect.aTraversalChanges.Length - 1; j >= 0; --j)
				{
					if (TraversalEffect.aTraversalChanges[j].Traversal == EffectEdit.TraversalChanges[i].Traversal)
					{
						TraversalEffect.aTraversalChanges.Remove(j, 1);
					}
				}
			}
		}
	}
}
