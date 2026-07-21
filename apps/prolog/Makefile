.PHONY: all test check lint run clean

all: check

# test/ 配下の全 .plt を読み込んで plunit を実行する
test:
	swipl -q test/run.pl

# 構文・特異点（singleton 変数など）を検査する
lint:
	@for f in src/*.pl; do \
		swipl -q -g "halt(0)" -t "halt(1)" "$$f" || exit 1; \
	done
	@echo "lint: OK"

check: lint test

run:
	swipl -q -g "main, halt(0)" -t "halt(1)" src/main.pl

clean:
	@echo "nothing to clean"
