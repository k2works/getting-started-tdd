# 第 3 章: 明白な実装とリファクタリング

## 3.1 はじめに

前章では、三角測量と `if` 式で FizzBuzz のコアロジックを完成させました。この章では、残りの TODO（リスト生成）を実装し、リファクタリングで「動作するきれいなコード」を目指します。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から 100 までの数
- [ ] プリントする

## 3.2 1 から 100 までのリスト生成

### Red: リスト生成のテスト

1 から指定した数までの FizzBuzz の結果をリストとして返す `generateList` 関数をテストします。Flix の `List.nth` は範囲外アクセスに備えて `Option[String]` を返すため、期待値も `Some("...")` で包みます。

```flix
    /// 100 件のリストを生成する。
    @Test
    def generateList_has_100_elements(): Unit \ Assert =
        Assert.assertEq(expected = 100, List.length(FizzBuzz.generateList(100)))

    /// 最初の要素は "1"。
    @Test
    def generateList_first_is_1(): Unit \ Assert =
        Assert.assertEq(expected = Some("1"), List.nth(0, FizzBuzz.generateList(100)))

    /// 3 番目の要素は "Fizz"。
    @Test
    def generateList_third_is_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = Some("Fizz"), List.nth(2, FizzBuzz.generateList(100)))

    /// 5 番目の要素は "Buzz"。
    @Test
    def generateList_fifth_is_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = Some("Buzz"), List.nth(4, FizzBuzz.generateList(100)))

    /// 15 番目の要素は "FizzBuzz"。
    @Test
    def generateList_fifteenth_is_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = Some("FizzBuzz"), List.nth(14, FizzBuzz.generateList(100)))
```

`List.nth(index, list)` は 0 始まりのインデックスアクセスです。存在しない位置を指定しても例外にならず `None` を返すため、Flix では「配列外アクセスによる実行時クラッシュ」が型レベルで排除されています。Rust の `list.get(0)` が `Option` を返すのと同じ設計思想です。

```bash
$ java -jar flix.jar test
>> Undefined name 'FizzBuzz.generateList'.
```

`generateList` がまだ定義されていないため、コンパイルエラーになります。Flix は静的型付け言語なので、関数が存在しないとコンパイルの段階でエラーが報告されます。

### Green: 明白な実装

ここでは **明白な実装** を適用します。`List.map` を使って、リストの各要素に `convert` を適用します。

> 明白な実装
>
> シンプルな操作を実現するにはどうすればいいだろうか——そのまま実装しよう。
>
> — テスト駆動開発

`src/FizzBuzz.flix` に `generateList` 関数を追加します。

```flix
mod FizzBuzz {
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)

    ///
    /// 1 から `n` までの FizzBuzz の結果をリストとして返す。
    ///
    pub def generateList(n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(convert)
}
```

Flix 特有のポイントを確認しましょう。

- `List.range(1, n + 1)` は 1 から `n` までの整数リストを生成します。`range` の終端は **含まない**（半開区間）ため、`n` を含めるには `n + 1` を渡します。
- `|>` は **パイプライン演算子** です。`x |> f` は `f(x)` と同じ意味で、データが左から右へ流れる様子をそのまま表現できます。`List.range(1, n + 1) |> List.map(convert)` は「1〜n のリストを作り、それを convert で写像する」と読めます。
- `List.map(convert)` の `convert` は関数をそのまま値として渡しています。Flix では関数は第一級の値です。

```bash
$ java -jar flix.jar test
Running 13 tests...
  ...
  TEST TestFizzBuzz.generateList_has_100_elements       PASS
  TEST TestFizzBuzz.generateList_first_is_1             PASS
  TEST TestFizzBuzz.generateList_third_is_Fizz          PASS
  TEST TestFizzBuzz.generateList_fifth_is_Buzz          PASS
  TEST TestFizzBuzz.generateList_fifteenth_is_FizzBuzz  PASS

Passed: 13, Failed: 0. Skipped: 0.
```

すべてのテストが通りました。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [x] 1 から 100 までの数
- [ ] プリントする

## 3.3 プリント機能

プリント機能は、生成したリストの各要素を標準出力に出力するものです。Flix のエントリーポイントである `main` 関数で `generateList` の結果を出力します。

```flix
// src/Main.flix
///
/// エントリーポイント。1 から 100 までの FizzBuzz を出力する。
///
def main(): Unit \ IO =
    FizzBuzz.generateList(100) |> List.forEach(println)
```

ここで注目したいのが戻り値型の `Unit \ IO` です。`\ IO` は、この関数が **IO 効果** を持つ——つまり画面出力という副作用を行うことを型で明示しています。

一方、前章までに作った `convert` や `generateList` は `String` や `List[String]` を返すだけで効果を持たない **純粋関数** です。Flix の効果システムにより、「副作用を持つコード」と「純粋なコード」がコンパイラによって厳密に区別されます。純粋関数からうっかり `println` を呼ぶと、効果の不一致として型エラーになります。この分離は、Haskell の `IO` モナドによる純粋/不純の分離と同じ狙いを、より軽量な効果注釈で実現したものです。

`List.forEach(println)` は各要素に `println` を適用し、結果（`Unit`）を捨てます。`List.map` が値を変換して新しいリストを返すのに対し、`List.forEach` は副作用の実行だけを目的とします。

実行して確認します。

```bash
$ java -jar flix.jar run
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

最終的な `src/FizzBuzz.flix` を確認します。

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

    ///
    /// 1 から `n` までの FizzBuzz の結果をリストとして返す。
    ///
    pub def generateList(n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(convert)
}
```

Flix のコードは非常に簡潔です。注目すべきポイントは以下の通りです。

- **型シグネチャ**: `convert(n: Int32): String` と `generateList(n: Int32): List[String]` により、関数の入出力の型が明確に宣言されています。Flix では型推論が強力ですが、トップレベル関数には明示的に型を書くのがベストプラクティスです。
- **効果の明示**: `convert` と `generateList` の型には `\ IO` などの効果注釈が付いていません。これは両者が **純粋関数** であることをコンパイラが保証している証拠です。
- **可視性**: `pub def` で外部に公開する関数を明示しています。`pub` を付けない定義はモジュール内に閉じるため、情報隠蔽が言語仕様として組み込まれています。

### テストコードの確認

`test/TestFizzBuzz.flix` は `convert` の 8 件と `generateList` の 5 件、合わせて 13 件のテストで構成されます。各テストは純粋関数に入力を与えて出力を検証するだけで完結し、モックやスタブといったテストダブルを一切必要としません。これは副作用が効果システムで隔離されている恩恵です。

## 3.5 他言語との比較

| 概念 | Java | Python | Rust | Haskell | Flix |
|------|------|--------|------|---------|------|
| テストフレームワーク | JUnit 5 | pytest | cargo test（標準） | HSpec | flix test（標準） |
| テスト実行 | `./gradlew test` | `pytest` | `cargo test` | `stack test` | `java -jar flix.jar test` |
| 文字列変換 | `String.valueOf(n)` | `str(n)` | `n.to_string()` | `show n` | `Int32.toString(n)` |
| 剰余判定 | `n % 3 == 0` | `n % 3 == 0` | `n % 3 == 0` | `` n `mod` 3 == 0 `` | `Int32.remainder(n, 3) == 0` |
| 条件分岐 | `if-else` | `if-elif` | `match` | ガード式 | `if` 式 |
| リスト生成 | `IntStream.rangeClosed` | `[f(n) for n in range]` | `(1..=n).map(f).collect()` | `map f [1..n]` | `List.range(1, n+1) \|> List.map(f)` |
| 副作用の分離 | なし | なし | なし | IO モナド | 効果システム（`\ IO`） |

## 3.6 まとめ

この章では以下のことを学びました。

- **明白な実装** でシンプルな操作をそのまま実装する手法
- Flix の `List.range` と `List.map` によるリスト生成
- **パイプライン演算子** `|>` によるデータフローの表現
- `List.nth` が `Option` を返すことによる安全なインデックスアクセス
- `List.forEach` と `println` による出力の実行
- Flix の **効果システム**（`\ IO`）による純粋関数と副作用の分離
- **型シグネチャ** と `pub` による可視性制御でコードを明確化
- Red-Green-Refactor サイクルの完了

第 1 部の 3 章を通じて、TDD の基本サイクル（仮実装 → 三角測量 → 明白な実装 → リファクタリング）を一通り体験しました。Flix では純粋関数と副作用が効果システムで明確に分離されるため、コアロジックはすべて純粋関数として書け、TDD との相性が非常に良いことが分かりました。入力を与えて出力を検証するだけでテストが完結します。

次の第 2 部では、開発環境の自動化（バージョン管理、パッケージ管理、CI/CD）に進みます。
