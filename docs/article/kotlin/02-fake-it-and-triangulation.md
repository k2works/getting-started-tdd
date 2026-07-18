# 第 2 章: 仮実装と三角測量

## 2.1 はじめに

前章では、FizzBuzz の仕様を TODO リストに分解し、最初のテストを仮実装で通しました。この章では、**三角測量** によってプログラムを一般化し、さらに FizzBuzz のコアロジックを実装していきます。

**TODO リスト**:

- [ ] 数を文字列にして返す
    - [x] 1 を渡したら文字列 "1" を返す
    - [ ] 2 を渡したら文字列 "2" を返す
- [ ] 3 の倍数のときは数の代わりに「Fizz」と返す
- [ ] 5 の倍数のときは「Buzz」と返す
- [ ] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 2.2 三角測量

1 を渡したら文字列 "1" を返すようにできました。前章の実装は引数を無視して `"1"` を返すだけの仮実装です。では、2 を渡したらどうなるでしょうか？

### Red: 2 つ目のテストを書く

```kotlin
    @Test fun `2 を渡したら文字列 2 を返す`() = assertEquals("2", FizzBuzz.convert(2))
```

テストを実行します。仮実装は常に `"1"` を返すため、期待値 `"2"` と一致せず失敗します。

```bash
$ gradle test
> Task :test FAILED
`2 を渡したら文字列 2 を返す` FAILED
    expected:<"2"> but was:<"1">
```

テストが失敗しました。文字列 "1" しか返さないプログラムなのですから当然です。

### Green: 一般化する

数値を文字列に変換して返すように修正します。Kotlin ではすべての値が `toString()` を持ち、`Int` の値も `n.toString()` で文字列に変換できます。これまで未使用だった引数 `n` を実際に使うことになり、前章で発生していた未使用引数の警告も解消されます。

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = n.toString()
}
```

テストを実行します。

```bash
$ gradle test
BUILD SUCCESSFUL
```

この章までのテストが通りました。2 つ目のテストによって `convert` 関数の一般化を実現できました。このようなアプローチを **三角測量** と言います。

> 三角測量
>
> テストから最も慎重に一般化を引き出すやり方はどのようなものだろうか——2 つ以上の例があるときだけ、一般化を行うようにしよう。
>
> — テスト駆動開発

Ruby では `n.to_s`、Java では `String.valueOf(n)` と書くところを、Kotlin では `n.toString()` を使います。Kotlin では `Int` は非 null 型なので、`null` に対する `toString` の心配は不要で、静的型により `n` が確実に `Int` であることが保証されています。

**TODO リスト**:

- [x] 数を文字列にして返す
    - [x] 1 を渡したら文字列 "1" を返す
    - [x] 2 を渡したら文字列 "2" を返す
- [ ] 3 の倍数のときは数の代わりに「Fizz」と返す
- [ ] 5 の倍数のときは「Buzz」と返す
- [ ] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 2.3 3 の倍数 — Fizz

次は「3 の倍数のときは数の代わりに Fizz と返す」に取り掛かります。

### Red: 3 の倍数のテスト

```kotlin
    @Test fun `3 の倍数は Fizz`() = assertEquals("Fizz", FizzBuzz.convert(3))
```

```bash
$ gradle test
> Task :test FAILED
`3 の倍数は Fizz` FAILED
    expected:<"Fizz"> but was:<"3">
```

### Green: when 式による条件分岐

3 の倍数のときは "Fizz" を返すように実装します。Kotlin では **`when` 式** を使って条件分岐を記述します。剰余は `%` 演算子で求めます。

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 3 == 0 -> "Fizz"
        else -> n.toString()
    }
}
```

Kotlin の `when` は文ではなく **式** です。引数を伴わない `when { 条件 -> 値 ... }` の形では、各分岐の条件を上から順に評価し、最初に真になった分岐の値を返します。値を返す式として使う場合、あらゆるケースを網羅する必要があり、ここでは `else` 分岐がそれを担っています。`else` を省略すると「値を返さない可能性」が生じてコンパイルエラーになるため、条件の考慮漏れを型検査で防げます。Ruby の `case/when` に相当しますが、Kotlin の `when` は式として値を返す点が特徴です。

```bash
$ gradle test
BUILD SUCCESSFUL
```

テストが通りました。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [ ] 5 の倍数のときは「Buzz」と返す
- [ ] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 2.4 5 の倍数 — Buzz

### Red: 5 の倍数のテスト

```kotlin
    @Test fun `5 の倍数は Buzz`() = assertEquals("Buzz", FizzBuzz.convert(5))
```

```bash
$ gradle test
> Task :test FAILED
`5 の倍数は Buzz` FAILED
    expected:<"Buzz"> but was:<"5">
```

### Green: Buzz の実装

`when` 式に 5 の倍数の分岐を追加します。

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }
}
```

```bash
$ gradle test
BUILD SUCCESSFUL
```

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [ ] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 2.5 15 の倍数 — FizzBuzz

### Red: 15 の倍数のテスト

```kotlin
    @Test fun `15 の倍数は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.convert(15))
```

```bash
$ gradle test
> Task :test FAILED
`15 の倍数は FizzBuzz` FAILED
    expected:<"FizzBuzz"> but was:<"Fizz">
```

15 は 3 の倍数でもあるため、"Fizz" が返されてしまいました。`when` 式は上から順番に評価されるので、3 の倍数の分岐に先にマッチしてしまいます。3 と 5 の両方の倍数（つまり 15 の倍数）の判定を **先に** 行う必要があります。

### Green: 分岐の順序を修正

```kotlin
package fizzbuzz

object FizzBuzz {
    fun convert(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }
}
```

`when` 式は上から順に評価されるため、最も限定的な条件（15 の倍数）を最初に配置します。これは Ruby の `case/when` でガード条件を並べる際の順序や、パターンマッチの並び順と同じ考え方です。

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
- [ ] 1 から 100 までの数
- [ ] プリントする

ここまでの作業をコミットしておきましょう。

```bash
$ git add .
$ git commit -m 'feat(kotlin): FizzBuzz のコアロジックを実装'
```

## 2.6 まとめ

この章では以下のことを学びました。

- **三角測量** で 2 つ以上の例を使ってプログラムを一般化する手法
- Kotlin の `toString()` による整数から文字列への変換
- Kotlin の `%` 演算子による剰余の計算
- **`when` 式** による条件分岐の記述（式として値を返し、`else` で網羅する）
- Ruby の `case/when` との対比（Kotlin の `when` は値を返す式である点が異なる）
- `when` の分岐の **評価順序** の重要性（限定的な条件を先に配置）
- Red-Green サイクルを繰り返してコアロジックを段階的に構築する方法

次章では、残りの TODO（リスト生成とプリント）を実装し、リファクタリングで「動作するきれいなコード」を目指します。

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
}
```

</details>
