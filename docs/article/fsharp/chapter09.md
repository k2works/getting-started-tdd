# 第 9 章: モジュール設計と型による設計

## 9.1 はじめに

前章では判別共用体とパターンマッチを導入しました。この章では、FizzBuzz プログラム全体を **モジュール分割** し、**型による設計（Type-Driven Design）** でアーキテクチャを整理します。

## 9.2 現在のコード構造の課題

これまでの実装では、すべてのコードが 1 つのモジュールに集約されています。プログラムの規模が大きくなると以下の課題が生じます。

- **責務の混在**: ドメインロジックとアプリケーションロジックが分離されていない
- **再利用性の低下**: 特定の機能だけを利用することが困難
- **テストの複雑化**: 依存関係が絡み合いテストが書きにくい

## 9.3 モジュール分割

### Domain モジュール

ビジネスルールとデータ型を定義するモジュールです。

```fsharp
module Domain =

    // 値オブジェクト
    type FizzBuzzValue =
        { Number: int
          Value: string }

        override this.ToString() = sprintf "%d:%s" this.Number this.Value

    let createValue number value = { Number = number; Value = value }

    // 判別共用体
    type FizzBuzzType =
        | Standard
        | NumberOnly
        | FizzBuzzOnly

    // ドメインロジック
    let private isFizz number = number % 3 = 0
    let private isBuzz number = number % 5 = 0
    let private isFizzBuzz number = isFizz number && isBuzz number

    let generate (fizzBuzzType: FizzBuzzType) (number: int) : FizzBuzzValue =
        match fizzBuzzType with
        | Standard ->
            if isFizzBuzz number then createValue number "FizzBuzz"
            elif isFizz number then createValue number "Fizz"
            elif isBuzz number then createValue number "Buzz"
            else createValue number (string number)
        | NumberOnly ->
            createValue number (string number)
        | FizzBuzzOnly ->
            if number % 15 = 0 then createValue number "FizzBuzz"
            else createValue number (string number)
```

### FizzBuzzList 型

FizzBuzzValue のコレクションを専用の型でラップする **ファーストクラスコレクション** を定義します。

```fsharp
    type FizzBuzzList =
        { Values: FizzBuzzValue list }

        member this.Count = this.Values.Length
        member this.Get(index) = this.Values.[index]

        member this.Filter(predicate: FizzBuzzValue -> bool) =
            { Values = this.Values |> List.filter predicate }

        member this.FindFirst(predicate: FizzBuzzValue -> bool) =
            this.Values |> List.tryFind predicate

        member this.ToStringValues() =
            this.Values |> List.map (fun v -> v.Value)

        member this.Add(value: FizzBuzzValue) =
            { Values = this.Values @ [ value ] }

        override this.ToString() =
            this.Values
            |> List.map (fun v -> v.ToString())
            |> String.concat ", "

    let emptyList = { Values = [] }

    let createList (values: FizzBuzzValue list) = { Values = values }
```

### テストを書く

```fsharp
module FizzBuzzListTests =

    [<Fact>]
    let ``空のリストを作成できる`` () =
        let list = emptyList
        Assert.Equal(0, list.Count)

    [<Fact>]
    let ``値を追加できる`` () =
        let list = emptyList
        let newList = list.Add(createValue 1 "1")
        Assert.Equal(1, newList.Count)
        Assert.Equal(0, list.Count)  // 元のリストは不変

    [<Fact>]
    let ``フィルタリングできる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 3 "Fizz"
                  createValue 5 "Buzz"
                  createValue 15 "FizzBuzz" ]
        let filtered = list.Filter(fun v -> v.Value = "Fizz")
        Assert.Equal(1, filtered.Count)
```

`list.Add` は新しいリストを返し、元のリストは変更されません。F# のレコード型は不変であるため、すべての操作が新しい値を返します。

### Application モジュール

ユースケースを実行するモジュールです。Domain モジュールに依存します。

```fsharp
module Application =
    open Domain

    let executeValue (fizzBuzzType: FizzBuzzType) (number: int) : FizzBuzzValue =
        generate fizzBuzzType number

    let executeList (fizzBuzzType: FizzBuzzType) (count: int) : FizzBuzzList =
        [ 1..count ]
        |> List.map (generate fizzBuzzType)
        |> createList
```

### FizzBuzz モジュール（公開 API）

外部に公開するシンプルな API を提供するモジュールです。

```fsharp
module FizzBuzz =
    open Domain
    open Application

    let generate (number: int) : string =
        let value = executeValue Standard number
        value.Value

    let generateList (count: int) : string list =
        let list = executeList Standard count
        list.ToStringValues()
```

### テストを書く

```fsharp
module ApplicationTests =

    [<Fact>]
    let ``executeValueで単一値を取得できる`` () =
        let result = executeValue Standard 3
        Assert.Equal("Fizz", result.Value)

    [<Fact>]
    let ``executeListでリストを生成できる`` () =
        let result = executeList Standard 100
        Assert.Equal(100, result.Count)
```

## 9.4 member から関数へのリファクタリング

### 何が問題か

ここまでの `FizzBuzzValue` と `FizzBuzzList` は、`member` と `override` によるオブジェクト指向的な記述になっています。F# では `member` を書けるためつい C# と同じ設計をしてしまいますが、関数型スタイルから見ると次の点が引っかかります。

- **合成できない**: `list.Filter(...)` はメソッド呼び出しなので、`|>` や `>>` でつなげられない
- **部分適用できない**: `FizzBuzzList.filter predicate` のように述語だけ束縛した関数を作れない
- **拡張が型の変更を要求する**: 新しい操作を足すたびに型定義そのものを編集することになる
- **標準ライブラリと不揃い**: `List` / `Option` / `Map` はすべて「モジュール + 関数」で提供されており、メンバーだけ流儀が違う

F# の標準的な設計は、**データ（レコード）と振る舞い（モジュール内の関数）を分離する** ことです。`List.map` や `Option.bind` と同じ形に揃えます。

### コンパニオンモジュール

型と同じ名前のモジュールを定義するには `CompilationRepresentation` 属性を付けます。これにより `FizzBuzzList` という名前を型としてもモジュールとしても使えます。

```fsharp
    type FizzBuzzList = { Values: FizzBuzzValue list }

    let emptyList = { Values = [] }

    let createList (values: FizzBuzzValue list) = { Values = values }

    [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
    module FizzBuzzList =

        let empty = emptyList

        let create values = createList values

        let count (list: FizzBuzzList) = List.length list.Values

        let get index (list: FizzBuzzList) = list.Values.[index]

        let filter (predicate: FizzBuzzValue -> bool) (list: FizzBuzzList) =
            { Values = list.Values |> List.filter predicate }

        let findFirst (predicate: FizzBuzzValue -> bool) (list: FizzBuzzList) =
            list.Values |> List.tryFind predicate

        let toStringValues (list: FizzBuzzList) =
            list.Values |> List.map (fun v -> v.Value)

        let countByValue (list: FizzBuzzList) =
            list.Values
            |> List.countBy (fun v -> v.Value)
            |> Map.ofList

        let add (value: FizzBuzzValue) (list: FizzBuzzList) =
            { Values = list.Values @ [ value ] }

        let addRange (values: FizzBuzzValue list) (list: FizzBuzzList) =
            { Values = list.Values @ values }

        let toDisplayString (list: FizzBuzzList) =
            list.Values
            |> List.map FizzBuzzValue.toDisplayString
            |> String.concat ", "
```

### 引数順序の規約

関数型スタイルでは **操作対象のデータを最後の引数に置く** のが規約です（data-last）。`List.filter predicate list` と同じ並びです。こうすると `|>` で自然につながり、部分適用がそのまま「設定済みの関数」になります。

```fsharp
// パイプラインでつながる
let fizzCount =
    list
    |> FizzBuzzList.filter (fun v -> v.Value = "Fizz")
    |> FizzBuzzList.count

// 部分適用で再利用できる関数を作れる
let onlyFizz = FizzBuzzList.filter (fun v -> v.Value = "Fizz")
let fizzList = onlyFizz list
```

member 版ではこのどちらも書けませんでした。

### ToString の扱い

`override this.ToString()` も .NET の仕組みに依存した記述です。表示は関心事の 1 つにすぎないため、`toDisplayString` という普通の関数に置き換えます。

```fsharp
    type FizzBuzzValue =
        { Number: int
          Value: string }

    let createValue number value = { Number = number; Value = value }

    [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
    module FizzBuzzValue =

        let toDisplayString (value: FizzBuzzValue) =
            sprintf "%d:%s" value.Number value.Value
```

レコードの等価比較や構造的な既定表示は F# が自動生成するため、`ToString` を自前で持たなくても困りません。

### 呼び出し側の更新

`FizzBuzz` モジュールもメソッド呼び出しをやめ、パイプラインで書けるようになります。

```fsharp
module FizzBuzz =
    open Domain
    open Application

    let generate (number: int) : string =
        let value = executeValue Standard number
        value.Value

    let generateList (count: int) : string list =
        executeList Standard count
        |> FizzBuzzList.toStringValues
```

### テストを書き換える

```fsharp
module FizzBuzzListTests =

    [<Fact>]
    let ``空のリストを作成できる`` () =
        let list = FizzBuzzList.empty
        Assert.Equal(0, FizzBuzzList.count list)

    [<Fact>]
    let ``値を追加できる`` () =
        let list = FizzBuzzList.empty
        let newList = list |> FizzBuzzList.add (createValue 1 "1")
        Assert.Equal(1, FizzBuzzList.count newList)
        Assert.Equal(0, FizzBuzzList.count list)  // 元のリストは不変

    [<Fact>]
    let ``フィルタリングできる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 3 "Fizz"
                  createValue 5 "Buzz"
                  createValue 15 "FizzBuzz" ]

        let filtered = list |> FizzBuzzList.filter (fun v -> v.Value = "Fizz")
        Assert.Equal(1, FizzBuzzList.count filtered)
        Assert.Equal("Fizz", (filtered |> FizzBuzzList.get 0).Value)
```

テストは振る舞いを変えずに呼び出し方だけを書き換えています。テストが緑のままリファクタリングできることを確認してください。

### 対応表

| member（オブジェクト指向） | 関数（関数型） |
|------|------|
| `list.Count` | `FizzBuzzList.count list` |
| `list.Get(i)` | `list \|> FizzBuzzList.get i` |
| `list.Filter(f)` | `list \|> FizzBuzzList.filter f` |
| `list.FindFirst(f)` | `list \|> FizzBuzzList.findFirst f` |
| `list.ToStringValues()` | `list \|> FizzBuzzList.toStringValues` |
| `list.CountByValue()` | `list \|> FizzBuzzList.countByValue` |
| `list.Add(v)` | `list \|> FizzBuzzList.add v` |
| `list.AddRange(vs)` | `list \|> FizzBuzzList.addRange vs` |
| `value.ToString()` | `FizzBuzzValue.toDisplayString value` |

### member を残してよい場合

すべての `member` が悪いわけではありません。次の場合はメンバーのままが妥当です。

- C# など他の .NET 言語から使われるライブラリの公開 API
- `IDisposable` や `IComparable` などインターフェース実装
- 演算子オーバーロード

今回のように F# 内で完結するドメインモデルであれば、関数に寄せたほうが合成しやすく、標準ライブラリとも一貫します。

## 9.5 依存関係

```
FizzBuzz (公開 API)
    ↓
Application (ユースケース)
    ↓
Domain (ドメインモデル)
```

- `FizzBuzz` モジュールは `Application` と `Domain` に依存
- `Application` モジュールは `Domain` に依存
- `Domain` モジュールは外部に依存しない（純粋なドメインロジック）
- 逆方向の依存は存在しない（単方向依存）

## 9.6 型による設計の利点

### 不正な状態を表現できない

判別共用体を使うことで、存在しないタイプを指定することがコンパイル時に防止されます。

```fsharp
// 型安全: コンパイルエラーになる
let result = generate InvalidType 1  // FizzBuzzType に InvalidType は定義されていない

// 型安全: 正しい使い方
let result = generate Standard 1
```

### SOLID 原則の適用

| 原則 | 適用内容 |
|------|---------|
| SRP | Domain / Application / FizzBuzz の責務分離 |
| OCP | 判別共用体にケースを追加して拡張 |
| LSP | FizzBuzzType の各ケースは同じ generate 関数で処理 |
| ISP | 各モジュールは必要な関数のみ公開 |
| DIP | Application は Domain の型に依存（抽象に依存） |

## 9.7 まとめ

この章では以下を実現しました。

| モジュール | 責務 | 含まれる型 |
|-----------|------|-----------|
| `Domain` | ドメインモデルとビジネスルール | FizzBuzzValue, FizzBuzzType, FizzBuzzList |
| `Application` | ユースケースの実行 | executeValue, executeList |
| `FizzBuzz` | 公開 API | generate, generateList |

あわせて、`member` によるオブジェクト指向的な記述をコンパニオンモジュールの関数に置き換え、data-last の引数順序でパイプライン合成と部分適用ができる形に整えました。

第 3 部を通じて、F# のレコード型、判別共用体、モジュールシステムを使った関数型アプローチによる設計を学びました。次の第 4 部では、F# の高度な関数型プログラミング機能（高階関数、関数合成、エラーハンドリング）を活用します。
