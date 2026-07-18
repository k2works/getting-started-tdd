# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

TDD を支える開発基盤として、依存関係の管理とコード品質の自動チェックは欠かせません。前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、Kotlin のパッケージ管理（Gradle と `build.gradle.kts`）と、**静的コード解析** を整備し、コードの品質を自動でチェックできるようにします。

## 5.2 Gradle によるパッケージ管理

### Gradle と build.gradle.kts

> Gradle は JVM 系プロジェクトの標準的なビルドツール兼パッケージマネージャです。依存関係の解決・ビルド・テスト・実行を統一的に扱えます。Kotlin では設定ファイルを Kotlin DSL（`build.gradle.kts`）で記述でき、型安全に構成を書けます。

本プロジェクトのビルド定義は `apps/kotlin/build.gradle.kts` にあります。

```kotlin
plugins {
    kotlin("jvm") version "2.1.0"
    application
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(21)
}

application {
    mainClass.set("fizzbuzz.MainKt")
}
```

### 設定の解説

| 要素 | 説明 |
|------|------|
| `kotlin("jvm") version "2.1.0"` | Kotlin/JVM プラグイン（Kotlin 2.x） |
| `application` | `gradle run` で `main` を実行できるようにする |
| `repositories { mavenCentral() }` | 依存を Maven Central から取得 |
| `testImplementation(kotlin("test"))` | テスト用に kotlin.test を追加 |
| `tasks.test { useJUnitPlatform() }` | テスト実行基盤に JUnit Platform を使用 |
| `kotlin { jvmToolchain(21) }` | JDK 21 のツールチェインを指定 |
| `application { mainClass.set(...) }` | 実行エントリポイントを指定 |

### 依存関係の追加と解決

依存パッケージは `dependencies` ブロックに宣言します。Kotlin は JVM 言語なので、Java の膨大な Maven エコシステムをそのまま利用できます。

```kotlin
dependencies {
    testImplementation(kotlin("test"))
    // 例: 追加ライブラリ
    // implementation("com.google.guava:guava:33.0.0-jre")
}
```

宣言した依存は、`gradle build` や `gradle test` の初回実行時に自動的に取得・解決されます。取得した成果物は Gradle のローカルキャッシュ（`~/.gradle` および `.gradle/`）に保存されます。

```bash
$ gradle build
```

FizzBuzz では標準ライブラリと kotlin.test のみで完結するため、追加の依存は不要です。

Java の Gradle は、Ruby の Bundler、Node の npm、Python の uv に相当する役割を担います。`gradle/wrapper/gradle-wrapper.properties` に Gradle バージョンを固定することで、チームメンバー全員が同じバージョンでビルドできます。

## 5.3 静的コード解析

Kotlin では、静的解析ツールとして **detekt** と **ktlint** が代表的です。いずれも `build.gradle.kts` のプラグインとして導入できます。

> なお、本プロジェクトではこれらのプラグインはまだ導入していません。ここでは **導入例** として設定方法を示します。実際の運用に合わせて必要なものを選んで組み込んでください。

### detekt の導入例

detekt は Kotlin 向けの静的解析ツールで、コードスメル・複雑度・命名規則などを検出します。Java の PMD、TypeScript の ESLint、Python の Ruff に相当します。

```kotlin
// build.gradle.kts（導入例）
plugins {
    kotlin("jvm") version "2.1.0"
    application
    id("io.gitlab.arturbosch.detekt") version "1.23.7"
}
```

```bash
# 解析の実行
$ gradle detekt
```

detekt は循環的複雑度（`CyclomaticComplexity`）や認知的複雑度（`CognitiveComplexity`）などの Metrics 系ルールを持ち、複雑なコードの混入を自動で防げます。設定は `detekt.yml` に記述します。

### ktlint の導入例

ktlint は Kotlin 公式のコーディング規約（Kotlin Coding Conventions）に基づくフォーマッタ兼リンターです。Java の Checkstyle + Spotless、TypeScript の Prettier に相当します。

```kotlin
// build.gradle.kts（導入例）
plugins {
    id("org.jlleitschuh.gradle.ktlint") version "12.1.1"
}
```

```bash
# フォーマットチェック
$ gradle ktlintCheck

# 自動フォーマット
$ gradle ktlintFormat
```

detekt がコード品質・複雑度を、ktlint がスタイル・フォーマットを担当する、という役割分担が一般的です。

### Kotlin コンパイラによる検査

外部ツールを追加しなくても、**Kotlin コンパイラ自体** が品質を大きく底上げします。コンパイル（`gradle build` / `gradle compileKotlin`）の時点で、次のような問題が排除されます。

- **型検査** -- 型の不一致をコンパイル時に検出する
- **null 安全性検査** -- Nullable 型（`String?`）と非 Nullable 型（`String`）を区別し、null 参照による実行時例外を型レベルで防ぐ
- **網羅性チェック** -- `when` 式が sealed class や enum の全ケースを網羅しているかを検査する（式として使う場合、考慮漏れがコンパイルエラーになる）

これにより「テストで守る範囲」と「型システムで守る範囲」を役割分担でき、テストは主にロジックの振る舞いに集中できます。

## 5.4 コードカバレッジ

Kotlin では、コードカバレッジ計測に **Kover**（JetBrains 製）または **JaCoCo** を利用できます。Ruby の SimpleCov、Java の JaCoCo、TypeScript の @vitest/coverage-v8 に相当します。

### Kover の導入例

Kover は Kotlin 向けに設計されたカバレッジツールで、Gradle プラグインとして導入します。

```kotlin
// build.gradle.kts（導入例）
plugins {
    id("org.jetbrains.kotlinx.kover") version "0.9.1"
}
```

```bash
# テスト実行 + カバレッジレポート生成
$ gradle koverHtmlReport
```

HTML レポートは `build/reports/kover/html/index.html` に生成されます。

TDD で開発を進める限り、実装は常にテストによって駆動されるため、カバレッジ数値を後追いで上げるのではなく、**テストファーストで書くことで自然に高いカバレッジが保たれる** のが利点です。

## 5.5 他言語との比較

| 用途 | Kotlin | Ruby | Java | TypeScript |
|------|--------|------|------|-----------|
| パッケージ管理 | Gradle | Bundler | Gradle / Maven | npm |
| テスト | kotlin.test (JUnit Platform) | Minitest | JUnit 5 | Vitest |
| 静的解析 | detekt | RuboCop | Checkstyle + PMD | ESLint |
| フォーマッタ | ktlint | RuboCop | google-java-format | Prettier |
| カバレッジ | Kover / JaCoCo | SimpleCov | JaCoCo | @vitest/coverage-v8 |
| 型・null 検査 | コンパイラ標準 | なし（動的型） | コンパイラ（null は別） | コンパイラ（tsc） |

Kotlin はコンパイラが型・null・網羅性の検査を標準で担い、その上に detekt・ktlint を重ねる構成になります。

## 5.6 まとめ

この章では以下を学びました。

- `build.gradle.kts` によるパッケージ定義と、`dependencies` での依存宣言（`mavenCentral` / `testImplementation`）
- `gradle build` / `gradle test` 実行時の依存の自動解決
- detekt・ktlint による静的解析とフォーマット（導入例）
- Kotlin コンパイラの型検査・null 安全性検査・`when` の網羅性チェック
- Kover / JaCoCo によるカバレッジ計測

次の章では、Makefile でこれらのタスクを集約し、Nix 開発環境と GitHub Actions による CI/CD パイプラインを構築します。
