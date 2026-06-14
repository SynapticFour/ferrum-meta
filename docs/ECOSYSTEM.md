# SynapticFour GA4GH stack

Six repositories implement a coherent on-premises GA4GH platform. This file is
**mirrored** across stack repos so readers can navigate between projects without
relearning structure.

**You are here:** [ferrum-meta](https://github.com/SynapticFour/ferrum-meta) —
metadata schema (LinkML core + archive profiles, crosswalks, fixtures).

## Repositories

| Repository | Role | License |
|------------|------|---------|
| [ga4gh-infra](https://github.com/SynapticFour/ga4gh-infra) | OIDC broker, visa registry, DUO, ADS, service registry | Apache-2.0 |
| [Ferrum](https://github.com/SynapticFour/Ferrum) | DRS, WES, TES, TRS, Beacon, htsget, Crypt4GH gateway | BUSL-1.1 |
| **ferrum-meta** | Archive-agnostic genomics metadata schema (this repo) | Apache-2.0 |
| [Ferrum-Lab-Kit](https://github.com/SynapticFour/Ferrum-Lab-Kit) | `lab-kit` profiles, compose generation, edge install | BUSL-1.1 |
| [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) | `./run` benchmark and co-deploy scenarios | Apache-2.0 |
| [HelixTest](https://github.com/SynapticFour/HelixTest) | `helixtest` conformance suite | Apache-2.0 |

## Ownership boundaries

| Layer | Owner | Notes |
|-------|--------|--------|
| Identity | **ga4gh-infra** | Broker, visas, DUO, ADS, service registry |
| Data/compute | **Ferrum** | DRS, WES/TES, TRS, Beacon; built-in passports in standalone mode |
| **Metadata** | **ferrum-meta** | LinkML schema, profiles, crosswalks — no runtime code |
| Deployment | **Ferrum-Lab-Kit** | Selective GA4GH surfaces for labs; does not fork Ferrum |
| Demo/benchmark | **Ferrum-GA4GH-Demo** | Reproducible GIAB benchmark; optional `--with-infra` |
| Conformance | **HelixTest** | Automated API and workflow tests |

ferrum-meta describes *what* metadata a Ferrum node stores and validates. Ferrum
implements *how* that metadata is served (DRS, Beacon, Passports). ga4gh-infra
implements *who* may access it. These layers are deliberately separate — see
[Design principles](design-principles.md) and [Protocol references](protocol-references/README.md).

## Metadata workflow

```
Field lab / sequencing centre
        │
        ▼
  ferrum-meta bundle (YAML/JSON)
        │  linkml-validate (offline)
        ▼
  Ferrum node (local queue + Crypt4GH storage)
        │  transpiler + crosswalk
        ▼
  Upstream archive (EGA, GHGA, ENA, EVA)
```

Archive profiles: `ghga-profile`, `ega-profile`, `h3africa-profile`,
`pathogen-profile`, `eva-profile`. See
[schema/profiles/](https://github.com/SynapticFour/ferrum-meta/tree/main/schema/profiles).

## Default co-deploy ports

| Service | Standalone Ferrum | Co-deploy (demo / lab) |
|---------|-------------------|-------------------------|
| Ferrum gateway | 8080 | 18080 (demo) or 8080 (lab) |
| AAI broker | — | 8180 |
| Visa registry | — | 8181 |
| DUO | — | 8182 |
| Service registry | — | 8183 |
| ADS | — | 8190 |
| mock-idp | — | 9100 |

## Local lifecycle (unified commands)

| Repository | Deploy | Stop | Destroy | Test |
|------------|--------|------|---------|------|
| **ga4gh-infra** | `make up` | `make down` | `make destroy` | `make test` |
| **Ferrum** | `make up` | `make down` | `make destroy` | `cargo test` |
| **ferrum-meta** | — | — | — | `make test` |
| **Ferrum-Lab-Kit** | `make up` | `make down` | `make destroy` | profile-specific |
| **Ferrum-GA4GH-Demo** | `make up` | `make down` | `make destroy` | `./run` |
| **HelixTest** | — | — | — | `helixtest --all` |

## Quick starts

**Validate metadata locally:**

```bash
cd ferrum-meta
make install && make test
./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-example.json
```

**Benchmark + co-deploy (demo):**

```bash
export FERRUM_SRC=/path/to/Ferrum
export GA4GH_INFRA_SRC=/path/to/ga4gh-infra
cd Ferrum-GA4GH-Demo && ./run --with-infra
```

**Field edge + infra (lab):**

```bash
cd Ferrum-Lab-Kit && ./install-edge.sh --with-infra
```

**Conformance:**

```bash
helixtest --all --mode ferrum
helixtest --all --mode ferrum+infra --profile ferrum-infra
```

## Documentation map

| Topic | Document |
|-------|----------|
| ferrum-meta design rationale | [design-principles.md](design-principles.md) |
| African field / H3Africa context | [african-context.md](african-context.md) |
| FEGA node compatibility | [fega-compatibility.md](fega-compatibility.md) |
| GA4GH protocol specs (upstream) | [protocol-references/README.md](protocol-references/README.md) |
| Ferrum ↔ ga4gh-infra wiring | [Ferrum GA4GH-INFRA-INTEGRATION.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/GA4GH-INFRA-INTEGRATION.md) |
| Africa-Mode (SQLite) | [Ferrum AFRICA-DEPLOYMENT.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/AFRICA-DEPLOYMENT.md) |

## CI

Each repository runs GitHub Actions on `main`. ferrum-meta validates LinkML schemas,
fixtures (positive and negative), crosswalk coverage, and MkDocs build (`make test`).
