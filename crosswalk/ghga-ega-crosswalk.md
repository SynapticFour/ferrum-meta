# GHGA ↔ EGA Crosswalk

TODO: Field-level semantic mapping between ferrum-meta (GHGA profile) and
EGA/ENA submission metadata.

## Scope

| ferrum-meta (GHGA profile) | GHGA schema | EGA/ENA equivalent | Notes |
|----------------------------|-------------|-------------------|-------|
| `Project.title` | `Project.title` | Study title | TODO |
| `Project.description` | `Project.description` | Study description | TODO |
| `Sample.sample_id` | `Biosample.alias` | Sample alias | TODO |
| `AccessConditions.duo_terms` | `DataAccessCommittee` / DUO | EGA policy / DUO | TODO |
| `ghga_accession` | GHGA accession fields | EGA study ID | TODO |

## Reference material

- GHGA crosswalk paper: `ferrum-meta-sources/ghga/papers/ghga-crosswalk-paper.pdf`
- GHGA schema: `sources/ghga-metadata-schema/src/schema/submission.yaml`
- EGA schema: `sources/ega-metadata-schema/`

## Mapping rules

TODO: Define cardinality, transform functions, and lossy vs. lossless mappings.

## Validation

Each mapping row should be backed by at least one valid fixture pair in
`fixtures/valid/` once modelling is complete.
