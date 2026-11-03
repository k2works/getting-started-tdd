# 第 8 章: パターンマッチと代数的データ型

## 8.1 はじめに

前章では、列挙型とトレイトで FizzBuzz のタイプを表現しました。この章では、Flix の **パターンマッチ** をより深く掘り下げ、**`Result` 型** を使った安全なエラーハンドリングを導入します。

追加仕様として、タイプを「番号」から生成する機能を考えます。

```
タイプ番号（1・2・3）から対応する FizzBuzzType を生成する。
未定義の番号が渡された場合はエラーを返す。
```

## 8.2 パターンマッチの基本

Flix のパターンマッチは `match` 式で行います。

```flix
match x {
    case FizzBuzzType.Type01 => ...
    case FizzBuzzType.Type02 => ...
    case FizzBuzzType.Type03 => ...
}
```

各 `case` はパターンと `=>` の後の式で構成されます。`match` は式なので、全体が 1 つの値を返します。

### パターンの種類

Flix では多様なパターンが使えます。

| パターン | 例 | 意味 |
|----------|-----|------|
| 列挙ケース | `case FizzBuzzType.Type01 =>` | 特定のケースにマッチ |
| リテラル | `case 1 =>` | 特定の値にマッチ |
| 変数束縛 | `case n =>` | 任意の値を `n` に束縛 |
| ワイルドカード | `case _ =>` | 任意の値（束縛しない） |
| コンストラクタ分解 | `case Ok(v) =>` | 中身を取り出して束縛 |

### 網羅性検査

Flix のパターンマッチは **網羅的** でなければなりません。すべてのケースを覆っていないと、コンパイラが警告・エラーを出します。

```flix
match x {
    case FizzBuzzType.Type01 => "..."
    case FizzBuzzType.Type02 => "..."
    // Type03 を忘れると非網羅としてコンパイルエラー
}
```

この網羅性検査により、「ケースを追加したのに分岐を書き忘れる」というバグをコンパイル時に排除できます。Rust の `match` や Haskell の `-Wincomplete-patterns` と同じ安全性を、Flix は既定で提供します。

## 8.3 Result 型によるエラーハンドリング

### Result 型とは

失敗しうる処理の結果は、例外ではなく **`Result` 型** で表します。Flix の `Result[e, t]` は 2 つのケースを持つ列挙型です。

```flix
enum Result[e, t] {
    case Ok(t)    // 成功。値 t を保持
    case Err(e)   // 失敗。エラー e を保持
}
```

戻り値の型に成功・失敗の両方が現れるため、呼び出し側は **エラー処理を省略できません**。これは Rust の `Result`、Haskell の `Either` と同じ設計です。例外による大域脱出と違い、エラーがどこで起こりうるかが型に明示されます。

### Red: createType のテスト

タイプ番号から `FizzBuzzType` を生成する `create` のテストを書きます。

```flix
mod TestFizzBuzzTypeCreate {
    /// 1 は Type01 を返す。
    @Test
    def create_1_is_Type01(): Unit \ Assert =
        Assert.assertEq(expected = Ok(FizzBuzzType.Type01), FizzBuzzType.create(1))

    /// 未定義の番号は Err を返す。
    @Test
    def create_99_is_Err(): Unit \ Assert =
        Assert.assertEq(expected = true, Result.isErr(FizzBuzzType.create(99)))
}
```

`create` がまだないため、コンパイルエラー（Red）です。

### Green: create の実装

`FizzBuzzType` モジュールに `create` を追加します。リテラルパターンとワイルドカードを組み合わせます。

```flix
mod FizzBuzzType {
    ///
    /// タイプ番号から FizzBuzzType を生成する。
    /// 未定義の番号は Err を返す。
    ///
    pub def create(no: Int32): Result[String, FizzBuzzType] = match no {
        case 1 => Ok(FizzBuzzType.Type01)
        case 2 => Ok(FizzBuzzType.Type02)
        case 3 => Ok(FizzBuzzType.Type03)
        case _ => Err("該当するタイプは存在しません: ${no}")
    }
}
```

ポイントを確認します。

- `case 1 =>` … `case 3 =>` は **リテラルパターン** で、特定の番号にマッチします。
- `case _ =>` は **ワイルドカード** で、上のどれにもマッチしなかった残り全部を受けます。これがあることで `match` は網羅的になります。
- `Err("...: ${no}")` の `${no}` は **文字列補間** です。変数の値を文字列に埋め込めます。

戻り値の型 `Result[String, FizzBuzzType]` は「成功時は `FizzBuzzType`、失敗時は `String`（エラーメッセージ）」を意味します。

```bash
$ java -jar flix.jar test
Passed: 30, Failed: 0. Skipped: 0.
```

テストが通りました。

### Result の利用

呼び出し側は `match` や `Result` モジュールの関数で結果を処理します。

```flix
match FizzBuzzType.create(1) {
    case Ok(fbType) => Generatable.generate(fbType, 15)  // "FizzBuzz"
    case Err(msg)   => msg
}
```

エラーケース（`Err`）の処理を書かないと網羅性検査でコンパイルエラーになるため、失敗の握りつぶしが構造的に防がれます。`Result.isErr`、`Result.map`、`Result.getWithDefault` などの補助関数も標準ライブラリに用意されています。

## 8.4 パターンマッチのベストプラクティス

- **網羅性を活かす**: `case _ =>` を安易に使うと、ケース追加時の検出漏れにつながります。列挙型の分岐では、可能な限り各ケースを明示的に書きます。今回の `create` のように「有限の既知の値＋それ以外」を扱う場合にのみワイルドカードを使います。
- **浅いネストを保つ**: 深くネストした `match` は読みにくくなります。関数に切り出すか、`Result` のコンビネータ（`map`・`flatMap`）で連結します。
- **エラーは型で表す**: 失敗は `Result`（または `Option`）で返し、例外的な大域脱出に頼りません。

## 8.5 他言語との比較

| 概念 | Flix | Rust | Haskell | Java |
|------|------|------|---------|------|
| 成功/失敗の型 | `Result[e, t]` | `Result<T, E>` | `Either e a` | `Optional` / 例外 |
| 分岐 | `match` | `match` | `case` / ガード | `switch` |
| 網羅性検査 | 標準（既定） | 標準 | `-Wincomplete-patterns` | `sealed` + `switch` |
| 文字列補間 | `"...${x}"` | `format!` | なし（`++`） | テキストブロック等 |

## 8.6 まとめ

この章では以下を学びました。

- Flix の `match` 式によるパターンマッチと、多様なパターン（リテラル・変数・ワイルドカード・コンストラクタ分解）
- パターンマッチの **網羅性検査** によるケース漏れの防止
- **`Result[e, t]` 型** による例外に頼らないエラーハンドリング
- **文字列補間** `${...}` によるエラーメッセージの生成
- `Result` の分岐でエラー処理の省略を型システムが防ぐこと

次章では、これらの型を複数のモジュールに分割し、コマンドパターンと SOLID 原則に基づく設計へと発展させます。
