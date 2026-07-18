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

```flix
    /// 2 を渡したら文字列 "2" を返す。
    @Test
    def convert_2_returns_2(): Unit \ Assert =
        Assert.assertEq(expected = "2", FizzBuzz.convert(2))
```

テストを実行します。仮実装は常に `"1"` を返すため、期待値 `"2"` と一致せず失敗します。

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_2_returns_2  FAIL
    Expected: "2"
    Actual:   "1"

Passed: 1, Failed: 1.
```

テストが失敗しました。文字列 "1" しか返さないプログラムなのですから当然です。

### Green: 一般化する

数値を文字列に変換して返すように修正します。Flix では標準ライブラリの `Int32.toString` で `Int32` 型の値を文字列に変換できます。これまで `_n` として無視していた仮引数を、実際に使う `n` に変更します。

```flix
mod FizzBuzz {
    pub def convert(n: Int32): String = Int32.toString(n)
}
```

テストを実行します。

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_1_returns_1  PASS
  TEST TestFizzBuzz.convert_2_returns_2  PASS

Passed: 2, Failed: 0.
```

テストが通りました。2 つ目のテストによって `convert` 関数の一般化を実現できました。このようなアプローチを **三角測量** と言います。

> 三角測量
>
> テストから最も慎重に一般化を引き出すやり方はどのようなものだろうか——2 つ以上の例があるときだけ、一般化を行うようにしよう。
>
> — テスト駆動開発

Haskell では `show n`、Rust では `n.to_string()` と書くところを、Flix では標準ライブラリ関数 `Int32.toString(n)` を使います。Flix の数値型は `Int8`/`Int16`/`Int32`/`Int64`/`BigInt` と明確に分かれており、それぞれに対応する `toString` が用意されています。型が固定されている分、暗黙の変換に悩まされることがありません。

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

```flix
    /// 3 の倍数を渡したら "Fizz" を返す。
    @Test
    def convert_3_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(3))
```

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_3_returns_Fizz  FAIL
    Expected: "Fizz"
    Actual:   "3"

Passed: 2, Failed: 1.
```

### Green: if 式による条件分岐

3 の倍数のときは "Fizz" を返すように実装します。Flix では **`if` 式** を使って条件分岐を記述します。剰余は `Int32.remainder` で求めます。

```flix
mod FizzBuzz {
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 3) == 0) "Fizz"
        else                            Int32.toString(n)
}
```

Flix の `if` は文ではなく **式** です。`if (条件) 真の値 else 偽の値` の形で、条件に応じた値そのものを返します。三項演算子や Haskell のガード式に近い書き方です。`else` を省略できないのも式であるがゆえの特徴で、「値を返さない分岐」を作れないため、条件の考慮漏れを防げます。

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_3_returns_Fizz  PASS

Passed: 3, Failed: 0.
```

テストが通りました。三角測量として 6 のテストも追加して確認します。

```flix
    /// 6 を渡したら "Fizz" を返す（三角測量）。
    @Test
    def convert_6_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(6))
```

```bash
$ java -jar flix.jar test
Passed: 4, Failed: 0.
```

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [ ] 5 の倍数のときは「Buzz」と返す
- [ ] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 2.4 5 の倍数 — Buzz

### Red: 5 の倍数のテスト

```flix
    /// 5 の倍数を渡したら "Buzz" を返す。
    @Test
    def convert_5_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(5))
```

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_5_returns_Buzz  FAIL
    Expected: "Buzz"
    Actual:   "5"

Passed: 4, Failed: 1.
```

### Green: Buzz の実装

`if` 式に 5 の倍数の条件を追加します。`else if` で分岐を連ねます。

```flix
mod FizzBuzz {
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 3) == 0)      "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)
}
```

```bash
$ java -jar flix.jar test
Passed: 5, Failed: 0.
```

三角測量として 10 のテストも追加します。

```flix
    /// 10 を渡したら "Buzz" を返す（三角測量）。
    @Test
    def convert_10_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(10))
```

```bash
$ java -jar flix.jar test
Passed: 6, Failed: 0.
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

```flix
    /// 15 の倍数を渡したら "FizzBuzz" を返す。
    @Test
    def convert_15_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(15))
```

```bash
$ java -jar flix.jar test
  TEST TestFizzBuzz.convert_15_returns_FizzBuzz  FAIL
    Expected: "FizzBuzz"
    Actual:   "Fizz"

Passed: 6, Failed: 1.
```

15 は 3 の倍数でもあるため、"Fizz" が返されてしまいました。`if` 式は上から順番に評価されるので、3 の倍数の条件に先にマッチしてしまいます。3 と 5 の両方の倍数（つまり 15 の倍数）の判定を **先に** 行う必要があります。

### Green: 条件の順序を修正

```flix
mod FizzBuzz {
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)
}
```

`if` 式は上から順に評価されるため、最も限定的な条件（15 の倍数）を最初に配置します。これは Haskell のガード式の並び順や、Rust の `match` 式のパターンの順序と同じ考え方です。

```bash
$ java -jar flix.jar test
Passed: 7, Failed: 0.
```

三角測量として 30 のテストも追加しておきます。

```flix
    /// 30 を渡したら "FizzBuzz" を返す（三角測量）。
    @Test
    def convert_30_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(30))
```

```bash
$ java -jar flix.jar test
Running 8 tests...
  TEST TestFizzBuzz.convert_1_returns_1          PASS
  TEST TestFizzBuzz.convert_2_returns_2          PASS
  TEST TestFizzBuzz.convert_3_returns_Fizz       PASS
  TEST TestFizzBuzz.convert_6_returns_Fizz       PASS
  TEST TestFizzBuzz.convert_5_returns_Buzz       PASS
  TEST TestFizzBuzz.convert_10_returns_Buzz      PASS
  TEST TestFizzBuzz.convert_15_returns_FizzBuzz  PASS
  TEST TestFizzBuzz.convert_30_returns_FizzBuzz  PASS

Passed: 8, Failed: 0. Skipped: 0.
```

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
$ git commit -m 'feat(flix): FizzBuzz のコアロジックを実装'
```

## 2.6 まとめ

この章では以下のことを学びました。

- **三角測量** で 2 つ以上の例を使ってプログラムを一般化する手法
- Flix の `Int32.toString` による整数から文字列への変換
- Flix の `Int32.remainder` による剰余の計算
- **`if` 式** による条件分岐の記述（`else` は省略不可で、常に値を返す）
- `if`/`else if` の **評価順序** の重要性（限定的な条件を先に配置）
- Red-Green-Refactor サイクルを繰り返してコアロジックを段階的に構築する方法

次章では、残りの TODO（リスト生成）を実装し、リファクタリングで「動作するきれいなコード」を目指します。

### 実装

<details>
<summary>実装コード（src/FizzBuzz.flix）</summary>

```flix
///
/// FizzBuzz を解くモジュール。
///
mod FizzBuzz {
    ///
    /// 数 `n` を FizzBuzz の規則に従って文字列に変換する。
    ///
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)
}
```

</details>

<details>
<summary>テストコード（test/TestFizzBuzz.flix）</summary>

```flix
mod TestFizzBuzz {
    /// 1 を渡したら文字列 "1" を返す。
    @Test
    def convert_1_returns_1(): Unit \ Assert =
        Assert.assertEq(expected = "1", FizzBuzz.convert(1))

    /// 2 を渡したら文字列 "2" を返す。
    @Test
    def convert_2_returns_2(): Unit \ Assert =
        Assert.assertEq(expected = "2", FizzBuzz.convert(2))

    /// 3 の倍数を渡したら "Fizz" を返す。
    @Test
    def convert_3_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(3))

    /// 6 を渡したら "Fizz" を返す（三角測量）。
    @Test
    def convert_6_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(6))

    /// 5 の倍数を渡したら "Buzz" を返す。
    @Test
    def convert_5_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(5))

    /// 10 を渡したら "Buzz" を返す（三角測量）。
    @Test
    def convert_10_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(10))

    /// 15 の倍数を渡したら "FizzBuzz" を返す。
    @Test
    def convert_15_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(15))

    /// 30 を渡したら "FizzBuzz" を返す（三角測量）。
    @Test
    def convert_30_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(30))
}
```

</details>
