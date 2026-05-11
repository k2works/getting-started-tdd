.PHONY: test fmt fmt-check lint complexity check build run clean

fmt:
	sbt --no-colors scalafmt

fmt-check:
	sbt --no-colors scalafmtCheck

lint:
	sbt --no-colors compile

complexity:
	bash scripts/complexity.sh --threshold 10 src

test:
	sbt --no-colors test

build:
	sbt --no-colors compile

run:
	sbt --no-colors run

clean:
	sbt --no-colors clean

check: fmt-check lint complexity test
