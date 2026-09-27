export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all test fmt fmt-check lint check clean

all: check

test:
	sbt test

fmt:
	sbt scalafmtAll

fmt-check:
	sbt scalafmtCheckAll

lint:
	sbt compile

check: fmt-check lint test

clean:
	sbt clean
