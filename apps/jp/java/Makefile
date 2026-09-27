export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all test lint check clean

all: check

test:
	gradle test --console=plain

lint:
	gradle qualityCheck --console=plain --continue

check: lint test

clean:
	gradle clean
