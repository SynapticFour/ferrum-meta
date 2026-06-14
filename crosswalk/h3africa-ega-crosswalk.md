# H3Africa ↔ EGA Crosswalk

Field-by-field mapping from ferrum-meta `h3africa-profile` to EGA JSON metadata
and Webin-CLI XML submission fields. H3Africa data flows through **H3ABioNet** to
**EGA** — never to GHGA.

Sources: `schema/profiles/h3africa-profile.yaml`, `schema/core/ferrum-core.yaml`,
`ega-metadata-schema/schemas/`, `webin-xml` SRA/EGA XSD schemas,
H3Africa Data Sharing Policy (April 2020).

## Policy notes

| Concept | ferrum-meta | EGA/Webin | Notes |
|---------|-------------|-----------|-------|
| 9-month embargo | `ConsentRecord.h3africa_release_date` | `approximateReleaseDate` (dataset) | Set to archival date + 9 months. Ferrum enforces automatic release. |
| Community consent | `ConsentType.COMMUNITY` | Policy text + `DUO:0000006` (HMB) | No direct EGA consent-type slot; document in `policyDescriptor.policyText`. |
| Benefit sharing | `ConsentRecord.benefit_sharing_agreement` | Policy documentation | Required by H3Africa policy; attach to DAP/policy text. |
| Target archive | `target_archive: EGA` | EGA submission endpoint | Always EGA via H3ABioNet intake. |

---

## H3AfricaProfileSubmission

| ferrum-meta field | EGA JSON field | Webin XML element / attribute | Notes |
|-------------------|----------------|-------------------------------|-------|
| `ferrum_meta_version` | `schemaDescriptor.metaVersion` | — | |
| `studies` | Study object set | `<STUDY>` | Standard EGA study submission. |
| `individuals` | Individual object set | `<SUBMISSION>` individual refs | `H3AfricaIndividual` typed entries. |
| `samples` | Sample object set | `<SAMPLE>` | |
| `experiments` | Experiment object set | `<EXPERIMENT>` | |
| `files` | File descriptors | `<RUN>` / `<DATA_BLOCK>` | Crypt4GH expected for human WGS. |
| `datasets` | Dataset object set | `<DATASET>` | Controlled access under embargo. |
| `consent_records` | Policy / documentation bundle | `<POLICY>` + supporting docs | Ethics + consent metadata; see ConsentRecord. |
| `h3abionet_archive_id` | `objectId.centerName` (provisional) | `SUBMITTER_ID@namespace` | Assigned by H3ABioNet on intake. |
| `ega_submission_status` | — (Ferrum workflow) | — | Ferrum-local pipeline tracking, not EGA field. |
| `target_archive` | — | — | Always `EGA`; transpiler sets EGA endpoint. |

---

## ConsentRecord

| ferrum-meta field | EGA JSON field | Webin XML element / attribute | Notes |
|-------------------|----------------|-------------------------------|-------|
| `ConsentRecord.alias` | Policy `objectId.alias` | `<POLICY>` alias | Links ethics bundle to DAP. |
| `ConsentRecord.consent_type` | — | — | Default `BROAD` for H3Africa. **COMMUNITY**: document representatives in policy text; map to `DUO:0000006`. |
| `ConsentRecord.h3africa_release_date` | `approximateReleaseDate` | `<SUBMISSION>` release date attrs | **Embargo**: ingestion + 9 months per H3Africa policy. |
| `ConsentRecord.community_representatives` | — | Policy free text | Required when `consent_type=COMMUNITY`. List in `policyText`. |
| `ConsentRecord.ethics_committee` | — | Policy / study documentation | Ethics committee name in policy preamble. |
| `ConsentRecord.ethics_approval_number` | — | Study/DAC documentation | IRB/ERC approval reference. |
| `ConsentRecord.ethics_country` | — | Geographic provenance | ISO 3166-1 alpha-2 ethics jurisdiction. |
| `ConsentRecord.benefit_sharing_agreement` | — | `policyDescriptor.policyText` | Must be `true`; document agreement in policy body. |

---

## H3AfricaIndividual

| ferrum-meta field | EGA JSON field | Webin XML element / attribute | Notes |
|-------------------|----------------|-------------------------------|-------|
| `Individual.alias` | `objectId.alias` | Sample/individual alias refs | Inherits ferrum-core Individual mapping. |
| `Individual.sex` | `minimalPublicAttributes.biologicalSex` | — | |
| `Individual.phenotype` | `minimalPublicAttributes.phenotypicAbnormalities` | — | HP terms (`HP:XXXXXXX`). |
| `Individual.diagnosis` | `minimalPublicAttributes.diseases` | — | Map ICD-10 to MONDO/NCIT on export. |
| `Individual.ancestry` | — | — | Prefer `population_group` for H3Africa. |
| `Individual.consent_type` | — | Policy linkage | Default `BROAD`; see ConsentRecord. |
| `Individual.consent_code` | — | Policy reference | FK to consent registry / `ConsentRecord.alias`. |
| `H3AfricaIndividual.country_of_recruitment` | — | Geographic attribute | ISO alpha-2; include in sample/individual attrs. |
| `H3AfricaIndividual.language_of_consent` | — | Documentation metadata | ISO 639-1; store in policy/consent docs. |
| `H3AfricaIndividual.population_group` | — | Population descriptor | HANCESTRO term for ancestry reporting. |
| `H3AfricaIndividual.consent_record_alias` | Policy relationship | `<POLICY>` ref | FK to `ConsentRecord.alias`. |

---

## Inherited ferrum-core entities (H3Africa context)

H3Africa submissions use standard ferrum-core `Sample`, `Experiment`, `File`, and
`Dataset` entities. See [ghga-ega-crosswalk.md](ghga-ega-crosswalk.md) for
EGA/SRA field mappings (GHGA column ignored for H3Africa).

| Entity | H3Africa note |
|--------|---------------|
| `Sample` | Linked to `H3AfricaIndividual` via `individual_alias`. |
| `Experiment` | Standard WGS/RNA-seq mapping to EGA experiment + SRA experiment. |
| `File` | Crypt4GH default for human data; checksums required for offline integrity. |
| `Dataset` | `data_use_conditions` DUO terms; embargo via `ConsentRecord.h3africa_release_date`. |

---

## Workflow status (Ferrum-local)

| ferrum-meta `ega_submission_status` | Meaning |
|-------------------------------------|---------|
| `NOT_STARTED` | Local Ferrum node; metadata capture only. |
| `IN_PREPARATION` | Files staged locally during embargo period. |
| `SUBMITTED_TO_H3ABIONET` | Package transmitted to H3ABioNet for EGA review. |
| `ACCESSIONED_AT_EGA` | EGA accession assigned; countdown to `h3africa_release_date`. |
