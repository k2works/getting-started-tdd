# F# debugger セットアップ手順

このドキュメントは、本リポジトリで **Vim + Vimspector + netcoredbg** を使って F# コードと F# テストをデバッグするためのセットアップ手順をまとめたものです。

## 概要

このリポジトリでは、F# デバッグに以下を使います。

- Vim プラグイン: `puremourning/vimspector`
- デバッグアダプタ: `netcoredbg`
- 実行環境: `nix develop .#dotnet`

F# の通常実行デバッグだけでなく、`Tests.fs` のブレークポイントも止められるように、`apps/fsharp/FizzBuzzFSharpTest/Program.fs` に **xUnit デバッグハーネス** を追加しています。

## 背景

通常の `dotnet test` + PID attach 方式は、この環境では安定しません。

- Linux 側で `kernel.yama.ptrace_scope = 1`
- `netcoredbg --attach <pid>` が失敗する
- そのため、`VSTEST_HOST_DEBUG=1` で待機させても Vimspector から既存プロセスへ attach できない

この制約を回避するため、**テスト対象を同一プロセス内で直接起動する launch 方式** を採用しています。

## 事前条件

以下が使えることを前提にします。

- `nix`
- `nix develop .#dotnet`
- Vim

## セットアップ済みの構成

### 1. Nix shell

`ops/nix/shells/shell.nix` に `netcoredbg` を追加しています。

```nix
buildInputs = with packages; [
  ...
  netcoredbg
  ...
];
```

これにより、`nix develop .#dotnet` の中で `netcoredbg` が使えます。

### 2. Vimspector 設定

リポジトリルートの `.vimspector.json` に、以下 2 つの構成を定義しています。

- `F# xUnit Debug Harness`
- `F# FizzBuzz Runner`

#### F# xUnit Debug Harness

`Tests.fs` のブレークポイントを止めるためのデフォルト構成です。

- `FizzBuzzFSharpTest.dll` を launch
- `--test <pattern>` を `Program.fs` に渡す
- `Program.fs` が reflection で `[<Fact>]` テストを 1 件だけ実行

#### F# FizzBuzz Runner

通常の FizzBuzz 実行をデバッグするための構成です。

- `ProgramArgs` に数値を渡す
- 未指定時は `15`

### 3. Program.fs のデバッグハーネス

`apps/fsharp/FizzBuzzFSharpTest/Program.fs` は、以下の 3 モードを持ちます。

1. `--list-tests`
2. `--test <pattern>`
3. 通常実行

#### `--list-tests`

利用可能なテスト名を表示します。

#### `--test <pattern>`

`[<Fact>]` が付いた静的メソッドを reflection で列挙し、名前に `pattern` を含むテストを 1 件だけ実行します。

- 0 件ならエラー
- 複数件なら候補を表示してエラー
- 1 件ならそのテストだけ実行

## 初回セットアップ手順

### 1. .NET 開発環境に入る

```bash
nix develop .#dotnet
```

### 2. F# アプリをビルドする

```bash
cd apps/fsharp
dotnet build
```

または

```bash
cd apps/fsharp
dotnet test FizzBuzzFSharpTest/FizzBuzzFSharpTest.fsproj
```

`bin/Debug/net8.0/FizzBuzzFSharpTest.dll` が生成されれば準備完了です。

### 3. テスト一覧を確認する

```bash
nix develop .#dotnet --command bash -lc \
  'cd apps/fsharp && dotnet run --project FizzBuzzFSharpTest/FizzBuzzFSharpTest.fsproj -- --list-tests'
```

例:

```text
Tests.safeGenerateで安全にFizzBuzzを生成
Tests.計算式でエラーが伝播する
```

## Vim での使い方

### テストをデバッグする

1. `apps/fsharp/FizzBuzzFSharpTest/Tests.fs` を開く
2. `,dt` でブレークポイントを置く
3. `,dd` を押す
4. `F# xUnit Debug Harness` を選ぶ
5. `TestPattern` にテスト名の一部を入力する

例:

```text
計算式でエラーが伝播する
```

これで、そのテストだけが起動され、`Tests.fs` のブレークポイントで停止できます。

### 通常実行をデバッグする

1. `Program.fs` や `Library.fs` を開く
2. `,dt` でブレークポイントを置く
3. `,dd` を押す
4. `F# FizzBuzz Runner` を選ぶ
5. `ProgramArgs` に件数を入れる

例:

```text
30
```

## キーマップ

Vimspector の主要操作は以下です。

| キー | 動作 |
|---|---|
| `,dd` | デバッグ開始 |
| `,de` | デバッグ終了 |
| `,dc` | 続行 |
| `,dt` | ブレークポイント切り替え |
| `,dT` | 全ブレークポイント解除 |
| `,dj` | ステップオーバー |
| `,dl` | ステップイン |
| `,dh` | ステップアウト |
| `,dk` | 再起動 |

## トラブルシューティング

### ブレークポイントで止まらない

以下を確認してください。

1. `nix develop .#dotnet` の中で Vim を起動しているか
2. `dotnet build` または `dotnet test` を一度実行しているか
3. `,dd` で **`F# xUnit Debug Harness`** を選んでいるか
4. `TestPattern` が 1 件だけに一致しているか

### `No test matched` が出る

`TestPattern` が一致していません。先に `--list-tests` で候補を確認してください。

### `Multiple tests matched` が出る

パターンが広すぎます。より長いテスト名を入力してください。

### PID attach で止まらない

この環境では PID attach は前提にしません。

- `ptrace_scope = 1`
- `netcoredbg --attach <pid>` が失敗する

そのため、**`F# xUnit Debug Harness` を使うのが正しい手順**です。

## 関連ファイル

- `ops/nix/shells/shell.nix`
- `.vimspector.json`
- `apps/fsharp/FizzBuzzFSharpTest/Program.fs`
- `docs/reference/Vim操作マニュアル.md`
