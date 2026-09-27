export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all install test lint format format-check typecheck check clean

all: check

node_modules: package.json
	npm install --no-audit --no-fund
	@touch node_modules

install: node_modules

test: node_modules
	npx vitest run

lint: node_modules
	npx eslint src/ test/

format: node_modules
	npx prettier --write "src/**/*.{js,ts}" "test/**/*.{js,ts}"

format-check: node_modules
	npx prettier --check "src/**/*.{js,ts}" "test/**/*.{js,ts}"

typecheck: node_modules
	npx tsc --noEmit

check: format-check lint typecheck test

clean:
	rm -rf node_modules dist coverage
