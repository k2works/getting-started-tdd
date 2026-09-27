# なでしこ3 実装の日本語識別子による Clojure 移植
# 日本語のファイル名を JVM が扱うには UTF-8 ロケールが必要。
# LANG=C だと sun.jnu.encoding が ASCII になり、lein test が名前空間を見つけられず 0 件で成功してしまう。
export LANG := C.UTF-8
export LC_ALL := C.UTF-8

# Leiningen 既定の base プロファイルは nREPL を Clojars から取得しようとする。
# Clojars に接続できない環境でも動くよう base プロファイルを外す。
LEIN := lein with-profile -base

.PHONY: test lint fmt fmt-check check clean

test:
	$(LEIN) test

# clj-kondo による静的解析（clojure-lsp 経由）
lint:
	clojure-lsp diagnostics --raw

fmt:
	clojure-lsp format

# cljfmt による整形チェック（clojure-lsp 経由、変更は書き込まない）
fmt-check:
	clojure-lsp format --dry

check: fmt-check lint test

clean:
	$(LEIN) clean
