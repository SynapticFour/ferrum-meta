# Design Principles

TODO: Expand into full design rationale during consensus modelling (Prompt 3.x).

## 1. Offline-first

Metadata must be capturable, editable, and validatable without network access.
Field labs in low-connectivity settings are first-class users, not edge cases.

- Single-file serialisation (YAML/JSON) for portable submission bundles
- Checksums on file references for local integrity verification
- No dependency on live ontology resolution during validation (pinned versions)

## 2. Archive-agnostic core, profile-specific extensions

`ferrum-core.yaml` holds the consensus minimum model. Archive profiles
(GHGA, EGA, H3Africa, EVA, pathogen, dbGaP) extend the core without forking it.

## 3. Federation-ready identifiers

Local archive nodes assign identifiers that can be mapped to global accessions
upon federation or deposition to upstream archives.

## 4. Consent and access by design

Access conditions (DUO-aligned) are first-class metadata, not an afterthought.
H3Africa community consent models inform the core access model.

## 5. Crosswalks, not conversions

Crosswalk documents describe semantic field mappings. Runtime transpilation
belongs in Ferrum tooling, not in this schema-only repository.

## 6. LinkML as the lingua franca

Same schema language and conventions as GHGA for interoperability with existing
European infrastructure and tooling (`linkml-validate`, `gen-pydantic`, etc.).

## 7. No runtime code in this repository

Pure schema, documentation, fixtures, and crosswalks. Validators and
connectors live in sibling Ferrum projects.
