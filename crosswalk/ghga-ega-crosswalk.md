# GHGA ↔ EGA/SRA Crosswalk

Field-by-field mapping from ferrum-meta (ferrum-core + ghga-profile) to GHGA
Metadata Schema v2.2.0 and EGA JSON / SRA-XML (Webin) equivalents.

Sources: `schema/core/ferrum-core.yaml`, `schema/profiles/ghga-profile.yaml`,
`ghga-metadata-schema/src/schema/submission.yaml`, `ega-metadata-schema/schemas/`.

## Special export cases

| ferrum-meta value | GHGA | EGA/SRA | Export note |
|-------------------|------|---------|-------------|
| `consent_type=COMMUNITY` | — | — | No GHGA equivalent. Map to `DUO:0000006` (HMB) on DAP export. |
| `Study.type=PATHOGEN_GENOMICS` | — | `studyTypes: metagenomics` (partial) | Not in GHGA StudyTypeEnum. Route to **ENA** public archive, not EGA human. |
| `File.encryption=NONE` | — (Crypt4GH required) | `unencryptedChecksum` | Valid in ferrum-meta; **not allowed** for GHGA human genomics export. |

---

## FerrumCoreSubmission / GhgaProfileSubmission

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `ferrum_meta_version` | — | `schemaDescriptor.metaVersion` | Schema version stamp; no GHGA slot. |
| `studies` | `Submission.studies` | `studyRelationships` (EGA.study.json) | Top-level study object set. |
| `individuals` | `Submission.individuals` | EGA Individual objects | GHGA uses `Individual`; EGA `EGA.individual.json`. |
| `samples` | `Submission.samples` | EGA Sample objects | EGA `EGA.sample.json`; SRA `SAMPLE` XML. |
| `experiments` | `Submission.experiments` | EGA Experiment objects | GHGA splits wet-lab metadata into `ExperimentMethod`. |
| `files` | `Submission.research_data_files` / `process_data_files` | `fileDescriptor` (EGA.common-definitions) | ferrum `File` maps to GHGA `ResearchDataFile` or `ProcessDataFile`. |
| `datasets` | `Submission.datasets` | EGA Dataset objects | EGA `EGA.dataset.json`. |
| `data_access_committees` | `Submission.data_access_committees` | EGA DAC objects | EGA `EGA.DAC.json`; Webin `DAC_SET` / `DAC`. |
| `data_access_policies` | `Submission.data_access_policies` | EGA Policy objects | EGA `EGA.policy.json`; Webin `POLICY`. |
| `analyses` | `Submission.analyses` | EGA Analysis objects | EGA `EGA.analysis.json`; GHGA pairs with `AnalysisMethod`. |

---

## Study

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `Study.alias` | `Study.alias` | `objectId.alias` | Submission-local identifier. |
| `Study.title` | `Study.title` | `objectTitle` | Max 500 chars in ferrum-meta. |
| `Study.description` | `Study.description` | `objectDescription` | Min 50 chars in ferrum-meta. |
| `Study.type` | `Study.types` | `studyTypes[]` | Enum mapping required (e.g. `WHOLE_GENOME_SEQUENCING` → `whole genome sequencing`). See special cases for `PATHOGEN_GENOMICS`. |

---

## Individual / GhgaIndividual

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `Individual.alias` | `Individual.alias` | `objectId.alias` | |
| `Individual.sex` | `Individual.sex` | `minimalPublicAttributes.biologicalSex` | GHGA `IndividualSexEnum`; EGA biological sex CV. |
| `Individual.phenotype` | `Individual.phenotypic_features_ids` | `minimalPublicAttributes.phenotypicAbnormalities[].phenotypicAbnormality` | HP terms (e.g. `HP:0001250`). |
| `Individual.diagnosis` | `Individual.diagnosis_ids` | `minimalPublicAttributes.diseases[].disease` | ferrum ICD-10; GHGA/EGA use ontology terms (MONDO/NCIT). |
| `Individual.ancestry` | `Individual.ancestry_ids` | — (study-level context) | HANCESTRO terms. |
| `Individual.consent_type` | — | — (policy scope) | **COMMUNITY**: no GHGA slot; export `DUO:0000006` HMB. |
| `Individual.consent_code` | — | Policy cross-reference | Links to consent form / DAP alias. |
| `GhgaIndividual.geographical_region` | `Individual.geographical_region_id` | — | NCIT country descendant or HANCESTRO geography. |

---

## Sample

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `Sample.alias` | `Sample.alias` | `objectId.alias` | SRA `SAMPLE@alias`. |
| `Sample.individual_alias` | `Sample.individual` | Individual relationship | FK to `Individual.alias`. |
| `Sample.tissue_type` | `Sample.biospecimen_tissue_term` | `sampleCollection.samplingSite` | UBERON/BRENDA anatomy. |
| `Sample.biospecimen_type` | `Sample.biospecimen_type` | `organismDescriptor` / material attributes | ferrum enum → GHGA `SampleTypeEnum` / EGA material CV. |

---

## Experiment

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `Experiment.alias` | `Experiment.alias` | `objectId.alias` | SRA `EXPERIMENT@alias`. |
| `Experiment.sample_alias` | `Experiment.sample` | Experiment–sample relationship | FK to `Sample.alias`. |
| `Experiment.sequencing_platform` | `ExperimentMethod.instrument_model` | `assayTechnology` | ferrum `ILLUMINA` → GHGA instrument enum / EGA technology term. |
| `Experiment.library_strategy` | `ExperimentMethod.library_selection_methods` | `experimentTypeSpecifications` / SRA `LIBRARY_STRATEGY` | e.g. `WGS` → SRA `WGS`. |
| `Experiment.library_source` | `ExperimentMethod.library_type` | `assayedBiologicalMacromolecule` / SRA `LIBRARY_SOURCE` | e.g. `GENOMIC` → SRA `GENOMIC`. |

---

## File

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `File.alias` | `ResearchDataFile.alias` / `File.alias` | `filename` | Logical alias; EGA uses filename in file descriptor. |
| `File.format` | `ResearchDataFile.format` | `filetype` | e.g. `FASTQ` → GHGA `FASTQ` / EGA `FASTQ`. |
| `File.checksum_md5` | — (validated at ingest) | `unencryptedChecksum` + `checksumMethod: MD5` | Required in ferrum-meta. |
| `File.checksum_sha256` | — | `unencryptedChecksum` + `checksumMethod: SHA-256` | Optional secondary checksum. |
| `File.size_bytes` | — | file size metadata | Optional in ferrum-meta. |
| `File.encryption` | — (Crypt4GH expected) | `encryptedChecksum` | `NONE` valid in ferrum-meta; **reject on GHGA human export**. |
| `File.drs_uri` | — | GA4GH DRS URI | Post-accession federated object store reference. |

---

## Dataset / GhgaDataset

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `Dataset.alias` | `Dataset.alias` | `objectId.alias` | |
| `Dataset.title` | `Dataset.title` | `objectTitle` | |
| `Dataset.description` | `Dataset.description` | `objectDescription` | |
| `Dataset.file_aliases` | `File.dataset` (inverse) | Dataset–file relationships | Files reference dataset via GHGA `File.dataset`. |
| `Dataset.data_use_conditions` | `DataAccessPolicy.data_use_permission_id` | Policy DUO terms | e.g. `DUO:0000004` no restriction. |
| `GhgaDataset.dap_alias` | `Dataset.data_access_policy` | Policy relationship | FK to `DataAccessPolicy.alias`. |
| `GhgaDataset.study_alias` | `Dataset.study` | Study relationship | FK to `Study.alias`. |

---

## DataAccessCommittee

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `DataAccessCommittee.alias` | `DataAccessCommittee.alias` | `objectId.alias` | Webin `DAC` submitter alias. |
| `DataAccessCommittee.name` | — (use `institute`) | `objectTitle` | ferrum explicit name; GHGA uses `institute`. |
| `DataAccessCommittee.main_contact` | `DataAccessCommittee.email` | `dacContacts.mainContact.email` | Institutional email only (ferrum constraint). |
| `DataAccessCommittee.members` | — | `dacContacts.additionalContacts[]` | ferrum extension; maps to EGA additional contacts. |
| `DataAccessCommittee.institutional_affiliation` | `DataAccessCommittee.institute` | Organization in contact block | |

---

## DataAccessPolicy

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `DataAccessPolicy.alias` | `DataAccessPolicy.alias` | `objectId.alias` | Webin `POLICY` alias. |
| `DataAccessPolicy.name` | `DataAccessPolicy.name` | `objectTitle` | |
| `DataAccessPolicy.description` | `DataAccessPolicy.description` | `objectDescription` | |
| `DataAccessPolicy.data_use_permission` | `DataAccessPolicy.data_use_permission_id` | Policy DUO permission term | e.g. `DUO:0000006`. |
| `DataAccessPolicy.data_use_modifiers` | `DataAccessPolicy.data_use_modifier_ids` | Policy DUO modifier terms | |
| `DataAccessPolicy.policy_text` | `DataAccessPolicy.policy_text` | `policyDescriptor.policyText` | Required in both GHGA and ferrum-meta. |
| `DataAccessPolicy.dac_alias` | `DataAccessPolicy.data_access_committee` | `DAC_REF` (Webin XML) | FK to DAC. |

---

## GhgaAnalysis

| ferrum-meta field | GHGA field (exact name) | EGA/SRA field (exact name) | Notes |
|-------------------|-------------------------|----------------------------|-------|
| `GhgaAnalysis.alias` | `Analysis.alias` | `objectId.alias` (EGAZ) | |
| `GhgaAnalysis.title` | `Analysis.title` | `objectTitle` | |
| `GhgaAnalysis.type` | `Analysis.type` | Analysis type descriptor | ferrum enum → GHGA analysis type CV. |
| `GhgaAnalysis.workflow_name` | `AnalysisMethod.workflow_name` | Workflow metadata | GHGA requires separate `AnalysisMethod` entity. |
| `GhgaAnalysis.workflow_version` | `AnalysisMethod.workflow_version` | Workflow version | Recommended in GHGA. |
| `GhgaAnalysis.input_file_aliases` | `Analysis.research_data_files` | Input file relationships | |
| `GhgaAnalysis.output_file_aliases` | `ProcessDataFile` (via `Analysis`) | Output file relationships | GHGA `ProcessDataFile.analysis`. |

---

## Enum quick reference (selected)

| ferrum-meta enum | GHGA enum / field | EGA/SRA equivalent |
|------------------|-------------------|---------------------|
| `StudyType.WHOLE_GENOME_SEQUENCING` | `StudyTypeEnum.WHOLE_GENOME_SEQUENCING` | `studyTypes: whole genome sequencing` |
| `StudyType.PATHOGEN_GENOMICS` | — | Route to ENA; partial `metagenomics` |
| `BiologicalSex.MALE` | `IndividualSexEnum.MALE` | `biologicalSex: male` |
| `BiospecimenType.BLOOD` | `SampleTypeEnum` / biospecimen CV | EGA material type |
| `SequencingPlatform.ILLUMINA` | `InstrumentModelEnum` | `assayTechnology` Illumina term |
| `LibraryStrategy.WGS` | `library_selection_methods` | SRA `LIBRARY_STRATEGY: WGS` |
| `LibrarySource.GENOMIC` | `library_type` | SRA `LIBRARY_SOURCE: GENOMIC` |
| `FileFormat.FASTQ` | `ResearchDataFileFormatEnum.FASTQ` | `filetype: FASTQ` |
| `EncryptionEnum.CRYPT4GH` | — (required practice) | `encryptedChecksum` |
| `EncryptionEnum.NONE` | — (not permitted) | `unencryptedChecksum` only |
