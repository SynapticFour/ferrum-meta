# Referenced Ontologies

TODO: Document all ontologies referenced by ferrum-core and archive profiles.

This file will list ontology IRIs, preferred versions, and usage within ferrum-meta
slots. Follow GHGA conventions for `default_curi_maps` and OBO Foundry PURLs.

## Planned references

| Ontology | Prefix | Used for | Status |
|----------|--------|----------|--------|
| DUO | `DUO:` | Data use ontology — access conditions | TODO |
| EFO | `EFO:` | Experimental factors, assay types | TODO |
| OBI | `OBI:` | Sample and specimen types | TODO |
| EDAM | `format:`, `topic:` | File formats and domains | TODO |
| HANCESTRO | `HANCESTRO:` | Ancestry descriptors (H3Africa profile) | TODO |
| GENEPIO | `GENEPIO:` | Pathogen surveillance fields | TODO |
| NCIT | `NCIT:` | Disease and anatomy terms | TODO |
| GSSO | `GSSO:` | Sex and gender (where applicable) | TODO |

## Version pinning policy

TODO: Define how ferrum-meta pins ontology release versions for offline validation
(e.g. bundled OWL/JSON copies vs. PURL resolution).

## Local copies

Pre-downloaded ontology files may be available in the consolidated source bundle:

- `ferrum-meta-sources/eva-h3africa-ga4gh-fega/ontologies/`
- `ferrum-meta-sources/eva-h3africa-ga4gh-fega/DUO/`

See [sources/README.md](../../sources/README.md) for clone instructions.
