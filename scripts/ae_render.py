"""Shared rendering helpers for the Ability Editor reference pages.

The site is a dumb transform of ``docs/schema.json``; all domain knowledge about
UnrealScript lives in ``.scripts/generate-docs.ps1``, which produces that file.
Nothing here should need to know what an ``X2Effect`` is.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any, Iterable

REPO_ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = REPO_ROOT / "docs" / "schema.json"


def load_schema() -> dict[str, Any]:
    with SCHEMA_PATH.open(encoding="utf-8-sig") as handle:
        return json.load(handle)


# --------------------------------------------------------------------------- #
# Slugs and links
# --------------------------------------------------------------------------- #

def family_slug(family: dict[str, Any]) -> str:
    """Directory name for a family, e.g. 'MultiTargetStyle' -> 'multitargetstyle'."""
    return re.sub(r"[^a-z0-9]+", "-", family["name"].lower()).strip("-")


def editor_slug(editor: dict[str, Any]) -> str:
    """Page name for an editor, keyed on its game class so URLs are guessable.

    Catch-all editors have no game class, so fall back to the editor class name.
    """
    name = editor.get("gameClass") or editor["class"]
    return name.lower()


def anchor(text: str) -> str:
    """Reproduce the heading anchors mkdocs generates, for intra-page links."""
    slug = text.strip().lower()
    slug = re.sub(r"[^\w\s-]", "", slug)
    return re.sub(r"[\s_]+", "-", slug).strip("-")


# --------------------------------------------------------------------------- #
# Markdown primitives
# --------------------------------------------------------------------------- #

def code(value: Any) -> str:
    """Inline code, or an em dash when there is nothing to show."""
    if value is None or value == "":
        return "&mdash;"
    return f"`{value}`"


def escape_cell(text: str) -> str:
    """Make a string safe inside a markdown table cell."""
    return str(text).replace("|", "\\|").replace("\n", " ")


def table(headers: Iterable[str], rows: Iterable[Iterable[str]]) -> str:
    headers = list(headers)
    out = ["| " + " | ".join(headers) + " |",
           "|" + "|".join("---" for _ in headers) + "|"]
    for row in rows:
        out.append("| " + " | ".join(str(cell) for cell in row) + " |")
    return "\n".join(out) + "\n"


# --------------------------------------------------------------------------- #
# Field rendering
# --------------------------------------------------------------------------- #

def requires_cell(field: dict[str, Any]) -> str:
    """What the user must also write for this field to take effect.

    Three shapes exist: a Set guard for scalars, a companion Mode field for
    arrays, and replace-only arrays which have neither (writing a mode field
    name for those would name something that does not exist).
    """
    if field.get("replaceOnly"):
        return "non-empty *(replace-only)*"
    if field.get("guard"):
        return f"`{field['guard']}=true`"
    if field.get("modeField"):
        mode = f"`{field['modeField']}`"
        if field.get("modeEnum"):
            mode += f" (`{field['modeEnum']}`)"
        return mode
    return "&mdash;"


def describe(field: dict[str, Any]) -> str:
    """The field's prose, or an honest derived line when none was authored.

    Only ~2% of fields carry a description today. Rather than leave 3,400 blank
    cells, fall back to something true that is built from data we already have,
    and mark it as derived so a real description is visibly different.
    """
    description = (field.get("description") or "").strip()
    if description:
        return escape_cell(description)

    game_field = field.get("gameField")
    field_type = field.get("type")
    if game_field and field_type:
        return f"<small>Sets `{game_field}` (`{field_type}`).</small>"
    if game_field:
        return f"<small>Sets `{game_field}`.</small>"
    return "&mdash;"


def field_rows(fields: Iterable[dict[str, Any]]) -> list[list[str]]:
    rows = []
    for field in fields:
        rows.append([
            code(field["config"]),
            code(field.get("type")),
            requires_cell(field),
            code(field.get("gameField")),
            describe(field),
        ])
    return rows


FIELD_HEADERS = ["Config field", "Type", "Requires", "Game field", "Description"]


def field_table(fields: Iterable[dict[str, Any]]) -> str:
    fields = list(fields)
    if not fields:
        return "*No editable fields.*\n"
    return table(FIELD_HEADERS, field_rows(fields))


def not_editable_block(entries: Iterable[dict[str, Any]]) -> str:
    """Fields the generator proved cannot be set from config, with the reason."""
    entries = list(entries)
    if not entries:
        return ""
    lines = ['??? warning "Not editable from config"', ""]
    for entry in entries:
        lines.append(f"    - `{entry['name']}` &mdash; {escape_cell(entry.get('reason', ''))}")
    lines.append("")
    return "\n".join(lines) + "\n"
