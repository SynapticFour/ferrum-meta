# ferrum-meta documentation

Welcome to the **ferrum-meta** documentation.

ferrum-meta defines an archive-agnostic genomics metadata schema in LinkML, with
profiles for major archives and federated node deployments.

## Contents

- [Design principles](design-principles.md) — offline-first, federation-ready modelling
- [African context](african-context.md) — field labs, connectivity, consent
- [FEGA compatibility](fega-compatibility.md) — GA4GH federated archive alignment
- [SynapticFour stack](ECOSYSTEM.md) — how ferrum-meta fits with Ferrum and ga4gh-infra
- [Contributing](contributing.md) — schema changes, fixtures, PR checklist
- [Protocol references](protocol-references/README.md) — upstream GA4GH specs
- [Crosswalks](crosswalk/ghga-ega-crosswalk.md) — field mappings between archives

## Schema artefacts

| File | Description |
|------|-------------|
| [ferrum-core.yaml](https://github.com/SynapticFour/ferrum-meta/blob/main/schema/core/ferrum-core.yaml) | Consensus minimum model |
| [profiles/](https://github.com/SynapticFour/ferrum-meta/tree/main/schema/profiles) | Archive-specific extensions |

## Status

Schema v0.1.0 with ferrum-core, six archive profiles, crosswalks, CI validation, and JSON
fixtures. See [Design principles](design-principles.md) for rationale and citation guidance.
