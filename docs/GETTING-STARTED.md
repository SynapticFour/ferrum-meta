# Getting started

Prerequisites: Python 3.10 or newer.

```bash
make install
make test
```

`make install` creates `.venv/` and installs the tools named in `requirements-dev.txt`. `make test` runs `./scripts/run-tests.sh`. You should see `All checks passed.`

Check one fixture:

```bash
./scripts/validate-fixture.sh fixtures/valid/ghga-minimal-submission.yaml
```

You should see `No issues found`.

Copy a starter fixture and check it:

```bash
./scripts/export-profile.sh ghga ./my-ghga-bundle.yaml
```

That copy is a fixture from this repository. It does not talk to Ferrum, list DRS objects, or upload to an archive.

## `migrate-assist`

```bash
./scripts/ferrum_meta_cli.py migrate-assist ghga export.csv
```

The command compares field names in a CSV or JSON file with the slots of a profile (`ghga`, `ega`, `h3africa`, `pathogen`, `eva`). It writes a report to the console, or to `--output`. The report is a suggestion. It does not apply a change.

The report heading in the tool is `migrate-assist (experimentell)`. The help text includes a German disclaimer. Those strings are what the program prints.

The report supports a migration project. It does not replace a manual check, and it does not export to EGA or GHGA. A matching column name is not a passed LinkML validation. YAML fixtures stay on `validate`.

dbGaP is not a profile here.
