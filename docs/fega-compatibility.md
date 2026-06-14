# FEGA Compatibility

[GA4GH Federated EGA (FEGA)](https://www.ga4gh.org/product/federated-ega/) defines how
institutions operate local archive nodes that federate with the central EGA while keeping
sensitive data under local governance. ferrum-meta is the **metadata schema layer** that
makes a Ferrum node FEGA-compatible by default.

---

## What Ferrum provides out of the box

| Capability | Implementation | ferrum-meta / Ferrum role |
|------------|----------------|---------------------------|
| **Metadata** | ferrum-core + archive profile | Structured submission bundles (YAML/JSON); local validation via LinkML |
| **Encryption** | Crypt4GH | `File.encryption: CRYPT4GH` default for human controlled-access data |
| **Discovery** | Beacon v2 | Ferrum node exposes Beacon v2 API over accessioned metadata (runtime) |
| **Access control** | GA4GH Passports | Visas and passports gate dataset access; metadata carries DUO terms |
| **Data access** | GA4GH DRS | DRS endpoints serve file access URLs for authorised requests (runtime) |

The schema records **what** the data are, **who** may access them, and **how** files are
protected. Ferrum runtime services implement the GA4GH protocol endpoints that act on that
metadata.

### Metadata detail

- **Core entities** — Study, Individual, Sample, Experiment, File, Dataset map to EGA object
  sets via crosswalks
- **Access conditions** — `Dataset.data_use_conditions` uses DUO ontology CURIEs
- **DAC / DAP** — GHGA and EGA profiles include `DataAccessCommittee` and `DataAccessPolicy`
- **Embargo** — H3Africa profile tracks `h3africa_release_date` for timed release

### Encryption detail

Human genomic data defaults to Crypt4GH (`File.encryption: CRYPT4GH`). Pathogen surveillance
(profile override) uses `NONE` for public outbreak data. The encryption scheme follows the
[GA4GH Crypt4GH specification](https://github.com/ga4gh/encryption-schemes).

---

## What is NOT required to be a useful federated node

FEGA formal membership and enterprise infrastructure are **goals**, not day-one prerequisites.

| Not required | Why |
|--------------|-----|
| **Formal FEGA membership** | Useful for ELIXIR-wide federation and accreditation; a Ferrum node can operate locally and deposit to EGA/H3ABioNet before joining |
| **Dedicated server room** | A **Raspberry Pi 4** (4 GB RAM) or equivalent mini-PC is sufficient for a research group's metadata node, validation, and queue management |
| **Full-time bioinformatician** | **Ferrum compass** handles metadata capture, validation prompts, and export checklists — designed for technologists and data managers, not pipeline engineers |

A sequencing centre, ethics-approved biobank, or national surveillance lab can run a Ferrum
node with:

1. Local storage for files during embargo or pre-upload queue
2. `linkml-validate` for offline metadata QA
3. Periodic sync when connectivity allows

Reference FEGA deployments (ELIXIR Norway SDA, GDI starter kit) are indexed in the
[protocol references](protocol-references/README.md) source bundle for teams scaling up.

---

## Alignment with upstream FEGA implementations

Pre-cloned reference material in the local source bundle (`ferrum-meta-sources/`):

| Component | Purpose |
|-----------|---------|
| ELIXIR Norway SDA | Production FEGA node patterns |
| GDI metadata / starter kit | German Genome Initiative federation tooling |

ferrum-meta crosswalks map core fields to EGA JSON and Webin XML. Ferrum transpilers (sibling
repos) implement the runtime export. GDI metadata schema alignment is tracked as future work.

---

## Profile selection guide

| Use case | Profile | Target archive |
|----------|---------|----------------|
| European human omics (GHGA member states) | `ghga-profile` | GHGA |
| Controlled-access human (incl. H3Africa) | `h3africa-profile` / `ega-profile` | EGA via H3ABioNet |
| Pathogen / public health | `pathogen-profile` | ENA, GISAID |
| Short-variant clinical | `eva-profile` | EVA |

---

## Vision

**Every institution its own node. All nodes one federated system.**

A hospital in Nairobi, a Pasteur institute in Dakar, and a university biobank in Cape Town each
operate sovereign Ferrum nodes — local ethics, local storage, local validation — while sharing
a common metadata language and federating discovery and access through GA4GH protocols.

ferrum-meta is the shared metadata contract that makes that federation possible without
forcing every institution into the same archive portal or connectivity model.
