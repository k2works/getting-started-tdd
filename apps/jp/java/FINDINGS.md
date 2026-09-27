# Java 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | バージョン（実行時の出力から） |
|------|------------------------------|
| JDK | OpenJDK 21.0.9（`javac 21.0.9`） |
| Gradle | 8.14.3（Nix 環境の `gradle`） |
| JUnit | JUnit Jupiter 5.10.2 |
| Checkstyle | 10.18.2 |
| PMD | 7.7.0 |
| SpotBugs | 4.8.3（Gradle プラグイン 6.0.7） |

`make test` の結果: **19 件成功、0 件失敗**（FizzBuzz 8 件、タイプ 6 件、パイプライン 2 件、安全変換 3 件）。
`make lint`（`gradle qualityCheck`）: 設定変更後は Checkstyle・PMD・SpotBugs とも違反 0 件で成功します。

Gradle のテストログには `@DisplayName` の日本語がそのまま出ます。

```text
FizzBuzz 変換 > 3を渡したらFizzを返す PASSED
FizzBuzz 変換 > 3を FizzBuzz変換（語順の再現） PASSED
タイプ生成 > 存在しないタイプはエラーになる PASSED
```

## 2. 日本語にできた名前・できなかった名前

### できた名前

| 種類 | 例 |
|------|----|
| パッケージ・ディレクトリ | `package フィズバズ;`（`src/main/java/フィズバズ/`） |
| クラス・ファイル名 | `タイプ.java`、`パイプライン.java`、`変換結果.java`、`エラー処理.java`、`日本語文.java` |
| enum と列挙子 | `enum タイプ { 通常, 数字限定, FizzBuzz限定 }` |
| sealed interface と record | `sealed interface 変換結果 { record 成功(String 値) … record 失敗(String エラー) … }` |
| メソッド・引数・ローカル変数・定数 | `FizzBuzz変換(int 数)`、`タイプ生成(int 番号)`、`static final int フィズバズ = 15` |
| 助詞のメソッド | `を`、`して`、`戻す` |
| テストクラス・テストメソッド | `class タイプテスト`、`void タイプ1は通常の変換をする()` |
| レコードパターン | `case 変換結果.成功(String 値) -> …` |

列挙子の名前がそのまま `name()` になるので、`タイプ.名前()` は `name()` を返すだけで「通常」「数字限定」を返せます。

### できなかった名前（言語仕様）

数字で始まるテスト名（`3を渡したらFizzを返す` など）はメソッド名にできません。

```text
実験.java:2: error: <identifier> expected
    void 3を渡したらFizzを返す() {}
        ^
実験.java:2: error: '(' expected
    void 3を渡したらFizzを返す() {}
         ^
実験.java:2: error: invalid method declaration; return type required
    void 3を渡したらFizzを返す() {}
          ^
3 errors
```

全角数字にしても識別子の先頭には置けません。

```text
実験2.java:2: error: illegal non-ASCII digit
    void ３を渡したらFizzを返す() {}
         ^
```

### 静的型付けで省略したテスト

`安全変換(int 数)` の引数は `int` なので、なでしこ3 の「数値でなければ失敗になる」テストはコンパイル時に弾かれます。

```text
実験3.java:3: error: incompatible types: String cannot be converted to int
    static void g() { f("a"); }
                        ^
```

## 3. 回避策とその代償

| 問題 | 回避策 | 代償 |
|------|--------|------|
| 数字で始まるテスト名 | `@DisplayName("3を渡したらFizzを返す")` で原文を保ち、メソッド名は先頭の数字だけ漢数字にする（`三を渡したらFizzを返す`、`十五まで作ると15件になる`、`零は失敗になる`） | 同じ名前を 2 回書く。メソッド名と表示名がずれる |
| クラスと同名のメソッド（`安全変換.安全変換`、`文.文`） | Checkstyle `Method Name '安全変換' must not equal the enclosing class name.` と PMD `MethodWithSameNameAsEnclosingClass` に当たるため、クラス名を `エラー処理`（なでしこ3 の `error.nako3` に対応）、`日本語文` に変更 | 静的インポートで関数だけを使うなでしこ3 風の書き方と、Java の「クラスに入れる」構造とのずれ |
| 引数名 `N` | PMD の `The method parameter name 'N' doesn't match '[a-z][a-zA-Z0-9]*'` を避けるため `数` にした | なでしこ3 の `N` と名前が変わる（日本語化としてはむしろ前進） |
| 起動時のロケール | `LANG` 未設定だと Gradle が日本語のパスを扱えない（下記）。`Makefile` で `LANG`・`LC_ALL` を `C.UTF-8` にする | `make` を通さずに `gradle` を直接実行すると失敗する |

`LANG` 未設定（`sun.jnu.encoding = ANSI_X3.4-1968`）で `gradle test` を実行すると、コンパイル前に失敗します。

```text
Execution failed for task ':compileJava'.
> Cannot access input property 'stableSources' of task ':compileJava'. Accessing unreadable inputs or outputs is not supported. …
   > Failed to create MD5 hash for file '/home/user/getting-started-tdd/apps/jp/java/src/main/java/���������������/������������.java' as it does not exist.
```

## 4. 語順の再現

Java には拡張メソッドも中置記法もないため、値を包む `record 日本語文<T>` に助詞のメソッド `を`・`して` を持たせ、メソッドチェーンで SOV 順にします。

```java
public record 日本語文<T>(T 値) {
    public static <T> 日本語文<T> 文(T 値) { return new 日本語文<>(値); }
    public <R> 日本語文<R> を(Function<? super T, ? extends R> 動詞) { return new 日本語文<>(動詞.apply(値)); }
    public <R> 日本語文<R> して(Function<? super T, ? extends R> 動詞) { return を(動詞); }
    public T 戻す() { return 値; }
}

// なでしこ3: NをFizzBuzz変換して装飾して戻す
文(数).を(FizzBuzz::FizzBuzz変換).して(パイプライン::装飾).戻す();
```

`文(3).を(FizzBuzz::FizzBuzz変換).戻す()` のように語順は再現できますが、`文(…)` で包む・`.戻す()` で取り出す・ドットと括弧が挟まる、という儀式が必要です。

## 5. lint・formatter の反応

既存 `apps/java` と同じ Checkstyle・PMD・SpotBugs の設定ファイルをコピーして実行しました。

### 前提: 既定のツール版が Java 21 で動かない

既存 `apps/java` の `build.gradle` はツール版を指定しておらず、Gradle 8.14.3 既定の PMD 6.55.0 が使われます。PMD 6.55.0 は Java 21 のクラスファイルを読めず、日本語かどうかに関係なく全ファイルが解析エラーになり、違反 0 件で「成功」してしまいます。

```text
Caused by: java.lang.IllegalArgumentException: Unsupported class file major version 65
```

このため `build.gradle` で PMD 7.7.0・Checkstyle 10.18.2 を明示しました。

### Checkstyle（apps/java と同じ設定）

名前の規則 5 種がすべての日本語の名前に反応しました（抜粋）。

```text
[ERROR] …/タイプ.java:6:13: Name 'タイプ' must match pattern '^[A-Z][a-zA-Z0-9]*$'. [TypeName]
[ERROR] …/FizzBuzz.java:17:26: Name 'FizzBuzz変換' must match pattern '^[a-z][a-zA-Z0-9]*$'. [MethodName]
[ERROR] …/FizzBuzz.java:9:30: Name 'フィズ' must match pattern '^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$'. [ConstantName]
[ERROR] …/タイプ.java:11:39: Name '変換' must match pattern '^[a-z][a-zA-Z0-9]*$'. [MemberName]
[ERROR] …/タイプテスト.java:17:13: Name '通常' must match pattern '^([a-z][a-zA-Z0-9]*|_)$'. [LocalVariableName]
[ERROR] …/FizzBuzzテスト.java:17:41: '3' is a magic number. [MagicNumber]
```

最後の `MagicNumber` は日本語の名前そのものではなく、既存の抑制設定 `<suppress files=".*Test\.java$" …/>` が `FizzBuzzテスト.java` に一致しないために出たものです。テストクラス名を日本語にすると、ファイル名で効かせていた抑制が外れます。

### PMD 7.7.0（apps/java と同じルールセット）

命名規則 5 ルールが日本語の名前すべてに反応しました（抜粋）。

```text
ClassNamingConventions | The enum name 'タイプ' doesn't match '[A-Z][a-zA-Z0-9]*'
FieldNamingConventions | The enum constant name '通常' doesn't match '[A-Z][A-Z_0-9]*'
MethodNamingConventions | The static method name 'FizzBuzz変換' doesn't match '[a-z][a-zA-Z0-9]*'
MethodNamingConventions | The JUnit 5 test method name '三を渡したらFizzを返す' doesn't match '[a-z][a-zA-Z0-9]*'
ClassNamingConventions | The class name 'FizzBuzzテスト' doesn't match '^Test.*$|^[A-Z][a-zA-Z0-9]*Test(s|Case)?$'
LocalVariableNamingConventions | The local variable name '通常' doesn't match '[a-z][a-zA-Z0-9]*'
```

### SpotBugs 4.8.3

`Nm`（命名規則）が日本語で始まるクラス名・メソッド名に反応し、ビルドが失敗しました。大文字・小文字の区別がない日本語は「大文字で始まる」「小文字で始まる」のどちらの判定にも通りません。

```text
M B Nm: The class name フィズバズ.タイプ doesn't start with an upper case letter  At タイプ.java:[lines 6-34]
M B Nm: The class name フィズバズ.変換結果$成功 doesn't start with an upper case letter  At 変換結果.java:[line 11]
M B Nm: The method name フィズバズ.FizzBuzz.FizzBuzz変換(int) doesn't start with a lower case letter  At FizzBuzz.java:[lines 18-27]
```

### 抑止方法

| ツール | 変更 | 代償 |
|--------|------|------|
| Checkstyle | `TypeName`・`MethodName`・`LocalVariableName`・`MemberName`・`ConstantName` の `format` を「既定値 `\|` 日本語を含む名前」に変更。`suppressions.xml` に `.*テスト\.java$` を追加 | 日本語を含む名前には大文字・小文字の規則が効かない。ASCII だけの名前には従来どおり効く |
| PMD | 命名規則 5 ルールをカテゴリから除外し、各パターンに「`\|` 日本語を含む名前」を足して再定義（`testClassPattern` は `…テスト` を追加）。日本語化と無関係の `UnitTestAssertionsShouldIncludeMessage` と、`JUnitTestContainsTooManyAsserts` の PMD 7 での新名 `UnitTestContainsTooManyAsserts` も除外 | ルールセットが長くなる（プロパティ 18 個） |
| SpotBugs | `config/spotbugs/exclude.xml` で `NM_CLASS_NAMING_CONVENTION`・`NM_METHOD_NAMING_CONVENTION` を除外 | ASCII の名前の命名違反も検出されなくなる |

「日本語を含む名前」の正規表現は `(?=.*[\p{IsHan}\p{IsHiragana}\p{IsKatakana}])[\p{L}\p{N}_]+` です。

formatter は既存 `apps/java` に設定がないため対象外です。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | 言語仕様上の制約なし。メソッド・引数・ローカル変数・定数・助詞 `を` まですべて日本語でコンパイルできる |
| 型・モジュール名 | 3 | パッケージ `フィズバズ`・ファイル名 `タイプ.java`・enum の列挙子・sealed interface・record まですべて日本語で可（`LANG=C.UTF-8` が前提） |
| テスト名 | 3 | `@DisplayName("3を渡したらFizzを返す")` で空白・記号込みの原文を書ける。ただしメソッド名は数字で始められず、表示名と二重に書く |
| 語順の再現 | 2 | `文(3).を(FizzBuzz::FizzBuzz変換).戻す()` のメソッドチェーンで SOV 順になるが、包む・取り出す儀式とドット・括弧が挟まる |
| ツール許容 | 2 | Checkstyle・PMD・SpotBugs の 3 つとも命名規則で失敗する。正規表現の変更と SpotBugs の除外で抑止できる。Gradle は `LANG` 未設定だと日本語のパスでビルド自体が失敗する |
