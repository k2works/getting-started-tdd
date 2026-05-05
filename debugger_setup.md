# Rust Vimspector Debugger Setup

## 前提

- Vim 設定では `puremourning/vimspector` が導入済み。
- Rust 開発環境は Nix の `rust` dev shell を使う。
- Rust プロジェクトは `apps/rust` 配下にある。

## セットアップ内容

リポジトリルートの `.vimspector.json` に Rust 用の CodeLLDB 設定を置く。

Rust の Nix shell では `vscode-lldb` を導入し、`CODELLDB_PATH` を export する。

```bash
nix develop .#rust
echo "$CODELLDB_PATH"
```

`CODELLDB_PATH` が未設定でも、`.vimspector.json` 側で Nix store から CodeLLDB を解決する。

## デバッグ実行手順

```bash
nix develop .#rust
vim apps/rust/src/lib.rs
```

Vim 上で以下を使う。

| キー | 動作 |
|---|---|
| `<leader>dt` | ブレークポイント切り替え |
| `<leader>dd` | デバッグ開始 |
| `<leader>dc` | 続行 |
| `<leader>dj` | ステップオーバー |
| `<leader>dl` | ステップイン |
| `<leader>dh` | ステップアウト |
| `<leader>de` | デバッグ終了 |

設定選択が出た場合は、まず `Rust: debug all library tests` を選ぶ。

特定のテストだけデバッグする場合は `Rust: debug named library test` を選び、テスト名を入力する。

## 動作確認コマンド

JSON 構文確認。

```bash
python3 -m json.tool .vimspector.json >/dev/null
```

CodeLLDB の解決確認。

```bash
nix develop .#rust --command bash -lc 'test -x "$CODELLDB_PATH" && "$CODELLDB_PATH" --help | sed -n "1,8p"'
```

Rust テストバイナリの生成確認。

```bash
cd apps/rust
cargo test --no-run --lib
```

品質チェック。

```bash
cd apps/rust
just check
```

## トラブルシューティング

### `ENTER VALUE CODELLDB_PATH` と表示される

`.vimspector.json` 内で `"${CODELLDB_PATH}"` と書くと、Vimspector は環境変数ではなく入力変数として扱う。

adapter 起動コマンド内では、シェルに展開させるために `"$CODELLDB_PATH"` と書く。

### `request for initialize aborted` が出る

Debug Adapter Protocol は stdout を通信に使う。`nix develop` の shellHook が stdout にメッセージを出すと、CodeLLDB の通信が壊れる。

adapter 起動では `nix develop ... --command` を直接使わず、CodeLLDB の実行ファイルを解決して `exec "$CODELLDB_PATH"` で直接起動する。

### `Initialize debug session failed` が出る

Vimspector ログを確認する。

```bash
tail -240 ~/.vimspector.log
```

`The "program" attribute is required for launch.` が出ている場合は、CodeLLDB にデバッグ対象バイナリが渡っていない。

現在の `.vimspector.json` では以下のコマンドでテストバイナリを生成し、`program` に渡す。

```bash
cd apps/rust
cargo test --no-run --lib --message-format=json
```

## ログ確認

Vimspector のログ。

```bash
tail -240 ~/.vimspector.log
```

CodeLLDB 解決時の Nix エラーログ。

```bash
cat /tmp/vimspector-codelldb-nix.log
```
