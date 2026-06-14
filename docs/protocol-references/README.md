# Protocol References

## GA4GH protocols (maintained upstream)

**ferrum-meta does not duplicate GA4GH protocol specifications.** DRS, Beacon, Passports,
Crypt4GH, WES, and TES are maintained by GA4GH working groups and evolve independently of
this metadata schema.

| Protocol | Purpose | Canonical specification |
|----------|---------|------------------------|
| **DRS** (Data Repository Service) | Standard API for access to data objects | https://github.com/ga4gh/data-repository-service-schemas |
| **Beacon v2** | Discovery API for genomic and phenotypic data | https://github.com/ga4gh-beacon/beacon-v2 |
| **Passports** | Authentication and authorisation (AAI) | https://github.com/ga4gh-duri/ga4gh-passports-portal |
| **Crypt4GH** | File encryption format for genomics | https://github.com/ga4gh/encryption-schemes |
| **WES** (Workflow Execution Service) | Standard API for workflow execution | https://github.com/ga4gh/workflow-execution-service-schemas |
| **TES** (Task Execution Service) | Standard API for batch task execution | https://github.com/ga4gh/task-execution-schemas |

Additional GA4GH products relevant to federated archives:

| Product | URL |
|---------|-----|
| Federated EGA (FEGA) | https://www.ga4gh.org/product/federated-ega/ |
| DUO (Data Use Ontology) | http://purl.obolibrary.org/obo/duo.owl |
| Phenopackets | https://github.com/phenopackets/phenopacket-schema |

---

## Separation of concerns

Three layers, three owners:

```
┌─────────────────────────────────────────────────────────┐
│  ferrum-meta          Metadata schema (this repo)       │
│  Study, Sample, File, Dataset, DUO, consent, …          │
└──────────────────────────┬──────────────────────────────┘
                           │ validates & describes
┌──────────────────────────▼──────────────────────────────┐
│  GA4GH protocols      Interoperability standards        │
│  DRS · Beacon v2 · Passports · Crypt4GH · WES · TES     │
└──────────────────────────┬──────────────────────────────┘
                           │ implemented by
┌──────────────────────────▼──────────────────────────────┐
│  Ferrum               Runtime (sibling repositories)    │
│  Node · compass UI · transpilers · upload queue         │
└─────────────────────────────────────────────────────────┘
```

- **ferrum-meta** — *What* metadata must be captured and how it is structured
- **GA4GH** — *How* nodes discover, authenticate, encrypt, and serve data
- **Ferrum** — *Where* metadata is authored, validated, stored, and exported

Do not embed protocol endpoint definitions in LinkML schema files. Crosswalks map metadata
fields to archive submission formats; protocol bindings live in Ferrum service configuration.

---

## Archive metadata schemas (modelling sources)

ferrum-core and profiles were derived from these upstream archive schemas. Clone into
`ferrum-meta-sources/` per [`sources/README.md`](../../sources/README.md) (local symlinks;
not committed to git).

| Archive | Repository | Used for |
|---------|------------|----------|
| GHGA | [ghga-metadata-schema](https://github.com/ghga-de/ghga-metadata-schema) | `ghga-profile`, GHGA crosswalk |
| EGA | [ega-metadata-schema](https://github.com/EbiEga/ega-metadata-schema) | `ega-profile`, H3Africa → EGA crosswalk |
| ENA Webin | [webin-xml](https://github.com/enasequence/webin-xml) | Pathogen → ENA export |
| FAIR Genomes | [fairgenomes-semantic-model](https://github.com/fairgenomes/fairgenomes-semantic-model) | Core field consensus |

---

## Ontologies referenced by ferrum-meta

| Ontology | Prefix | Role |
|----------|--------|------|
| HANCESTRO | `HANCESTRO:` | Ancestry descriptors |
| AfPO | `AfPO:` | African population terms (imported by HANCESTRO) |
| DUO | `DUO:` | Data use conditions |
| HPO | `HP:` | Phenotype terms |

See [`schema/ontologies/referenced-ontologies.md`](../../schema/ontologies/referenced-ontologies.md).

---

## Papers and policies

Reference PDFs in the local source bundle (`ferrum-meta-sources/`):

| Document | Relevance |
|----------|-----------|
| H3Africa Data Sharing Policy (April 2020) | `h3africa-profile` embargo and consent |
| H3Africa data archive paper | EGA via H3ABioNet workflow |
| GHGA crosswalk paper | GHGA ↔ EGA field alignment |
| Africa CDC pathogen genomics paper | `pathogen-profile` use cases |

Full inventory: `ferrum-meta-sources/SOURCES.md` (local clone only).

---

## Adding references

When a new upstream spec informs ferrum-meta modelling:

1. Add a row to the appropriate table above with a one-line note on affected slots or profiles
2. Update crosswalks if export semantics change
3. Do **not** copy GA4GH protocol text into this repository — link to the canonical URL
