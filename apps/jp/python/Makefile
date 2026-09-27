export LANG := C.UTF-8
export LC_ALL := C.UTF-8
export UV_PYTHON_DOWNLOADS := never
# Nix の python 環境（MkDocs 用）の PYTHONPATH が古い pathspec を先に読ませ、mypy が起動しないため外す
unexport PYTHONPATH

UV_RUN := uv run --group dev

.PHONY: all test lint format format-check typecheck check clean

all: check

test:
	$(UV_RUN) pytest -v

lint:
	$(UV_RUN) ruff check 実装 test

format:
	$(UV_RUN) ruff format 実装 test

format-check:
	$(UV_RUN) ruff format --check 実装 test

typecheck:
	$(UV_RUN) mypy 実装 test

check: format-check lint typecheck test

clean:
	rm -rf .venv .pytest_cache .mypy_cache .ruff_cache
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
