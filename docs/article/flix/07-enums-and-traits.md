# 第 7 章: 列挙型とトレイトによるポリモーフィズム

## 7.1 はじめに

第 1 部では手続き型の FizzBuzz プログラムを TDD で構築し、第 2 部では開発環境と自動化を整備しました。この章からは Flix の型システムを活用して、プログラムを構造化された設計に進化させます。

第 1 部で作成した `convert` 関数を振り返りましょう。

```flix
pub def convert(n: Int32): String =
    if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
    else if (Int32.remainder(n, 3) == 0) "Fizz"
    else if (Int32.remainder(n, 5) == 0) "Buzz"
    else                                 Int32.toString(n)
```

この関数は正しく動作しますが、新しい FizzBuzz のバリエーション（数値のみ返す、Fizz のみ返す等）を追加するには、既存の関数を直接修正するか、別の関数を作る必要があります。Flix の **列挙型（enum）** と **トレイト（trait）** を使えば、この問題をエレガントに解決できます。

### 追加仕様

```
タイプごとに出力を切り替えることができる。
タイプ 1 は通常の FizzBuzz、タイプ 2 は数字のみ、タイプ 3 は FizzBuzz の場合のみをプリントする。
```

## 7.2 TODO リスト

**TODO リスト**:

- [ ] タイプ 1 の場合（通常の FizzBuzz）
- [ ] タイプ 2 の場合（数字のみ）
- [ ] タイプ 3 の場合（Fizz の場合のみ、Buzz なし）
- [ ] 値オブジェクト FizzBuzzValue の導入
- [ ] コレクション FizzBuzzList の導入

## 7.3 列挙型 — FizzBuzzType

### enum 宣言による直和型

Flix の `enum` キーワードで、FizzBuzz のタイプを表す列挙型を定義します。

```flix
enum FizzBuzzType with Eq, ToString {
    case Type01  // 通常の FizzBuzz
    case Type02  // 数字のみ
    case Type03  // FizzBuzz の場合のみ
}
```

`FizzBuzzType` は **直和型**（sum type）です。`Type01`、`Type02`、`Type03` の 3 つのケースを持ち、`FizzBuzzType` 型の値はこのいずれかです。Java の `enum` や Rust の `enum` に近い概念ですが、Flix の列挙型は各ケースがフィールドを持つこともできるため、より柔軟です。

`with Eq, ToString` は型クラス相当のインスタンスを自動導出するディレクティブです。

| トレイト | 提供される機能 | 他言語の相当物 |
|----------|---------------|---------------|
| `Eq` | 値の等値比較（`Type01 == Type01`） | Java の `equals()` |
| `ToString` | 値を文字列に変換 | Java の `toString()` |

### トレイトによるインターフェース

「タイプに応じて数を変換できる」という振る舞いを **トレイト** で定義します。

```flix
trait Generatable[a] {
    pub def generate(x: a, n: Int32): String
}
```

`Generatable[a]` は「`generate` を実装する型 `a`」を表すインターフェースです。Java のインターフェースや Rust のトレイト、Haskell の型クラスに相当します。トレイトはデータ型の定義とは独立に、後からインスタンスを追加できる点が特徴で、これを **アドホックポリモーフィズム** と呼びます。

### Red: タイプ別テストの作成

```flix
mod TestFizzBuzzType {
    use Generatable.generate

    /// Type01: 1 を渡すと "1"。
    @Test
    def type01_1_returns_1(): Unit \ Assert =
        Assert.assertEq(expected = "1", generate(FizzBuzzType.Type01, 1))
}
```

`use Generatable.generate` でトレイトのメソッドを名前で使えるようにします。この時点で `Generatable` の実装がないため、コンパイルエラー（Red）になります。

### Green: instance の定義

`FizzBuzzType` に対する `Generatable` の実装を書きます。ケースごとの分岐には **パターンマッチ（`match`）** を使います。

```flix
instance Generatable[FizzBuzzType] {
    pub def generate(x: FizzBuzzType, n: Int32): String = match x {
        case FizzBuzzType.Type01 =>
            if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
            else if (Int32.remainder(n, 3) == 0) "Fizz"
            else if (Int32.remainder(n, 5) == 0) "Buzz"
            else                                 Int32.toString(n)
        case FizzBuzzType.Type02 =>
            Int32.toString(n)
        case FizzBuzzType.Type03 =>
            if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
            else if (Int32.remainder(n, 3) == 0) "Fizz"
            else                                 Int32.toString(n)
    }
}
```

`match x { case ... => ... }` はタイプごとにロジックを分岐します。Flix のパターンマッチは **網羅性検査** を伴い、`Type01`〜`Type03` のいずれかを書き忘れるとコンパイルエラーになります。ケースの追加漏れを型システムが防いでくれるのです。

| 概念 | Flix | Java | Rust | Haskell |
|------|------|------|------|---------|
| 型の列挙 | `enum ... { case A, case B }` | `enum` | `enum` | `data ... = A \| B` |
| インターフェース | `trait` | `interface` | `trait` | `class`（型クラス） |
| 実装 | `instance` | `implements` | `impl ... for` | `instance` |
| 分岐 | `match` | `switch` | `match` | ガード式・`case` |

テストを実行すると Type01〜Type03 の全ケースが通ります。Type02 は数値をそのまま文字列にし、Type03 は 5 の倍数判定がないため `generate(Type03, 5)` は `"5"` を返します。

**TODO リスト**:

- [x] タイプ 1 の場合（通常の FizzBuzz）
- [x] タイプ 2 の場合（数字のみ）
- [x] タイプ 3 の場合（Fizz の場合のみ、Buzz なし）
- [ ] 値オブジェクト FizzBuzzValue の導入
- [ ] コレクション FizzBuzzList の導入

## 7.4 値オブジェクト — FizzBuzzValue

### レコードを持つ列挙型

数値と変換結果を 1 つにまとめた値オブジェクトを定義します。Flix の **レコード**（`{ フィールド名 = 型 }`）をケースのペイロードにします。

```flix
enum FizzBuzzValue({ number = Int32, value = String })

mod FizzBuzzValue {
    ///
    /// タイプに従って数 `n` の値オブジェクトを生成する。
    ///
    pub def create(fbType: FizzBuzzType, n: Int32): FizzBuzzValue =
        FizzBuzzValue.FizzBuzzValue({ number = n, value = Generatable.generate(fbType, n) })

    ///
    /// 保持している数値を取り出す。
    ///
    pub def number(v: FizzBuzzValue): Int32 =
        let FizzBuzzValue.FizzBuzzValue(r) = v;
        r#number

    ///
    /// 保持している変換結果を取り出す。
    ///
    pub def value(v: FizzBuzzValue): String =
        let FizzBuzzValue.FizzBuzzValue(r) = v;
        r#value
}
```

Flix 特有の書き方を確認しましょう。

- `enum FizzBuzzValue({ number = Int32, value = String })` は、1 つのレコードをペイロードに持つ列挙型です。名前付きフィールドで意図が明確になります。
- `let FizzBuzzValue.FizzBuzzValue(r) = v;` は **パターン束縛** です。列挙型の中身（レコード）を取り出して `r` に束縛します。
- `r#number` は **レコードのフィールドアクセス** です。`#` の後にフィールド名を書きます。

同名のモジュール `mod FizzBuzzValue` に操作を集約することで、値オブジェクトに対するふるまい（生成・アクセス）を型と一体で管理できます。

| 概念 | Flix | Java | Rust |
|------|------|------|------|
| 定義 | `enum V({ number = Int32, ... })` | `record V(...)` | `struct V { ... }` |
| アクセス | `r#number`（束縛後） | `v.number()` | `v.number` |
| 生成 | `FizzBuzzValue.create(...)` | `new V(...)` | `V { ... }` |

**TODO リスト**:

- [x] タイプ 1 の場合（通常の FizzBuzz）
- [x] タイプ 2 の場合（数字のみ）
- [x] タイプ 3 の場合（Fizz の場合のみ、Buzz なし）
- [x] 値オブジェクト FizzBuzzValue の導入
- [ ] コレクション FizzBuzzList の導入

## 7.5 ファーストクラスコレクション — FizzBuzzList

### リストを包む列挙型

FizzBuzz の結果リストを表す専用のコレクション型を定義します。生の `List[FizzBuzzValue]` を列挙型で包みます。

```flix
enum FizzBuzzList(List[FizzBuzzValue])

mod FizzBuzzList {
    ///
    /// 1 から `count` までの値オブジェクトを生成してコレクションを作る。
    ///
    pub def create(count: Int32, fbType: FizzBuzzType): FizzBuzzList =
        List.range(1, count + 1)
            |> List.map(n -> FizzBuzzValue.create(fbType, n))
            |> FizzBuzzList.FizzBuzzList

    ///
    /// 要素数を返す。
    ///
    pub def count(list: FizzBuzzList): Int32 =
        let FizzBuzzList.FizzBuzzList(xs) = list;
        List.length(xs)

    ///
    /// 内部のリストを取り出す。
    ///
    pub def values(list: FizzBuzzList): List[FizzBuzzValue] =
        let FizzBuzzList.FizzBuzzList(xs) = list;
        xs
}
```

生のリストをドメイン固有の型 `FizzBuzzList` で包むことで、リストに対する操作を `mod FizzBuzzList` に集約し、不正な操作を型レベルで防ぎます。このパターンは **ファーストクラスコレクション** と呼ばれます。`List[FizzBuzzValue]` と `FizzBuzzList` は別の型として扱われるため、誤って無関係なリストを渡すことはできません。

`create` では `List.range` → `List.map` → `FizzBuzzList.FizzBuzzList`（コンストラクタ）へと **パイプライン `|>`** でデータを流しています。最後の `FizzBuzzList.FizzBuzzList` は列挙型のコンストラクタを関数として使い、リストを包んでいます。

**TODO リスト**:

- [x] タイプ 1 の場合（通常の FizzBuzz）
- [x] タイプ 2 の場合（数字のみ）
- [x] タイプ 3 の場合（Fizz の場合のみ、Buzz なし）
- [x] 値オブジェクト FizzBuzzValue の導入
- [x] コレクション FizzBuzzList の導入

## 7.6 トレイトの仕組み

### アドホックポリモーフィズム

トレイトが提供するポリモーフィズムは **アドホックポリモーフィズム** と呼ばれます。「アドホック」とは「その場限りの」という意味で、型ごとに異なる実装を提供できることを指します。

```flix
trait Generatable[a] {
    pub def generate(x: a, n: Int32): String
}
```

この定義は「`Generatable` のインスタンスである型 `a` は、`generate: (a, Int32) -> String` を持つ」と読みます。将来 `FizzBuzzType` 以外の型に別のルールを実装したくなっても、既存コードを変更せず `instance` を追加するだけで済みます。これは **開放閉鎖原則（OCP）** に沿った拡張です。

### パラメトリックポリモーフィズムとの違い

Flix には 2 種類のポリモーフィズムがあります。

| 種類 | 例 | 特徴 |
|------|-----|------|
| パラメトリック | `List.length: List[a] -> Int32` | すべての型に対して同じ実装 |
| アドホック | `generate: Generatable[a] => (a, Int32) -> String` | 型ごとに異なる実装 |

`List.length` は要素の型に関係なく同じアルゴリズムで動作します。一方、`generate` は `FizzBuzzType` のケースごとに異なるロジックを実行します。

## 7.7 まとめ

この章では以下のことを学びました。

- **列挙型（enum）** で FizzBuzz のタイプを直和型として定義する
- **トレイト（trait）** でアドホックポリモーフィズムのインターフェースを定義する
- **instance** 宣言でタイプごとの `generate` 実装を分離する
- **パターンマッチ（match）** と **網羅性検査** でケースの考慮漏れを防ぐ
- **レコードを持つ列挙型** で値オブジェクト `FizzBuzzValue` を定義し、`r#field` でアクセスする
- **リストを包む列挙型** でファーストクラスコレクション `FizzBuzzList` を定義する
- `with Eq, ToString` によるインスタンスの自動導出
- パラメトリックポリモーフィズムとアドホックポリモーフィズムの違い

次章では、パターンマッチと代数的データ型をさらに掘り下げ、デザインパターンを Flix らしく表現していきます。
