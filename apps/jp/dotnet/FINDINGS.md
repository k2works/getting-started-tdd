# C# と F# の日本語実装 検証記録

C# と F# は同じ .NET SDK・同じソリューション（`FizzBuzz日本語.sln`）で動かしていますが、日本語への反応が異なるため、記録と採点は言語ごとに分けています。

## 共通: 実行環境と結果

| 項目 | バージョン（実行結果から記録） |
|------|------|
| .NET SDK | 8.0.416（`dotnet --version`） |
| .NET ランタイム | 8.0.22 |
| C# | 12.0（`dotnet build -getProperty:LangVersion`） |
| F# | 8.0（`F# Interactive version 12.8.403.0 for F# 8.0`） |
| xUnit | 2.5.3 |
| Roslynator.Analyzers / SonarAnalyzer.CSharp | 4.15.0 / 10.20.0.135146（既存 `apps/dotnet` と同じ） |
| FSharpLint | 0.26.10（既存 `apps/dotnet` と同じ dotnet tool） |

`make test`（`dotnet test FizzBuzz日本語.sln`）の結果です。

- C#（`FizzBuzz日本語.テスト`）: `Total tests: 21 / Passed: 21`
- F#（`FizzBuzz日本語FSharp.テスト`）: `Total tests: 20 / Passed: 20`

プロジェクト・フォルダ・ファイル名もすべて日本語です。

```text
FizzBuzz日本語.sln
FizzBuzz日本語/              C# 本体（FizzBuzz変換.cs, タイプ.cs, パイプライン.cs, 安全変換.cs, 助詞.cs）
FizzBuzz日本語.テスト/        C# テスト（FizzBuzz変換のテスト.cs など）
FizzBuzz日本語FSharp/        F# 本体（FizzBuzz.fs, タイプ別変換.fs, パイプライン.fs, エラー処理.fs）
FizzBuzz日本語FSharp.テスト/  F# テスト（FizzBuzz変換のテスト.fs など）
```

題材 D の「数値でなければ失敗になる」は、両言語とも引数が `int` のためコンパイル時に弾かれるので省略しました（C#: `error CS1503: Argument 1: cannot convert from 'string' to 'int'`、F#: `error FS0001: This expression was expected to have type 'int' but here has type 'string'`）。

---

## C#

### 日本語にできた名前・できなかった名前

次の名前はすべて日本語のままコンパイルできました。

- 名前空間 `FizzBuzz日本語.テスト`、クラス `FizzBuzz変換のテスト`
- record `タイプ(string 名前, Func<int, string> 変換)`、入れ子 record `変換結果.成功` / `変換結果.失敗`
- enum `タイプ番号 { 通常, 数字限定, FizzBuzz限定 }`、例外クラス `タイプ未定義例外`
- 拡張メソッド `FizzBuzz変換(this int 数)`、ジェネリック拡張メソッド `を<T, TResult>`
- 引数・ローカル変数（`数`・`上限`・`例外`）、プロジェクト名・`.csproj`・`.sln`・ソースファイル名

できなかったのは、日本語に固有ではない次の 2 点だけです。

- 数字で始まるメソッド名は識別子にならない: `error CS1519: Invalid token '3' in class, record, struct, or interface member declaration`。テストメソッド名は `三を渡したらFizzを返す` と漢数字で始め、`[Fact(DisplayName = "3を渡したらFizzを返す")]` でなでしこ3 と同じ文を表示名にした
- `using static` で取り込んだ拡張メソッドは前置で呼べない（C# の仕様）: `error CS0103: The name 'FizzBuzz変換' does not exist in the current context`。テストでは `FizzBuzz.FizzBuzz変換(3)` と型名で修飾した

### 回避策とその代償

- テストメソッド名は漢数字始まり（`十五まで作ると15件になる`）。メソッド名はなでしこ3 のテスト名と一字一句は一致しないが、`DisplayName` で一致させた
- SonarAnalyzer の `S3376`（例外クラス名を `Exception` で終える規則）と Roslynator の `RCS1194`（例外の標準コンストラクタ）を `.editorconfig` で抑止した

### 語順の再現

`this int` の拡張メソッドで `3.FizzBuzz変換()` と後置で書けます。助詞に見立てたジェネリック拡張メソッド `を`・`して` を用意すると、なでしこ3 の `NをFizzBuzz変換して装飾して戻す` にかなり近づきます。

```csharp
public static class 助詞
{
    public static TResult を<T, TResult>(this T 対象, Func<T, TResult> 処理) => 処理(対象);
    public static TResult して<T, TResult>(this T 対象, Func<T, TResult> 処理) => 処理(対象);
}

public static string FizzBuzz装飾(int 数) => 数.を(FizzBuzz.FizzBuzz変換).して(装飾);
```

### lint・formatter の反応

- `dotnet build -warnaserror:S3776`（既存と同じ Roslynator + SonarAnalyzer）では、日本語の例外クラス名に `warning RCS1194: Implement exception constructors` と `warning S3376: Make this class name end with 'Exception'.` が出た。`.editorconfig` で抑止して 0 件
- `dotnet format --verify-no-changes --severity info` では次の 2 種類が出た

  ```text
  info IDE0130: Namespace "FizzBuzz日本語.テスト" does not match folder structure, expected "FizzBuzz日本語.Tests"
  info IDE1006: Naming rule violation: These words must begin with upper case characters: switch式で振り分ける
  ```

  - IDE0130 はテストプロジェクトのフォルダ名を `FizzBuzz日本語.テスト` にして解消（フォルダ名も日本語にできる）
  - IDE1006 は **ASCII 小文字で始まる `switch式で振り分ける` にだけ** 出た。漢字・かなで始まる名前には 1 件も出ない。大文字・小文字の区別がない文字は PascalCase 違反と判定されないため。`成功と失敗をswitch式で振り分ける` に改名して 0 件

### 日本語化スコア（C#）

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | メソッド・拡張メソッド・引数・ローカル変数すべて日本語で書け、IDE1006 も日本語始まりには出ない |
| 型・モジュール名 | 3 | 名前空間・クラス・record・enum と列挙子・例外・プロジェクト・フォルダ・ファイル名まですべて可 |
| テスト名 | 3 | `[Fact(DisplayName = "3を渡したらFizzを返す")]` で空白・記号込みの文を書ける |
| 語順の再現 | 3 | 助詞に見立てた拡張メソッドで `数.を(FizzBuzz変換).して(装飾)` |
| ツール許容 | 2 | 日本語の例外クラス名に S3376・RCS1194 が出る。`.editorconfig` で抑止できる |
| **合計** | **14** | |

---

## F#

### 日本語にできた名前・できなかった名前

次の名前はすべて日本語でコンパイルできました。

- 関数 `FizzBuzz変換`（大文字始まりのまま）、`FizzBuzz配列作成`・`タイプ生成`・`装飾`
- record `タイプ = { 名前: string; 変換: int -> string }`
- 判別共用体 `タイプ番号 = 通常 | 数字限定 | FizzBuzz限定`、`変換結果 = 成功 of 値: string | 失敗 of エラー: string`
- 例外 `exception タイプ未定義例外 of 番号: int`
- モジュール `FizzBuzz日本語FSharp.タイプ別変換`、ソースファイル名 `タイプ別変換.fs`

判別共用体のケース名の大文字規則（FS0053）は、F# 8.0 では **ASCII の小文字始まりにだけ** 適用されます。`| fizz` は `error FS0053: Lowercase discriminated union cases are only allowed when using RequireQualifiedAccess attribute` になりますが、`| 通常 | 数字限定` は警告なしで通ります。

ただし落とし穴があります。**日本語のケース名の綴りを間違えると、エラーにも警告にもならず、変数パターンとして黙って通ります。**

```fsharp
match n with
| 通常 -> "通常"
| 数値限定 -> "数字限定"   // 正しくは 数字限定。変数パターンになり、すべてに一致する
```

ASCII で同じ間違い（`| NumberOnlyy ->`）をすると `warning FS0049: Uppercase variable identifiers should not generally be used in patterns, and may indicate a missing open declaration or a misspelt pattern name.` が出ます。日本語には大文字がないため、この安全網が働きません。

### 回避策とその代償

- 綴り間違いの落とし穴を避けるため、`タイプ番号` に `[<RequireQualifiedAccess>]` を付け、`タイプ番号.通常` と修飾して書く。代償は記述が長くなること
- `成功 値` のように引数を取るケースは、綴りを間違えると FS0039（pattern discriminator が未定義）のエラーになるため、修飾なしのまま
- FSharpLint は既存 `apps/dotnet` と同じ `fsharplint.json`（循環的複雑度だけ有効）で実行

### 語順の再現

`|>` で値を先に書けるので SOV 順になります。`>>` の関数合成で「FizzBuzz変換して装飾」の順もそのまま書けます。

```fsharp
/// FizzBuzz変換して >> 装飾する
let FizzBuzz装飾 = FizzBuzz変換 >> 装飾

let パイプライン処理 上限 = [ 1..上限 ] |> List.map FizzBuzz装飾
```

F# のユーザー定義演算子は記号でしか作れないため、`を` のような助詞そのものを中置で置くことはできません。

### lint・formatter の反応

- 既存と同じ `fsharplint.json` では、本体・テストとも `Summary: 0 warnings`
- 既定の設定では、全 7 ファイルで 44 件の命名警告が出た。日本語は PascalCase にも camelCase にも当てはまらないと判定される

  ```text
  Consider changing `タイプ番号` to PascalCase.          (FL0038 型名)
  Consider changing `通常` to PascalCase.                (FL0041 判別共用体のケース)
  Consider changing `上限` to camelCase.                 (FL0046 引数 / FL0067 非公開の値)
  Consider changing `タイプ未定義例外` to be suffixed with `Exception`.  (FL0037)
  ```

  二重バッククォートのテスト名には警告は出ない

### 日本語化スコア（F#）

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | `FizzBuzz変換` を大文字始まりのまま関数名にでき、引数・ローカル値も日本語 |
| 型・モジュール名 | 3 | record・判別共用体のケース・例外・モジュール・ファイル名まで可。ただしケース名の綴り間違いが警告なしで変数パターンになる |
| テスト名 | 3 | ``` ``15を FizzBuzz変換して 装飾する`` ``` のように空白込みの文を関数名にでき、テストランナーにもそのまま表示される |
| 語順の再現 | 2 | `3 \|> FizzBuzz変換` と `FizzBuzz変換 >> 装飾` で SOV 順になるが、助詞に当たる語は置けない |
| ツール許容 | 2 | FSharpLint の既定設定では 44 件の命名警告。設定で抑止できる |
| **合計** | **13** | |
