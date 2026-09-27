# Elixir は VM 起動時のロケールで名前のエンコーディングを決めるため UTF-8 を明示する
export LANG := C.UTF-8
export LC_ALL := C.UTF-8
export ELIXIR_ERL_OPTIONS := +fnu

.PHONY: test fmt fmt-check lint check build clean deps

deps:
	mix deps.get

test: deps
	mix test --trace

fmt:
	mix format

fmt-check:
	mix format --check-formatted

lint: deps
	mix credo --strict

check: fmt-check lint test

build: deps
	mix compile

clean:
	mix clean
