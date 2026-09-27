#!/usr/bin/env python3
"""Checks for the experimental migrate-assist report. Schema-only, no network."""
from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

from migrate_assist import DISCLAIMER, build_report, main  # noqa: E402


def fail(message: str) -> None:
    print(f"FAIL {message}", file=sys.stderr)
    sys.exit(1)


def main_check() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        csv_path = Path(tmp) / "export.csv"
        csv_path.write_text(
            "alias,title,not_a_slot\nghga_study001,Example study,x\n",
            encoding="utf-8",
        )
        report = build_report("ghga", csv_path)
        if DISCLAIMER not in report:
            fail("disclaimer missing")
        if report.count(DISCLAIMER) < 2:
            fail("disclaimer not repeated at the end of the report")
        if "experimentell" not in report:
            fail("experimental marker missing")
        if "`not_a_slot`" not in report:
            fail("unmapped column missing")
        if "Pflicht-Slots ohne gleichnamiges Feld" not in report:
            fail("required-slot section missing")
        if "Study.description" not in report:
            fail("expected a required slot gap such as Study.description")
        if "GhgaAnalysis.type" in report.split("Pflicht-Slots", 1)[-1]:
            fail("optional analysis class was reported as a required gap")
        for banned in ("No issues found", "DRS object", "uploaded"):
            if banned in report:
                fail(f"report claims more than a suggestion: {banned}")
        code = main(["ghga", str(csv_path), "--output", str(Path(tmp) / "report.md")])
        if code != 0:
            fail(f"markdown output exit {code}")
        written = (Path(tmp) / "report.md").read_text(encoding="utf-8")
        if DISCLAIMER not in written:
            fail("markdown file missing disclaimer")
        try:
            unknown = main(["not-a-profile", str(csv_path)])
        except SystemExit as exc:
            unknown = exc.code
        if unknown == 0:
            fail("unknown profile was accepted")
        yaml_path = Path(tmp) / "already.yaml"
        yaml_path.write_text("alias: x\n", encoding="utf-8")
        if main(["ghga", str(yaml_path)]) == 0:
            fail("YAML input was accepted")
        json_path = Path(tmp) / "rows.json"
        json_path.write_text(
            '{"studies":[{"alias":"s1","title":"t","not_a_slot":"x"}]}',
            encoding="utf-8",
        )
        grouped = build_report("ega", json_path)
        if "studies →" not in grouped or "`not_a_slot`" not in grouped:
            fail("grouped JSON report incomplete")
        if "EGA" in grouped and "exportiert nicht direkt zu EGA/GHGA" not in grouped:
            fail("grouped report missing the no-export line")

    cli = subprocess.run(
        [
            sys.executable,
            str(ROOT / "scripts" / "ferrum_meta_cli.py"),
            "migrate-assist",
            "--help",
        ],
        check=False,
        capture_output=True,
        text=True,
    )
    if cli.returncode != 0 or "EXPERIMENTAL" not in cli.stdout:
        fail("CLI help does not mark migrate-assist experimental")
    if "Unterstützt Migrationsprojekte" not in cli.stdout:
        fail("CLI help missing the disclaimer")
    print("migrate-assist: ok")


if __name__ == "__main__":
    main_check()
