# Contributing

Thank you for contributing to ferrum-meta. This guide covers schema changes,
fixtures, crosswalks, and review expectations.

## Development setup

```bash
git clone https://github.com/SynapticFour/ferrum-meta.git
cd ferrum-meta
make install    # creates .venv/ — no standalone pip required
make test       # full validation suite
```

Run schema and fixture checks without building docs:

```bash
make validate
```

Verbose output (full linkml-lint and validation messages):

```bash
./scripts/run-tests.sh --verbose
```

## What to change where

| Change type | Location | Also update |
|-------------|----------|-------------|
| Core field | `schema/core/ferrum-core.yaml` | Crosswalks, valid fixture, CHANGELOG |
| Archive extension | `schema/profiles/*.yaml` | Profile fixture in `fixtures/`, crosswalk |
| Export mapping | `crosswalk/*.md` | `scripts/check-crosswalks.sh` entity list if new classes |
| Negative test | `fixtures/invalid/` | Ensure CI rejects it (`make test`) |
| Design rationale | `docs/` | Keep aligned with schema enums and slots |

## Schema conventions

- **LinkML YAML** — same language as GHGA for interoperability
- **Enum naming** — `SCREAMING_SNAKE_CASE` (ferrum-meta convention; see `.linkmllint.yaml`)
- **Profiles import core** — extend with `is_a: FerrumCoreSubmission`, do not fork entity definitions
- **Version** — bump `version:` in schema YAML and `ferrum_meta_version` in fixtures together

## Adding a fixture

1. Place valid examples in `fixtures/valid/` with a filename prefix matching the profile
   (`ghga-*`, `h3africa-*`, `pathogen-*`, etc.) — see `scripts/validate-fixture.sh`
2. Add invalid examples to `fixtures/invalid/` with intentional, documented errors
3. Run `./scripts/validate-fixture.sh <file>` locally before opening a PR
4. Run `make test` to confirm the full suite passes

## Adding a crosswalk row

1. Edit the appropriate file in `crosswalk/`
2. Use exact upstream field names in the GHGA / EGA / Webin columns
3. Document special cases (consent types, encryption, embargo) in Notes
4. `./scripts/check-crosswalks.sh` verifies entity coverage

## Pull request checklist

- [ ] `make test` passes locally
- [ ] Valid fixtures pass; invalid fixtures fail
- [ ] Crosswalk entity references updated if new classes added
- [ ] CHANGELOG.md updated under `[Unreleased]`
- [ ] No absolute local paths in committed files
- [ ] No upstream schema clones committed under `sources/`

## Scope boundaries

- **In scope:** LinkML schema, docs, fixtures, crosswalks, validation scripts
- **Out of scope:** Ferrum runtime code, transpilers, UI — those belong in
  [Ferrum](https://github.com/SynapticFour/Ferrum) and sibling repos

## Questions

Open a GitHub issue or contact [contact@synapticfour.com](mailto:contact@synapticfour.com).
