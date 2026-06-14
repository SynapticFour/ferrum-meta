# Design Principles

ferrum-meta exists because genomics metadata in Africa and other low-connectivity settings is
captured **before** it reaches an archive — often days or weeks before any network is available.
European archive schemas (GHGA, EGA) were designed for well-connected submitter portals. They
assume live ontology lookups, institutional IT teams, and re-keying data at each deposition step.

ferrum-meta inverts that assumption: **one canonical record, validated locally, exported anywhere.**

---

## 1. Archive-agnostic core

The consensus minimum lives in [`ferrum-core.yaml`](https://github.com/SynapticFour/ferrum-meta/blob/main/schema/core/ferrum-core.yaml). It is
independent of any single archive's naming, required fields, or submission portal quirks.

Archive-specific requirements are added through **profiles**, not forks:

| Layer | Role |
|-------|------|
| `ferrum-core` | Minimum fields shared across GHGA, EGA/SRA, FAIR Genomes, and H3Africa |
| `ghga-profile`, `ega-profile`, … | Extensions for a target archive's extra objects and constraints |
| Crosswalks | Field-by-field export maps (see [crosswalk/](crosswalk/ghga-ega-crosswalk.md)) |

A GHGA submission record can export to EGA without re-entering metadata. The core entities
(Study, Individual, Sample, Experiment, File, Dataset) stay stable; the transpiler applies
profile-specific and archive-specific mappings at export time.

**Why this matters:** A Ferrum node at a Kenyan hospital may need GHGA compatibility for a
European collaboration today and EGA deposition via H3ABioNet tomorrow. Re-curation is not
acceptable when consent, phenotype, and file checksums were captured once in the field.

---

## 2. African context as a first-class requirement

African genomics workflows are not edge cases bolted onto a European schema. The following are
**core ferrum-meta fields**, not regional add-ons:

| Requirement | ferrum-meta location | Rationale |
|-------------|---------------------|-----------|
| Community consent | `ConsentType.COMMUNITY` in ferrum-core | H3Africa and many national ethics frameworks recognise community-level consent models |
| Pathogen surveillance | `StudyType.PATHOGEN_GENOMICS` in ferrum-core | Outbreak response is a primary use case across Africa CDC member states |
| BGI / MGI sequencing | `SequencingPlatform.BGI`, `MGI` in ferrum-core | DNBSEQ platforms are widely deployed in African sequencing centres |
| Buccal swab collection | `BiospecimenType.BUCCAL_SWAB` in ferrum-core | Common in field collection where venipuncture is impractical |
| Ancestry descriptors | `Individual.ancestry` (HANCESTRO / AfPO CURIEs) | Population genomics without European-centric defaults |
| Offline validation | All profiles | No live API calls required during curation |

HANCESTRO defers detailed African population terminology to the [African Population Ontology
(AfPO)](https://github.com/h3abionet/African-Population-Ontology). ferrum-meta accepts both
`HANCESTRO:` and `AfPO:` CURIEs in ancestry and population fields.

Community consent (`COMMUNITY`) has no direct GHGA slot. On export it maps to
`DUO:0000006` (Health/Medical/Biomedical research). See the
[GHGA ↔ EGA crosswalk](crosswalk/ghga-ega-crosswalk.md) for export notes.

---

## 3. Offline-first by design

A Ferrum node in a mobile lab in East Africa may have no internet for days. ferrum-meta is
built for that reality:

- **Single-file bundles** — YAML or JSON submission documents portable on USB or local disk
- **Local validation** — `linkml-validate` runs entirely on the node; no ontology resolver calls
- **Checksum integrity** — `File.checksum_md5` verified before upload
- **Queued submission** — metadata and files accumulate locally; export/upload runs when
  connectivity returns

This is a **core design requirement**, not a workaround for poor infrastructure. Field
sequencing, biobank accession, and ethics review often complete offline; metadata capture must
keep pace with sample processing, not with when EGA's Webin portal happens to respond.

---

## 4. FEGA-compatible by default

A Ferrum node implementing ferrum-meta satisfies the metadata layer of
[GA4GH Federated EGA (FEGA)](https://www.ga4gh.org/product/federated-ega/) requirements:

- Structured metadata with DUO-aligned access conditions
- Crypt4GH encryption metadata on controlled-access files (default `CRYPT4GH` for human data)
- Identifiers and relationships suitable for federation to upstream EGA services

FEGA membership and formal node registration are **optional accelerators**, not prerequisites
for operating a useful federated archive node. See [FEGA compatibility](fega-compatibility.md).

---

## 5. Citable and versionable

Every ferrum-meta release is:

- **Version-tagged** in git (`v0.1.0`, …)
- **Pinned** in submission bundles via `ferrum_meta_version`
- **Archived** on Zenodo with a DOI

**Citation format:**

> Senf A. (2026). ferrum-meta v0.1.0. Zenodo. https://doi.org/10.5281/zenodo.XXXXXX

Replace the DOI placeholder when the Zenodo record is published. Cite the specific version
used at submission time, not `main`.

---

## 6. Crosswalks, not conversions in-schema

Semantic field mappings live in [crosswalk/](crosswalk/ghga-ega-crosswalk.md) markdown documents. Runtime
transpilation (YAML/JSON → GHGA TSV, EGA Webin XML, ENA manifests) belongs in Ferrum tooling,
not in this schema-only repository.

---

## 7. LinkML as the lingua franca

ferrum-meta uses LinkML — the same schema language as GHGA — so existing tooling
(`linkml-validate`, `linkml generate json-schema`, `gen-pydantic`) works without adaptation.
Profiles import ferrum-core; validators and CI treat each schema file independently.

---

## 8. Separation of concerns

| Concern | Owner |
|---------|-------|
| Metadata schema | **ferrum-meta** (this repository) |
| GA4GH protocol specs | **GA4GH** upstream (DRS, Beacon, Passports, Crypt4GH, WES, TES) |
| Runtime services | **Ferrum** (node software, compass UI, transpilers, upload queue) |

These layers are deliberately independent. See [Protocol references](protocol-references/README.md).
