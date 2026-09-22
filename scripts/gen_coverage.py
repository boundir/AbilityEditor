"""Generate the documentation-coverage page.

Field descriptions come from ``//`` comments in ``AE_DataStructures.uc``. Because
``schema.json`` flattens inheritance, one comment can light up many rendered rows
- so raw row counts wildly overstate the work. This page reports both, and lists
what to write next in the order that helps most.
"""

from __future__ import annotations

import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

import mkdocs_gen_files

# See the note in gen_reference.py: runpy.run_path does not extend sys.path.
sys.path.insert(0, str(Path(__file__).resolve().parent))

from ae_render import code, escape_cell, family_slug, load_schema, table  # noqa: E402

SCHEMA = load_schema()


def collect() -> tuple[dict[str, dict[str, Any]], dict[str, dict[str, int]]]:
    """Return (per-config-key stats, per-family stats)."""
    keys: dict[str, dict[str, Any]] = defaultdict(
        lambda: {"rows": 0, "described": False, "families": set()}
    )
    families: dict[str, dict[str, int]] = {}

    for family in SCHEMA["families"]:
        unique: set[str] = set()
        described_unique: set[str] = set()
        for editor in family["editors"]:
            for field in editor["fields"]:
                name = field["config"]
                entry = keys[name]
                entry["rows"] += 1
                entry["families"].add(family["name"])
                unique.add(name)
                if (field.get("description") or "").strip():
                    entry["described"] = True
                    described_unique.add(name)
        families[family["name"]] = {
            "unique": len(unique),
            "described": len(described_unique),
        }
    return keys, families


keys, families = collect()

total_keys = len(keys)
described_keys = sum(1 for v in keys.values() if v["described"])
total_rows = sum(v["rows"] for v in keys.values())
described_rows = sum(v["rows"] for v in keys.values() if v["described"])


def pct(part: int, whole: int) -> str:
    return f"{(100.0 * part / whole):.0f}%" if whole else "&mdash;"


family_rows = []
for family in SCHEMA["families"]:
    stats = families[family["name"]]
    family_rows.append([
        f"[{family['name']}](../reference/{family_slug(family)}/index.md)",
        str(stats["unique"]),
        str(stats["described"]),
        pct(stats["described"], stats["unique"]),
    ])

undescribed = sorted(
    ((name, v["rows"], sorted(v["families"])) for name, v in keys.items() if not v["described"]),
    key=lambda item: -item[1],
)[:40]

body = "\n".join([
    "# Documentation coverage",
    "",
    "Field descriptions are authored as `//` comments in "
    "`AbilityEditor/Src/AbilityEditor/Classes/AE_DataStructures.uc` and flow into "
    "[`schema.json`](../schema.json) and these pages. See "
    "[Adding an editor](adding-an-editor.md) for where the comment goes - it is above the "
    "*value* var, not the `Set` guard.",
    "",
    "## Where things stand",
    "",
    table(
        ["Measure", "Described", "Total", "Coverage"],
        [
            ["Unique config keys", str(described_keys), str(total_keys), pct(described_keys, total_keys)],
            ["Rendered table rows", str(described_rows), str(total_rows), pct(described_rows, total_rows)],
        ],
    ),
    "",
    "The two rows differ because inheritance is flattened: a field on "
    "`X2AbilityEffectsEditor` is rendered for every effect class that inherits it. **Writing one "
    "comment can therefore document dozens of rows**, which is why the unique-key count is the "
    "number worth tracking.",
    "",
    "## By family",
    "",
    table(["Family", "Unique keys", "Described", "Coverage"], family_rows),
    "",
    "## Highest-value keys still undescribed",
    "",
    "Ordered by how many rendered rows each one would fix.",
    "",
    table(
        ["Config key", "Rows it would document", "Families"],
        [[code(name), str(rows), escape_cell(", ".join(fams))] for name, rows, fams in undescribed],
    ) if undescribed else "*Everything is described.*\n",
    "",
])

with mkdocs_gen_files.open("contributing/doc-coverage.md", "w") as handle:
    handle.write(body)
mkdocs_gen_files.set_edit_path(
    "contributing/doc-coverage.md",
    "AbilityEditor/Src/AbilityEditor/Classes/AE_DataStructures.uc",
)
