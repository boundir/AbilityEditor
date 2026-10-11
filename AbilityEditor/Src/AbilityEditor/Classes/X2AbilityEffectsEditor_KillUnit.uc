class X2AbilityEffectsEditor_KillUnit extends X2AbilityEffectsEditor_OverrideDeathAction;

static function bool CanEdit(X2Effect Effect)
{
	return Effect.IsA('X2Effect_KillUnit');
}
