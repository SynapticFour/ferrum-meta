#!/usr/bin/env python3
"""Apache-2.0 CLI: validate and write GHGA/EGA/H3Africa starter bundles.

Does not talk to a running Ferrum node and does not upload to any archive.
Live DRS ids: Ferrum `ferrum meta export` (without --starter).
"""
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"
FIXTURES = {
    "ghga": ROOT / "fixtures/valid/ghga-minimal-submission.yaml",
    "ega": ROOT / "fixtures/valid/ega-minimal-submission.yaml",
    "h3africa": ROOT / "fixtures/valid/h3africa-minimal-submission.yaml",
}


def run_validate(path: Path) -> int:
    cmd = [str(SCRIPTS / "validate-fixture.sh"), str(path)]
    return subprocess.call(cmd)


def cmd_validate(args: argparse.Namespace) -> int:
    path = Path(args.file)
    if not path.is_file():
        print(f"error: not a file: {path}", file=sys.stderr)
        return 2
    return run_validate(path)


def cmd_export(args: argparse.Namespace) -> int:
    profile = args.profile
    src = FIXTURES[profile]
    if not src.is_file():
        print(f"error: missing fixture {src}", file=sys.stderr)
        return 2
    if args.output:
        dest = Path(args.output)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
        print(f"wrote {dest} (starter fixture, not live DRS, not archive acceptance)")
        target = dest
    else:
        target = src
        print(f"validating {target}")
    return run_validate(target)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="ferrum-meta",
        description="Validate and write ferrum-meta archive starter bundles (not EGA/GHGA upload).",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_val = sub.add_parser("validate", help="Validate a YAML/JSON fixture with LinkML")
    p_val.add_argument("file")
    p_val.set_defaults(func=cmd_validate)

    p_exp = sub.add_parser(
        "export",
        help="Write a GHGA/EGA/H3Africa starter YAML and validate it",
    )
    p_exp.add_argument("profile", choices=sorted(FIXTURES))
    p_exp.add_argument("output", nargs="?", default=None)
    p_exp.set_defaults(func=cmd_export)

    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
