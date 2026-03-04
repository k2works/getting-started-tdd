.PHONY: all build test lint complexity check clean

all: check

build:
	stack build

test:
	stack test

lint:
	hlint src/ test/ app/ -h .hlint.yaml

complexity:
	bash scripts/complexity.sh --threshold 10 src

check: lint complexity test

clean:
	stack clean
