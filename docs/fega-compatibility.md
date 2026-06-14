# FEGA Compatibility

TODO: Document alignment between ferrum-meta and the GA4GH Federated EGA (FEGA)
ecosystem.

## Goals

ferrum-meta metadata should be consumable by FEGA nodes (e.g. ELIXIR Norway SDA,
GDI Germany starter kit) without loss of semantic intent when federating with
EGA central services.

## Reference implementations

Pre-cloned in `ferrum-meta-sources/`:

| Component | Path |
|-----------|------|
| ELIXIR Norway SDA | `eva-h3africa-ga4gh-fega/neicnordic-sda/sensitive-data-archive/` |
| GDI metadata | `eva-h3africa-ga4gh-fega/gdi/gdi-metadata/` |
| GDI starter kit | `eva-h3africa-ga4gh-fega/gdi/starter-kit/` |

## GA4GH standards touchpoints

TODO: Map ferrum-core classes to relevant GA4GH service info and passport/visa
metadata where applicable:

- DUO terms for access conditions
- Beacon/discovery metadata (future profile?)
- Crypt4GH file encryption metadata (handled at Ferrum runtime layer)

## Ferrum as a FEGA node

Ferrum archive nodes use ferrum-meta as their native metadata schema. Federation
to upstream EGA/FEGA services will use crosswalks and transpilers defined in
sibling repositories.

## Open questions

- TODO: Minimum metadata set for FEGA node registration
- TODO: Mapping ferrum access conditions to EGA DAC/policy objects
- TODO: Alignment with GDI metadata schema tool (`gdi-metadata/schema-tool/`)
