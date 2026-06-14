# H3Africa ↔ EGA Crosswalk

TODO: Field-level semantic mapping between ferrum-meta (H3Africa profile) and
EGA submission metadata, with emphasis on consent and community governance fields.

## Scope

| ferrum-meta (H3Africa profile) | H3Africa concept | EGA/ENA equivalent | Notes |
|--------------------------------|------------------|-------------------|-------|
| `community_consent_model` | H3Africa consent tier | EGA policy / consent | TODO |
| `biobank_id` | Biorepository ID | Sample source | TODO |
| `h3africa_project_code` | Project code | Study alias | TODO |
| `AccessConditions.consent_summary` | Community consent text | DAC documentation | TODO |

## Reference material

- H3Africa data archive paper: `ferrum-meta-sources/eva-h3africa-ga4gh-fega/papers/h3africa-data-archive-paper.pdf`
- H3Africa data sharing policy: `ferrum-meta-sources/eva-h3africa-ga4gh-fega/papers/h3africa-data-sharing-policy.pdf`
- HANCESTRO ontology: `ferrum-meta-sources/eva-h3africa-ga4gh-fega/hancestro/`

## Mapping rules

TODO: Document how community consent tiers map to EGA access policies and DUO terms.

## Validation

Each mapping row should be backed by at least one valid fixture pair in
`fixtures/valid/` once modelling is complete.
