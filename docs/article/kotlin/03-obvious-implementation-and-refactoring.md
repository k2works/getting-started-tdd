# 第 3 章: 明白な実装とリファクタリング

## 3.1 はじめに

前章では、三角測量と `when` 式で FizzBuzz のコアロジックを完成させました。この章では、残りの TODO（リスト生成とプリント）を実装し、リファクタリングで「動作するきれいなコード」を目指します。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 3.2 1 から 100 までのリスト生成

### Red: リスト生成のテスト

1 から指定した数までの FizzBuzz の結果をリストとして返す `generateList` 関数をテストします。まずリストの件数と、いくつかの位置の要素を検証します。

```kotlin
    @Test fun `100 件のリストを生成する`() = assertEquals(100, FizzBuzz.generateList(100).size)
    @Test fun `3 番目の要素は Fizz`() = assertEquals("Fizz", FizzBuzz.generateList(100)[2])
```

Kotlin のリストは 0 始まりのインデックスアクセスで、`list[2]` のように `[]` 演算子で要素を取得します。`size` プロパティで件数を取得できます。

```bash
$ gradle test
> Task :compileTestKotlin FAILED
e: FizzBuzzTest.kt: unresolved reference: generateList
```

`generateList` がまだ定義されていないため、コンパイルエラーになります。Kotlin は静的型付け言語なので、関数が存在しないとコンパイルの段階でエラーが報告されます。

### Green: 明白な実装

ここでは **明白な実装** を適用します。範囲を作り、各要素に `convert` を適用します。

> 明白な実装
>
> シンプルな操作を実現するにはどうすればいいだろうか——そのまま実装しよう。
>
> — テスト駆動開発

`src/main/kotlin/fizzbuzz/FizzBuzz.kt` に `generateList` 関数を追加します。

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }

    fun generateList(n: Int): List<String> = (1..n).map(::convert)
}
```

Kotlin 特有のポイントを確認しましょう。

- `(1..n)` は **範囲（`IntRange`）** を作る式です。`..` 演算子は両端を含む閉区間なので、`1..n` は 1 から `n` までを含みます。Ruby の `(1..n)` と同じく終端を含む点に注意してください。
- `.map(...)` は範囲の各要素に関数を適用し、新しい `List` を返す高階関数です。戻り値の型 `List<String>` を明示しているため、変換結果が文字列のリストであることが型で保証されます。
- `::convert` は **関数参照** です。`convert` 関数そのものを値として `map` に渡しています。`{ n -> convert(n) }` とラムダで書くこともできますが、関数参照の方が簡潔です。

```bash
$ gradle test
BUILD SUCCESSFUL
```

この章までのテストが通りました。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [x] 1 から 100 までの数
- [ ] プリントする

三角測量として、他の位置の要素も検証しておきましょう。

```kotlin
    @Test fun `最初の要素は 1`() = assertEquals("1", FizzBuzz.generateList(100)[0])
    @Test fun `2 番目の要素は 2`() = assertEquals("2", FizzBuzz.generateList(100)[1])
    @Test fun `5 番目の要素は Buzz`() = assertEquals("Buzz", FizzBuzz.generateList(100)[4])
    @Test fun `6 番目の要素は Fizz`() = assertEquals("Fizz", FizzBuzz.generateList(100)[5])
    @Test fun `10 番目の要素は Buzz`() = assertEquals("Buzz", FizzBuzz.generateList(100)[9])
    @Test fun `15 番目の要素は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.generateList(100)[14])
    @Test fun `30 番目の要素は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.generateList(100)[29])
```

```bash
$ gradle test
BUILD SUCCESSFUL
```

## 3.3 プリント機能

プリント機能は、生成したリストの各要素を標準出力に出力するものです。Kotlin のエントリーポイントである `main` 関数で `generateList` の結果を出力します。

```kotlin
// src/main/kotlin/fizzbuzz/Main.kt
package fizzbuzz

fun main() {
    FizzBuzz.generateList(100).forEach(::println)
}
```

- `forEach(...)` はリストの各要素に対して副作用のある処理を実行する高階関数です。`map` が値を変換して新しいリストを返すのに対し、`forEach` は各要素を消費するだけで値を返しません。
- `::println` は標準ライブラリの `println` 関数への関数参照です。`{ item -> println(item) }` と書くのと同じですが、関数参照の方が簡潔です。

実行して確認します。

```bash
$ gradle run
1
2
Fizz
4
Buzz
Fizz
...
Fizz
Buzz
```

1 から 100 までの FizzBuzz が出力されました。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [x] 1 から 100 までの数
- [x] プリントする

## 3.4 リファクタリング

テスト駆動開発の流れを確認しておきましょう。

> 1. レッド：動作しない、おそらく最初のうちはコンパイルも通らないテストを 1 つ書く。
> 2. グリーン：そのテストを迅速に動作させる。このステップでは罪を犯してもよい。
> 3. リファクタリング：テストを通すために発生した重複をすべて除去する。
>
> レッド・グリーン・リファクタリング。それが TDD のマントラだ。
>
> — テスト駆動開発

### プロダクトコードの確認

最終的な `src/main/kotlin/fizzbuzz/FizzBuzz.kt` を確認します。

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }

    fun generateList(n: Int): List<String> = (1..n).map(::convert)
}
```

Kotlin のコードは非常に簡潔です。注目すべきポイントは以下の通りです。

- **型シグネチャ**: `convert(n: Int): String` と `generateList(n: Int): List<String>` により、関数の入出力の型が明確に宣言されています。Kotlin は型推論も強力ですが、公開する関数には明示的に型を書くのがベストプラクティスです。
- **式本体**: どちらの関数も `= ...` の **式本体** で書かれており、単一の式で完結しています。中括弧と `return` を伴うブロック本体より簡潔です。
- **when 式**: `convert` の分岐は `when` 式で網羅的に表現され、`else` により必ず値を返すことが保証されています。Ruby のガード節を並べる書き方より、条件と結果の対応が一目で読み取れます。

プロダクトコードは十分にシンプルで、これ以上のリファクタリングの必要はありません。

### テストコードの確認

`FizzBuzzTest.kt` は `convert` と `generateList` に入力を与えて出力を検証するだけで完結し、モックやスタブといったテストダブルを一切必要としません。これは `convert`・`generateList` がいずれも副作用を持たない **純粋な関数** であるためです。バッククォート記法により、各テスト名が日本語の仕様そのものとして読める点も、テストの意図を明確にしています。

## 3.5 他言語との比較

| 概念 | Java | Python | TypeScript | Ruby | Kotlin |
|------|------|--------|-----------|------|--------|
| テストフレームワーク | JUnit 5 | pytest | Vitest | Minitest | kotlin.test |
| テスト実行 | `./gradlew test` | `pytest` | `npx vitest` | `bundle exec rake test` | `gradle test` |
| 型付け | 静的 | 動的 | 静的 | 動的 | 静的 |
| 文字列変換 | `String.valueOf(n)` | `str(n)` | `n.toString()` | `n.to_s` | `n.toString()` |
| 剰余判定 | `n % 3 == 0` | `n % 3 == 0` | `n % 3 === 0` | `(n % 3).zero?` | `n % 3 == 0` |
| 条件分岐 | `if-else` | `if-elif` | `if-else` | `case/when` | `when` 式 |
| リスト生成 | `IntStream.rangeClosed` | `[f(n) for n in range]` | `Array.from({length})` | `(1..n).map { }` | `(1..n).map(::f)` |
| null 安全 | なし | なし | strict オプション | なし | 言語仕様（`?` と非 null 型） |

Ruby との対比で見ると、剰余判定やリスト生成の書き味は近い一方で、Kotlin は **静的型付け** と **null 安全** を言語仕様として備えている点が大きく異なります。`Int` は非 null 型であり、`convert(n: Int): String` というシグネチャだけで「`n` は必ず整数」「戻り値は必ず文字列（null になり得ない）」ことが保証されます。動的型付けの Ruby では実行時にしか分からない型の不整合を、Kotlin ではコンパイル時に検出できます。

## 3.6 まとめ

この章では以下のことを学びました。

- **明白な実装** でシンプルな操作をそのまま実装する手法
- Kotlin の範囲 `(1..n)` と `map` によるリスト生成
- **関数参照** `::convert` / `::println` による簡潔な高階関数の利用
- `forEach` による副作用（出力）の実行
- Kotlin の **式本体** と **型シグネチャ** による簡潔で明確なコード
- Ruby（動的型付け）と Kotlin（静的型付け・null 安全）の比較
- Red-Green-Refactor サイクルの完了

第 1 部の 3 章を通じて、TDD の基本サイクル（仮実装 → 三角測量 → 明白な実装 → リファクタリング）を一通り体験しました。Kotlin では静的型付けと null 安全により、関数のシグネチャがそのまま仕様の一部となり、コンパイル時に多くの誤りを防げることが分かりました。

次の第 2 部では、開発環境の自動化（バージョン管理、パッケージ管理、CI/CD）に進みます。

### 実装

<details>
<summary>実装コード（src/main/kotlin/fizzbuzz/FizzBuzz.kt）</summary>

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }

    fun generateList(n: Int): List<String> = (1..n).map(::convert)
}
```

</details>

<details>
<summary>エントリーポイント（src/main/kotlin/fizzbuzz/Main.kt）</summary>

```kotlin
package fizzbuzz

fun main() {
    FizzBuzz.generateList(100).forEach(::println)
}
```

</details>

<details>
<summary>テストコード（src/test/kotlin/fizzbuzz/FizzBuzzTest.kt）</summary>

```kotlin
package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzTest {
    @Test fun `1 を渡したら文字列 1 を返す`() = assertEquals("1", FizzBuzz.convert(1))
    @Test fun `2 を渡したら文字列 2 を返す`() = assertEquals("2", FizzBuzz.convert(2))
    @Test fun `3 の倍数は Fizz`() = assertEquals("Fizz", FizzBuzz.convert(3))
    @Test fun `5 の倍数は Buzz`() = assertEquals("Buzz", FizzBuzz.convert(5))
    @Test fun `15 の倍数は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.convert(15))
    @Test fun `100 件のリストを生成する`() = assertEquals(100, FizzBuzz.generateList(100).size)
    @Test fun `最初の要素は 1`() = assertEquals("1", FizzBuzz.generateList(100)[0])
    @Test fun `2 番目の要素は 2`() = assertEquals("2", FizzBuzz.generateList(100)[1])
    @Test fun `3 番目の要素は Fizz`() = assertEquals("Fizz", FizzBuzz.generateList(100)[2])
    @Test fun `5 番目の要素は Buzz`() = assertEquals("Buzz", FizzBuzz.generateList(100)[4])
    @Test fun `6 番目の要素は Fizz`() = assertEquals("Fizz", FizzBuzz.generateList(100)[5])
    @Test fun `10 番目の要素は Buzz`() = assertEquals("Buzz", FizzBuzz.generateList(100)[9])
    @Test fun `15 番目の要素は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.generateList(100)[14])
    @Test fun `30 番目の要素は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.generateList(100)[29])
}
```

</details>
