class X2AbilityCooldownEditor_Global extends X2AbilityCooldownEditor;

static function bool CanEdit(X2AbilityCooldown AbilityCooldown)
{
	return AbilityCooldown.IsA('X2AbilityCooldown_Global');
}
