.PHONY: all test check lint run clean

# 日本語のコメント・文字列を含むため、ロケールが UTF-8 でないと読み込み時に警告が出る
export LANG := C.UTF-8
export LC_ALL := C.UTF-8

all: check

# test/ 配下の全 .plt を読み込んで plunit を実行する
test:
	swipl -q test/run.pl

# 構文・特異点（singleton 変数など）を検査する
# --on-warning=status により、警告が 1 件でもあれば終了コード 1 で失敗する
lint:
	@for f in src/*.pl; do \
		swipl -q --on-warning=status -g halt "$$f" || exit 1; \
	done
	@echo "lint: OK"

check: lint test

run:
	swipl -q -g "main, halt(0)" -t "halt(1)" src/main.pl

clean:
	@echo "nothing to clean"
