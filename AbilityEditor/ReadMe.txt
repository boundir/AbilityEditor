[h1]Description[/h1]

This mod allows you to change how any ability works - base game, DLC or another mod's - from an .ini file. No scripting.

Costs, cooldowns, charges, effects, conditions, hit chance, targeting, triggers and the template's own fields can all be edited. An ability can also be created from config, either as a copy of an existing one or blank.

[h1]Documentation[/h1]

[url=https://boundir.github.io/AbilityEditor/]boundir.github.io/AbilityEditor[/url] - the full field reference for every supported class, guides, and a config builder that writes an entry for you or checks one you paste in.

[h1]Example[/h1]

Slash keeps the turn going:

[code]
[AbilityEditor.X2DLCInfo_AbilityEditor]
+AbilityEdits=( \\
    Ability=SwordSlice, \\
    CostMode=eACEM_Merge, \\
    Costs=( \\
        ( \\
            Class="X2AbilityCost_ActionPoints", \\
            Mode=eACEM_Merge, \\
            SetNumPoints=true, \\
            NumPoints=1, \\
            SetConsumeAllPoints=true, \\
            ConsumeAllPoints=false \\
        ) \\
    ) \\
)
[/code]

[h1]Usage[/h1]

Entries go under [b][AbilityEditor.X2DLCInfo_AbilityEditor][/b] in an [u]XComAbilityEditor.ini[/u]: this mod's own, or better your own small mod so a Workshop update cannot overwrite them. Several mods can contribute entries at once.

[b]Config changes need a cache clear.[/b] Delete [u]Documents\My Games\XCOM2 War of the Chosen\XComGame\Config[/u] after editing any .ini. Skipping this is the most common reason a correct entry seems to do nothing.

[h1]Troubleshooting[/h1]

Set [b]EnableDebug=true[/b] under the same section in [u]XComEngine.ini[/u]. Every applied change is then written to Launch.log under the AbilityEditor tag. If a field is not in that log, it was never applied.

The three usual causes: a stale config cache, a value written without its SetX=true guard, and a Mode left at its default, which replaces rather than merges. The site's troubleshooting page covers the rest.

[h1]Compatibility[/h1]

No dependencies. Mods that build on what this one produces, such as those granting a created ability to units, should declare [b]+RunAfter=AbilityEditor[/b] in their own CHDLCRunOrder section.

The 1.x [AbilityEditor.OPTC_Abilities] keys still work and are documented on the site under Legacy 1.x config.
