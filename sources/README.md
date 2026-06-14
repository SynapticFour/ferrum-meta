# Local reference schemas

Clone the following schemas into subdirectories here before running schema prompts.
These are **NOT** committed to the repo — local reference material only.

## Required clones

| Subdirectory | Upstream repository |
|--------------|---------------------|
| `ghga-metadata-schema/` | https://github.com/ghga-de/ghga-metadata-schema |
| `ega-metadata-schema/` | https://github.com/EbiEga/ega-metadata-schema |
| `webin-xml/` | https://github.com/enasequence/webin-xml |
| `fairgenomes-semantic-model/` | https://github.com/fairgenomes/fairgenomes-semantic-model |

## Quick setup

From this directory (`sources/`):

```bash
git clone --depth 1 https://github.com/ghga-de/ghga-metadata-schema.git ghga-metadata-schema
git clone --depth 1 https://github.com/EbiEga/ega-metadata-schema.git ega-metadata-schema
git clone --depth 1 https://github.com/enasequence/webin-xml.git webin-xml
git clone --depth 1 https://github.com/fairgenomes/fairgenomes-semantic-model.git fairgenomes-semantic-model
```

## Pre-populated source bundle

If you maintain a consolidated source tree elsewhere (e.g.
`/Users/SynapticFour/devel/ferrum-meta-sources`), you can symlink instead of cloning:

```bash
ln -s /Users/SynapticFour/devel/ferrum-meta-sources/ghga/ghga-metadata-schema ghga-metadata-schema
ln -s /Users/SynapticFour/devel/ferrum-meta-sources/ega-ena/ega-metadata-schema ega-metadata-schema
ln -s /Users/SynapticFour/devel/ferrum-meta-sources/ega-ena/webin-xml webin-xml
ln -s /Users/SynapticFour/devel/ferrum-meta-sources/ega-ena/fairgenomes-semantic-model fairgenomes-semantic-model
```

See `ferrum-meta-sources/SOURCES.md` for a full index of papers, ontologies, and
additional reference repositories (EVA, H3Africa, GA4GH, FEGA, GDI, DUO, etc.).
