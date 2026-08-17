# ferrum-meta

<p align="center"><strong>ferrum-meta</strong></p>

[![Validate](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml/badge.svg)](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![LinkML](https://img.shields.io/badge/schema-LinkML-orange.svg)](https://linkml.io/)

**Archive-agnostic genomics metadata for federated Ferrum nodes.**

ferrum-meta is a **Ferrum companion** (schema only — not sold separately) for archive-agnostic genomics metadata. Any
institution — from a university hospital in Stuttgart to a field lab in Nairobi —
can be its own federated archive node, while participating seamlessly in the global
genomics data ecosystem.

> **Scope:** Schema, documentation, fixtures, crosswalks, and a **starter CLI**
> (`scripts/ferrum_meta_cli.py`). `validate` checks YAML against the schema.
> `export` **copies a committed fixture file** (`shutil.copyfile`) and re-validates it —
> it does **not** talk to Ferrum, list DRS objects, or upload to EGA/GHGA.
> Live DRS ids: Ferrum `ferrum meta export` (without `--starter`).

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
| `schema/profiles/` | Archive extensions (GHGA, EGA, H3Africa, pathogen, EVA) |
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
make install   # creates .venv/ and installs linkml + mkdocs
make test
```

Requires **Python 3.10+** (`python3` on PATH). On macOS, Xcode Command Line Tools or
Homebrew Python is sufficient — a standalone `pip` command is not required.

Validate a single fixture:

```bash
./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-example.json
./scripts/validate-fixture.sh fixtures/valid/pathogen-sarscov2-kenya.json
```

### Export a GHGA or EGA starter bundle

```bash
./scripts/export-profile.sh ghga ./my-ghga-bundle.yaml
./scripts/export-profile.sh ega ./my-ega-bundle.yaml
./scripts/export-profile.sh h3africa ./my-h3africa-bundle.yaml
python3 scripts/ferrum_meta_cli.py export ghga ./my-ghga-bundle.yaml
python3 scripts/ferrum_meta_cli.py validate fixtures/valid/ega-minimal-submission.yaml
# same starter from Ferrum, if you already have the CLI:
#   ferrum meta export --profile ghga --output ./my-ghga-bundle.yaml --starter
# live DRS ids (needs a running node): ferrum meta export --profile ghga --output ./out.yaml
```

Replace aliases/checksums with your DRS objects, then re-run `validate-fixture.sh`.
dbGaP is **not** modelled here (stub removed). Use GHGA/EGA/H3Africa/pathogen/EVA.

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

dbGaP is out of scope until there is a real mapping (the stub profile was removed).

## Citation

> Cite the git tag of this repository. Schema **0.1.0** is dated **2026-06-14**. No Zenodo DOI has been issued — do not invent one. Live GHGA/EGA YAML with DRS object ids is `ferrum meta export` in Ferrum (this repo stays schema-only).

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

---

**Synaptic Four** · [contact@synapticfour.com](mailto:contact@synapticfour.com) · [synapticfour.com](https://synapticfour.com) · Apache-2.0 (free; Ferrum companion, not sold separately)
