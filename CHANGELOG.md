# Changelog

All notable changes to ferrum-meta will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Unified test runner (`scripts/run-tests.sh`, `make test`) and pinned dev dependencies
- SynapticFour stack doc (`docs/ECOSYSTEM.md`), contributing guide, Makefile, CI badge
- MkDocs symlinks for crosswalks and ontology docs (strict build in CI)

### Changed

- README aligned with SynapticFour GA4GH stack conventions
- Renamed `TODO-minimal-submission.yaml` → `ferrum-core-minimal-submission.yaml`
- Removed redundant `TODO-missing-required-fields.yaml` (superseded by JSON fixture)
- CI consolidated to single job running full validation suite

### Fixed

- `dbgap-profile.yaml`: inherit `FerrumCoreSubmission` (was invalid `FerrumSubmission`)
- `ega-profile.yaml`: `policy_url` range `uri` (was undefined `uritype`)

## [0.1.0] - 2026-06-14

### Added

- **ferrum-core** v0.1.0 — six entity types (Study, Individual, Sample, Experiment, File, Dataset)
- First-class `ConsentType.COMMUNITY` and `StudyType.PATHOGEN_GENOMICS`
- Sequencing platforms BGI/MGI and `BiospecimenType.BUCCAL_SWAB`
- Archive profiles: GHGA, EGA, EVA, H3Africa, pathogen (dbGaP stub)
- Crosswalks: GHGA ↔ EGA/SRA, H3Africa ↔ EGA Webin
- Fixtures: valid YAML/JSON per profile; invalid negative tests
- CI workflow: schema lint, JSON Schema generation, fixture validation, crosswalk checks
- Documentation: design principles, African context, FEGA compatibility, protocol references
- Validation scripts: `validate-fixture.sh`, `check-crosswalks.sh`, `run-tests.sh`
- SynapticFour stack integration: `docs/ECOSYSTEM.md`, contributing guide, Makefile

[Unreleased]: https://github.com/SynapticFour/ferrum-meta/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/SynapticFour/ferrum-meta/releases/tag/v0.1.0
