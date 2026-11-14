# ferrum-meta

ferrum-meta is a form for the facts a Ferrum node keeps about a study, a sample, and a file, so those facts can be checked on the spot before anyone sends them to an archive.

For a person recording those facts, and for an engineer checking the form.

**Status: No public status is recorded.** Registry: none.

This schema checks a document. Helix checks a running service. HELIOS writes signed evidence. This repository does neither, and `export` does not talk to Ferrum.

[![Validate](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml/badge.svg)](https://github.com/SynapticFour/ferrum-meta/actions/workflows/validate.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![LinkML](https://img.shields.io/badge/schema-LinkML-orange.svg)](https://linkml.io/)

## What it does

- It defines a LinkML schema: a shared core plus archive profiles for GHGA, EGA, H3Africa, pathogen surveillance, and EVA. LinkML is a language for describing a form and checking a document against it. The schema version in the YAML is **0.1.0**.
- `validate` checks a YAML or JSON document against that schema.
- `export` copies a committed starter fixture and checks that copy. It does not list DRS objects and it does not upload to EGA or GHGA. Live DRS identifiers, when a node has them, are Ferrum's own `ferrum meta export` without `--starter`.
- `migrate-assist` compares column names in a CSV or JSON file with the slots of one profile (`ghga`, `ega`, `h3africa`, `pathogen`, `eva`) and writes a suggestion. The suggestion does not change the file. The command prints its heading as `migrate-assist (experimentell)`.

## Limits

- No maturity claim is recorded for this schema. An older opening of this page said "Early access". That label is not repeated here.
- Git tag **v0.1.0** peels to `e34fce4920d249fa69109a6d0600123901832eba`. That commit is the published join. The default branch is ahead of the tag. The schema YAML on the tag stays 0.1.0. Pin the tag, not the default branch, when another repository vendors this schema. The schema comment dates 0.1.0 as 2026-06-14. The changelog dates the tag 2026-08-01.
- No Zenodo DOI has been issued. This page does not invent one.
- dbGaP is not modelled. The profiles are GHGA, EGA, H3Africa, pathogen, and EVA.
- A column with the same name as a slot is not a passed LinkML run.

## Quick start

Prerequisites: Python 3.10 or newer.

```bash
make install
make test
```

You should see `All checks passed.`

One fixture, after `make install`:

```bash
./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-submission.yaml
```

You should see `No issues found`.

This path does not start Ferrum. A node that already runs is [Ferrum](https://github.com/SynapticFour/Ferrum). This tool does not start it.

## Documentation

The full index, one line for every file under `docs/`, is [docs/README.md](docs/README.md).

### Tutorial

- [Getting started](docs/GETTING-STARTED.md)

### How-to guides

- [African context](docs/african-context.md) — field capture before a network is available
- [Contributing](docs/contributing.md)
- [FEGA compatibility](docs/fega-compatibility.md)

### Reference

- [Protocol references](docs/protocol-references/README.md)
- [GHGA–EGA crosswalk](docs/crosswalk/ghga-ega-crosswalk.md)
- [Changelog](CHANGELOG.md)

### Explanation

- [Architecture](docs/ARCHITECTURE.md)
- [For evaluators](docs/FOR-EVALUATORS.md)
- [Design principles](docs/design-principles.md)

## Licence

Apache License 2.0. The file is [LICENSE](LICENSE).

## Cite

Use [CITATION.cff](CITATION.cff). Prefer that file over a hand-copied line. There is no DOI for this schema.

## Website

- Product page: [https://synapticfour.com/en/ferrum/](https://synapticfour.com/en/ferrum/)
- Technical profile: [https://synapticfour.com/en/technical/ferrum/](https://synapticfour.com/en/technical/ferrum/)

The same pages exist in German (`/de/ferrum/`, `/de/technik/ferrum/`) and in French (`/fr/ferrum/`, `/fr/technique/ferrum/`).

The map of repositories: [profile/README.md](https://github.com/SynapticFour/.github/blob/main/profile/README.md).

Contact: [contact@synapticfour.com](mailto:contact@synapticfour.com)
