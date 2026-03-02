# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、**パッケージ管理** と **静的コード解析** を導入し、コードの品質を自動でチェックできるようにします。

## 5.2 NuGet によるパッケージ管理

### NuGet とは

> NuGet は .NET のパッケージマネージャです。開発者が作成・共有したライブラリやツールを「パッケージ」として配布・利用することができます。

Java の Gradle、Node の npm、Python の pip、Ruby の Bundler、Rust の Cargo に相当するのが NuGet です。

### .csproj ファイルの構成

本プロジェクトの `.csproj` ファイルは以下のようになっています。

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
</Project>
```

テストプロジェクトの `.csproj` にはテスト関連のパッケージが含まれます。

```xml
<ItemGroup>
  <PackageReference Include="coverlet.collector" Version="6.0.0" />
  <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
  <PackageReference Include="xunit" Version="2.5.3" />
  <PackageReference Include="xunit.runner.visualstudio" Version="2.5.3" />
</ItemGroup>
```

### 主要なコマンド

| コマンド | 説明 |
|---------|------|
| `dotnet new <テンプレート>` | 新しいプロジェクトを作成 |
| `dotnet build` | プロジェクトをビルド |
| `dotnet test` | テストを実行 |
| `dotnet run` | アプリケーションを実行 |
| `dotnet add package <名前>` | NuGet パッケージを追加 |
| `dotnet restore` | 依存パッケージを復元 |

### NuGet の特徴

- **`packages.lock.json` による再現性** — パッケージバージョンを固定し、チーム全員が同じ環境で開発できる
- **ソリューション構成** — 複数プロジェクトを 1 つのソリューションで管理
- **`bin/` / `obj/` ディレクトリ** — Rust の `target/`、Node の `node_modules/` に相当（`.gitignore` に追加）

## 5.3 dotnet format によるコードフォーマット

### dotnet format とは

> dotnet format は .NET の標準コードフォーマッターです。コードスタイルを統一し、チーム内のスタイル議論を排除します。

Rust の rustfmt、Go の gofmt、Python の Ruff format、TypeScript の Prettier に相当します。

### 実行してみる

```bash
# フォーマットチェック（CI 向け）
$ dotnet format --verify-no-changes

# 自動フォーマット
$ dotnet format
```

### .editorconfig による設定

`.editorconfig` ファイルでコーディングスタイルを定義できます。

```ini
root = true

[*]
indent_style = space
indent_size = 4
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.cs]
dotnet_sort_using_directives = true
csharp_prefer_braces = true:warning
```

## 5.4 Roslyn アナライザによる静的解析

### Roslyn アナライザとは

> Microsoft.CodeAnalysis.Analyzers は .NET の公式リンターです。コンパイル時にコードの品質を自動チェックし、一般的なミスやアンチパターンを検出します。

Rust の Clippy、TypeScript の ESLint、Python の Ruff、Go の golangci-lint に相当するツールです。

### 導入方法

```bash
$ dotnet add package Microsoft.CodeAnalysis.Analyzers
```

ビルド時に自動的に静的解析が実行されます。

```bash
$ dotnet build
```

### 警告カテゴリ

| カテゴリ | 説明 |
|---------|------|
| Design | 設計上の問題 |
| Naming | 命名規則違反 |
| Performance | パフォーマンスに影響するコード |
| Reliability | 信頼性に関する問題 |
| Security | セキュリティリスク |
| Usage | API の誤用 |

## 5.5 コードカバレッジ

### coverlet

C# のカバレッジツールとして `coverlet` があります。xUnit テストプロジェクトには既に含まれています。

```bash
# カバレッジ付きテスト実行
$ dotnet test --collect:"XPlat Code Coverage"
```

HTML レポートを生成するには `reportgenerator` を利用します。

```bash
$ dotnet tool install -g dotnet-reportgenerator-globaltool
$ reportgenerator -reports:"**/coverage.cobertura.xml" -targetdir:"coverage" -reporttypes:Html
```

## 5.6 まとめ

この章では以下を導入しました。

| ツール | 役割 | 他言語の対応ツール |
|--------|------|-------------------|
| NuGet | パッケージ管理 | npm, Bundler, Cargo, pip |
| dotnet format | コードフォーマット | rustfmt, gofmt, Prettier |
| Roslyn アナライザ | 静的解析（リンター） | Clippy, ESLint, Ruff |
| coverlet | カバレッジ計測 | cargo-tarpaulin, c8, SimpleCov |

次章では、これらのツールを **タスクランナー**（Cake）でまとめて実行できるようにし、**CI/CD** パイプラインを構築します。
