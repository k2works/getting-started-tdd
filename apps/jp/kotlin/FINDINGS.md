# Kotlin 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | バージョン（実行時の出力から） |
|------|------------------------------|
| Kotlin | Kotlin Gradle プラグイン 2.2.20（既存 `apps/kotlin` と同じ。Nix 環境の `kotlinc` は 2.3.0 で、実験に使用） |
| JDK | OpenJDK 21.0.9 |
| Gradle | 8.14.3（Nix 環境の `gradle`） |
| テスト | kotlin.test 2.2.20（JUnit 5 上で実行） |
| detekt | detekt-cli 1.23.8 |
| ktlint | ktlint-cli 1.8.0 |

`make test` の結果: **21 件成功、0 件失敗**（FizzBuzz 9 件、タイプ 6 件、パイプライン 3 件、安全変換 3 件）。
`make lint`（detekt と ktlint）: 設定変更後は両方とも違反 0 件で成功します。

Gradle のテストログにはバッククォートの関数名がそのまま出ます。

```text
FizzBuzzテスト > 3を FizzBuzz変換 と書ける（中置関数）() PASSED
FizzBuzzテスト > 3の FizzBuzz変換 と書ける（拡張関数）() PASSED
タイプテスト > 列挙子を日本語で when に書ける() PASSED
```

## 2. 日本語にできた名前・できなかった名前

### できた名前

| 種類 | 例 |
|------|----|
| パッケージ・ディレクトリ | `package フィズバズ`（`src/main/kotlin/フィズバズ/`） |
| ファイル名 | `タイプ.kt`、`パイプライン.kt`、`語順.kt`、`変換結果.kt` |
| enum class と列挙子 | `enum class タイプ(val 変換: (Int) -> String) { 通常(…), 数字限定(…), FizzBuzz限定(…) }` |
| sealed interface と data class | `sealed interface 変換結果 { data class 成功(val 値: String) … data class 失敗(val エラー: String) … }` |
| トップレベル関数・引数・プロパティ・定数 | `fun FizzBuzz変換(数: Int)`、`fun タイプ生成(番号: Int)`、`private const val フィズ = 3` |
| 拡張関数・中置関数 | `fun Int.FizzBuzz変換()`、`infix fun <T, R> T.を(動詞: (T) -> R)` |
| テスト名 | ``@Test fun `3を渡したらFizzを返す`()``（数字始まり・空白・全角括弧も可） |

`when` の分岐に日本語の列挙子をそのまま書け、網羅性検査も効きます。

```kotlin
when (タイプ生成(3)) {
    タイプ.通常 -> "通常"
    タイプ.数字限定 -> "数字だけ"
    タイプ.FizzBuzz限定 -> "15 の倍数だけ"
}
```

### できなかった名前（言語仕様）

バッククォートの名前でも、JVM の制約で `.`・`:`・`[`・`]` などは使えません。なでしこ3 のエラーメッセージ（`該当するタイプは存在しません: 4`）をテスト名に含めることはできません。

```text
colon.kt:1:5: error: name contains illegal characters: :.
fun `存在しないタイプは 該当するタイプは存在しません: 4 になる`() {}
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
colon.kt:2:5: error: name contains illegal characters: ..
fun `3.0を渡す`() {}
    ^^^^^^^^
colon.kt:3:5: error: name contains illegal characters: [].
fun `配列[0]を返す`() {}
    ^^^^^^^^^^
```

全角の `：` や `「」` にすれば通ります（``fun `存在しないタイプは「該当するタイプは存在しません：4」になる`()`` はコンパイル成功）。

バッククォートなしでは数字（全角数字も含む）で始まる名前は書けません。

```text
fullwidth.kt:2:1: error: function declaration must have a name.
fun ３を渡す() {}
^^^^^
```

トップレベル関数 `FizzBuzz変換(数: Int)` と拡張関数 `Int.FizzBuzz変換()` を同じファイル・同じパッケージに置くと、JVM 上で同じシグネチャになり衝突します。

```text
clash.kt:1:1: error: platform declaration clash: The following declarations have the same JVM signature (FizzBuzz変換(I)Ljava/lang/String;):
    fun FizzBuzz変換(数: Int): String defined in root package
    fun Int.FizzBuzz変換(): String defined in root package
```

### 静的型付けで省略したテスト

`安全変換(数: Int)` の引数は `Int` なので、なでしこ3 の「数値でなければ失敗になる」テストはコンパイル時に弾かれます。

```text
str.kt:2:15: error: argument type mismatch: actual type is 'String', but 'Int' was expected.
val 結果 = 安全変換("a")
              ^^^
```

## 3. 回避策とその代償

| 問題 | 回避策 | 代償 |
|------|--------|------|
| 拡張関数とトップレベル関数の JVM シグネチャ衝突 | 拡張関数に `@JvmName("FizzBuzz変換拡張")` を付ける | Java から呼ぶときの名前が変わる。Kotlin からは `FizzBuzz変換(3)` と `3.FizzBuzz変換()` の両方が使える |
| テスト名に `:` などを入れられない | テスト名を言い換える（今回のテスト名はなでしこ3 の原文のままで問題なし） | エラーメッセージ原文をテスト名に埋め込めない |
| 引数名 `N` | 日本語の `数` にした | なでしこ3 の `N` と名前が変わる（日本語化としてはむしろ前進） |
| 起動時のロケール | `LANG` 未設定だと Gradle が日本語のパスを扱えない（下記）。`Makefile` で `LANG`・`LC_ALL` を `C.UTF-8` にする | `make` を通さずに `gradle` を直接実行すると失敗する |

`LANG` 未設定で `gradle clean`・`gradle test` を実行すると、どちらも失敗します。

```text
Execution failed for task ':clean'.
> Malformed input or input contains unmappable characters: /home/user/getting-started-tdd/apps/jp/kotlin/build/classes/kotlin/test/���������������

Execution failed for task ':compileKotlin'.
> Cannot access input property 'sources' of task ':compileKotlin'. …
   > Failed to create MD5 hash for file '/home/user/getting-started-tdd/apps/jp/kotlin/src/main/kotlin/���������������/������������������.kt' as it does not exist.
```

なお、Gradle 経由のコンパイルエラーはパスが URL エンコードされて表示され、日本語のファイル名が読めなくなります。

```text
e: file:///home/user/getting-started-tdd/apps/jp/kotlin/src/test/kotlin/%E3%83%95%E3%82%A3%E3%82%BA%E3%83%90%E3%82%BA/FizzBuzz%E3%83%86%E3%82%B9%E3%83%88.kt:7:56 Unresolved reference 'FizzBuzz変換'.
```

## 4. 語順の再現

中置関数（`infix`）に助詞の名前を付けると、関数参照と組み合わせて SOV 順がそのまま書けます。

```kotlin
infix fun <T, R> T.を(動詞: (T) -> R): R = 動詞(this)
infix fun <T, R> T.して(動詞: (T) -> R): R = 動詞(this)

// なでしこ3: NをFizzBuzz変換して装飾して戻す
fun FizzBuzz装飾(数: Int): String = 数 を ::FizzBuzz変換 して ::装飾

assertEquals("Fizz", 3 を ::FizzBuzz変換)
assertEquals("Fizz", 3.FizzBuzz変換())   // 拡張関数（後置呼び出し）
```

中置関数は左結合なので `(数 を ::FizzBuzz変換) して ::装飾` と評価され、なでしこ3 と同じ順で処理が進みます。関数参照の `::` だけが残る記号です。

## 5. lint・formatter の反応

既存 `apps/kotlin` には lint がないため、detekt と ktlint を CLI（Maven Central の `-all` jar）で Gradle の `JavaExec` タスクとして追加し、既定ルールで実行しました。

### detekt 1.23.8（既定ルール）

名前の規則 8 種が日本語に反応しました（52 件）。ただしテストの関数名（バッククォート）には反応しません。detekt の既定設定では、テストソースが `FunctionNaming` の対象外になっているためです。

```text
…/FizzBuzz.kt:1:1: Package name should match the pattern: [a-z]+(\.[a-z][A-Za-z0-9]*)* [PackageNaming]
…/FizzBuzz.kt:8:5: Function names should match the pattern: [a-z][a-zA-Z0-9]* [FunctionNaming]
…/FizzBuzz.kt:3:19: Top level constant names should match the pattern: [A-Z][_A-Z0-9]* [TopLevelPropertyNaming]
…/タイプ.kt:4:12: Class and Object names should match the pattern: [A-Z][a-zA-Z0-9]* [ClassNaming]
…/タイプ.kt:7:5: Enum entry names should match the pattern: [A-Z][_a-zA-Z0-9]* [EnumNaming]
…/タイプ.kt:16:11: Function parameter names should match the pattern: [a-z][A-Za-z0-9]* [FunctionParameterNaming]
…/変換結果.kt:6:9: Constructor parameter names should match the pattern: [a-z][A-Za-z0-9]* [ConstructorParameterNaming]
…/タイプテスト.kt:9:13: Variable names should match the pattern: [a-z][A-Za-z0-9]* [VariableNaming]
Analysis failed with 52 weighted issues.
```

### ktlint 1.8.0（既定ルール）

6 ルール・43 件が反応しました。テストのバッククォート関数名には反応しません。

```text
…/FizzBuzz.kt:1:9: Package name contains a disallowed character (standard:package-name)
…/FizzBuzz.kt:8:5: Function name should start with a lowercase letter (except factory methods) and use camel case (standard:function-naming)
…/FizzBuzz.kt:3:19: Property name should use the screaming snake case notation when the value can not be changed (standard:property-naming)
…/タイプ.kt:4:12: Class or object name should start with an uppercase letter and use camel case (standard:class-naming)
…/タイプ.kt:7:5: Enum entry name should be uppercase underscore-separated names like "ENUM_ENTRY" or upper camel-case like "EnumEntry" (standard:enum-entry-name-case)
…/パイプライン.kt:1:1: File name 'パイプライン.kt' should conform PascalCase (standard:filename)
Summary error count (descending) by rule:
  standard:function-naming: 11
  standard:package-name: 9
  standard:property-naming: 9
  standard:class-naming: 8
  standard:enum-entry-name-case: 3
  standard:filename: 3
```

`filename` はトップレベル関数だけのファイル（`パイプライン.kt`、`語順.kt`、`タイプ.kt`）にだけ出ます。クラス 1 つだけのファイル（`FizzBuzzテスト.kt` など）はクラス名と一致していれば通ります。

### 抑止方法

| ツール | 変更 | 代償 |
|--------|------|------|
| detekt | `config/detekt.yml`（`--build-upon-default-config`）で 8 ルールのパターンを「既定値 `\|` 日本語を含む名前」に変更 | 日本語を含む名前には大文字・小文字の規則が効かない。ASCII だけの名前には従来どおり効く |
| ktlint | 命名ルールは正規表現を設定できないため、`.editorconfig` で 6 ルールを `disabled` にする | ASCII の名前に対する同じ検査もすべて失われる |

「日本語を含む名前」の正規表現は `(?=.*[\p{IsHan}\p{IsHiragana}\p{IsKatakana}])[\p{L}\p{N}_]+` です。

formatter（ktlint のフォーマット系ルール）は日本語に反応しませんでした。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | 言語仕様上の制約なし。トップレベル関数・拡張関数・中置関数・引数・定数まですべて日本語で書ける |
| 型・モジュール名 | 3 | パッケージ `フィズバズ`・ファイル名 `タイプ.kt`・enum class の列挙子・sealed interface・data class まですべて日本語で可（`LANG=C.UTF-8` が前提） |
| テスト名 | 3 | ``fun `3を FizzBuzz変換 と書ける（中置関数）`()`` のように数字始まり・空白・全角記号込みの文章で書ける（半角の `.`・`:`・`[]` などは不可） |
| 語順の再現 | 3 | 助詞 `を`・`して` を中置関数にして `数 を ::FizzBuzz変換 して ::装飾` と書ける |
| ツール許容 | 2 | detekt・ktlint とも命名規則で失敗する。detekt はパターン変更で両立できるが、ktlint はルールごと無効化するしかない。Gradle は `LANG` 未設定だと日本語のパスでビルド自体が失敗する |
