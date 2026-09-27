GONAKO ?= gonako
SOURCES := $(wildcard src/*.nako3) $(wildcard test/*.nako3)

.PHONY: all test lint format format-check doctest check run clean

all: check

# test/ 配下の *_test.nako3 を 1 ファイルずつ実行し、終了コードで合否を判定する
test:
	@pass=0; fail=0; \
	for f in test/*_test.nako3; do \
		echo "== $$f"; \
		if $(GONAKO) run "$$f"; then pass=$$((pass + 1)); else fail=$$((fail + 1)); fi; \
	done; \
	echo "テストファイル: $$pass 件成功、$$fail 件失敗"; \
	test $$fail -eq 0

# 文法エラーがないかを検査する
lint:
	@for f in $(SOURCES); do \
		$(GONAKO) lint "$$f" > /dev/null || exit 1; \
	done
	@echo "lint: OK"

# gonako format の整形結果と差分がないかを検査する
format-check:
	@for f in $(SOURCES); do \
		$(GONAKO) format "$$f" | diff -u "$$f" - || { echo "要整形: $$f（make format で修正）"; exit 1; }; \
	done
	@echo "format: OK"

# ソースを整形して書き戻す
format:
	@for f in $(SOURCES); do $(GONAKO) format -f "$$f" > /dev/null; done

# 受け入れテスト（doctest/*.txt の表示結果を照合する）
doctest:
	$(GONAKO) doctest doctest

check: lint format-check test doctest

run:
	$(GONAKO) run src/main.nako3

clean:
	rm -rf bin
