# C# debugger セットアップ手順

このドキュメントは、本リポジトリで **Vim + Vimspector + netcoredbg** を使って C# コードと C# テストをデバッグするためのセットアップ手順をまとめたものです。

## 概要

このリポジトリでは、C# デバッグに以下を使います。

- Vim プラグイン: `puremourning/vimspector`
- デバッグアダプタ: `netcoredbg`
- 実行環境: `nix develop .#dotnet`

C# の通常実行デバッグだけでなく、`FizzBuzzTest/*.cs` のブレークポイントも止められるように、`apps/csharp/FizzBuzzTest/Program.cs` に **xUnit デバッグハーネス** を追加しています。

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

リポジトリルートの `.vimspector.json` に、以下 2 つの C# 構成を定義しています。

- `C# xUnit Debug Harness`
- `C# FizzBuzz Runner`

#### C# xUnit Debug Harness

`FizzBuzzTest/*.cs` のブレークポイントを止めるための構成です。

- `FizzBuzzTest.dll` を launch
- `--test <pattern>` を `Program.cs` に渡す
- `Program.cs` が reflection で `[Fact]` テストを 1 件だけ実行

#### C# FizzBuzz Runner

通常の FizzBuzz 実行をデバッグするための構成です。

- `ProgramArgs` に数値を渡す
- 未指定時は `15`

### 3. FizzBuzzTest.csproj の変更

`apps/csharp/FizzBuzzTest/FizzBuzzTest.csproj` は、テストプロジェクトのまま **実行可能な EXE** としても起動できるようにしています。

主な設定は以下です。

```xml
<OutputType>Exe</OutputType>
<StartupObject>FizzBuzzTest.Program</StartupObject>
<IsTestProject>true</IsTestProject>
```

これにより、`dotnet test` でも `dotnet run --project FizzBuzzTest/FizzBuzzTest.csproj` でも使えます。

### 4. Program.cs のデバッグハーネス

`apps/csharp/FizzBuzzTest/Program.cs` は、以下の 3 モードを持ちます。

1. `--list-tests`
2. `--test <pattern>`
3. 通常実行

#### `--list-tests`

利用可能なテスト名を表示します。

#### `--test <pattern>`

`[Fact]` が付いたインスタンスメソッドを reflection で列挙し、名前に `pattern` を含むテストを 1 件だけ実行します。

- 0 件ならエラー
- 複数件なら候補を表示してエラー
- 1 件ならそのテストだけ実行

`Task` / `ValueTask` を返す非同期テストにも対応しています。

## 初回セットアップ手順

### 1. .NET 開発環境に入る

```bash
nix develop .#dotnet
```

### 2. C# アプリをビルドする

```bash
cd apps/csharp
dotnet build FizzBuzzTest/FizzBuzzTest.csproj
```

または

```bash
cd apps/csharp
dotnet test FizzBuzzTest/FizzBuzzTest.csproj
```

`bin/Debug/net8.0/FizzBuzzTest.dll` が生成されれば準備完了です。

> `cd apps/csharp && dotnet test` だけではプロジェクトを特定できず失敗するため、`FizzBuzzTest/FizzBuzzTest.csproj` まで指定します。

### 3. テスト一覧を確認する

```bash
nix develop .#dotnet --command bash -lc \
  'cd apps/csharp && dotnet run --project FizzBuzzTest/FizzBuzzTest.csproj -- --list-tests'
```

例:

```text
DebugHarnessTest.test_単一一致したテストだけを実行する
FizzBuzzCommandTest.ValueCommandで単一値を取得できる
```

## Vim での使い方

### テストをデバッグする

1. `apps/csharp/FizzBuzzTest/*.cs` を開く
2. `,dt` でブレークポイントを置く
3. `,dd` を押す
4. `C# xUnit Debug Harness` を選ぶ
5. `TestPattern` にテスト名の一部を入力する

例:

```text
FizzBuzzCommandTest.ValueCommandで単一値を取得できる
```

これで、そのテストだけが起動され、`FizzBuzzTest/*.cs` のブレークポイントで停止できます。

### 通常実行をデバッグする

1. `Program.cs` や `FizzBuzz/*.cs` を開く
2. `,dt` でブレークポイントを置く
3. `,dd` を押す
4. `C# FizzBuzz Runner` を選ぶ
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
2. `dotnet build FizzBuzzTest/FizzBuzzTest.csproj` または `dotnet test FizzBuzzTest/FizzBuzzTest.csproj` を一度実行しているか
3. `,dd` で **`C# xUnit Debug Harness`** を選んでいるか
4. `TestPattern` が 1 件だけに一致しているか

### `No test matched` が出る

`TestPattern` が一致していません。先に `--list-tests` で候補を確認してください。

### `Multiple tests matched` が出る

パターンが広すぎます。より長いテスト名を入力してください。

### PID attach で止まらない

この環境では PID attach は前提にしません。

- `ptrace_scope = 1`
- `netcoredbg --attach <pid>` が失敗する

そのため、**`C# xUnit Debug Harness` を使うのが正しい手順**です。

## 関連ファイル

- `ops/nix/shells/shell.nix`
- `.vimspector.json`
- `apps/csharp/FizzBuzzTest/FizzBuzzTest.csproj`
- `apps/csharp/FizzBuzzTest/Program.cs`
- `apps/csharp/FizzBuzzTest/DebugHarness.cs`
- `docs/reference/Vim操作マニュアル.md`
