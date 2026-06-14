# ferrum-meta documentation

Welcome to the **ferrum-meta** documentation.

ferrum-meta defines an archive-agnostic genomics metadata schema in LinkML, with
profiles for major archives and federated node deployments.

## Contents

- [Design principles](design-principles.md) — offline-first, federation-ready modelling
- [African context](african-context.md) — field labs, connectivity, consent
- [FEGA compatibility](fega-compatibility.md) — GA4GH federated archive alignment
- [Protocol references](protocol-references/README.md) — upstream specs and papers
- [Crosswalks](../crosswalk/) — field mappings between archives

## Schema artefacts

| File | Description |
|------|-------------|
| [ferrum-core.yaml](../schema/core/ferrum-core.yaml) | Consensus minimum model |
| [profiles/](../schema/profiles/) | Archive-specific extensions |

## Status

Schema v0.1.0 with ferrum-core, six archive profiles, crosswalks, CI validation, and JSON
fixtures. See [Design principles](design-principles.md) for rationale and citation guidance.
