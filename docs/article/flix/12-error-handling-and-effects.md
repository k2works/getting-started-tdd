# 第 12 章: エラーハンドリングと代数的効果

## 12.1 はじめに

第 4 部の締めくくりとして、`Result` 型による安全なエラーハンドリングと、Flix を最も特徴づける機能である **代数的効果（algebraic effects）** を学びます。代数的効果は、副作用を「実行」と「解釈」に分離する強力な仕組みで、テスト容易性と再利用性を大きく高めます。

### この章で学ぶこと

- `Result` 型による安全な変換 `safeConvert`
- 代数的効果の定義（`eff`）
- 効果ハンドラによる解釈（`run ... with handler`）
- 同じロジックを「集める」「出力する」で使い分ける

## 12.2 Result による安全な変換

まず、入力を検証する `safeConvert` を実装します。正の数のみ受け付け、それ以外は `Err` を返します。

### Red: safeConvert のテスト

```flix
mod TestFizzBuzzEff {
    /// 正の数は Ok を返す。
    @Test
    def safeConvert_positive_ok(): Unit \ Assert =
        Assert.assertEq(expected = Ok("Fizz"), FizzBuzzEff.safeConvert(3))

    /// ゼロ以下は Err を返す。
    @Test
    def safeConvert_zero_err(): Unit \ Assert =
        Assert.assertEq(expected = true, Result.isErr(FizzBuzzEff.safeConvert(0)))
}
```

### Green: safeConvert の実装

```flix
mod FizzBuzzEff {
    ///
    /// 正の数のみ受け付ける安全な変換。負数・ゼロは Err を返す。
    ///
    pub def safeConvert(n: Int32): Result[String, String] =
        if (n <= 0)
            Err("正の数を指定してください: ${n}")
        else
            Ok(FizzBuzzPipeline.convert(n))
}
```

戻り値が `Result[String, String]` なので、呼び出し側は成功（`Ok`）と失敗（`Err`）の両方を扱う必要があります。第 8 章で見た通り、エラー処理の省略を型システムが防ぎます。

## 12.3 代数的効果とは

FizzBuzz の結果を「どこかへ出力する」処理を考えます。標準出力に出す、リストに集める、ファイルに書く——出力先はさまざまです。従来なら出力先ごとに関数を分けるか、出力先をパラメータで渡すことになります。

**代数的効果** を使うと、「出力する」という **操作の宣言** と、「実際にどう出力するか」という **解釈（ハンドラ）** を完全に分離できます。ロジックは「出力せよ」とだけ言い、その意味は後から与えます。

### 効果の定義

`eff` キーワードで効果を宣言します。効果は「実行できる操作」の集まりです。

```flix
///
/// FizzBuzz の出力を抽象化する代数的効果。
///
eff Emit {
    def line(s: String): Unit
}
```

`Emit` は `line`（1 行を発行する）という操作を持つ効果です。この時点では「どう出力するか」は一切決まっていません。

### 効果を使うロジック

```flix
mod FizzBuzzEff {
    ///
    /// Emit 効果を使って 1..n の FizzBuzz を発行する。
    /// どこへ出力するかは効果ハンドラに委ねる。
    ///
    pub def emitAll(n: Int32): Unit \ Emit =
        List.range(1, n + 1)
            |> List.forEach(i -> Emit.line(FizzBuzzPipeline.convert(i)))
}
```

戻り値型 `Unit \ Emit` は「この関数は `Emit` 効果を使う」ことを表します。`Emit.line(...)` を呼ぶだけで、その先で何が起きるかは知りません。`emitAll` は **純粋なロジック**（何を発行するか）に専念し、副作用（どこへ出すか）から解放されています。

## 12.4 効果ハンドラによる解釈

同じ `emitAll` を、異なる **ハンドラ** で解釈します。

### 結果をリストに集めるハンドラ

```flix
mod FizzBuzzEff {
    ///
    /// Emit 効果を「リストへ集める」ハンドラで解釈し、結果を返す。
    /// 各 line は自身の文字列を継続の結果に cons することでリストを組み立てる。
    ///
    pub def collect(n: Int32): List[String] =
        run {
            emitAll(n);
            Nil
        } with handler Emit {
            def line(s, resume) = s :: resume(())
        }
}
```

`run { ... } with handler Emit { ... }` が効果を解釈します。ハンドラの `line(s, resume)` は 2 つの引数を取ります。

- `s` — 発行された文字列
- `resume` — **継続（continuation）**。「この操作の後に続く残りの計算」を表す関数

`s :: resume(())` は、「発行された文字列 `s` を、残りの計算の結果（リスト）の先頭に cons する」という意味です。`resume(())` が次の `line` 呼び出しへと計算を進め、最終的に `Nil`（`emitAll` の末尾の値）へ到達します。結果として、発行順に並んだリストが組み上がります。**副作用を一切使わず**、純粋にリストを構築できているのがポイントです。

```flix
    /// Emit 効果を collect ハンドラで解釈すると結果が集まる。
    @Test
    def collect_gathers_results(): Unit \ Assert =
        let result = FizzBuzzEff.collect(5);
        Assert.assertEq(expected = Some("Buzz"), List.nth(4, result))
```

### 標準出力に書くハンドラ

同じ `emitAll` を、今度は標準出力へ流します。

```flix
mod FizzBuzzEff {
    ///
    /// Emit 効果を「標準出力へ書く」ハンドラで解釈する。
    ///
    pub def printAll(n: Int32): Unit \ IO =
        run {
            emitAll(n)
        } with handler Emit {
            def line(s, resume) = { println(s); resume(()) }
        }
}
```

こちらのハンドラは `println(s)` で実際に出力し、`resume(())` で計算を続けます。戻り値型が `Unit \ IO` になっているのは、ハンドラが `IO` 効果（`println`）を使うためです。`Emit` 効果は `run ... with handler` によって解釈され尽くし、`printAll` の型からは消えています。

**1 つのロジック `emitAll` を、2 つのハンドラで「集める」「出力する」に使い分けられました。** テストでは副作用のない `collect` で検証し、本番では `printAll` で出力する——という分離が自然に実現します。これが代数的効果の威力です。

```bash
$ java -jar flix.jar test
Passed: 45, Failed: 0. Skipped: 0.
```

## 12.5 代数的効果の意義

代数的効果は、次の点で優れています。

- **テスト容易性** — 副作用を伴うロジックを、副作用なしのハンドラ（`collect`）でテストできる。モックが不要になる。
- **再利用性** — 同じロジックを異なる文脈（出力先）で使い回せる。
- **関心の分離** — 「何をするか（ロジック）」と「どう実現するか（ハンドラ）」が明確に分かれる。
- **型安全性** — どの効果を使うかが関数の型に現れ、未処理の効果はコンパイルエラーになる。

Haskell がモナドと型クラスで実現していた副作用の制御を、Flix は代数的効果というより直接的な仕組みで、しかも複数の効果を自由に組み合わせられる形で提供します。

## 12.6 他言語との比較

| 概念 | Flix | Rust | Haskell | Elixir |
|------|------|------|---------|--------|
| 成功/失敗 | `Result[e, t]` | `Result<T, E>` | `Either e a` | `{:ok, _}` / `{:error, _}` |
| 値の有無 | `Option[t]` | `Option<T>` | `Maybe a` | `nil` |
| 副作用の抽象化 | **代数的効果** | トレイト | モナド / IO | ビヘイビア |
| 副作用の解釈分離 | 効果ハンドラ | — | モナド変換子 | — |

Result・Option による安全なエラー表現は多くのモダン言語に共通しますが、**代数的効果とハンドラによる副作用の解釈分離** は Flix を際立たせる特徴です。

## 12.7 まとめ: Flix の関数型プログラミング

この章では以下を学びました。

- `Result[e, t]` 型による安全な変換 `safeConvert`
- **代数的効果** `eff Emit` による「操作の宣言」と「解釈」の分離
- 効果を使うロジック `emitAll` は純粋な関心（何を発行するか）に専念する
- **効果ハンドラ** `run ... with handler` と **継続 `resume`** による解釈
- 同一ロジックを `collect`（集める）と `printAll`（出力する）で使い分ける
- 代数的効果がテスト容易性・再利用性・関心の分離をもたらすこと

### 第 4 部の振り返り

第 4 部を通じて、Flix の関数型プログラミングの核心をたどりました。

- 第 10 章: **高階関数** で振る舞いを注入する
- 第 11 章: **不変データ** と **関数合成**・**パイプライン** で宣言的に変換する
- 第 12 章: **Result** と **代数的効果** で副作用とエラーを型安全に扱う

FizzBuzz という小さな題材を通じて、TDD の基本サイクルから、列挙型・トレイトによる構造化、そして代数的効果に至るまで、Flix の設計思想を一貫して体験しました。純粋なロジックと副作用を効果システムで厳密に分離できる Flix は、変更を楽に安全に行える——まさに「よいソフトウェア」を支える言語だと言えます。
