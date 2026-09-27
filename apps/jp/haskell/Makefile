export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all build test lint check clean

all: check

build:
	stack build

test:
	stack test

lint:
	hlint src/ test/ -h .hlint.yaml

check: lint test

clean:
	stack clean
