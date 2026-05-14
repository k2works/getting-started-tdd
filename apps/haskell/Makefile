.PHONY: all build test lint complexity check clean

STACK = stack --system-ghc --no-install-ghc

all: check

build:
	$(STACK) build

test:
	$(STACK) test

lint:
	hlint src/ test/ -h .hlint.yaml

complexity:
	bash scripts/complexity.sh --threshold 10 src

check: lint complexity test

clean:
	stack clean
