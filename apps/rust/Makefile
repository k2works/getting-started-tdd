.PHONY: test lint fmt fmt-check check build run clean

test:
	cargo test

lint:
	cargo clippy -- -D warnings

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

check: fmt-check lint test

build:
	cargo build --release

run:
	cargo run

clean:
	cargo clean
