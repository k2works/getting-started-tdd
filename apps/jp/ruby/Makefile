export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: test lint check

test:
	rake test

lint:
	rubocop

check: lint test
