export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all test lint detekt ktlint check clean

all: check

test:
	gradle test --console=plain

detekt:
	gradle detektCheck --console=plain

ktlint:
	gradle ktlintCheck --console=plain

lint: detekt ktlint

check: lint test

clean:
	gradle clean
