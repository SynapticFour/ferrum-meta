#!/usr/bin/env bash
# Validate a ferrum-meta fixture against the core schema (or a named profile).
#
# Usage:
#   ./scripts/validate-fixture.sh <fixture.yaml> [schema.yaml]
#
# Defaults:
#   schema.yaml → schema/core/ferrum-core.yaml
#
# Requires: linkml-validate (pip install linkml)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE="${1:-}"
SCHEMA="${2:-${ROOT}/schema/core/ferrum-core.yaml}"

if [[ -z "${FIXTURE}" ]]; then
  echo "Usage: $0 <fixture.yaml> [schema.yaml]" >&2
  exit 1
fi

if [[ ! -f "${FIXTURE}" ]]; then
  echo "Error: fixture not found: ${FIXTURE}" >&2
  exit 1
fi

if [[ ! -f "${SCHEMA}" ]]; then
  echo "Error: schema not found: ${SCHEMA}" >&2
  exit 1
fi

if ! command -v linkml-validate &>/dev/null; then
  echo "Error: linkml-validate not found. Install with: pip install linkml" >&2
  exit 1
fi

echo "Validating ${FIXTURE} against ${SCHEMA} ..."
linkml-validate -s "${SCHEMA}" "${FIXTURE}"
