# Vim 設定メモ

このリポジトリで使っている `Vim` 設定の要点をまとめます。

## 起動環境

- `ops/nix/shells/shell.nix` で `vim-full` を使います。
- 同じ Nix シェルに `universal-ctags` と `python3Packages.debugpy` を入れています。
- `shellHook` で `ops/nix/shells/.vimrc` を `~/.vimrc` にリンクします。

## 主なプラグイン

- `dein.vim`
- `NERDTree`
- `ctrlp.vim` 系
- `vimspector`
- `vim-fugitive`
- `vim-gitgutter`
- `vim-test`
- `coc.nvim`
- `ludovicchabant/vim-gutentags`

## 基本設定

- `mapleader` は `,`
- `autowrite` を有効化
- `number` と `cursorline` を有効化
- `expandtab`
- `tabstop=2`
- `softtabstop=2`
- `shiftwidth=2`
- `fileencoding=utf-8`
- `fileencodings=ucs-boms,utf-8,euc-jp,cp932`

## ファイルツリー

- `,e` で `NERDTreeToggle`
- `,ef` で現在ファイルのディレクトリを `NERDTreeFind`
- 隠しファイルも表示します

## タグ

- `gutentags` を有効化しています。
- `ctags` は `universal-ctags` を使います。
- `tags` は `./tags;,tags` を読む設定です。
- 保存時や必要時にタグが自動生成されます。

## デバッグ

`vimspector` を使います。

- `,dd` で起動
- `,de` でリセット
- `,dc` で続行
- `,dt` でブレークポイント切替
- `,dT` で全ブレークポイント削除
- `,dj` で Step Over
- `,dl` で Step Into
- `,dh` で Step Out
- `,dk` で Restart

Python 用には `.vimspector.json` を置いています。
`debugpy` は `python3Packages.debugpy` を直接使う設定なので、`:VimspectorInstall debugpy` は不要です。

- `Python: Current File`
- `Python: pytest current file`
- `Python: main.py`

テストを止めて調べたい場合は `apps/python/test/test_fizzbuzz.py` を開き、`Python: pytest current file` を選びます。
`pytest` は `apps/python/.venv/bin/python` で起動し、現在のファイルに対して実行します。

### デバッグ設定の詳細

- `adapters.python-debugpy` は `python3 -m debugpy.adapter` を起動します。
- `Python: Current File` は今開いている `*.py` をそのまま起動します。
- `Python: pytest current file` は `apps/python/.venv/bin/python -m pytest <current file>` を実行します。
- `Python: main.py` は `apps/python/main.py` を直接起動します。
- すべて `integratedTerminal` を使うので、標準入出力は Vim 内の端末に出ます。
- ブレークポイントは `,dt` で切り替え、`<Leader>dd` で実行を開始します。

## 検索・移動

- `ctrlp.vim` でファイル検索
- `CtrlPCommandLine` を有効化
- `CtrlPFunky` を有効化
- `ag` がある場合は hidden ファイル込みで検索します

## Git 連携

- `,gs` で `:Git`
- `,ga` で現在ファイルを add
- `,gc` で commit
- `,gp` で push
- `,gd` で diff split
- `,gl` で log
- `,gb` で blame

## 補足

- `Vim` の設定本体は `ops/nix/shells/.vimrc`
- 起動用の Nix 定義は `ops/nix/shells/shell.nix`
- `vimspector` の Python デバッグは `debugpy` 前提です。
- アダプタは `python3 -m debugpy.adapter` を直接起動します。
