# ferrum-meta

ferrum-meta is the metadata schema layer for a world where every genomics
research institution - from a university hospital in Stuttgart to a field lab
in Nairobi - can be its own federated archive node, while participating
seamlessly in the global genomics data ecosystem.

## Overview

**ferrum-meta** is a public, archive-agnostic genomics metadata schema. It defines
a consensus minimum model and archive-specific profiles so that metadata can be
authored once and exchanged across GHGA, EGA/ENA, EVA, H3Africa, Africa CDC
pathogen workflows, dbGaP, and federated GA4GH/FEGA nodes.

- **License:** Apache 2.0
- **Schema language:** [LinkML](https://linkml.io/) (YAML-based, same convention as GHGA)
- **Runtime code:** none — pure schema, documentation, fixtures, and crosswalks

## Design principle

**Offline-first:** metadata can be captured, validated, and curated in African
field settings without reliable internet connectivity.

## Repository layout

| Path | Purpose |
|------|---------|
| `schema/core/` | Consensus minimum model (`ferrum-core.yaml`) |
| `schema/profiles/` | Archive-specific extensions (GHGA, EGA, H3Africa, …) |
| `schema/ontologies/` | Referenced ontology documentation |
| `fixtures/valid/` | Example instances that must pass validation |
| `fixtures/invalid/` | Negative test cases |
| `crosswalk/` | Field-level mappings between archives |
| `docs/` | Human-readable design and context documentation |
| `sources/` | Local clone instructions for upstream schemas (not committed) |
| `scripts/` | Validation and maintenance scripts |

## Getting started

1. Clone upstream reference schemas into `sources/` (see [sources/README.md](sources/README.md)).
2. Install LinkML tooling: `pip install linkml`
3. Validate a fixture: `./scripts/validate-fixture.sh fixtures/valid/TODO-minimal-submission.yaml`
4. Build docs: `mkdocs serve` (requires `pip install mkdocs-material`)

## Status

This repository is an initial scaffold. Schema classes, slots, and profiles are
marked with `TODO` placeholders pending consensus modelling (Prompt 3.x series).

## Related projects

- [Ferrum](https://github.com/SynapticFour/Ferrum) — federated archive node runtime
- Reference material index: `/Users/SynapticFour/devel/ferrum-meta-sources/SOURCES.md`

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
