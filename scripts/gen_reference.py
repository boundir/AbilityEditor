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
    code,
    editor_slug,
    escape_cell,
    family_slug,
    field_table,
    load_schema,
    not_editable_block,
    table,
)

SCHEMA = load_schema()
SRC = ".scripts/generate-docs.ps1"

SHARED_HEADING = "Shared fields"


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

    out = [f"# {family['name']}", ""]

    if family.get("intro"):
        out += [family["intro"], ""]

    config_key = family.get("configKey")
    if config_key:
        out += [f"Config key: `{config_key}`. Edit struct: `{family['editStruct']}`.", ""]
    else:
        out += [f"Edit struct: `{family['editStruct']}`.", ""]

    # Dispatch order matters: first match wins, so a class is handled by the first
    # editor in this list that accepts it.
    if family.get("dispatchOrder"):
        chain = []
        for cls in family["dispatchOrder"]:
            editor = next((e for e in family["editors"] if e["class"] == cls), None)
            if editor is None:
                continue
            chain.append("any other class" if editor.get("catchAll") else f"`{editor['gameClass']}`")
        out += [
            "## Dispatch order",
            "",
            "The first editor that accepts a class handles it, so a class is matched by the "
            "earliest entry below that it derives from.",
            "",
            " &rarr; ".join(chain),
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
        for editor in sorted(concrete, key=lambda e: e.get("gameClass") or e["class"]):
            own = len(own_fields(editor))
            badge = " *(abstract)*" if editor.get("abstract") else ""
            rows.append([
                f"[`{editor['gameClass']}`]({editor_slug(editor)}.md){badge}",
                str(own) if own else "&mdash;",
                code(editor.get("extends")),
            ])
        out += [
            "## Classes",
            "",
            "Class-specific fields are documented on each page below. A class with no dedicated "
            f"editor still accepts every field in [{SHARED_HEADING}](#{anchor(SHARED_HEADING)}).",
            "",
            table(["Game class", "Own fields", "Editor extends"], rows),
            "",
        ]

    return "\n".join(out)


def render_editor(editor: dict[str, Any]) -> str:
    own = own_fields(editor)
    groups = inherited_groups(editor)

    title = editor.get("gameClass") or editor["class"]
    out = [f"# {title}", ""]

    meta = [f"Editor: `{editor['class']}`"]
    if editor.get("extends"):
        meta.append(f"extends `{editor['extends']}`")
    out += [" &middot; ".join(meta) + ".", ""]

    if editor.get("abstract"):
        out += [
            "!!! note",
            "    This game class is abstract. It exists here so its fields reach the concrete "
            "    classes that derive from it; you cannot name it as a `Class` yourself.",
            "",
        ]

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
        "",
        "!!! tip \"Machine-readable\"",
        "    The whole API is published as [`schema.json`](../schema.json) - the same file this "
        "    site is generated from. It is versioned with each release and carries a `sourceHash` "
        "    so tooling can detect staleness.",
        "",
    ])


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
        "    mode explicitly; you almost always want `Merge`.",
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
    write(f"reference/{slug}/index.md", render_family_index(family))
    summary.append(f"* [{family['name']}]({slug}/index.md)")

    children = [e for e in family["editors"] if not e.get("catchAll")]
    for editor in sorted(children, key=lambda e: e.get("gameClass") or e["class"]):
        page = f"reference/{slug}/{editor_slug(editor)}.md"
        write(page, render_editor(editor))
        summary.append(f"    * [{editor.get('gameClass') or editor['class']}]"
                       f"({slug}/{editor_slug(editor)}.md)")

summary.append("* [Nested structs](nested-structs.md)")

with mkdocs_gen_files.open("reference/SUMMARY.md", "w") as handle:
    handle.write("\n".join(summary) + "\n")
