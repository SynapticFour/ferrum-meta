#!/usr/bin/env bash
# Verify crosswalk markdown files exist, are non-empty, and mention required entities.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_file_nonempty() {
  local file="$1"
  if [[ ! -s "${file}" ]]; then
    echo "ERROR: crosswalk file missing or empty: ${file}" >&2
    return 1
  fi
}

check_entities() {
  local file="$1"
  shift
  local missing=()
  for entity in "$@"; do
    if ! grep -q "${entity}" "${file}"; then
      missing+=("${entity}")
    fi
  done
  if ((${#missing[@]} > 0)); then
    echo "ERROR: ${file} missing entity references: ${missing[*]}" >&2
    return 1
  fi
}

GHGA_EGA="${ROOT}/crosswalk/ghga-ega-crosswalk.md"
H3A_EGA="${ROOT}/crosswalk/h3africa-ega-crosswalk.md"

check_file_nonempty "${GHGA_EGA}"
check_file_nonempty "${H3A_EGA}"

check_entities "${GHGA_EGA}" \
  FerrumCoreSubmission GhgaProfileSubmission Study Individual Sample Experiment File Dataset \
  DataAccessCommittee DataAccessPolicy GhgaDataset GhgaIndividual GhgaAnalysis

check_entities "${H3A_EGA}" \
  H3AfricaProfileSubmission ConsentRecord H3AfricaIndividual Study Sample Experiment File Dataset
