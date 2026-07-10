class X2AbilityEffectsEditor extends Object abstract;

static function bool CanEdit(X2Effect Effect);

static function ApplyEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	ApplyBaseEdit(AbilityName, Slot, Effect, EffectEdit);
	ApplyDerivedEdit(AbilityName, Slot, Effect, EffectEdit);
}

static function ApplyBaseEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit EffectEdit
)
{
	if (EffectEdit.SetApplyOnHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyOnHit",
			string(Effect.bApplyOnHit),
			string(EffectEdit.ApplyOnHit)
		);

		Effect.bApplyOnHit = EffectEdit.ApplyOnHit;
	}

	if (EffectEdit.SetApplyOnMiss)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyOnMiss",
			string(Effect.bApplyOnMiss),
			string(EffectEdit.ApplyOnMiss)
		);

		Effect.bApplyOnMiss = EffectEdit.ApplyOnMiss;
	}

	if (EffectEdit.SetApplyChance)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".ApplyChance",
			string(Effect.ApplyChance),
			string(EffectEdit.ApplyChance)
		);

		Effect.ApplyChance = EffectEdit.ApplyChance;
	}

	if (EffectEdit.SetApplyToWorldOnHit)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyToWorldOnHit",
			string(Effect.bApplyToWorldOnHit),
			string(EffectEdit.ApplyToWorldOnHit)
		);

		Effect.bApplyToWorldOnHit = EffectEdit.ApplyToWorldOnHit;
	}

	if (EffectEdit.SetApplyToWorldOnMiss)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bApplyToWorldOnMiss",
			string(Effect.bApplyToWorldOnMiss),
			string(EffectEdit.ApplyToWorldOnMiss)
		);

		Effect.bApplyToWorldOnMiss = EffectEdit.ApplyToWorldOnMiss;
	}

	if (EffectEdit.SetUseSourcePlayerState)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bUseSourcePlayerState",
			string(Effect.bUseSourcePlayerState),
			string(EffectEdit.UseSourcePlayerState)
		);

		Effect.bUseSourcePlayerState = EffectEdit.UseSourcePlayerState;
	}

	if (EffectEdit.SetIsImpairing)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIsImpairing",
			string(Effect.bIsImpairing),
			string(EffectEdit.IsImpairing)
		);

		Effect.bIsImpairing = EffectEdit.IsImpairing;
	}

	if (EffectEdit.SetIsImpairingMomentarily)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bIsImpairingMomentarily",
			string(Effect.bIsImpairingMomentarily),
			string(EffectEdit.IsImpairingMomentarily)
		);

		Effect.bIsImpairingMomentarily = EffectEdit.IsImpairingMomentarily;
	}

	if (EffectEdit.SetBringRemoveVisualizationForward)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bBringRemoveVisualizationForward",
			string(Effect.bBringRemoveVisualizationForward),
			string(EffectEdit.BringRemoveVisualizationForward)
		);

		Effect.bBringRemoveVisualizationForward = EffectEdit.BringRemoveVisualizationForward;
	}

	if (EffectEdit.SetShowImmunity)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bShowImmunity",
			string(Effect.bShowImmunity),
			string(EffectEdit.ShowImmunity)
		);

		Effect.bShowImmunity = EffectEdit.ShowImmunity;
	}

	if (EffectEdit.SetShowImmunityAnyFailure)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bShowImmunityAnyFailure",
			string(Effect.bShowImmunityAnyFailure),
			string(EffectEdit.ShowImmunityAnyFailure)
		);

		Effect.bShowImmunityAnyFailure = EffectEdit.ShowImmunityAnyFailure;
	}

	if (EffectEdit.SetAppliesDamage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bAppliesDamage",
			string(Effect.bAppliesDamage),
			string(EffectEdit.AppliesDamage)
		);

		Effect.bAppliesDamage = EffectEdit.AppliesDamage;
	}

	if (EffectEdit.SetCanBeRedirected)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bCanBeRedirected",
			string(Effect.bCanBeRedirected),
			string(EffectEdit.CanBeRedirected)
		);

		Effect.bCanBeRedirected = EffectEdit.CanBeRedirected;
	}

	if (EffectEdit.SetHideDeathWorldMessage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".bHideDeathWorldMessage",
			string(Effect.bHideDeathWorldMessage),
			string(EffectEdit.HideDeathWorldMessage)
		);

		Effect.bHideDeathWorldMessage = EffectEdit.HideDeathWorldMessage;
	}

	if (EffectEdit.SetMinStatContestResult)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MinStatContestResult",
			string(Effect.MinStatContestResult),
			string(EffectEdit.MinStatContestResult)
		);

		Effect.MinStatContestResult = EffectEdit.MinStatContestResult;
	}

	if (EffectEdit.SetMaxStatContestResult)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".MaxStatContestResult",
			string(Effect.MaxStatContestResult),
			string(EffectEdit.MaxStatContestResult)
		);

		Effect.MaxStatContestResult = EffectEdit.MaxStatContestResult;
	}

	if (EffectEdit.SetDelayVisualizationSec)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".DelayVisualizationSec",
			string(Effect.DelayVisualizationSec),
			string(EffectEdit.DelayVisualizationSec)
		);

		Effect.DelayVisualizationSec = EffectEdit.DelayVisualizationSec;
	}

	if (EffectEdit.SetOverrideMissMessage)
	{
		class'X2AbilityEditor_Logger'.static.LogInfo(
			AbilityName,
			Slot $ ".OverrideMissMessage",
			Effect.OverrideMissMessage,
			EffectEdit.OverrideMissMessage
		);

		Effect.OverrideMissMessage = EffectEdit.OverrideMissMessage;
	}

	class'X2AbilityEditor_Helper'.static.ApplyNameArrayEdit(
		AbilityName,
		Slot $ ".DamageTypes",
		Effect.DamageTypes,
		EffectEdit.DamageTypes,
		EffectEdit.DamageTypesMode
	);

	class'X2AbilityConditionEditor_Helper'.static.ApplyConditionEdits(
		AbilityName,
		Slot $ ".TargetConditions",
		Effect.TargetConditions,
		EffectEdit.TargetConditions
	);
}

static function ApplyDerivedEdit(
	name AbilityName,
	string Slot,
	X2Effect Effect,
	EffectEdit Edit
);
