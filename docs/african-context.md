# African Context

This document describes how ferrum-meta supports genomics workflows across African research
settings — from university hospitals and H3Africa biobanks to rural field laboratories and
national pathogen surveillance programmes.

English is the lingua franca of African science collaboration; this document is written in
English for cross-border use while acknowledging that **consent and participant-facing materials
must be in local languages** (recorded in `H3AfricaIndividual.language_of_consent`).

---

## H3Africa submission workflow

H3Africa data is deposited at **EGA via H3ABioNet**, not GHGA. The
[`h3africa-profile`](../schema/profiles/h3africa-profile.yaml) encodes the consortium's data
sharing policy, including the **9-month post-archival embargo** and mandatory ethics
documentation.

### Step-by-step using ferrum-meta

1. **Create a submission bundle** on the local Ferrum node (YAML or JSON). Set
   `ferrum_meta_version` to the schema version in use (e.g. `"0.1.0"`).

2. **Define the study** — `Study.alias`, `title`, `description`, `type` (typically
   `POPULATION_GENOMICS` for H3Africa cohorts).

3. **Record consent and ethics** — Add one or more `ConsentRecord` entries:
   - `consent_type` (`BROAD` or `COMMUNITY`)
   - `h3africa_release_date` — archival date + 9 months (Ferrum enforces release on this date)
   - `ethics_committee`, `ethics_approval_number`, `ethics_country` (ISO 3166-1 alpha-2)
   - `benefit_sharing_agreement: true` with agreement text in policy documentation
   - For `COMMUNITY` consent: `community_representatives` (required)

4. **Describe participants** — `H3AfricaIndividual` records with:
   - `country_of_recruitment`, `ancestry` / `population_group` (HANCESTRO or AfPO CURIEs)
   - `language_of_consent` (ISO 639-1, e.g. `sw`, `yo`, `zu`)
   - `consent_record_alias` linking to the governing `ConsentRecord`

5. **Link biospecimens and sequencing** — Standard ferrum-core `Sample`, `Experiment`, and
   `File` records. Human WGS typically uses `encryption: CRYPT4GH`.

6. **Define the dataset** — `Dataset` with `data_use_conditions` (commonly `DUO:0000006` for
   HMB under H3Africa controlled access).

7. **Validate locally** — Run `./scripts/validate-fixture.sh submission.yaml` (offline). Fix
   all errors before files leave the institution.

8. **Set workflow status** — `ega_submission_status`:
   - `IN_PREPARATION` while curating locally
   - `SUBMITTED_TO_H3ABIONET` when the package is sent for intake review
   - `ACCESSIONED_AT_EGA` once EGA accession is confirmed

9. **Hold embargo locally** — Ferrum stores data on-node until `h3africa_release_date`, then
   triggers federated release via H3ABioNet to EGA.

10. **Export** — Transpiler applies the [H3Africa ↔ EGA crosswalk](../crosswalk/h3africa-ega-crosswalk.md)
    to produce EGA JSON / Webin XML. No metadata re-entry.

See [`fixtures/valid/h3africa-minimal-submission.yaml`](../fixtures/valid/h3africa-minimal-submission.yaml)
for a complete valid example.

---

## Community consent

### Definition

**Community consent** is informed consent obtained at the level of a defined community — not
only from individual participants — where the community, through recognised representatives,
authorises collection, storage, and sharing of biospecimens and genomic data according to
agreed conditions.

This model appears in H3Africa guidance, many national ethics frameworks, and indigenous
health research protocols. It differs from **broad consent** (individual-level authorisation
for future research) and **specific consent** (limited to a defined study).

### Why ferrum-meta supports it

`ConsentType.COMMUNITY` is a first-class enum value in **ferrum-core**, not a H3Africa-only
extension. Any profile or archive export path must handle it explicitly rather than silently
dropping it.

European archives often lack a direct "community consent" field. ferrum-meta records the
consent model at source; crosswalks document export semantics (typically `DUO:0000006` HMB plus
free-text policy documentation).

### How to document community consent

In an H3Africa submission:

```yaml
consent_records:
  - alias: community_consent_001
    consent_type: COMMUNITY
    h3africa_release_date: "2027-06-01"
    community_representatives:
      - "Chief Medical Officer, District Health Board"
      - "Community Advisory Board Chair"
    ethics_committee: "National Health Research Ethics Committee (NHREC)"
    ethics_approval_number: "NHREC/01/01/2026-001"
    ethics_country: "NG"
    benefit_sharing_agreement: true

individuals:
  - alias: participant_001
    consent_type: COMMUNITY
    consent_record_alias: community_consent_001
    # ... other fields
```

Validators should reject `COMMUNITY` records without at least one `community_representative`.

---

## Pathogen surveillance use case

Pathogen genomics — SARS-CoV-2, Ebola, malaria drug-resistance, cholera — is time-critical.
Data are often **public** and destined for **ENA/GISAID**, not controlled-access EGA.

### Concrete deployment scenario

A sequencing lab at **KEMRI-Wellcome Trust** (Kenya) or **ACEGID** (Nigeria) runs a Ferrum
node on a **single server** (see [FEGA compatibility](fega-compatibility.md) — no data-steward
team required):

1. **Ingest** — Outbreak samples arrive; technologists enter metadata in Ferrum compass (or
   edit YAML/JSON directly).

2. **Validate offline** — `./scripts/validate-fixture.sh pathogen-sarscov2-kenya.json` confirms
   the [`pathogen-profile`](../schema/profiles/pathogen-profile.yaml) constraints locally.

3. **Sequence and checksum** — FASTQ files registered with MD5 checksums. Pathogen data uses
   `encryption: NONE` (public data; GHGA human export would reject this value).

4. **Queue** — Submission sits in the Ferrum upload queue while connectivity is absent.

5. **Submit when online** — Transpiler exports ENA Webin manifest; files upload to ENA.

Key fields: `Study.type: PATHOGEN_GENOMICS`, `PathogenSample.ncbi_taxon_id`,
`SurveillanceMetadata.lineage`, `collection_country`, `sequencing_lab`.

See [`fixtures/valid/pathogen-sarscov2-kenya.json`](../fixtures/valid/pathogen-sarscov2-kenya.json)
for a SARS-CoV-2 Nairobi example (taxon 2697049, lineage XBB.1.5, KEMRI-Wellcome Trust).

`Study.type: PATHOGEN_GENOMICS` exports to **ENA**, not EGA — documented in the
[GHGA ↔ EGA crosswalk](../crosswalk/ghga-ega-crosswalk.md).

---

## HANCESTRO African population terms

ferrum-meta references [HANCESTRO](http://purl.obolibrary.org/obo/HANCESTRO) for
`Individual.ancestry` and `H3AfricaIndividual.population_group`. Since v2023-06-21, HANCESTRO
imports detailed African population terms from the
[African Population Ontology (AfPO)](https://github.com/h3abionet/African-Population-Ontology).
Both `HANCESTRO:` and `AfPO:` CURIEs are valid.

**Ten terms most relevant to African genomics submissions:**

| CURIE | Label | Use when |
|-------|-------|----------|
| `HANCESTRO:0010` | African ancestry | Continental descriptor; insufficient detail for sub-region |
| `HANCESTRO:0011` | Sub-Saharan African | Broad sub-continental grouping (GWAS Catalog convention) |
| `AfPO:0000277` | Western African | Regional — Nigeria, Ghana, Senegal, etc. |
| `AfPO:0000188` | Eastern African | Regional — Kenya, Tanzania, Uganda, etc. |
| `AfPO:0000276` | Southern African | Regional — South Africa, Botswana, Zimbabwe, etc. |
| `AfPO:0000274` | Central African | Regional — DRC, Cameroon, CAR, etc. |
| `HANCESTRO:0544` | Nigerian | National demonym (HANCESTRO-maintained) |
| `HANCESTRO:0507` | Kenyan | National demonym |
| `AfPO:0000105` | Yoruba | Specific population — 1000 Genomes / H3Africa reference |
| `AfPO:0000056` | Maasai | Specific population — East African pastoralist reference |

Prefer the **most specific accurate term** available. Use AfPO for ethnic/population groups;
use HANCESTRO national demonyms when AfPO has no exact match. Raise new AfPO term requests at
the [AfPO GitHub tracker](https://github.com/h3abionet/African-Population-Ontology/issues).

---

## Ethics committee reference

Record the **full committee name** in `ConsentRecord.ethics_committee` and the **approval
reference number** in `ethics_approval_number`. Use `ethics_country` as ISO 3166-1 alpha-2.

| Country | Ethics / research governance body | Notes |
|---------|-----------------------------------|-------|
| **Nigeria** | National Health Research Ethics Committee (NHREC) | National oversight; institutional IRBs also operate under NHREC framework |
| **Kenya** | KEMRI Scientific and Ethics Review Unit (SERU) | KEMRI-affiliated studies; also **NACOSTI** for research licensing |
| **South Africa** | Human Research Ethics Committee (HREC) | Institutional HRECs registered with the National Health Research Ethics Council (NHREC SA) |
| **Ghana** | Ghana Health Service Ethics Review Committee (GHS-ERC) | Ministry of Health pathway; institutional IRBs for university hospitals |
| **Uganda** | UNCST (Uganda National Council for Science and Technology) | Research registration and clearance; **UVRI** REC for UVRI-affiliated infectious disease research |

This table is a **starting reference**, not legal advice. Always verify current national
requirements before submission.

---

## Pasteur Network deployment

The [Pasteur Network](https://pasteur-network.org/) operates genomic surveillance nodes across
Francophone and Lusophone Africa. **Institut Pasteur Dakar** (Senegal) exemplifies a Ferrum node
deployment:

- Field and laboratory teams capture pathogen metadata in French or English via Ferrum compass
- Local validation against `pathogen-profile` before any export
- ENA submission for outbreak data; controlled human data via EGA where applicable
- Integration with Africa CDC pathogen genomics initiatives and WHO reference laboratories

Institut Pasteur Dakar's existing sequencing infrastructure (including mobile lab capacity)
maps directly to the offline-first queue-and-upload model described above.

---

## Benefit sharing

H3Africa policy requires **documented benefit sharing arrangements** before data release from
embargo. ferrum-meta captures this structurally:

| Field | Type | Requirement |
|-------|------|-------------|
| `ConsentRecord.benefit_sharing_agreement` | boolean | Must be `true` for H3Africa submissions |
| Policy / DAP text | free text (export) | Describe the agreement: capacity building, IP, community return of results, etc. |

The boolean flag enables automated CI and pre-submission checks. The substantive agreement text
belongs in the data access policy body exported to EGA (`policyDescriptor.policyText` per the
[H3Africa crosswalk](../crosswalk/h3africa-ega-crosswalk.md)).

Example benefit-sharing elements to document:

- Training placements for community laboratory technicians
- Shared authorship policy with community investigators
- Return of aggregate (not individual) findings to community representatives
- Local infrastructure investment tied to the project

---

## Connectivity and partnership

ferrum-meta is developed in dialogue with African genomics communities. The schema encodes
requirements discovered in H3Africa, GHGA crosswalk, and field deployment feedback — not
imported wholesale from any single European archive.

For implementation guidance (Ferrum node setup, compass UI, transpilers), see sibling Ferrum
repositories. This repository provides the **metadata contract** those tools enforce.
