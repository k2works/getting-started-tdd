# なでしこ3 実装の日本語識別子による Rust 移植
export LANG := C.UTF-8

.PHONY: test lint fmt fmt-check check clean

test:
	cargo test

lint:
	cargo clippy --all-targets -- -D warnings

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

check: fmt-check lint test

clean:
	cargo clean
