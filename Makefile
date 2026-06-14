# ferrum-meta — SynapticFour metadata schema validation
PYTHON ?= python3
VENV := .venv
BIN := $(VENV)/bin

export PATH := $(BIN):$(PATH)

.PHONY: help install test validate docs clean

help:
	@echo "ferrum-meta — local validation (SynapticFour GA4GH stack)"
	@echo ""
	@echo "  make install   Create .venv and install Python dev dependencies"
	@echo "  make test      Run full validation suite (schemas, fixtures, crosswalks, docs)"
	@echo "  make validate  Run schema and fixture checks only (skip mkdocs)"
	@echo "  make docs      Build documentation site"
	@echo "  make clean     Remove build artefacts and .venv"

install: $(VENV)/.deps-installed
	@echo "Dependencies ready in .venv/"

$(VENV)/.deps-installed: requirements-dev.txt | $(BIN)/python
	@$(BIN)/pip install -q -U pip
	@$(BIN)/pip install -q -r requirements-dev.txt
	@touch $@

$(BIN)/python:
	@$(PYTHON) -m venv $(VENV)

test: install
	@./scripts/run-tests.sh

validate: install
	@./scripts/run-tests.sh --skip-docs

docs: install
	@$(BIN)/mkdocs build --strict

clean:
	rm -rf build/ site/ $(VENV)
