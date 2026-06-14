# African Context

TODO: Document how ferrum-meta addresses genomics metadata needs across African
research settings — from university hospitals to rural field laboratories.

## Connectivity constraints

Many African genomics workflows operate with intermittent or absent internet.
ferrum-meta is designed so that:

- Metadata can be authored and validated entirely on local hardware
- Submission bundles sync to a Ferrum node when connectivity is available
- No live API calls are required during curation

## H3Africa and community consent

The [H3Africa profile](../schema/profiles/h3africa-profile.yaml) will encode
community consent models, biobank linkage, and tiered data sharing requirements
aligned with the H3Africa Consortium data sharing policy.

Reference: `ferrum-meta-sources/eva-h3africa-ga4gh-fega/papers/h3africa-data-sharing-policy.pdf`

## Pathogen surveillance

The [pathogen profile](../schema/profiles/pathogen-profile.yaml) supports
public health genomics workflows relevant to Africa CDC and national surveillance
programmes.

Reference: `ferrum-meta-sources/eva-h3africa-ga4gh-fega/papers/africa-cdc-pathogen-paper.pdf`

## Ancestry and population descriptors

TODO: Integrate HANCESTRO and community-defined population descriptors without
imposing European-centric defaults.

## Language and localisation

TODO: Consider multilingual field labels and controlled vocabulary translations
for metadata capture interfaces (implementation in Ferrum UI, not in LinkML schema).

## Partnership model

ferrum-meta is developed in dialogue with African genomics communities. This
document will grow with stakeholder input during the consensus modelling phase.
