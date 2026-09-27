# なでしこ3 実装の日本語識別子による Prolog 移植
# LANG=C だと日本語ファイル名の expand_file_name で SWI-Prolog が異常終了するため UTF-8 を指定する。
export LANG := C.UTF-8
export LC_ALL := C.UTF-8

.PHONY: all test lint check clean

all: check

# test/ 配下の全 .plt を読み込んで plunit を実行する
test:
	swipl -q test/run.pl

# 構文・特異点（singleton 変数など）を検査する。
# 既存 apps/prolog の -g "halt(0)" では警告が出ても終了コード 0 になるため、
# --on-warning=status と引数なしの halt で警告を失敗として扱う。
lint:
	@for f in src/*.pl; do \
		swipl -q --on-warning=status -g halt "$$f" || exit 1; \
	done
	@echo "lint: OK"

check: lint test

clean:
	@echo "nothing to clean"
