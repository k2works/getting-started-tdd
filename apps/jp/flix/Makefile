FLIX ?= java -jar $(or $(FLIX_JAR),flix.jar)
export LANG := C.UTF-8

.PHONY: all test check format clean

all: check test

test:
	$(FLIX) test

check:
	$(FLIX) check

format:
	$(FLIX) format

clean:
	$(FLIX) clean
