# Architecture

ferrum-meta is a schema and a set of checks. It is not a server, and it does not open a connection to Ferrum.

## Pieces

- `schema/core/ferrum-core.yaml` is the shared minimum. The entities named there are Study, Individual, Sample, Experiment, File, and Dataset. The schema version in that file is 0.1.0.
- `schema/profiles/` adds the extra objects and constraints of one archive: GHGA, EGA, H3Africa, pathogen, and EVA.
- Crosswalk documents map fields from one profile toward another. They are text, not a live transfer.
- `scripts/validate-fixture.sh` runs LinkML validation on a YAML or JSON fixture.
- `export` in `scripts/ferrum_meta_cli.py` copies a starter fixture with `shutil.copyfile` and validates the copy. The command prints that the result is not live DRS and not archive acceptance.

Why the core is archive-agnostic, and why field capture comes before a network, is in [design-principles.md](design-principles.md). This page does not add a decision.

The published join for other repositories is git tag v0.1.0. The default branch may be ahead of that tag. See the repository [README](https://github.com/SynapticFour/ferrum-meta/blob/main/README.md).
