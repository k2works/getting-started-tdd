.PHONY: test fmt fmt-check lint complexity check build run clean

test:
	sbt test

fmt:
	sbt scalafmt

fmt-check:
	sbt scalafmtCheck

lint:
	sbt compile

complexity:
	bash scripts/complexity.sh --threshold 10 src

check: fmt-check lint complexity test

build:
	sbt package

run:
	sbt run

clean:
	sbt clean
