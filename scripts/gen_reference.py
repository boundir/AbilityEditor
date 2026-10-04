"""Generate the reference section of the docs site from ``docs/schema.json``.

Run by mkdocs-gen-files at build time; nothing here is committed.
"""

from __future__ import annotations

import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

import mkdocs_gen_files

# mkdocs-gen-files executes these with runpy.run_path, which does not put the script's own
# directory on sys.path, so a plain "import ae_render" would fail.
sys.path.insert(0, str(Path(__file__).resolve().parent))

from ae_render import (  # noqa: E402
    anchor,
    assign_slugs,
    bridge_slug,
    code,
    escape_cell,
    family_slug,
    field_table,
    is_bridge,
    load_schema,
    not_editable_block,
    qualified_class,
    requirements_text,
    table,
)

SCHEMA = load_schema()
SRC = ".scripts/generate-docs.ps1"

SHARED_HEADING = "Shared fields"

BRIDGES: dict[str, dict[str, Any]] = {b["name"]: b for b in SCHEMA.get("bridges", [])}


def own_fields(editor: dict[str, Any]) -> list[dict[str, Any]]:
    """Fields this editor introduces itself, in schema order."""
    return [f for f in editor["fields"] if f.get("origin") == "derived" and not f.get("inheritedFrom")]


def shared_fields(family: dict[str, Any]) -> list[dict[str, Any]]:
    """Fields every editor in the family has, taken from the catch-all.

    The catch-all (`*_Base`) accepts any class, so whatever it exposes is by
    definition available family-wide. Falling back to the widest editor keeps
    this working if a family ever loses its catch-all.
    """
    for editor in family["editors"]:
        if editor.get("catchAll"):
            return editor["fields"]
    if not family["editors"]:
        return []
    return max(family["editors"], key=lambda e: len(e["fields"]))["fields"]


def inherited_groups(editor: dict[str, Any]) -> dict[str, list[dict[str, Any]]]:
    """Inherited fields bucketed by the editor that defines them."""
    groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for field in editor["fields"]:
        source = field.get("inheritedFrom")
        if source:
            groups[source].append(field)
    return groups


def bridge_of(editor: dict[str, Any]) -> dict[str, Any] | None:
    name = editor.get("bridge")
    if not name:
        return None
    return BRIDGES.get(name) or {"name": name, "displayName": name, "requires": {}}


def bridge_page(bridge: dict[str, Any]) -> str:
    return f"bridges/{bridge_slug(bridge['name'])}.md"


def bridge_link(bridge: dict[str, Any], prefix: str = "") -> str:
    return f"[{bridge['displayName']}]({prefix}{bridge_page(bridge)})"


def sort_key(editor: dict[str, Any]) -> str:
    return editor.get("gameClass") or editor["class"]


def write(path: str, body: str) -> None:
    with mkdocs_gen_files.open(path, "w") as handle:
        handle.write(body)
    mkdocs_gen_files.set_edit_path(path, SRC)


# --------------------------------------------------------------------------- #
# Pages
# --------------------------------------------------------------------------- #

def render_family_index(family: dict[str, Any]) -> str:
    shared = shared_fields(family)
    concrete = [e for e in family["editors"] if not e.get("catchAll")]
    slugs = assign_slugs(family)
    has_bridge = any(is_bridge(e) for e in concrete)

    out = [f"# {family['name']}", ""]

    if family.get("intro"):
        out += [family["intro"], ""]

    config_key = family.get("configKey")
    if config_key:
        out += [f"Config key: `{config_key}`. Edit struct: `{family['editStruct']}`.", ""]
    else:
        out += [f"Edit struct: `{family['editStruct']}`.", ""]

    # Dispatch order matters: first match wins, so a class is handled by the first editor in this list that accepts it.
    if family.get("dispatchOrder"):
        chain = []
        for cls in family["dispatchOrder"]:
            editor = next((e for e in family["editors"] if e["class"] == cls), None)
            if editor is None:
                continue
            if editor.get("catchAll"):
                chain.append("any other class")
            elif is_bridge(editor):
                chain.append(f"`{qualified_class(editor)}`<sup>bridge</sup>")
            else:
                chain.append(f"`{editor['gameClass']}`")
        out += [
            "## Dispatch order",
            "",
            "The first editor that accepts a class handles it, so a class is matched by the "
            "earliest entry below that it derives from.",
            "",
            " &rarr; ".join(chain),
            "",
        ]
        if has_bridge:
            out += [
                "<sup>bridge</sup> Provided by a [bridge mod](../bridges/index.md) and only present "
                "when that mod is installed; bridge editors are checked before every built-in one.",
                "",
            ]

    out += [
        f"## {SHARED_HEADING}",
        "",
        f"Available on every `{family['editStruct']}` entry, whatever its `Class`.",
        "",
        field_table(shared),
        "",
    ]

    if concrete:
        rows = []
        for editor in sorted(concrete, key=sort_key):
            own = len(own_fields(editor))
            badge = " *(abstract)*" if editor.get("abstract") else ""
            row = [
                f"[`{qualified_class(editor)}`]({slugs[editor['class']]}.md){badge}",
                str(own) if own else "&mdash;",
                code(editor.get("extends")),
            ]
            if has_bridge:
                bridge = bridge_of(editor)
                row.append(bridge_link(bridge, "../") if bridge else "built-in")
            rows.append(row)
        headers = ["Game class", "Own fields", "Editor extends"]
        if has_bridge:
            headers.append("Provided by")
        out += [
            "## Classes",
            "",
            "Class-specific fields are documented on each page below. A class with no dedicated "
            f"editor still accepts every field in [{SHARED_HEADING}](#{anchor(SHARED_HEADING)}).",
            "",
            table(headers, rows),
            "",
        ]

    return "\n".join(out)


def render_bridge_notice(editor: dict[str, Any], bridge: dict[str, Any]) -> list[str]:
    """Admonitions on a bridge editor's page: what to install, how to name the class."""
    needs = requirements_text(bridge)
    needs_line = f" It needs {needs}." if needs else ""
    fallback = editor.get("extends")
    fallback_line = (
        f" Without it, an entry naming this class is handled by the built-in `{fallback}` "
        "and the own fields below are silently skipped."
        if fallback
        else " Without it, the own fields below are silently skipped."
    )
    out = [
        '!!! warning "Requires a bridge mod"',
        f"    This class is edited by the **{bridge_link(bridge, '../')}** bridge mod.{needs_line}"
        f"{fallback_line} Name the class with its package - a bare name is looked up in "
        "`XComGame` and never matches:",
        "",
        "    ```ini",
        f'    Class="{qualified_class(editor)}"',
        "    ```",
        "",
    ]
    if editor.get("overrides"):
        out += [
            "!!! note",
            f"    This bridge editor overrides the built-in `{editor['overrides']}` for the same "
            "game class. With the bridge installed it wins; without it the built-in applies.",
            "",
        ]
    if bridge.get("stale"):
        out += [
            "!!! info",
            "    The bridge's fragment was generated against an older Ability Editor than this "
            "site. The inherited fields below are current; the own fields may lag behind the "
            "bridge's latest release.",
            "",
        ]
    return out


def render_editor(editor: dict[str, Any]) -> str:
    own = own_fields(editor)
    groups = inherited_groups(editor)
    bridge = bridge_of(editor)

    title = qualified_class(editor)
    out = [f"# {title}", ""]

    meta = [f"Editor: `{editor['class']}`"]
    if editor.get("extends"):
        meta.append(f"extends `{editor['extends']}`")
    if bridge:
        meta.append(f"provided by {bridge_link(bridge, '../')}")
    out += [" &middot; ".join(meta) + ".", ""]

    if editor.get("abstract"):
        out += [
            "!!! note",
            "    This game class is abstract. It exists here so its fields reach the concrete "
            "    classes that derive from it; you cannot name it as a `Class` yourself.",
            "",
        ]

    if bridge:
        out += render_bridge_notice(editor, bridge)

    out += ["## Own fields", "", field_table(own), ""]

    if groups:
        out += ["## Inherited fields", ""]
        for source, fields in groups.items():
            names = ", ".join(f"`{f['config']}`" for f in fields)
            out += [
                f'??? abstract "From `{source}` ({len(fields)})"',
                "",
                f"    {names}",
                "",
            ]
        out += [
            f"Every one of these is documented under "
            f"[{SHARED_HEADING}](index.md#{anchor(SHARED_HEADING)}) or on the page for the class "
            "that introduces it.",
            "",
        ]

    out.append(not_editable_block(editor.get("notEditable", [])))
    return "\n".join(out)


def render_reference_index() -> str:
    rows = []
    for family in SCHEMA["families"]:
        concrete = [e for e in family["editors"] if not e.get("catchAll")]
        rows.append([
            f"[{family['name']}]({family_slug(family)}/index.md)",
            code(family.get("configKey")),
            code(family["editStruct"]),
            str(len(concrete)),
        ])

    return "\n".join([
        "# Reference",
        "",
        "Every field an `+AbilityEdits` entry can carry, generated from the mod's UnrealScript "
        "sources. See [Config syntax](../getting-started/config-syntax.md) for how entries are "
        "written and [Edit modes](../getting-started/edit-modes.md) for what the `Mode` fields do.",
        "",
        table(["Family", "Config key", "Edit struct", "Classes"], rows),
        "",
        "## Also here",
        "",
        "- [Ability template fields](template-fields.md) - the scalars and arrays you set directly "
        "on an `+AbilityEdits` entry.",
        "- [Nested structs](nested-structs.md) - the shape of every block that nests inside one.",
        "- [Bridges](bridges/index.md) - classes from DLC packages and other mods, editable through "
        "a separate bridge mod.",
        "",
        "!!! tip \"Machine-readable\"",
        "    The whole API is published as [`schema.json`](../schema.json) - the same file this "
        "    site is generated from. It is versioned with each release and carries a `sourceHash` "
        "    so tooling can detect staleness.",
        "",
    ])


def render_bridges_index() -> str:
    out = [
        "# Bridges",
        "",
        "A bridge is a separate mod that plugs editors for game classes Ability Editor cannot "
        "compile against - DLC packages, other mods - into its dispatch. Its classes show up on "
        "the family pages marked <sup>bridge</sup>, and must be named with their package in "
        "config (`Class=\"DLC_2.X2Effect_DLC_Day60Freeze\"`). See "
        "[Extending Ability Editor](../../guides/bridge-mods.md) for how bridges work and how to "
        "publish one here.",
        "",
    ]
    if not BRIDGES:
        out += [
            "*No bridge is published yet.* The first one appears here once its fragment is "
            "merged - see "
            "[Publishing your bridge on this site](../../guides/bridge-mods.md#publishing-your-bridge-on-this-site).",
            "",
        ]
        return "\n".join(out)

    rows = []
    for bridge in BRIDGES.values():
        requires = bridge.get("requires") or {}
        dlc = ", ".join(requires.get("dlc") or []) or "&mdash;"
        rows.append([
            f"[{bridge['displayName']}]({bridge_slug(bridge['name'])}.md)",
            f"`{bridge['name']}`",
            dlc,
            str(bridge.get("editorCount", len(bridge.get("editors", [])))),
            "needs refresh" if bridge.get("stale") else "current",
        ])
    out += [table(["Bridge", "Package", "DLC", "Classes", "Fragment"], rows), ""]
    return "\n".join(out)


def render_bridge(bridge: dict[str, Any]) -> str:
    out = [f"# {bridge['displayName']}", ""]

    meta = [f"Mod package `{bridge['name']}`"]
    if bridge.get("repo"):
        meta.append(f"[source and releases]({bridge['repo']})")
    out += [" &middot; ".join(meta) + ".", ""]

    needs = requirements_text(bridge)
    if needs:
        out += [f"Requires {needs}.", ""]

    if bridge.get("stale"):
        out += [
            '!!! info "Needs a refresh"',
            "    This bridge's fragment was generated against an older Ability Editor than this "
            "site. Inherited fields are recomposed from the current built-in editors, so they are "
            "accurate; the bridge's own fields may lag behind its latest release.",
            "",
        ]

    # Editors, grouped by family, with links into the family directories.
    registrations: list[str] = []
    for family in SCHEMA["families"]:
        editors = [e for e in family["editors"] if e.get("bridge") == bridge["name"]]
        if not editors:
            continue
        slugs = assign_slugs(family)
        fslug = family_slug(family)
        rows = []
        for editor in sorted(editors, key=sort_key):
            own = len(own_fields(editor))
            note = f" overrides `{editor['overrides']}`" if editor.get("overrides") else ""
            rows.append([
                f"[`{qualified_class(editor)}`](../{fslug}/{slugs[editor['class']]}.md)",
                f"`{editor['class']}`{note}",
                code(editor.get("extends")),
                str(own) if own else "&mdash;",
            ])
            registry = editor.get("registration")
            if registry:
                registrations.append(
                    f'+{registry}=(EditorClass="{bridge["name"]}.{editor["class"]}", '
                    f'Priority={editor.get("priority", 0)})'
                )
        out += [
            f"## {family['name']}",
            "",
            table(["Game class", "Editor", "Extends", "Own fields"], rows),
            "",
        ]

    out += [
        "## Writing the config",
        "",
        "These classes live outside `XComGame`, so every entry names them with their package. "
        "The fields themselves are ordinary Ability Editor fields, listed on each class page.",
        "",
    ]
    if registrations:
        out += [
            "## Registration",
            "",
            "What the bridge's `Config\\XComAbilityEditor.ini` registers with Ability Editor. "
            "Extras are checked before every built-in editor, highest `Priority` first; an editor "
            "for a subclass of one of these classes needs a higher `Priority`.",
            "",
            "```ini",
            "[AbilityEditor.X2DLCInfo_AbilityEditor]",
            *registrations,
            "```",
            "",
        ]
    return "\n".join(out)


def render_template_fields() -> str:
    template = SCHEMA["template"]
    return "\n".join([
        "# Ability template fields",
        "",
        "Set directly on an `+AbilityEdits` entry, alongside `Ability`. These change the ability "
        "template itself rather than one of its costs, effects or conditions.",
        "",
        field_table(template["fields"]),
        "",
        not_editable_block(template.get("notEditable", [])),
    ])


def render_edit_modes() -> str:
    """The Mode enums. Generated because every value is already described in the schema.

    The first value of each enum is the UnrealScript default, and in every one of these it is a
    Replace - which is the single most expensive thing to not know about this config format.
    """
    out = [
        "# Edit modes",
        "",
        "Array-shaped fields take a companion `Mode` that says how your list combines with what "
        "the ability already has.",
        "",
        "!!! danger \"The default is destructive\"",
        "    UnrealScript uses an enum's **first value** when you omit the field, and in every "
        "    enum below that first value is a Replace. Omitting `CostMode` does not add a cost - "
        "    it throws away every cost the ability had and keeps only what you listed. Write the "
        "    mode explicitly; you almost always want `Merge`. The one exception is an ability you "
        "    are [creating](../guides/create-an-ability.md) blank: there is nothing to destroy "
        "    yet. A copy made with `CloneFrom` has everything its source had, so the rule applies "
        "    to it in full.",
        "",
        "!!! warning \"`AddOnly` does not append\"",
        "    For **name arrays** (`ENameArrayEditMode`), `eNAEM_AddOnly` writes your values only "
        "    when the target array is currently *empty*. It is \"provide a default\", not \"add "
        "    without removing\" - that is `Merge`. For effects, conditions and costs, `AddOnly` "
        "    *is* a synonym for `Merge`. Different enums, near-identical names, opposite "
        "    behaviour.",
        "",
    ]
    for enum in SCHEMA["enums"]:
        rows = [[code(v["name"]), escape_cell(v.get("description") or "")] for v in enum["values"]]
        out += [f"## `{enum['name']}`", "", table(["Value", "Meaning"], rows), ""]
    return "\n".join(out)


def render_nested_structs() -> str:
    out = [
        "# Nested structs",
        "",
        "The shape of each block that nests inside an `+AbilityEdits` entry. These are the "
        "structures you type; which *fields* apply depends on the `Class` you name - see the "
        "family pages under [Reference](index.md).",
        "",
    ]
    for struct in SCHEMA["structs"]:
        rows = []
        for field in struct["fields"]:
            if field.get("kind") == "guard":
                continue  # guards are shown in the Requires column of their value field
            rows.append([
                code(field["name"]),
                code(field.get("type")),
                code(field.get("guard")) if field.get("guard") else "&mdash;",
                escape_cell(field.get("description") or "") or "&mdash;",
            ])
        out += [
            f"## `{struct['name']}`",
            "",
            table(["Field", "Type", "Guard", "Description"], rows) if rows else "*No fields.*\n",
            "",
        ]
    return "\n".join(out)


# --------------------------------------------------------------------------- #
# Emit
# --------------------------------------------------------------------------- #

summary: list[str] = ["* [Overview](index.md)",
                      "* [Ability template fields](template-fields.md)"]

write("reference/index.md", render_reference_index())
write("reference/template-fields.md", render_template_fields())
write("reference/nested-structs.md", render_nested_structs())
write("getting-started/edit-modes.md", render_edit_modes())

for family in SCHEMA["families"]:
    slug = family_slug(family)
    slugs = assign_slugs(family)
    write(f"reference/{slug}/index.md", render_family_index(family))
    summary.append(f"* [{family['name']}]({slug}/index.md)")

    children = [e for e in family["editors"] if not e.get("catchAll")]
    for editor in sorted(children, key=sort_key):
        page = f"reference/{slug}/{slugs[editor['class']]}.md"
        write(page, render_editor(editor))
        summary.append(f"    * [{qualified_class(editor)}]({slug}/{slugs[editor['class']]}.md)")

write("reference/bridges/index.md", render_bridges_index())
summary.append("* [Bridges](bridges/index.md)")
for bridge in BRIDGES.values():
    write(f"reference/{bridge_page(bridge)}", render_bridge(bridge))
    summary.append(f"    * [{bridge['displayName']}]({bridge_page(bridge)})")

summary.append("* [Nested structs](nested-structs.md)")

with mkdocs_gen_files.open("reference/SUMMARY.md", "w") as handle:
    handle.write("\n".join(summary) + "\n")
