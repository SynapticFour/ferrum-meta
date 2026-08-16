#!/usr/bin/env bash
# User path: emit a GHGA or EGA starter bundle and validate it with LinkML.
# Full profile parity lives here; Ferrum `ferrum meta export` writes the same
# starter YAML when ferrum-meta is not on PATH.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROFILE="${1:-}"
OUT="${2:-}"
case "$PROFILE" in
  ghga) SRC="$ROOT/fixtures/valid/ghga-minimal-submission.yaml" ;;
  ega) SRC="$ROOT/fixtures/valid/ega-minimal-submission.yaml" ;;
  h3africa) SRC="$ROOT/fixtures/valid/h3africa-minimal-submission.yaml" ;;
  *)
    echo "usage: $0 ghga|ega|h3africa [output.yaml]" >&2
    exit 2
    ;;
esac
if [[ -n "$OUT" ]]; then
  cp "$SRC" "$OUT"
  echo "wrote $OUT"
  TARGET="$OUT"
else
  TARGET="$SRC"
fi
exec "$ROOT/scripts/validate-fixture.sh" "$TARGET"
