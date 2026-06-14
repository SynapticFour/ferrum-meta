#!/usr/bin/env bash
# Run all ferrum-meta validation checks (schemas, fixtures, crosswalks, docs).
#
# Usage: ./scripts/run-tests.sh [--skip-docs]
#
# Requires: pip install -r requirements-dev.txt

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

SKIP_DOCS=false
for arg in "$@"; do
  case "${arg}" in
    --skip-docs) SKIP_DOCS=true ;;
    *) echo "Unknown argument: ${arg}" >&2; exit 1 ;;
  esac
done

require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: ${1} not found. Install with: pip install -r requirements-dev.txt" >&2
    exit 1
  fi
}

require_cmd linkml-lint
require_cmd linkml-validate
require_cmd linkml

echo "=== Lint LinkML schemas ==="
while IFS= read -r schema_file; do
  echo "--- lint ${schema_file} ---"
  linkml-lint --ignore-warnings "${schema_file}"
done < <(find schema -name '*.yaml' -print | sort)

echo "=== Generate JSON Schema ==="
mkdir -p build/json-schema
while IFS= read -r schema_file; do
  out="build/json-schema/$(basename "${schema_file}" .yaml).schema.json"
  echo "--- ${schema_file} -> ${out} ---"
  linkml generate json-schema "${schema_file}" > "${out}"
  test -s "${out}"
done < <(find schema -name '*.yaml' -print | sort)

echo "=== Validate valid fixtures (expect pass) ==="
shopt -s nullglob
for fixture in fixtures/valid/*.{yaml,yml,json}; do
  echo "--- ${fixture} ---"
  ./scripts/validate-fixture.sh "${fixture}"
done

echo "=== Validate invalid fixtures (expect fail) ==="
for fixture in fixtures/invalid/*.{yaml,yml,json}; do
  echo "--- expecting failure: ${fixture} ---"
  if ./scripts/validate-fixture.sh "${fixture}"; then
    echo "ERROR: invalid fixture passed validation: ${fixture}" >&2
    exit 1
  fi
done

echo "=== Check crosswalks ==="
./scripts/check-crosswalks.sh

if [[ "${SKIP_DOCS}" == false ]]; then
  require_cmd mkdocs
  echo "=== Build documentation (mkdocs --strict) ==="
  mkdocs build --strict
fi

echo "All checks passed."
