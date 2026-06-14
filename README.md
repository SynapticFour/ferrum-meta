# ferrum-meta

<p align="center"><strong>ferrum-meta</strong></p>

[![Validate](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml/badge.svg)](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![LinkML](https://img.shields.io/badge/schema-LinkML-orange.svg)](https://linkml.io/)

**Archive-agnostic genomics metadata for federated Ferrum nodes.**

ferrum-meta is the metadata schema layer for a world where every genomics research
institution — from a university hospital in Stuttgart to a field lab in Nairobi —
can be its own federated archive node, while participating seamlessly in the global
genomics data ecosystem.

> **Scope:** This repository contains schema, documentation, fixtures, and crosswalks
> only. Validators, transpilers, and upload queues live in
> [Ferrum](https://github.com/SynapticFour/Ferrum).

## SynapticFour GA4GH stack

ferrum-meta is the **metadata plane**. See **[docs/ECOSYSTEM.md](docs/ECOSYSTEM.md)**
for ga4gh-infra (identity), Ferrum (data/compute), Lab Kit, Demo, and HelixTest.

| Layer | Repository | This repo's role |
|-------|------------|------------------|
| Identity | [ga4gh-infra](https://github.com/SynapticFour/ga4gh-infra) | DUO terms in `Dataset.data_use_conditions` |
| Data/compute | [Ferrum](https://github.com/SynapticFour/Ferrum) | Native metadata format for Ferrum nodes |
| **Metadata** | **ferrum-meta** | LinkML core + archive profiles |
| Deployment | [Ferrum-Lab-Kit](https://github.com/SynapticFour/Ferrum-Lab-Kit) | Field-edge validation before upload |
| Conformance | [HelixTest](https://github.com/SynapticFour/HelixTest) | Complementary — API tests, not schema |

## Design principle

**Offline-first:** metadata can be captured, validated, and curated in African field
settings without reliable internet connectivity. See
[docs/design-principles.md](docs/design-principles.md).

## Repository layout

| Path | Purpose |
|------|---------|
| `schema/core/` | Consensus minimum model (`ferrum-core.yaml` v0.1.0) |
| `schema/profiles/` | Archive extensions (GHGA, EGA, H3Africa, pathogen, EVA, dbGaP stub) |
| `schema/ontologies/` | Referenced ontology documentation |
| `fixtures/valid/` | Examples that must pass validation |
| `fixtures/invalid/` | Negative test cases (CI must reject) |
| `crosswalk/` | Field-level mappings between archives |
| `docs/` | Design rationale, African context, FEGA alignment |
| `sources/` | Local clone instructions for upstream schemas (not committed) |
| `scripts/` | Validation and test scripts |

## Quick start

```bash
git clone https://github.com/SynapticFour/ferrum-meta.git
cd ferrum-meta
make install
make test
```

Validate a single fixture:

```bash
./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-example.json
./scripts/validate-fixture.sh fixtures/valid/pathogen-sarscov2-kenya.json
```

Build documentation:

```bash
make docs && mkdocs serve   # browse at http://127.0.0.1:8000
```

Optional: clone upstream reference schemas into `sources/` — see
[sources/README.md](sources/README.md).

## Schema artefacts

| Profile | Target archive | Submission class |
|---------|----------------|------------------|
| `ferrum-core.yaml` | Archive-agnostic minimum | `FerrumCoreSubmission` |
| `ghga-profile.yaml` | GHGA | `GhgaProfileSubmission` |
| `ega-profile.yaml` | EGA | `EgaProfileSubmission` |
| `h3africa-profile.yaml` | EGA via H3ABioNet | `H3AfricaProfileSubmission` |
| `pathogen-profile.yaml` | ENA / GISAID | `PathogenProfileSubmission` |
| `eva-profile.yaml` | EVA | `EvaProfileSubmission` |
| `dbgap-profile.yaml` | dbGaP (stub) | `DbGaPProfileSubmission` |

## Status

**v0.1.0** — ferrum-core with six implemented profiles, crosswalks, CI validation,
and JSON/YAML fixtures. dbGaP profile is a stub pending consensus modelling.

## Citation

> Senf A. (2026). ferrum-meta v0.1.0. Zenodo. https://doi.org/10.5281/zenodo.XXXXXX

(DOI placeholder — assign on first Zenodo release.)

## Documentation

| Topic | Link |
|-------|------|
| Design principles | [docs/design-principles.md](docs/design-principles.md) |
| African context | [docs/african-context.md](docs/african-context.md) |
| FEGA compatibility | [docs/fega-compatibility.md](docs/fega-compatibility.md) |
| Stack overview | [docs/ECOSYSTEM.md](docs/ECOSYSTEM.md) |
| Contributing | [docs/contributing.md](docs/contributing.md) |
| Crosswalks | [crosswalk/](crosswalk/) |

## License

Copyright 2026 SynapticFour. Licensed under the Apache License, Version 2.0.
See [LICENSE](LICENSE).
