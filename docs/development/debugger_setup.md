# Vimspector デバッガーセットアップ（Elixir）

Vimspector を使って Elixir プロジェクトをデバッグするためのセットアップ手順。

## 前提条件

- Vim 9.x（Python3 サポート付き）
- dein.vim（プラグインマネージャ）
- Nix 開発環境（`nix develop .#elixir`）

## インストール状態の確認

本プロジェクトでは以下がすでに設定済み。

| 項目 | 場所 | 状態 |
|------|------|------|
| Vimspector プラグイン | `~/.vimrc` の `dein#add('puremourning/vimspector')` | ✅ |
| elixir-ls + debug adapter | Nix ストア（`/nix/store/.../elixir-ls-0.30.0/`） | ✅ |
| キーマッピング | `~/.vimrc` の `vimspector` セクション | ✅ |
| プロジェクト設定 | `.vimspector.json`（プロジェクトルート） | ✅ |

## ガジェット設定（初回のみ）

dein.vim がプラグインを配置するキャッシュディレクトリに設定ファイルを作成する。

### 1. ガジェットディレクトリを作成

```bash
mkdir -p ~/.cache/dein/.cache/.vimrc/.dein/gadgets/linux/.gadgets.d
```

### 2. `.gadgets.json` を作成

```bash
cat > ~/.cache/dein/.cache/.vimrc/.dein/gadgets/linux/.gadgets.json << 'EOF'
{
  "adapters": {
    "elixir-ls": {
      "command": [
        "/nix/store/yqrp9kpmwa8l9zvhrgk7c9qc0s29v6rb-elixir-ls-0.30.0/bin/elixir-debug-adapter"
      ],
      "name": "mix_task",
      "async_timeout": 120000
    }
  }
}
EOF
```

> **`async_timeout: 120000`** が重要。elixir-debug-adapter は初回起動時に約 60 秒かかるため、デフォルトの 15 秒タイムアウトでは失敗する。

### 3. `.gadgets.d/elixir.json` を作成（バックアップ）

```bash
cp ~/.cache/dein/.cache/.vimrc/.dein/gadgets/linux/.gadgets.json \
   ~/.cache/dein/.cache/.vimrc/.dein/gadgets/linux/.gadgets.d/elixir.json
```

## デバッグの使い方

### キーマッピング

| キー | 動作 |
|------|------|
| `<Leader>dd` | デバッグ起動（設定選択ダイアログ） |
| `<Leader>dc` | 続行（Continue） |
| `<Leader>dt` | ブレークポイント Toggle |
| `<Leader>dT` | ブレークポイント全クリア |
| `<Leader>de` | デバッグ終了（Reset） |

### デバッグセッションの起動手順

1. `apps/elixir/lib/fizz_buzz.ex` を Vim で開く
2. ブレークポイントを置きたい行で `<Leader>dt`
3. `<Leader>dd` → `"Elixir: mix test"` を選択
4. **初回は 60〜90 秒待つ**（elixir-ls のコンパイル）
5. 2 回目以降は数秒で起動

### デバッグ設定（`.vimspector.json`）

プロジェクトルートの `.vimspector.json` に 2 つの設定が定義されている。

| 設定名 | 内容 |
|--------|------|
| `Elixir: mix test` | テストをデバッグ実行（`MIX_ENV=test`） |
| `Elixir: mix run` | アプリをデバッグ実行（`MIX_ENV=dev`） |

## トラブルシューティング

### "The specified adapter 'elixir-ls' is not available"

**原因**: ガジェット設定ファイルがない、または wrong な場所にある。

**確認コマンド**:
```bash
ls ~/.cache/dein/.cache/.vimrc/.dein/gadgets/linux/.gadgets.json
```

**解決策**: 上記「ガジェット設定」の手順を再実行。

### "Initializing debug session" から進まない（15 秒でタイムアウト）

**原因**: elixir-debug-adapter の起動時間（~60 秒）が Vimspector のデフォルトタイムアウト（15 秒）を超えている。

**確認コマンド**:
```bash
tail -30 ~/.vimspector.log
# "Timeout: Aborting request" が出ていればこの問題
```

**解決策**: `.gadgets.json` に `"async_timeout": 120000` を追加（上記設定に含まれている）。

### ログの確認方法

```bash
tail -50 ~/.vimspector.log
```

または Vim 内で:
```vim
:VimspectorShowOutput Vimspector
```

## Nix 環境更新時の注意

Nix の `flake.lock` を更新すると `elixir-ls` のストアパスが変わる場合がある。
その際は `.gadgets.json` の `command` パスを更新が必要。

```bash
# 新しい elixir-debug-adapter のパスを確認
which elixir-debug-adapter
# または
find /nix/store -name "elixir-debug-adapter" -type f 2>/dev/null | head -3
```
