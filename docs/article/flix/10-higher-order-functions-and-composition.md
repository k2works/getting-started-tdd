# 第 10 章: 高階関数と関数合成

## 10.1 はじめに

第 3 部では列挙型とトレイトで FizzBuzz を構造化しました。この第 4 部では、Flix の関数型プログラミングの核心——**高階関数**、**関数合成**、**不変データ**、**代数的効果**——へ進みます。

この章では、関数を引数や戻り値として扱う **高階関数** を学びます。

### この章で学ぶこと

- 高階関数（`List.map` / `List.filter` / `List.foldLeft`）
- 変換ルールを関数として受け取る `generateWith`
- ラムダ式とクロージャ
- リストの加工パイプライン

## 10.2 高階関数とは

**高階関数** とは、関数を引数に取る、あるいは関数を返す関数のことです。Flix では関数は第一級の値なので、他の値と同じように受け渡しできます。

### List.map — リストの変換

```flix
List.range(1, 6) |> List.map(n -> n * n)  // 1 :: 4 :: 9 :: 16 :: 25 :: Nil
```

`List.map` は「各要素に関数を適用して新しいリストを作る」高階関数です。`n -> n * n` は **ラムダ式**（無名関数）です。

### List.filter — リストの絞り込み

```flix
List.range(1, 11) |> List.filter(n -> Int32.remainder(n, 3) == 0)  // 3 :: 6 :: 9 :: Nil
```

`List.filter` は述語（`Bool` を返す関数）を受け取り、真になる要素だけを残します。

### List.foldLeft — リストの畳み込み

```flix
List.range(1, 6) |> List.foldLeft((acc, n) -> acc + n, 0)  // 15
```

`List.foldLeft` は初期値と二項関数を受け取り、リストを 1 つの値に畳み込みます。`map`・`filter`・`fold` は関数型プログラミングの基本三種であり、ほとんどのリスト操作はこの組み合わせで表現できます。

## 10.3 generateWith — 高階関数の実践

変換ルール自体を **関数として外から渡せる** ようにします。これにより FizzBuzz のルールを差し替え可能にします。

### Red: カスタムルールのテスト

```flix
mod TestFizzBuzzHof {
    /// generateWith は渡したルールで変換する。
    @Test
    def generateWith_uses_rule(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzzHof.generateWith(FizzBuzzHof.defaultRule, 3))

    /// generateWith にカスタムルールを渡せる。
    @Test
    def generateWith_custom_rule(): Unit \ Assert =
        let rule = n -> if (Int32.remainder(n, 2) == 0) "Even" else "Odd";
        Assert.assertEq(expected = "Even", FizzBuzzHof.generateWith(rule, 4))
}
```

### Green: generateWith の実装

```flix
mod FizzBuzzHof {
    ///
    /// 変換ルールを関数として受け取り、数 `n` を変換する。
    ///
    pub def generateWith(rule: Int32 -> String, n: Int32): String =
        rule(n)

    ///
    /// 標準の FizzBuzz ルール。
    ///
    pub def defaultRule(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)
}
```

`generateWith` の第 1 引数の型 `Int32 -> String` は **関数型** です。「`Int32` を受け取り `String` を返す関数」を引数として受け取ります。標準ルール `defaultRule` を渡せば通常の FizzBuzz に、`n -> ...` のカスタムラムダを渡せば別のルールになります。振る舞いをデータとして注入できるのが高階関数の力です。

## 10.4 ラムダ式とクロージャ

Flix のラムダ式は `引数 -> 本体` の形です。

```flix
let dbl = x -> x * 2;
dbl(21)  // 42
```

ラムダは **クロージャ** として、定義時の環境（外側の変数）を捕捉できます。

```flix
let factor = 3;
let scale = x -> x * factor;  // factor を捕捉
scale(10)  // 30
```

このクロージャの性質により、`defaultRule` のようなルールを部分的に構成したり、設定値を閉じ込めた関数を作ったりできます。

## 10.5 transform と filterList

リスト全体にルールを適用する `transform` と、結果を絞り込む `filterList` を実装します。

```flix
mod FizzBuzzHof {
    ///
    /// 1 から `n` までのリストに変換関数を適用する。
    ///
    pub def transform(rule: Int32 -> String, n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(rule)

    ///
    /// リストを述語で絞り込む。
    ///
    pub def filterList(pred: String -> Bool, xs: List[String]): List[String] =
        List.filter(pred, xs)
}
```

テストで組み合わせて使います。

```flix
    /// filterList は述語で絞り込む。
    @Test
    def filterList_filters(): Unit \ Assert =
        let xs = FizzBuzzHof.transform(FizzBuzzHof.defaultRule, 15);
        let fizzes = FizzBuzzHof.filterList(s -> s == "Fizz", xs);
        Assert.assertEq(expected = 4, List.length(fizzes))
```

1〜15 で純粋な "Fizz"（3・6・9・12。15 は "FizzBuzz"）は 4 件です。`transform` でルールを適用し、`filterList` で絞り込む——高階関数を組み合わせた **加工パイプライン** が構築できました。

```bash
$ java -jar flix.jar test
Passed: 37, Failed: 0. Skipped: 0.
```

## 10.6 他言語との比較

| 概念 | Flix | Java | Rust | Haskell |
|------|------|------|------|---------|
| 変換 | `List.map(f, xs)` | `stream.map(f)` | `iter.map(f)` | `map f xs` |
| 絞り込み | `List.filter(p, xs)` | `stream.filter(p)` | `iter.filter(p)` | `filter p xs` |
| 畳み込み | `List.foldLeft(f, z, xs)` | `stream.reduce(z, f)` | `iter.fold(z, f)` | `foldl f z xs` |
| ラムダ | `x -> x * 2` | `x -> x * 2` | `\|x\| x * 2` | `\x -> x * 2` |
| 関数型 | `Int32 -> String` | `Function<Integer,String>` | `Fn(i32) -> String` | `Int -> String` |

Flix の関数型は `A -> B` と簡潔に書け、Java の `Function<A, B>` のような冗長さがありません。

## 10.7 まとめ

この章では以下を学びました。

- **高階関数**（`List.map` / `List.filter` / `List.foldLeft`）によるリスト操作
- **ラムダ式** `x -> ...` と **クロージャ** による環境の捕捉
- 変換ルールを関数として注入する `generateWith`
- `transform` と `filterList` を組み合わせた加工パイプライン
- 関数型 `A -> B` による高階関数の型付け

次章では、関数を組み合わせる **関数合成** と、不変データの **パイプライン処理** を学びます。
