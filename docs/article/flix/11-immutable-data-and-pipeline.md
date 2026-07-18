# 第 11 章: 不変データとパイプライン処理

## 11.1 はじめに

前章では高階関数でリストを加工しました。この章では、関数を組み合わせる **関数合成** と、**不変データ** を段階的に変換する **パイプライン処理** を学びます。

### この章で学ぶこと

- 関数合成（`compose`）
- パイプライン演算子 `|>`
- 不変データによる安全な変換
- 命令型スタイルからの書き換え

## 11.2 不変データ

Flix のデータは既定で **不変（immutable）** です。`List` や文字列を「変更」する操作は、元のデータをそのままに **新しいデータを返します**。

```flix
let xs = 1 :: 2 :: 3 :: Nil;
let ys = List.map(n -> n * 10, xs);
// xs は 1 :: 2 :: 3 :: Nil のまま、ys は 10 :: 20 :: 30 :: Nil
```

元の `xs` は決して書き換わりません。これにより、「どこかで知らないうちにデータが変わっていた」という副作用由来のバグが原理的に発生しません。並行処理でも共有データの競合を気にせず済みます。

## 11.3 関数合成

複数の変換をひとつの関数にまとめるのが **関数合成** です。`compose` を実装します。

### Red: compose のテスト

```flix
    /// compose は f のあとに g を適用する。
    @Test
    def compose_applies_in_order(): Unit \ Assert =
        let inc = x -> x + 1;
        let dbl = x -> x * 2;
        let f = FizzBuzzPipeline.compose(inc, dbl);
        Assert.assertEq(expected = 8, f(3))
```

`compose(inc, dbl)` は「`inc` を適用してから `dbl` を適用する」関数です。`f(3)` は `dbl(inc(3))` = `dbl(4)` = `8` になります。

### Green: compose の実装

```flix
mod FizzBuzzPipeline {
    ///
    /// 2 つの関数を合成する（f を適用してから g を適用）。
    ///
    pub def compose(f: a -> b \ ef, g: b -> c \ ef): a -> c \ ef =
        x -> g(f(x))
}
```

型シグネチャの `\ ef` に注目してください。これは **効果多相（effect polymorphism）** です。`f` と `g` が持つ効果 `ef` を、合成後の関数もそのまま引き継ぐことを表します。純粋な関数を合成すれば結果も純粋、`IO` を持つ関数を合成すれば結果も `IO`——効果の情報が合成をまたいで正しく伝播します。これは Flix の効果システムならではの表現力です。

## 11.4 変換と装飾の合成

FizzBuzz の変換に「装飾」を合成してみます。

```flix
mod FizzBuzzPipeline {
    ///
    /// 数を FizzBuzz 文字列に変換する。
    ///
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)

    ///
    /// 文字列を括弧で装飾する。
    ///
    pub def decorate(s: String): String =
        "[${s}]"

    ///
    /// convert と decorate を合成した変換。
    ///
    pub def convertAndDecorate(n: Int32): String =
        compose(convert, decorate)(n)
}
```

```flix
    /// 合成で変換と装飾を連結する。
    @Test
    def convertAndDecorate_composes(): Unit \ Assert =
        Assert.assertEq(expected = "[Fizz]", FizzBuzzPipeline.convertAndDecorate(3))
```

`convertAndDecorate(3)` は `decorate(convert(3))` = `decorate("Fizz")` = `"[Fizz]"` です。小さな純粋関数を合成して、より大きな変換を組み立てられました。

## 11.5 パイプライン処理

`|>` 演算子を使うと、データが変換を通り抜けていく流れをそのまま書けます。

```flix
mod FizzBuzzPipeline {
    ///
    /// パイプラインで 1..n を変換・装飾する。
    /// 不変データを段階的に変換し、元のリストは変更しない。
    ///
    pub def process(n: Int32): List[String] =
        List.range(1, n + 1)
            |> List.map(convert)
            |> List.map(decorate)
}
```

`x |> f` は `f(x)` と同じです。`process` は次のように読めます。

1. `List.range(1, n + 1)` で 1〜n のリストを作る
2. `|> List.map(convert)` で各要素を FizzBuzz 文字列に変換する
3. `|> List.map(decorate)` で各要素を装飾する

各ステップは前段の出力を受け取り、**新しいリストを返します**。元のリストは変更されません。データが左から右へ流れる様子がコードにそのまま表れます。

```flix
    /// パイプラインは各要素を変換・装飾する。
    @Test
    def process_pipeline(): Unit \ Assert =
        let result = FizzBuzzPipeline.process(5);
        Assert.assertEq(expected = Some("[Buzz]"), List.nth(4, result))
```

## 11.6 命令型スタイルからの書き換え

命令型言語なら、次のようにループと可変変数で書くところです（擬似コード）。

```
result = []
for i in 1..n:
    s = convert(i)
    s = decorate(s)
    result.append(s)   # 可変リストを破壊的に更新
return result
```

これをパイプラインで書き換えると、可変変数（`result`）もループカウンタ（`i`）も消え、「何をするか」だけが残ります。

```flix
List.range(1, n + 1) |> List.map(convert) |> List.map(decorate)
```

命令型が「どう計算するか（手順）」を記述するのに対し、パイプラインは「何を計算するか（データの変換）」を記述します。可変状態が無いぶん、読みやすく、テストしやすく、並行化にも強くなります。

## 11.7 他言語との比較

| 概念 | Flix | Elixir | Haskell | Java |
|------|------|--------|---------|------|
| パイプライン | `x \|> f` | `x \|> f` | （`&` / `.`） | `stream()...` |
| 関数合成 | `compose(f, g)` | `Function.compose` | `g . f` | `f.andThen(g)` |
| 不変データ | 既定 | 既定 | 既定 | 明示的に不変化 |
| 効果の伝播 | 効果多相 `\ ef` | なし | 型（IO） | なし |

Flix のパイプラインは Elixir の `|>` と同じ読み口を持ちつつ、効果多相によって副作用の情報も型で追跡できる点が独特です。

## 11.8 まとめ

この章では以下を学びました。

- Flix のデータは既定で **不変** であり、変換は新しいデータを返す
- **関数合成** `compose` で小さな純粋関数を組み合わせる
- 型シグネチャの `\ ef` による **効果多相** で、合成後も効果情報が伝播する
- **パイプライン演算子** `|>` でデータの変換フローを宣言的に書く
- 命令型のループ・可変変数をパイプラインへ書き換える利点

次章では、第 4 部の締めくくりとして、`Result` 型による安全なエラーハンドリングと、Flix の目玉である **代数的効果** を学びます。
