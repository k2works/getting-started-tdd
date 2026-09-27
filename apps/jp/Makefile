# 日本語実装比較（第 9 章コラム）の検証用コードを、言語ごとの Nix 環境でテストする。
# 使い方: make test            … 全言語
#         make test-rust       … 1 言語だけ
# リポジトリルートの flake.nix を使うため、apps/jp から実行する。

ROOT := $(abspath ../..)
export LANG := C.UTF-8

# ディレクトリ名 → Nix 環境名（dotnet は C# と F#、node は JavaScript と TypeScript を含む）
LANGS := java node python ruby php go rust dotnet clojure scala elixir haskell flix kotlin prolog

.PHONY: test $(addprefix test-,$(LANGS))

test: $(addprefix test-,$(LANGS))

test-%:
	cd $(ROOT) && nix develop .#$* --command bash -c "make -C apps/jp/$* test"
