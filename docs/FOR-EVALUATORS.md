# For evaluators

**No public status is recorded.** There is no maturity claim for this schema. An older README opening said "Early access". This page does not keep that label.

## What a check shows

`make test` runs schema lint, fixture checks, crosswalk checks, and the documentation build, through `./scripts/run-tests.sh`. A pass prints `All checks passed.` That is a check of the files in this repository. It is not a check of a running Ferrum node, not an archive acceptance, and not a certificate.

`export` copies a starter fixture and validates the copy. It does not talk to Ferrum.

## Version

Schema YAML: 0.1.0. Git tag v0.1.0 peels to `e34fce4920d249fa69109a6d0600123901832eba`. The default branch is ahead of that tag. Pin the tag when vendoring. No Zenodo DOI has been issued.

## Licence

Apache License 2.0. The file is [LICENSE](https://github.com/SynapticFour/ferrum-meta/blob/main/LICENSE).

Contact: [contact@synapticfour.com](mailto:contact@synapticfour.com)
