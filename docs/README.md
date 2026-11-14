# ferrum-meta documentation

ferrum-meta defines an archive-agnostic genomics metadata schema in LinkML, with profiles for major archives and federated node deployments.

Schema v0.1.0, with ferrum-core, six archive profiles, crosswalks, CI validation, and JSON fixtures. The reason for that shape is in [design-principles.md](design-principles.md).

| Artefact | What it is |
|----------|------------|
| [ferrum-core.yaml](https://github.com/SynapticFour/ferrum-meta/blob/main/schema/core/ferrum-core.yaml) | The shared minimum. |
| [profiles/](https://github.com/SynapticFour/ferrum-meta/tree/main/schema/profiles) | Archive-specific extensions. |

Every document under `docs/`, grouped as a tutorial, how-to guides, reference, and explanation. One line each. Some paths are links to files that live beside `docs/`. This file is the documentation home. MkDocs cannot keep a second `index.md` beside it.

## Tutorial

| Document | What it is |
|----------|------------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | Install, test, validate one fixture, and run `migrate-assist`. |

## How-to guides

| Document | What it is |
|----------|------------|
| [african-context.md](african-context.md) | Capture metadata before a network is available. |
| [fega-compatibility.md](fega-compatibility.md) | How the schema sits next to a federated EGA-style archive. |
| [contributing.md](contributing.md) | How to change the schema, the fixtures, and a pull request. |
| [sources.md](sources.md) | Where the modelled fields were taken from. |

## Reference

| Document | What it is |
|----------|------------|
| [protocol-references/README.md](protocol-references/README.md) | Upstream specifications this schema points at. |
| [crosswalk/ghga-ega-crosswalk.md](crosswalk/ghga-ega-crosswalk.md) | Field map from GHGA toward EGA. |
| [crosswalk/h3africa-ega-crosswalk.md](crosswalk/h3africa-ega-crosswalk.md) | Field map from H3Africa toward EGA. |
| [schema/referenced-ontologies.md](schema/referenced-ontologies.md) | Ontologies named by the schema. |

## Explanation

| Document | What it is |
|----------|------------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Core, profiles, checks, and what `export` actually copies. |
| [FOR-EVALUATORS.md](FOR-EVALUATORS.md) | No public status, the v0.1.0 tag, and what a pass is. |
| [design-principles.md](design-principles.md) | Why the core is archive-agnostic. |
| [ECOSYSTEM.md](ECOSYSTEM.md) | This schema beside Ferrum and ga4gh-infra. |

The repository README is [README.md](https://github.com/SynapticFour/ferrum-meta/blob/main/README.md) at the root.
