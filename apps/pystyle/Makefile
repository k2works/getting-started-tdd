# コラム「なでしこ3 を Python 風に書く」の検証用コードを、言語ごとの Nix 環境でテストする。
# 使い方: make test            … なでしこ3 と Python の両方
#         make test-nadesiko   … なでしこ3 だけ
# リポジトリルートの flake.nix を使うため、apps/pystyle から実行する。

ROOT := $(abspath ../..)
export LANG := C.UTF-8

LANGS := nadesiko python

.PHONY: test $(addprefix test-,$(LANGS))

test: $(addprefix test-,$(LANGS))

$(addprefix test-,$(LANGS)): test-%:
	cd $(ROOT) && nix develop .#$* --command bash -c "make -C apps/pystyle/$* check"
