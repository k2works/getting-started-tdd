# デバッガセットアップ手順

このドキュメントは、本リポジトリで Ruby のチュートリアルを `Vimspector` + `rdbg` でデバッグするためのセットアップ手順をまとめたものです。

## 対象

- Vim / Vimspector を使っていること
- Codespaces もしくは `nix develop` を使えること
- Ruby のサンプルコードが `apps/ruby/` 配下にあること

## 事前に入っている設定

本リポジトリでは、以下のファイルを前提にします。

- [.vimspector.json](/workspaces/getting-started-tdd/.vimspector.json) - Vimspector の Ruby 用設定
- [apps/ruby/Gemfile](/workspaces/getting-started-tdd/apps/ruby/Gemfile) - `debug` gem を含む Ruby 依存関係
- [ops/nix/environments/ruby/shell.nix](/workspaces/getting-started-tdd/ops/nix/environments/ruby/shell.nix) - `libyaml` と `pkg-config` を含む Nix 環境

## セットアップ手順

### 1. Ruby の開発環境に入る

```bash
nix develop .#ruby
```

### 2. `apps/ruby` で依存関係をインストールする

```bash
cd apps/ruby
bundle install
```

`debug` gem は `psych` の native extension を経由して `libyaml` を必要とします。`shell.nix` に `libyaml` と `pkg-config` が入っていないと、ここで失敗します。

### 3. 通常のテストが通ることを確認する

```bash
bundle exec rake test
```

### 4. `rdbg` が使えることを確認する

```bash
bundle exec rdbg --version
```

期待値の例:

```text
rdbg 1.11.1
```

## Vimspector の使い方

### 利用できる構成

`.vimspector.json` には以下の構成があります。

- `Ruby: Debug current file`
- `Ruby: Debug test suite`

TDD のチュートリアル中は、基本的に `Ruby: Debug test suite` を使ってください。`current file` は開いている Ruby ファイルをそのまま `ruby <file>` で実行するため、テストファイルやライブラリファイルによっては期待どおりに動きません。

### 基本操作

`[Vim操作マニュアル](/workspaces/getting-started-tdd/docs/reference/Vim操作マニュアル.md)` にあるとおり、主なキーは以下です。

- `,dt` - ブレークポイント切り替え
- `,dd` - デバッグ開始
- `,dc` - Continue
- `,dj` - Step Over
- `,dl` - Step Into
- `,dh` - Step Out
- `,de` - Reset

### 起動手順

1. Vim で [apps/ruby/test/fizz_buzz_test.rb](/workspaces/getting-started-tdd/apps/ruby/test/fizz_buzz_test.rb) もしくは [apps/ruby/lib/fizz_buzz.rb](/workspaces/getting-started-tdd/apps/ruby/lib/fizz_buzz.rb) を開く
2. 止めたい行で `,dt`
3. `,dd`
4. `Ruby: Debug test suite` を選ぶ
5. ブレークポイントで停止したら `,dj` / `,dl` / `,dh` / `,dc` を使う

## `.vimspector.json` のポイント

現在の設定は、`rdbg` を DAP サーバーとして TCP で立ち上げ、Vimspector がそこへ `attach` する形です。

重要な点:

- `--open --port ${DebugPort}` で `rdbg` を待受起動する
- `--nonstop` で開始直後の停止を避ける
- `remote-request: "launch"` で Vimspector 側から `rdbg` の起動も面倒を見る
- `cwd` は `apps/ruby` に固定する

## よくある失敗と対処

### `bundle install` で `psych` の build に失敗する

症状:

```text
yaml.h not found
```

対処:

- `nix develop .#ruby` で Ruby 環境に入っているか確認する
- [ops/nix/environments/ruby/shell.nix](/workspaces/getting-started-tdd/ops/nix/environments/ruby/shell.nix) に `libyaml` と `pkg-config` が入っているか確認する

### `rdbg` が見つからない

症状:

```text
bundle exec: command not found: rdbg
```

対処:

- [apps/ruby/Gemfile](/workspaces/getting-started-tdd/apps/ruby/Gemfile) に `gem 'debug'` があるか確認する
- `bundle install` を再実行する

### Vimspector が開始直後に止まったままに見える

原因:

- `rdbg` に接続はできているが、開始位置で停止している

対処:

- `,dc` で Continue する
- もしくは `.vimspector.json` で `--nonstop` が入っていることを確認する

### ブレークポイントで止まらない

対処:

- `Ruby: Debug test suite` を選んでいるか確認する
- テストから実際に通る行へブレークポイントを置く
- `apps/ruby` 配下のファイルを開いてから起動する

### Vimspector の成否を確認したい

ログ:

```bash
tail -n 200 ~/.vimspector.log
```

見るポイント:

- `.vimspector.json` が読まれているか
- `rdbg --open --port ...` が起動しているか
- `initialize` と `attach` が成功しているか
- `stopped` / `terminated` のイベントがどう出ているか

## 手元での確認コマンド

Vimspector を介さず、`rdbg` の待受起動だけを確認するなら以下です。

```bash
cd apps/ruby
bundle exec rdbg --open --nonstop --port 45678 -c -- bundle exec rake test
```

期待する出力の例:

```text
DEBUGGER: Debugger can attach via TCP/IP (127.0.0.1:45678)
```

この表示が出れば、少なくとも `rdbg` 側の起動までは成功しています。
