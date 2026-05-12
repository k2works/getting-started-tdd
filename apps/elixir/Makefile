.PHONY: test fmt fmt-check lint complexity check

test:
	mix test

fmt:
	mix format

fmt-check:
	mix format --check-formatted

lint:
	mix credo --strict

complexity:
	bash scripts/complexity.sh --threshold 10 lib

check: fmt-check lint complexity test
