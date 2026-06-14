# ferrum-meta — SynapticFour metadata schema validation
.PHONY: help install test validate docs clean

help:
	@echo "ferrum-meta — local validation (SynapticFour GA4GH stack)"
	@echo ""
	@echo "  make install   Install Python dev dependencies"
	@echo "  make test      Run full validation suite (schemas, fixtures, crosswalks, docs)"
	@echo "  make validate  Run schema and fixture checks only (skip mkdocs)"
	@echo "  make docs      Build documentation site"
	@echo "  make clean     Remove build artefacts"

install:
	pip install -r requirements-dev.txt

test:
	./scripts/run-tests.sh

validate:
	./scripts/run-tests.sh --skip-docs

docs:
	mkdocs build --strict

clean:
	rm -rf build/ site/
