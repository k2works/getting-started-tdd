.PHONY: test lint fmt fmt-check complexity check build run clean

test:
	cargo test

lint:
	cargo clippy -- -D warnings

complexity:
	cargo clippy -- -D clippy::cognitive_complexity

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

check: fmt-check lint complexity test

build:
	cargo build --release

run:
	cargo run

clean:
	cargo clean
