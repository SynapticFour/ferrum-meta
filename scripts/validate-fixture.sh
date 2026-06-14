#!/usr/bin/env bash
# Validate a ferrum-meta fixture against the core schema or an archive profile.
#
# Usage:
#   ./scripts/validate-fixture.sh <fixture> [schema.yaml] [target_class]
#
# Supports YAML and JSON fixtures. Schema and target class are inferred from the
# fixture filename when not provided.
#
# Requires: make install  (creates .venv with linkml)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -d "${ROOT}/.venv/bin" ]]; then
  export PATH="${ROOT}/.venv/bin:${PATH}"
fi

FIXTURE="${1:-}"
SCHEMA="${2:-}"
TARGET_CLASS="${3:-}"

if [[ -z "${FIXTURE}" ]]; then
  echo "Usage: $0 <fixture.yaml|fixture.json> [schema.yaml] [target_class]" >&2
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
    eva-*)
      SCHEMA="${ROOT}/schema/profiles/eva-profile.yaml"
      ;;
    h3africa-*|h3a-*)
      SCHEMA="${ROOT}/schema/profiles/h3africa-profile.yaml"
      ;;
    pathogen-*|path-*)
      SCHEMA="${ROOT}/schema/profiles/pathogen-profile.yaml"
      ;;
    ferrum-core-*|core-*)
      SCHEMA="${ROOT}/schema/core/ferrum-core.yaml"
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
    ghga-profile.yaml)     TARGET_CLASS="GhgaProfileSubmission" ;;
    ega-profile.yaml)      TARGET_CLASS="EgaProfileSubmission" ;;
    eva-profile.yaml)      TARGET_CLASS="EvaProfileSubmission" ;;
    h3africa-profile.yaml) TARGET_CLASS="H3AfricaProfileSubmission" ;;
    pathogen-profile.yaml) TARGET_CLASS="PathogenProfileSubmission" ;;
    *)                     TARGET_CLASS="FerrumCoreSubmission" ;;
  esac
fi

if ! command -v linkml-validate &>/dev/null; then
  echo "Error: linkml-validate not found. Run: make install" >&2
  exit 1
fi

echo "Validating ${FIXTURE} against ${SCHEMA} (target: ${TARGET_CLASS}) ..."
linkml-validate -s "${SCHEMA}" -C "${TARGET_CLASS}" "${FIXTURE}"
