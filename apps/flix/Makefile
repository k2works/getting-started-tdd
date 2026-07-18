FLIX := java -jar flix.jar

.PHONY: all build test check format format-check doc run clean

all: check

build:
	$(FLIX) build

test:
	$(FLIX) test

check:
	$(FLIX) check

format:
	$(FLIX) format

format-check:
	$(FLIX) format --check

doc:
	$(FLIX) doc

run:
	$(FLIX) run

clean:
	$(FLIX) clean
