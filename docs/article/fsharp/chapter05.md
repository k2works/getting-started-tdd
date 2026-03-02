# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、**パッケージ管理** と **静的コード解析** を導入し、コードの品質を自動でチェックできるようにします。

## 5.2 NuGet によるパッケージ管理

### NuGet とは

> NuGet は .NET のパッケージマネージャです。パッケージの追加、削除、更新、依存関係の解決を自動で行います。

Java の Gradle、Node の npm、Python の uv、Ruby の Bundler、Rust の Cargo に相当するのが NuGet です。

### .fsproj ファイルの構成

F# プロジェクトの設定は `.fsproj` ファイルで管理されます。本プロジェクトのライブラリプロジェクトは以下の構成です。

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="Library.fs" />
  </ItemGroup>
</Project>
```

テストプロジェクトの設定は以下の通りです。

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <IsPackable>false</IsPackable>
    <GenerateProgramFile>false</GenerateProgramFile>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="Tests.fs" />
    <Compile Include="Program.fs" />
  </ItemGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
    <PackageReference Include="xunit" Version="2.5.3" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.3" />
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\FizzBuzzFSharp\FizzBuzzFSharp.fsproj" />
  </ItemGroup>
</Project>
```

F# プロジェクトの重要な特徴として、`<Compile Include>` の **順序が意味を持つ** 点があります。F# コンパイラはファイルを上から下へ順に処理するため、依存先のファイルを先に記述する必要があります。

### 主要なコマンド

| コマンド | 説明 |
|---------|------|
| `dotnet new` | 新しいプロジェクトを作成 |
| `dotnet build` | プロジェクトをビルド |
| `dotnet test` | テストを実行 |
| `dotnet run` | アプリケーションを実行 |
| `dotnet add package <name>` | パッケージを追加 |
| `dotnet restore` | 依存パッケージを復元 |

### NuGet の特徴

- **`obj/project.assets.json` による再現性** — 依存パッケージのバージョンを固定し、環境間の差異を排除
- **Central Package Management** — `Directory.Packages.props` で複数プロジェクトのパッケージバージョンを統一管理
- **`bin/` と `obj/` ディレクトリ** — Rust の `target/`、Node の `node_modules/` に相当（`.gitignore` に追加）

## 5.3 Fantomas によるコードフォーマット

### Fantomas とは

> Fantomas は F# の公式コードフォーマッターです。コードスタイルを統一し、チーム内のスタイル議論を排除します。

Rust の rustfmt、Go の gofmt、Python の Ruff format、TypeScript の Prettier に相当します。

### インストールと実行

```bash
# グローバルツールとしてインストール
$ dotnet tool install -g fantomas

# フォーマットチェック（CI 向け）
$ fantomas --check src/ tests/

# 自動フォーマット
$ fantomas src/ tests/
```

### コードスタイル例

Fantomas はデフォルトで F# のスタイルガイドに従ったフォーマットを適用します。

```fsharp
// Before（手動フォーマット）
let generate(number:int):string=match(number%3,number%5)with|(0,0)->"FizzBuzz"|(0,_)->"Fizz"|(_,0)->"Buzz"|_->string number

// After（Fantomas 適用後）
let generate (number: int) : string =
    match (number % 3, number % 5) with
    | (0, 0) -> "FizzBuzz"
    | (0, _) -> "Fizz"
    | (_, 0) -> "Buzz"
    | _ -> string number
```

## 5.4 コード複雑度の管理

### サイクロマティック複雑度

コードの複雑さを定量化する指標です。

| 複雑度の範囲 | 意味 |
|-------------|------|
| 1 - 7 | 低複雑度: 管理しやすく、問題なし |
| 8 - 15 | 中程度の複雑度: リファクタリングを検討 |
| 16 - 25 | 高複雑度: リファクタリングが強く推奨される |
| 26 以上 | 非常に高い複雑度: 関数を分割する必要がある |

F# の match 式はパターンの数に応じて複雑度が増加します。現在の `generate` 関数は 4 つのパターンを持ちますが、ヘルパー関数に分割することで複雑度を低く保てます。

```fsharp
// ヘルパー関数で複雑度を分散
let private isFizz number = number % 3 = 0
let private isBuzz number = number % 5 = 0
let private isFizzBuzz number = isFizz number && isBuzz number
```

## 5.5 コードカバレッジ

### coverlet によるカバレッジ計測

coverlet は .NET のクロスプラットフォームカバレッジツールです。

```bash
# カバレッジ付きでテスト実行
$ dotnet test --collect:"XPlat Code Coverage"
```

テスト結果は `TestResults/` ディレクトリに Cobertura XML 形式で出力されます。

## 5.6 他言語との比較

| ツール | 役割 | 他言語の対応ツール |
|--------|------|-------------------|
| NuGet | パッケージ管理 | npm, Bundler, Cargo, Go Modules |
| Fantomas | コードフォーマット | Prettier, rustfmt, gofmt, Ruff |
| coverlet | カバレッジ計測 | c8, tarpaulin, go test -cover |

## 5.7 まとめ

この章では以下を導入しました。

| ツール | 役割 |
|--------|------|
| NuGet | パッケージ管理と依存関係の解決 |
| .fsproj | F# プロジェクトの設定とファイル順序管理 |
| Fantomas | F# コードの自動フォーマット |
| coverlet | テストカバレッジの計測 |

次章では、これらのツールを **タスクランナー**（Cake）でまとめて実行できるようにし、**CI/CD** パイプラインを構築します。
