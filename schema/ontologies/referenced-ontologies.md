# Referenced Ontologies

ferrum-meta references standard biomedical ontologies via OBO Foundry PURLs and
CURIE prefixes. Validation uses pattern constraints and enum values — **no live
ontology resolution** is required during offline validation.

Follow GHGA conventions for `default_curi_maps` (`obo_context`, `semweb_context`).

## Ontologies in use (v0.1.0)

| Ontology | Prefix | Used for | Schema location |
|----------|--------|----------|-----------------|
| DUO | `DUO:` | Data use conditions on datasets and policies | `Dataset.data_use_conditions`, DAP fields |
| HPO | `HP:` | Phenotype terms on individuals | `Individual.phenotype` (pattern `^HP:\d{7}$`) |
| HANCESTRO | `HANCESTRO:` | Ancestry and geographical region | `Individual.ancestry`, `GhgaIndividual.geographical_region` |
| AfPO | `AfPO:` | African population terms (imported by HANCESTRO) | `H3AfricaIndividual.population_group` |

## Planned references

| Ontology | Prefix | Used for | Status |
|----------|--------|----------|--------|
| EFO | `EFO:` | Experimental factors, assay types | Planned |
| OBI | `OBI:` | Sample and specimen types | Partially covered by ferrum enums |
| EDAM | `format:`, `topic:` | File formats and domains | Partially covered by `FileFormat` enum |
| GENEPIO | `GENEPIO:` | Pathogen surveillance fields | Planned for pathogen profile expansion |
| NCIT | `NCIT:` | Disease and anatomy terms | Planned |
| GSSO | `GSSO:` | Sex and gender (where applicable) | Planned |

## HANCESTRO and AfPO

Since HANCESTRO v2023-06-21, detailed African population terminology is maintained in
[AfPO](https://github.com/h3abionet/African-Population-Ontology) and imported into
HANCESTRO. ferrum-meta accepts both prefix styles in ancestry and population fields.

See [African context — HANCESTRO terms](../african-context.md#hancestro-african-population-terms).

## Version pinning policy

- Submission bundles record `ferrum_meta_version` (schema semver), not ontology versions
- Slot patterns (e.g. HPO seven-digit IDs, ISO country codes) enforce structural validity offline
- Ferrum runtime may optionally resolve PURLs against pinned ontology releases
- Bundled ontology copies for offline use may be maintained in the local source bundle
  (`ferrum-meta-sources/`) — not committed to this repository

## Local copies

Pre-downloaded ontology files may be available in the consolidated source bundle:

- `ferrum-meta-sources/eva-h3africa-ga4gh-fega/ontologies/`
- `ferrum-meta-sources/eva-h3africa-ga4gh-fega/DUO/`

See [Source clones](../sources.md) for clone instructions.
