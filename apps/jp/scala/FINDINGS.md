# Scala 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | バージョン（実行時の出力・設定から） |
|------|--------------------------------------|
| Scala | 3.3.4（`build.sbt`。既存 `apps/scala` と同じ） |
| sbt | 1.10.6（`welcome to sbt 1.10.6 (N/A Java 21.0.9)`） |
| JDK | OpenJDK 21.0.9 |
| テスト | ScalaTest 3.2.18（`AnyFunSuite`） |
| scalafmt | 3.7.17（sbt-scalafmt 2.5.2） |
| WartRemover | sbt-wartremover 3.2.5 |

`make test` の結果: **20 件成功、0 件失敗**（FizzBuzz 8 件、タイプ 6 件、パイプライン 3 件、安全変換 3 件）。
`make check`（`scalafmtCheckAll`・`-Xfatal-warnings` 付きの `compile`・`test`）: 設定変更なしで成功します。

```text
[info] FizzBuzzテスト:
[info] - 3を渡したらFizzを返す
[info] - 3 を FizzBuzz変換 と書ける（中置の拡張メソッド）
[info] Tests: succeeded 20, failed 0, canceled 0, ignored 0, pending 0
```

## 2. 日本語にできた名前・できなかった名前

### できた名前

| 種類 | 例 |
|------|----|
| パッケージ・ディレクトリ | `package フィズバズ`（`src/main/scala/フィズバズ/`） |
| ファイル名 | `タイプ.scala`、`パイプライン.scala`、`語順.scala`、`変換結果.scala` |
| enum と case | `enum タイプ(val 変換: Int => String): case 通常 … case 数字限定 … case FizzBuzz限定` |
| ADT（enum） | `enum 変換結果: case 成功(値: String) case 失敗(エラー: String)` |
| トップレベル定義・引数・定数 | `def FizzBuzz変換(数: Int)`、`def タイプ生成(番号: Int)`、`private val フィズ = 3` |
| 拡張メソッド・中置 | `extension [T](目的語: T) infix def を[R](動詞: T => R): R` |
| テストクラス・テスト名 | `class タイプテスト extends AnyFunSuite`、`test("3を渡したらFizzを返す")` |

enum の `toString` が case 名を返すため、`タイプ.名前` は `toString` だけで「通常」「数字限定」を返せます。

### パターンマッチでの日本語の識別子（実験結果）

Scala ではパターン中の「小文字で始まる名前」だけが変数束縛になり、それ以外は既存の値への参照（定数パターン）になります。日本語の文字には大文字・小文字の区別がないため、**日本語の名前はパターン中で常に定数参照として扱われます**。

- `import タイプ.*` のあとの `case 通常 => …` は列挙子 `タイプ.通常` への参照になり、期待どおり動く（テスト「列挙子を日本語のままパターンマッチできる」）。
- `val 閾値 = 3` のあと `x match { case 閾値 => "一致"; case _ => "不一致" }` は `閾値` を定数として比較し、`4` を渡すと `不一致` になった（新しい変数に束縛されない）。
- 抽出子の中で日本語の変数に束縛しようとすると、未定義の値を参照したとしてエラーになる。

```text
[error] -- [E006] Not Found Error: /home/user/getting-started-tdd/apps/jp/scala/src/test/scala/フィズバズ/安全変換テスト.scala:16:19
[error] 16 |      case 変換結果.成功(値)   => s"成功 $値"
[error]    |                   ^
[error]    |                   Not found: 値
```

型付きパターンでも同じ理由で拒否されます。

```text
[error] 5 |    case 結果: 変換結果.成功 => 結果.値
[error]   |           ^
[error]   |Type ascriptions after patterns other than:
[error]   |  * variable pattern, e.g. `case x: String =>`
[error]   |  * number literal pattern, e.g. `case 10.5: Double =>`
[error]   |are no longer supported. Remove the type ascription or move it to a separate variable pattern.
```

`値 @ _`（束縛子）や `_値`（下線始まりは小文字扱い）と書けば、日本語の名前で変数に束縛できました。

### できなかった名前（中置記法）

Scala 3 では英数字（日本語の文字も含む）の名前のメソッドを中置で使うには `infix` 修飾子が必要です。`infix` を外し `-source:future` でコンパイルすると次のエラーになります（3.3.4 の既定ではエラーになりません）。

```text
[error] 7 |def FizzBuzz装飾(数: Int): String = 数 を FizzBuzz変換 して 装飾
[error]   |                                   ^
[error]   |Alphanumeric method を is not declared infix; it should not be used as infix operator.
[error]   |Instead, use method syntax .を(...) or backticked identifier `を`.
```

### 静的型付けで省略したテスト

`安全変換(数: Int)` の引数は `Int` なので、なでしこ3 の「数値でなければ失敗になる」テストはコンパイル時に弾かれるため省略しました。

## 3. 回避策とその代償

| 問題 | 回避策 | 代償 |
|------|--------|------|
| パターン中の日本語名が変数束縛にならない | `case 変換結果.成功(値 @ _) =>` と書く | `@ _` という儀式が必要。うっかり `case 値 =>` と書くと、同名の値がスコープにあれば定数比較として静かに通ってしまう |
| 中置の助詞メソッド | `infix def を` と宣言する | なし（宣言時に 1 語足すだけ） |
| 引数名 `N` | 日本語の `数` にした | なでしこ3 の `N` と名前が変わる（日本語化としてはむしろ前進） |
| 起動時のロケール | `LANG` 未設定だと sbt が日本語のパスを扱えない（下記）。`Makefile` で `LANG`・`LC_ALL` を `C.UTF-8` にする | `make` を通さずに `sbt` を直接実行すると失敗する |

`LANG` 未設定で `sbt Test/compile` を実行すると、ソースの監視処理で失敗します。

```text
[error] java.nio.file.InvalidPathException: Malformed input or input contains unmappable characters: /home/user/getting-started-tdd/apps/jp/scala/src/main/scala/?????
[error] 	at java.base/sun.nio.fs.UnixPath.encode(UnixPath.java:129)
```

## 4. 語順の再現

拡張メソッドを `infix` で宣言すると、メソッドが関数へ自動で変換される（eta 展開）ため、記号なしで SOV 順が書けます。

```scala
extension [T](目的語: T)
  infix def を[R](動詞: T => R): R = 動詞(目的語)
  infix def して[R](動詞: T => R): R = 動詞(目的語)

// なでしこ3: NをFizzBuzz変換して装飾して戻す
def FizzBuzz装飾(数: Int): String = 数 を FizzBuzz変換 して 装飾

assert((3 を FizzBuzz変換) === "Fizz")
```

なでしこ3 の `NをFizzBuzz変換して装飾して戻す` とほぼ同じ並びで、空白以外の記号が入りません。

## 5. lint・formatter の反応

### scalafmt 3.7.17（既存と同じ `.scalafmt.conf`）

日本語の名前でエラーにはなりません。ただし桁の数え方が文字数（コードポイント）基準のため、全角文字を含む行では見た目がずれます。

- `case` の矢印の整列は文字数でそろえるため、等幅フォントでは矢印がそろいません。

```scala
    val 説明 = タイプ生成(3) match
      case 通常         => "通常"
      case 数字限定       => "数字だけ"
      case FizzBuzz限定 => "15 の倍数だけ"
```

- `maxColumn = 100` も文字数で数えるため、表示幅 112 桁（91 文字）の行（`タイプ.scala` 13 行目）が折り返されずに通ります。

### WartRemover 3.2.5

既存 `apps/scala` と同じくプラグインは読み込むだけで wart は有効にしていません。試しに `Warts.unsafe` と `Warts.allBut(Wart.Throw)` を有効にしたところ、反応したのは `[wartremover:Throw] throw is disabled`（題材 B のエラー送出）と `[wartremover:ToString] class タイプ does not override toString`（enum の `toString`）だけで、日本語の名前に反応するルールはありませんでした（WartRemover には命名規則のルールがありません）。

### コンパイラ（`-Xfatal-warnings`）

日本語の名前に対する警告は出ませんでした。エラー表示のキャレット（`^`）は文字数で位置を決めるため、全角文字を含む行では指す位置が見た目上ずれます。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 2 | 定義側は制約なし。ただしパターン中では日本語の名前が変数束縛にならず、`値 @ _` と書く必要がある |
| 型・モジュール名 | 3 | パッケージ `フィズバズ`・ファイル名 `タイプ.scala`・enum とその case・ADT まですべて日本語で可（`LANG=C.UTF-8` が前提） |
| テスト名 | 3 | `test("3を FizzBuzz変換 と書ける（中置の拡張メソッド）")` のように文字列でそのまま書ける |
| 語順の再現 | 3 | `infix` の拡張メソッドで `数 を FizzBuzz変換 して 装飾` と、記号なしで助詞を置いた SOV 順になる |
| ツール許容 | 3 | scalafmt・コンパイラ（`-Xfatal-warnings`）・ScalaTest・WartRemover とも設定変更なしで通る。ただし scalafmt の整列と `maxColumn` は全角の表示幅を考慮しない。sbt は `LANG` 未設定だと日本語のパスで失敗する |
