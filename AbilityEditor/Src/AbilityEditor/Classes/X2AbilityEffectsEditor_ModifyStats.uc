class X2AbilityEffectsEditor_ModifyStats extends X2AbilityEffectsEditor_Persistent;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_ModifyStats');
}
