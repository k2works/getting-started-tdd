.PHONY: test fmt fmt-check lint check build run clean

test:
	sbt test

fmt:
	sbt scalafmt

fmt-check:
	sbt scalafmtCheck

lint:
	sbt compile

check: fmt-check lint test

build:
	sbt package

run:
	sbt run

clean:
	sbt clean
