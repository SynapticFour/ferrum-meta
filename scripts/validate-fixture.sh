#!/usr/bin/env bash
# Validate a ferrum-meta fixture against the core schema or an archive profile.
#
# Usage:
#   ./scripts/validate-fixture.sh <fixture.yaml> [schema.yaml] [target_class]
#
# Defaults:
#   schema.yaml   → inferred from fixture name when possible, else ferrum-core.yaml
#   target_class  → inferred from schema (FerrumCoreSubmission, GhgaProfileSubmission, …)
#
# Examples:
#   ./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-submission.yaml
#   ./scripts/validate-fixture.sh fixtures/valid/TODO-minimal-submission.yaml \
#       schema/core/ferrum-core.yaml FerrumCoreSubmission
#
# Requires: linkml-validate (pip install linkml)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE="${1:-}"
SCHEMA="${2:-}"
TARGET_CLASS="${3:-}"

if [[ -z "${FIXTURE}" ]]; then
  echo "Usage: $0 <fixture.yaml> [schema.yaml] [target_class]" >&2
  exit 1
fi

if [[ ! -f "${FIXTURE}" ]]; then
  echo "Error: fixture not found: ${FIXTURE}" >&2
  exit 1
fi

fixture_basename="$(basename "${FIXTURE}")"

if [[ -z "${SCHEMA}" ]]; then
  case "${fixture_basename}" in
    ghga-*)
      SCHEMA="${ROOT}/schema/profiles/ghga-profile.yaml"
      ;;
    ega-*)
      SCHEMA="${ROOT}/schema/profiles/ega-profile.yaml"
      ;;
    h3africa-*|h3a-*)
      SCHEMA="${ROOT}/schema/profiles/h3africa-profile.yaml"
      ;;
    pathogen-*|path-*)
      SCHEMA="${ROOT}/schema/profiles/pathogen-profile.yaml"
      ;;
    *)
      SCHEMA="${ROOT}/schema/core/ferrum-core.yaml"
      ;;
  esac
fi

if [[ ! -f "${SCHEMA}" ]]; then
  echo "Error: schema not found: ${SCHEMA}" >&2
  exit 1
fi

if [[ -z "${TARGET_CLASS}" ]]; then
  case "$(basename "${SCHEMA}")" in
    ghga-profile.yaml) TARGET_CLASS="GhgaProfileSubmission" ;;
    ega-profile.yaml)  TARGET_CLASS="EgaProfileSubmission" ;;
    eva-profile.yaml)  TARGET_CLASS="EvaProfileSubmission" ;;
    h3africa-profile.yaml) TARGET_CLASS="H3AfricaProfileSubmission" ;;
    pathogen-profile.yaml) TARGET_CLASS="PathogenProfileSubmission" ;;
    *)                 TARGET_CLASS="FerrumCoreSubmission" ;;
  esac
fi

if ! command -v linkml-validate &>/dev/null; then
  echo "Error: linkml-validate not found. Install with: pip install linkml" >&2
  exit 1
fi

echo "Validating ${FIXTURE} against ${SCHEMA} (target: ${TARGET_CLASS}) ..."
linkml-validate -s "${SCHEMA}" -C "${TARGET_CLASS}" "${FIXTURE}"
