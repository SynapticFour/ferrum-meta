# Changelog

All notable changes to ferrum-meta will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Commits on `main` after git tag **v0.1.0** (`e34fce4`). Schema YAML for the published join is unchanged; later commits are docs/CLI honesty. Consumers should pin **v0.1.0**, not `main`.

### Changed

- README: CLI `export` is `shutil.copyfile` of committed fixtures + validate — not a live DRS export.

### Added

- `scripts/ferrum_meta_cli.py` — `validate` / `export ghga|ega|h3africa` starter bundles (not archive upload).
- `scripts/export-profile.sh` — GHGA/EGA/H3Africa **starter** bundle. Live DRS ids belong in the consuming product CLI, not this schema repo.

## [0.1.0] - 2026-08-01

Git tag `v0.1.0` peels to `e34fce4920d249fa69109a6d0600123901832eba`. Schema version in YAML remains 0.1.0 (first dated 2026-06-14).

### Added

- **ferrum-core** v0.1.0 — six entity types (Study, Individual, Sample, Experiment, File, Dataset)
- First-class `ConsentType.COMMUNITY` and `StudyType.PATHOGEN_GENOMICS`
- Sequencing platforms BGI/MGI and `BiospecimenType.BUCCAL_SWAB`
- Archive profiles: GHGA, EGA, EVA, H3Africa, pathogen
- Crosswalks: GHGA ↔ EGA/SRA, H3Africa ↔ EGA Webin
- Fixtures: valid YAML/JSON per profile; invalid negative tests
- CI workflow: schema lint, JSON Schema generation, fixture validation, crosswalk checks
- Documentation: design principles, African context, FEGA compatibility, protocol references
- Validation scripts: `validate-fixture.sh`, `check-crosswalks.sh`, `run-tests.sh`

[Unreleased]: https://github.com/SynapticFour/ferrum-meta/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/SynapticFour/ferrum-meta/releases/tag/v0.1.0
