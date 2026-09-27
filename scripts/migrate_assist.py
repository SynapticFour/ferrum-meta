"""Experimental mapping report for CSV/JSON exports against an archive profile.

Schema-only. Does not read Ferrum, DRS, or any archive. A name match is a
suggestion for a migration project. It is not a LinkML pass and not an upload.
"""
from __future__ import annotations

import csv
import json
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

DISCLAIMER = (
    "Unterstützt Migrationsprojekte, ersetzt keine manuelle Prüfung, "
    "exportiert nicht direkt zu EGA/GHGA."
)

PROFILES: dict[str, tuple[str, str]] = {
    "ghga": ("schema/profiles/ghga-profile.yaml", "GhgaProfileSubmission"),
    "ega": ("schema/profiles/ega-profile.yaml", "EgaProfileSubmission"),
    "h3africa": ("schema/profiles/h3africa-profile.yaml", "H3AfricaProfileSubmission"),
    "pathogen": ("schema/profiles/pathogen-profile.yaml", "PathogenProfileSubmission"),
    "eva": ("schema/profiles/eva-profile.yaml", "EvaProfileSubmission"),
}


@dataclass(frozen=True)
class SlotRef:
    class_name: str
    name: str
    required: bool
    range_class: str | None


@dataclass(frozen=True)
class ProfileModel:
    profile: str
    schema_path: Path
    target_class: str
    slots: tuple[SlotRef, ...]
    entity_ranges: dict[str, str]


def load_profile(profile: str) -> ProfileModel:
    if profile not in PROFILES:
        known = ", ".join(sorted(PROFILES))
        raise ValueError(f"unknown profile {profile!r}; choose one of: {known}")
    rel, target = PROFILES[profile]
    schema_path = ROOT / rel
    if not schema_path.is_file():
        raise ValueError(f"schema not found: {schema_path}")
    try:
        from linkml_runtime.utils.schemaview import SchemaView
    except ImportError as exc:
        raise ValueError("linkml-runtime is not installed. Run: make install") from exc
    view = SchemaView(str(schema_path))
    if view.get_class(target) is None:
        raise ValueError(f"target class {target} is not in {schema_path}")
    slots: list[SlotRef] = []
    entity_ranges: dict[str, str] = {}
    seen: set[str] = set()

    def walk(class_name: str) -> None:
        if class_name in seen:
            return
        seen.add(class_name)
        for slot in view.class_induced_slots(class_name):
            range_class = slot.range if view.get_class(slot.range) is not None else None
            slots.append(
                SlotRef(
                    class_name=class_name,
                    name=slot.name,
                    required=bool(slot.required),
                    range_class=range_class,
                )
            )
            if range_class is not None:
                if class_name == target:
                    entity_ranges[slot.name] = range_class
                walk(range_class)

    walk(target)
    return ProfileModel(
        profile=profile,
        schema_path=schema_path,
        target_class=target,
        slots=tuple(slots),
        entity_ranges=entity_ranges,
    )


def _records_from_json(payload: object) -> dict[str, set[str]] | set[str]:
    """Return field names, or field names grouped by a root entity slot."""
    if isinstance(payload, list):
        if not payload or not all(isinstance(item, dict) for item in payload):
            raise ValueError("JSON array must contain only objects")
        fields: set[str] = set()
        for item in payload:
            fields.update(_string_keys(item))
        return fields
    if isinstance(payload, dict):
        if not payload:
            raise ValueError("JSON object is empty")
        if all(isinstance(value, list) for value in payload.values()):
            grouped: dict[str, set[str]] = {}
            for key, rows in payload.items():
                if not isinstance(key, str) or not rows or not all(isinstance(row, dict) for row in rows):
                    raise ValueError(
                        "JSON object of lists must use string keys and object rows"
                    )
                names: set[str] = set()
                for row in rows:
                    names.update(_string_keys(row))
                grouped[key] = names
            return grouped
        if any(isinstance(value, (list, dict)) for value in payload.values()):
            raise ValueError(
                "JSON mix of objects and lists is not a supported shape; "
                "use a flat object, an array of objects, or an object of row arrays"
            )
        return set(_string_keys(payload))
    raise ValueError("JSON root must be an object or an array of objects")


def _string_keys(row: dict) -> list[str]:
    keys: list[str] = []
    for key, value in row.items():
        if not isinstance(key, str) or not key.strip():
            raise ValueError("field names must be non-empty strings")
        if key != key.strip():
            raise ValueError(f"field name {key!r} has surrounding whitespace")
        if value is None or value == "" or value == [] or value == {}:
            continue
        if isinstance(value, str) and not value.strip():
            continue
        keys.append(key)
    return keys


def read_input(path: Path) -> dict[str, set[str]] | set[str]:
    if not path.is_file():
        raise ValueError(f"not a file: {path}")
    suffix = path.suffix.lower()
    if suffix == ".csv":
        return _read_csv(path)
    if suffix == ".json":
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise ValueError(f"invalid JSON: {exc}") from exc
        return _records_from_json(payload)
    raise ValueError("input must be .csv or .json; YAML fixtures stay on `validate`")


def _read_csv(path: Path) -> dict[str, set[str]] | set[str]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError("CSV has no header")
        fields = list(reader.fieldnames)
        if any(name is None or not str(name).strip() for name in fields):
            raise ValueError("CSV header has an empty column")
        if any(str(name) != str(name).strip() for name in fields):
            raise ValueError("CSV header has surrounding whitespace")
        if len(fields) != len(set(fields)):
            raise ValueError("CSV header has a duplicate column")
        rows = list(reader)
    if not rows:
        raise ValueError("CSV has a header and no rows")
    if "entity" in fields:
        grouped: dict[str, set[str]] = {}
        others = [name for name in fields if name != "entity"]
        for row in rows:
            entity = (row.get("entity") or "").strip()
            if not entity:
                raise ValueError("CSV entity column has an empty cell")
            bucket = grouped.setdefault(entity, set())
            for name in others:
                cell = row.get(name)
                if cell is not None and str(cell).strip() != "":
                    bucket.add(name)
        for entity, bucket in grouped.items():
            if not bucket:
                raise ValueError(f"CSV entity {entity!r} has no populated columns")
        return grouped
    present: set[str] = set()
    for row in rows:
        for name in fields:
            cell = row.get(name)
            if cell is not None and str(cell).strip() != "":
                present.add(name)
    if not present:
        raise ValueError("CSV rows have no populated cells")
    return present


def render_report(
    model: ProfileModel,
    source: Path,
    fields: dict[str, set[str]] | set[str],
) -> str:
    lines = [
        "# migrate-assist (experimentell)",
        "",
        DISCLAIMER,
        "",
        "Dieser Bericht vergleicht Feldnamen mit Slots des gewählten Archivprofils.",
        "Ein Treffer ist ein Vorschlag. Er ist keine bestandene Prüfung, keine GA4GH-Zertifizierung",
        "und kein Import. Es wird nichts an Ferrum, DRS, EGA oder GHGA gesendet.",
        "Werte werden nicht geprüft. Eine von Hand geprüfte YAML-Fixture bleibt bei `validate`.",
        "",
        f"- Profil: `{model.profile}`",
        f"- Schema: `{model.schema_path.relative_to(ROOT)}`",
        f"- Zielklasse: `{model.target_class}`",
        f"- Eingabe: `{source}`",
        "",
    ]
    if isinstance(fields, set):
        lines.append(
            "Ohne Entitätszuordnung gilt ein Feld nur dann als vorgeschlagen, "
            "wenn sein Name exakt einem Slotnamen entspricht."
        )
        lines.append("")
        _append_flat(lines, model, fields)
    else:
        unknown = sorted(set(fields) - set(model.entity_ranges))
        if unknown:
            raise ValueError(
                "unknown entity "
                + ", ".join(unknown)
                + "; expected a root slot such as "
                + ", ".join(sorted(model.entity_ranges))
            )
        lines.append(
            "Jede Gruppe wird nur gegen die Klasse gemappt, die das Profil für diesen Root-Slot nennt."
        )
        lines.append("")
        for entity in sorted(fields):
            range_class = model.entity_ranges[entity]
            lines.append(f"## {entity} → {range_class}")
            lines.append("")
            _append_class(lines, model, range_class, fields[entity])
    lines.append("## Grenze")
    lines.append("")
    lines.append(DISCLAIMER)
    lines.append("")
    return "\n".join(lines)


def required_classes(model: ProfileModel) -> set[str]:
    """Classes a submission must populate. Optional branches stay out of the gap list."""
    included = {model.target_class}
    queue = [model.target_class]
    while queue:
        current = queue.pop()
        for slot in model.slots:
            if (
                slot.class_name == current
                and slot.required
                and slot.range_class is not None
                and slot.range_class not in included
            ):
                included.add(slot.range_class)
                queue.append(slot.range_class)
    return included


def _slots_for(model: ProfileModel, class_name: str | None) -> list[SlotRef]:
    if class_name is None:
        return list(model.slots)
    return [slot for slot in model.slots if slot.class_name == class_name]


def _append_flat(lines: list[str], model: ProfileModel, names: set[str]) -> None:
    by_name: dict[str, list[str]] = {}
    for slot in model.slots:
        by_name.setdefault(slot.name, [])
        if slot.class_name not in by_name[slot.name]:
            by_name[slot.name].append(slot.class_name)
    mapped = sorted(name for name in names if name in by_name)
    unmapped = sorted(names - set(by_name))
    lines.append("## Vorgeschlagene Zuordnung")
    lines.append("")
    if mapped:
        for name in mapped:
            classes = ", ".join(by_name[name])
            lines.append(f"- `{name}` → Slot `{name}` ({classes})")
    else:
        lines.append("- keine")
    lines.append("")
    lines.append("## Nicht zugeordnet")
    lines.append("")
    if unmapped:
        for name in unmapped:
            lines.append(f"- `{name}`")
    else:
        lines.append("- keine")
    lines.append("")
    lines.append("## Pflicht-Slots ohne gleichnamiges Feld")
    lines.append("")
    needed = required_classes(model)
    missing = [
        slot
        for slot in model.slots
        if slot.required and slot.class_name in needed and slot.name not in names
    ]
    _append_missing(lines, missing)


def _append_class(lines: list[str], model: ProfileModel, class_name: str, names: set[str]) -> None:
    known = {slot.name for slot in _slots_for(model, class_name)}
    mapped = sorted(name for name in names if name in known)
    unmapped = sorted(names - known)
    lines.append("### Vorgeschlagene Zuordnung")
    lines.append("")
    if mapped:
        for name in mapped:
            lines.append(f"- `{name}` → Slot `{name}` auf `{class_name}`")
    else:
        lines.append("- keine")
    lines.append("")
    lines.append("### Nicht zugeordnet")
    lines.append("")
    if unmapped:
        for name in unmapped:
            lines.append(f"- `{name}`")
    else:
        lines.append("- keine")
    lines.append("")
    lines.append("### Pflicht-Slots ohne gleichnamiges Feld")
    lines.append("")
    missing = [
        slot
        for slot in _slots_for(model, class_name)
        if slot.required and slot.name not in names
    ]
    _append_missing(lines, missing)


def _append_missing(lines: list[str], missing: list[SlotRef]) -> None:
    seen: set[tuple[str, str]] = set()
    if not missing:
        lines.append("- keine namensgleiche Lücke in dieser Gruppe")
        lines.append("")
        return
    for slot in missing:
        key = (slot.class_name, slot.name)
        if key in seen:
            continue
        seen.add(key)
        lines.append(f"- `{slot.class_name}.{slot.name}`")
    lines.append("")


def build_report(profile: str, source: Path) -> str:
    model = load_profile(profile)
    fields = read_input(source)
    return render_report(model, source, fields)


def main(argv: list[str] | None = None) -> int:
    import argparse

    parser = argparse.ArgumentParser(
        prog="migrate-assist",
        description=(
            "EXPERIMENTAL. Suggest slot names for a CSV or JSON export. "
            + DISCLAIMER
        ),
    )
    parser.add_argument("profile", choices=sorted(PROFILES))
    parser.add_argument("file")
    parser.add_argument(
        "--output",
        help="Write the markdown report to this path instead of stdout",
    )
    args = parser.parse_args(argv)
    try:
        report = build_report(args.profile, Path(args.file))
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    if args.output:
        dest = Path(args.output)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(report, encoding="utf-8")
        print(
            f"wrote {dest} (mapping report only; not a submission; not an archive export)"
        )
    else:
        sys.stdout.write(report)
    return 0


if __name__ == "__main__":
    sys.exit(main())
