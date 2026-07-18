# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

TDD を支える開発基盤として、依存関係の管理とコード品質の自動チェックは欠かせません。この章では、Flix のパッケージ管理（`flix.toml`）と、コンパイラに組み込まれた静的解析（型検査・効果検査・フォーマッタ）を整備します。

Flix の大きな特徴は、**ビルドツール・パッケージマネージャ・テストランナー・フォーマッタ・ドキュメント生成・LSP がすべて `flix.jar` 単体に同梱** されていることです。外部ツールを追加インストールする必要がありません。

## 5.2 パッケージ管理

### flix.toml

Flix のパッケージ定義は `flix.toml` に記述します。`flix init` で雛形が生成されます。

```toml
[package]
name        = "fizzbuzz"
description = "FizzBuzz TDD implementation in Flix"
version     = "0.1.0"
flix        = "0.75.1"
authors     = ["k2works"]
```

- `name` / `version` -- パッケージ名とセマンティックバージョン
- `flix` -- 対応する Flix コンパイラのバージョン
- `authors` -- 作者

### 依存関係の追加

依存パッケージは `[dependencies]`（Flix パッケージ）と `[mvn-dependencies]`（Maven パッケージ）のセクションに記述します。Flix は JVM 言語なので、Java の膨大な Maven エコシステムをそのまま利用できます。

```toml
[dependencies]
"github:flix/museum" = "1.4.0"

[mvn-dependencies]
"org.apache.commons:commons-lang3" = "3.14.0"
```

FizzBuzz では標準ライブラリ（`Int32`、`List` など）のみで完結するため、追加の依存は不要です。

### 依存関係の解決

`flix build` や `flix test` の実行時に、宣言された依存が自動的に取得・解決されます。取得したパッケージは `lib/` に展開されるため、`.gitignore` で除外します（第 4 章参照）。

```bash
$ java -jar flix.jar test
Running Maven dependency resolver.
Downloading external jar dependencies...
Dependency resolution completed.
```

### 古い依存の確認

`outdated` コマンドで、更新可能な依存を確認できます。

```bash
$ java -jar flix.jar outdated
```

## 5.3 静的解析

Flix のコンパイラは、他言語では別ツール（リンター・型チェッカ）で行う検査の多くを、**コンパイル時に標準で** 実施します。

### 型検査と効果検査

`check` コマンドは、コードを実行せずに型と効果の整合性を検査します。

```bash
$ java -jar flix.jar check
```

エラーがなければ何も出力されず終了します。Flix の検査は非常に厳格で、次のようなものをコンパイル時に排除します。

- **型の不一致** -- `Int32` を期待する箇所に `String` を渡すなど
- **効果の不一致** -- 純粋関数のはずの関数内で `println`（`IO` 効果）を呼ぶなど
- **未使用の仮引数** -- 第 1 章で触れたように、使わない引数は `_` を前置する必要がある
- **網羅されていないパターンマッチ** -- 分岐の考慮漏れ

特に **効果検査** は Flix ならではの強力な機能です。関数の型 `Int32 -> String`（効果なし）と `Int32 -> String \ IO`（IO 効果あり）は別物として扱われ、副作用の混入がコンパイラによって検出されます。これにより「どの関数が純粋で、どの関数が副作用を持つか」がコード上で常に明確になります。

### フォーマッタ

`format` コマンドで、ソースコードを統一スタイルに整形します。

```bash
# 差分の確認のみ
$ java -jar flix.jar format --check

# 実際に整形
$ java -jar flix.jar format
```

チーム開発では、CI に `format --check` を組み込むことで、スタイルの揺れを防げます。

### ドキュメント生成

`doc` コマンドで、`///` ドキュメントコメントから API ドキュメント（HTML）を生成します。

```bash
$ java -jar flix.jar doc
```

第 1〜3 章で関数に付けてきた `///` コメントが、そのままドキュメントになります。

## 5.4 カバレッジと品質の考え方

Flix には専用のカバレッジツールはまだ整備されていませんが、TDD で開発を進める限り、実装は常にテストによって駆動されます。カバレッジ数値を後追いで上げるのではなく、**テストファーストで書くことで自然に高いカバレッジが保たれる** のが TDD の利点です。

加えて、Flix では次の 2 点が品質を底上げします。

- **強力な型・効果システム** -- テストで検出すべきバグの多くをコンパイル時に排除する
- **網羅性検査** -- パターンマッチの考慮漏れをコンパイラが指摘する

つまり Flix では「テストで守る範囲」と「型システムで守る範囲」を役割分担でき、テストは主にロジックの振る舞いに集中できます。

## 5.5 他言語との比較

| 項目 | Java | Rust | Haskell | Flix |
|------|------|------|---------|------|
| パッケージ定義 | `pom.xml` / `build.gradle` | `Cargo.toml` | `package.yaml` | `flix.toml` |
| 依存取得 | Maven / Gradle | `cargo build` | `stack build` | `flix build`（自動） |
| 型検査 | `javac` | `cargo check` | `ghc` | `flix check` |
| 静的解析 | SpotBugs / Checkstyle | Clippy | HLint | コンパイラ標準 |
| フォーマッタ | google-java-format | `rustfmt` | ormolu / fourmolu | `flix format` |
| 副作用の検査 | なし | なし | 型（IO モナド） | 効果システム |

Flix はこれらを **単一ツールに統合** している点が際立ちます。

## 5.6 まとめ

この章では以下を学びました。

- `flix.toml` によるパッケージ定義と、`[dependencies]` / `[mvn-dependencies]` での依存宣言
- `flix build` / `flix test` 実行時の依存の自動解決
- `flix check` による型検査と **効果検査**
- `flix format` によるコード整形と `flix doc` による API ドキュメント生成
- Flix では型・効果システムと網羅性検査が品質を底上げし、テストとの役割分担ができること

次章では、これらのコマンドをタスクランナーと CI/CD パイプラインに組み込み、自動化を進めます。
