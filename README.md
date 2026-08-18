# ferrum-meta

[![Validate](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml/badge.svg)](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![LinkML](https://img.shields.io/badge/schema-LinkML-orange.svg)](https://linkml.io/)

Archive-agnostic genomics metadata schema for Ferrum nodes (LinkML core + archive profiles).

**Maturity: Early access.** Ferrum companion — schema only. `validate` checks YAML against the schema. `export` **copies a committed fixture file** (`shutil.copyfile`) and re-validates it — it does **not** talk to Ferrum, list DRS objects, or upload to EGA/GHGA. Live DRS ids: Ferrum `ferrum meta export` (without `--starter`).

These public repositories are maintained by the same organisation and are designed to work together. Each repository keeps its own version and license. For details on roles, maturity, and how the components relate to one another, see [SUITE-OVERVIEW](https://github.com/SynapticFour/.github/blob/main/profile/SUITE-OVERVIEW.md).

## Quick start

```bash
make install   # creates .venv/ and installs linkml + mkdocs
make test
```

Requires Python 3.10+. Validate a fixture: `./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-example.json`. Starter export: `./scripts/export-profile.sh ghga ./my-ghga-bundle.yaml`.

dbGaP is not modelled here. Use GHGA/EGA/H3Africa/pathogen/EVA.

Schema **0.1.0** (dated **2026-06-14**). Git tag **v0.1.0** peels to `e34fce4920d249fa69109a6d0600123901832eba` — that is the published join consumers vendor. `main` may be ahead (docs/CLI honesty). No Zenodo DOI has been issued — do not invent one.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
