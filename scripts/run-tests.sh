#!/usr/bin/env bash
# Run all ferrum-meta validation checks (schemas, fixtures, crosswalks, docs).
#
# Usage: ./scripts/run-tests.sh [--skip-docs] [--verbose]
#
# Requires: make install

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

# shellcheck source=_env.sh
source "${ROOT}/scripts/_env.sh"

if [[ -d "${ROOT}/.venv/bin" ]]; then
  export PATH="${ROOT}/.venv/bin:${PATH}"
fi

SKIP_DOCS=false
VERBOSE=false
for arg in "$@"; do
  case "${arg}" in
    --skip-docs) SKIP_DOCS=true ;;
    --verbose) VERBOSE=true ;;
    *) echo "Unknown argument: ${arg}" >&2; exit 1 ;;
  esac
done

require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: ${1} not found. Run: make install" >&2
    exit 1
  fi
}

pass() {
  echo "  ok  $1"
}

fail() {
  echo "  FAIL  $1" >&2
}

run_capture() {
  local log
  log="$(mktemp)"
  if "$@" >"${log}" 2>&1; then
    rm -f "${log}"
    return 0
  fi
  cat "${log}" >&2
  rm -f "${log}"
  return 1
}

require_cmd linkml-lint
require_cmd linkml-validate
require_cmd linkml

echo "ferrum-meta validation"
echo

schema_count=0
while IFS= read -r schema_file; do
  ((schema_count++)) || true
  if [[ "${VERBOSE}" == true ]]; then
    echo "lint ${schema_file}"
    linkml-lint "${schema_file}"
  elif ! run_capture linkml-lint "${schema_file}"; then
    fail "lint ${schema_file}"
    exit 1
  fi
done < <(find schema -name '*.yaml' -print | sort)
pass "${schema_count} LinkML schemas"

mkdir -p build/json-schema
json_count=0
while IFS= read -r schema_file; do
  out="build/json-schema/$(basename "${schema_file}" .yaml).schema.json"
  ((json_count++)) || true
  if [[ "${VERBOSE}" == true ]]; then
    echo "json-schema ${schema_file} -> ${out}"
  fi
  if ! linkml generate json-schema "${schema_file}" > "${out}" 2>/dev/null; then
    fail "json-schema ${schema_file}"
    linkml generate json-schema "${schema_file}" >&2 || true
    exit 1
  fi
  if [[ ! -s "${out}" ]]; then
    fail "json-schema ${schema_file} (empty output)"
    exit 1
  fi
done < <(find schema -name '*.yaml' -print | sort)
pass "${json_count} JSON Schema artefacts"

shopt -s nullglob
valid_count=0
for fixture in fixtures/valid/*.{yaml,yml,json}; do
  ((valid_count++)) || true
  if [[ "${VERBOSE}" == true ]]; then
    ./scripts/validate-fixture.sh "${fixture}"
  elif ! run_capture ./scripts/validate-fixture.sh --quiet "${fixture}"; then
    fail "valid fixture ${fixture}"
    exit 1
  fi
done
pass "${valid_count} valid fixtures"

invalid_count=0
for fixture in fixtures/invalid/*.{yaml,yml,json}; do
  ((invalid_count++)) || true
  if [[ "${VERBOSE}" == true ]]; then
    echo "expect fail: ${fixture}"
    if ./scripts/validate-fixture.sh "${fixture}"; then
      fail "invalid fixture passed: ${fixture}"
      exit 1
    fi
  elif ./scripts/validate-fixture.sh --quiet "${fixture}" >/dev/null 2>&1; then
    fail "invalid fixture passed: ${fixture}"
    exit 1
  fi
done
pass "${invalid_count} invalid fixtures rejected"

if ! run_capture ./scripts/check-crosswalks.sh; then
  fail "crosswalk checks"
  exit 1
fi
pass "crosswalk documentation"

if [[ "${SKIP_DOCS}" == false ]]; then
  require_cmd mkdocs
  if [[ "${VERBOSE}" == true ]]; then
    mkdocs build --strict
  elif ! run_capture mkdocs build --strict; then
    fail "mkdocs build"
    exit 1
  fi
  pass "documentation site"
fi

echo
echo "All checks passed."
