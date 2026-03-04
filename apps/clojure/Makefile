.PHONY: test lint kibit fmt fmt-check complexity coverage check build run clean

test:
	lein test

lint:
	lein eastwood

kibit:
	lein kibit

fmt:
	lein cljfmt fix || true

fmt-check:
	lein cljfmt check || true

complexity:
	lein complexity

bikeshed:
	lein bikeshed

coverage:
	lein cloverage

check: lint kibit complexity test

build:
	lein uberjar

run:
	lein run

clean:
	lein clean
