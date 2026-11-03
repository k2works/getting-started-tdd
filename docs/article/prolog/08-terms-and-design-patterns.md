# 第 8 章: 項とデザインパターン

## 8.1 はじめに

前章ではモジュールと述語の複数節を使って、手続き的な条件分岐を宣言的なルールに置き換え、タイプごとの振る舞いを `generate/3` の節へ分散させました。この章では、さらに多くの **デザインパターン** を適用して、コードの表現力と安全性を向上させます。

オブジェクト指向言語では、値オブジェクトやコマンドを「クラスのインスタンス」として表現します。しかし Prolog にはクラスもオブジェクトもありません。その代わりに、Prolog では **複合項（compound term）** がデータの基本単位となります。複合項とは `ファンクタ名(引数, ...)` という形で構造化されたデータであり、生成されたあとは書き換えられない不変の値です。

この章では、値オブジェクトを `fizzbuzz_value(Number, Value)` という複合項で、コマンドを `value_command(Type)` / `list_command(Type)` という「データとしての項」で表現します。そして、それらを解釈する述語（`value_create/3`、`execute/3`）を複数節で定義することで、宣言的にパターンを実現します。

**TODO リスト**:

- [ ] 値オブジェクト（Value Object）
- [ ] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.2 値オブジェクト（Value Object）

### 問題: 裸の値の受け渡し

数値とその変換結果を別々の変数で持ち回ると、両者の対応関係がコード上のどこにも明示されません。「番号 3 の変換結果は Fizz である」という一組の事実を、ひとつのデータとしてまとめたくなります。

### 解決: 複合項による値オブジェクト

オブジェクト指向言語では、値オブジェクトをクラス（Kotlin の `data class`、Java の `record`）で表現します。Prolog では、番号と変換結果を **複合項** `fizzbuzz_value(Number, Value)` にまとめます。ファンクタ名 `fizzbuzz_value` が「これは FizzBuzz の値である」という意味を与え、2 つの引数が構造化されたデータを保持します。

### Red: 値オブジェクトのテスト

```prolog
:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_value).

test(create_holds_number_and_value) :-
    value_create(type_01, 3, V),
    value_number(V, N),
    value_value(V, S),
    assertion(N == 3),
    assertion(S == "Fizz").

test(value_is_a_compound_term) :-
    value_create(type_01, 5, V),
    assertion(V == fizzbuzz_value(5, "Buzz")).

:- end_tests(fizzbuzz_value).
```

`create_holds_number_and_value` は、生成した値オブジェクトから番号と変換結果を取り出せることを確認します。`value_is_a_compound_term` は、値オブジェクトが `fizzbuzz_value(5, "Buzz")` という複合項そのものであることを、`==` による構造的な等価判定で確認します。

### Green: fizzbuzz_value の実装

```prolog
:- module(fizzbuzz_value, [value_create/3, value_number/2, value_value/2]).

:- use_module(fizzbuzz_type).

%% value_create(+Type:atom, +N:integer, -Value) is det.
%
%  数値と変換結果をまとめた値オブジェクト fizzbuzz_value(Number, Value) を生成する。
value_create(Type, N, fizzbuzz_value(N, V)) :-
    generate(Type, N, V).

%% value_number(+Value, -Number) is det.
value_number(fizzbuzz_value(N, _), N).

%% value_value(+Value, -Str) is det.
value_value(fizzbuzz_value(_, V), V).
```

Prolog 固有の書き方を確認しましょう。

- `value_create(Type, N, fizzbuzz_value(N, V))` は、第 3 引数の位置に複合項 `fizzbuzz_value(N, V)` を直接書いています。頭部（head）で項を組み立てるこの書き方により、生成と同時にデータ構造が決まります。
- `value_number(fizzbuzz_value(N, _), N)` と `value_value(fizzbuzz_value(_, V), V)` は **単一化（unification）によるパターンマッチ** です。引数に複合項のパターンを書くと、その構造に一致した項から必要な要素だけを取り出せます。`_`（無名変数）は使わない要素を明示的に無視します。
- 複合項は一度生成されると変更できません。この **不変性** はオブジェクト指向の値オブジェクトが目指す性質と同じであり、Prolog では言語の基本的な性質として最初から備わっています。
- `==` による等価判定は、2 つの項が同じ構造・同じ内容であるかを比較します。`data class` の `equals` に相当する **値による等価性** が、複合項では標準で成り立ちます。

| 特徴 | 実現方法（Prolog） |
|------|-------------------|
| **不変性** | 複合項は生成後に書き換え不可 |
| **等価性** | `==` による構造的な比較 |
| **自己記述性** | ファンクタ名 `fizzbuzz_value` が意味を表す |
| **要素の取り出し** | 単一化によるパターンマッチ |
| **生成の集約** | `value_create/3` |

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [ ] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.3 ファーストクラスコレクション（First-Class Collection）

### 問題: 生のリストの直接操作

`fizzbuzz_value` のリストをそのまま扱うと、コレクションに対する操作（生成・件数取得）が呼び出し側に散らばります。

### 解決: 専用述語へのカプセル化

Prolog にはコレクションを包むクラスはありませんが、リストに対する操作を専用のモジュール（`fizzbuzz_list`）に閉じ込めることで、ファーストクラスコレクションと同等のカプセル化を実現します。生成は `list_create/3`、件数取得は `list_count/2` に集約します。

### Green: fizzbuzz_list の実装

```prolog
:- module(fizzbuzz_list, [list_create/3, list_count/2]).

:- use_module(fizzbuzz_value).

%% list_create(+Count:integer, +Type:atom, -Values:list) is det.
%
%  1 から Count までの値オブジェクトを生成するファーストクラスコレクション。
list_create(Count, Type, Values) :-
    numlist(1, Count, Ns),
    maplist([N, V]>>value_create(Type, N, V), Ns, Values).

%% list_count(+Values:list, -Count:integer) is det.
list_count(Values, Count) :-
    length(Values, Count).
```

Prolog 固有の書き方を確認しましょう。

- `numlist(1, Count, Ns)` は 1 から `Count` までの整数リスト `Ns` を生成する標準ライブラリ述語です。Kotlin の範囲式 `1..count` に相当します。
- `maplist([N, V]>>value_create(Type, N, V), Ns, Values)` は、リスト `Ns` の各要素 `N` に対してラムダ式 `[N, V]>>value_create(Type, N, V)` を適用し、結果を `Values` に集めます。`>>` を使う **yall ライブラリのラムダ** で、Kotlin の `map { ... }` に相当します。
- `list_count(Values, Count)` は `length/2` に委譲し、コレクションの件数取得ロジックをモジュール内に閉じ込めます。

生のリストを直接操作する代わりに `list_create/3`・`list_count/2` を通すことで、コレクション操作の責務が `fizzbuzz_list` モジュールに集約されます。

| 特徴 | 実現方法（Prolog） |
|------|-------------------|
| **カプセル化** | コレクション操作を `fizzbuzz_list` に集約 |
| **生成の集約** | `list_create/3` |
| **件数管理** | `list_count/2`（`length/2` に委譲） |

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.4 コマンドパターン（Command Pattern）

### 問題: 操作の直接実行

「単一の値を生成する」と「リストを生成する」という 2 種類の操作を、呼び出し側が直接使い分けるのは煩雑です。操作をデータとして表現すれば、実行の定義と呼び出しを分離できます。

### 解決: データとしての項 + 解釈述語

オブジェクト指向言語では、コマンドを `sealed class` やインターフェースの実装として表現します。Prolog では、コマンドそのものを **複合項** `value_command(Type)` / `list_command(Type)` で表し、それを解釈する述語 `execute/3` を **複数節** で定義します。「データとしての項」と「それを解釈する述語」という組み合わせが、宣言的なコマンドパターンになります。

### Red: コマンドのテスト

```prolog
:- use_module('../src/fizzbuzz_command').
:- use_module('../src/fizzbuzz_value').
:- use_module('../src/fizzbuzz_list').

:- begin_tests(fizzbuzz_command).

test(value_command_returns_single_value) :-
    execute(value_command(type_01), 3, Values),
    list_count(Values, Count),
    assertion(Count == 1),
    Values = [V],
    value_value(V, S),
    assertion(S == "Fizz").

test(list_command_returns_list) :-
    execute(list_command(type_01), 15, Values),
    list_count(Values, Count),
    assertion(Count == 15).

:- end_tests(fizzbuzz_command).
```

`value_command_returns_single_value` は、`value_command(type_01)` を実行すると単一要素のリストが返り、その要素の値が `Fizz` であることを確認します。`list_command_returns_list` は、`list_command(type_01)` を実行すると 1 から 15 までの 15 件のリストが返ることを確認します。

### Green: fizzbuzz_command の実装

```prolog
:- module(fizzbuzz_command, [execute/3]).

:- use_module(fizzbuzz_value).
:- use_module(fizzbuzz_list).

%% execute(+Command, +N:integer, -Values:list) is det.
%
%  コマンドを数 N に対して実行し、値オブジェクトのリストを返す。
%  value_command(Type): 単一の値を生成する。
%  list_command(Type):  1 から N までのリストを生成する。
execute(value_command(Type), N, [Value]) :-
    value_create(Type, N, Value).
execute(list_command(Type), N, Values) :-
    list_create(N, Type, Values).
```

Prolog 固有の書き方を確認しましょう。

- `value_command(Type)` / `list_command(Type)` は、実行に必要なパラメータ `Type` を保持した **コマンドの項** です。この項自体が「何をするか」というデータを表します。
- `execute/3` は **2 つの節** で構成されています。第 1 引数のパターン `value_command(Type)` と `list_command(Type)` によって単一化がどちらの節を選ぶかを決めます。これは「コマンドの型による分岐」を宣言的に表現したものであり、Kotlin の `when (this)` に相当します。
- 第 1 節は頭部の第 3 引数を `[Value]` と書き、**単一要素のリスト** を返すことを構造で表しています。第 2 節は `list_create/3` に委譲して 1 から N までのリストを返します。
- どちらの節も戻り値は値オブジェクトのリストに統一されているため、呼び出し側は結果を一様に扱えます。

### コマンドパターンの利点

- **操作の具象化**: 「何をするか」を項（`value_command`／`list_command`）で表現
- **パラメータの保持**: 実行に必要な `Type` をコマンドの項に保持
- **実行の分離**: 操作の「定義（項）」と `execute/3` による「実行（解釈）」を分離
- **宣言的な分岐**: `execute/3` の複数節と単一化で操作を選択

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [x] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.5 ファクトリメソッドと ok/error

前章の `type_create/2` は、番号からタイプを生成する **ファクトリメソッド** です。ここでは失敗を項で表現するために `ok/error` を使っています。

```prolog
%% type_create(+No:integer, -Result) is det.
%
%  タイプ番号から Type を生成する。未定義の番号は error(Message) を返す。
type_create(1, ok(type_01)) :- !.
type_create(2, ok(type_02)) :- !.
type_create(3, ok(type_03)) :- !.
type_create(No, error(Message)) :-
    format(string(Message), "該当するタイプは存在しません: ~w", [No]).
```

- `ok(Type)` / `error(Message)` は、成功と失敗を **区別された複合項** で表します。Kotlin の `Result`、Flix の `Result` に相当し、「成功なら `ok`、失敗なら `error`」という結果を項の構造で表現します。
- 呼び出し側は `type_create(No, Result)` を実行したあと、`Result` が `ok(Type)` か `error(Message)` かをパターンマッチで判定できます。例外を投げる代わりに、戻り値の項で成否を表現します。
- `ok/error` は Null Object や Option 相当の考え方につながります。「値が無い」「失敗した」という状態を `nil` や例外ではなく項として明示的に表す手法であり、詳しくは第 12 章で扱います。

例外を throw する代わりに `ok/error` を返すことで、**失敗の可能性を戻り値の構造に表す** ため、呼び出し側に処理を促せます。

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [x] コマンドパターン（Command）
- [x] ファクトリメソッド（Factory Method）

## 8.6 適用したデザインパターン一覧

| パターン | 実装 | 役割 |
|---------|------|------|
| **Value Object** | 複合項 `fizzbuzz_value(N, V)` | 不変の値を表現 |
| **First-Class Collection** | `fizzbuzz_list` モジュール | コレクション操作のカプセル化 |
| **State（Strategy 相当）** | `generate/3` の複数節 | アルゴリズムの切り替え |
| **Factory Method** | `type_create/2` | 生成の集約（`ok/error` で失敗表現） |
| **Command** | 項 `value_command`／`list_command` + `execute/3` | 操作のデータ化 |

## 8.7 各言語のデザインパターン比較

| パターン | Prolog | Kotlin | Ruby | Java |
|---------|--------|--------|------|------|
| Value Object | 複合項 | `data class` | `attr_reader` + `==` | `record` |
| Collection | 専用モジュール | ラップした `class` | `Enumerable` + `freeze` | 不変 `List` ラップ |
| Command | 項 + 述語の複数節 | `sealed class` + `when` | `module`（Mix-in） | `interface` 実装 |
| 分岐の表現 | 単一化・複数節 | `sealed` + `when` | ダックタイピング | `switch` |
| 失敗表現 | `ok/error` の項 | `Result` | 例外（`raise`） | 例外 / `Optional` |

## 8.8 まとめ

この章で学んだこと。

1. **値オブジェクト**: 複合項 `fizzbuzz_value(Number, Value)` で番号と変換結果をひとつの不変データにまとめ、単一化によるパターンマッチで要素を取り出す
2. **ファーストクラスコレクション**: `fizzbuzz_list` モジュールにコレクション操作をカプセル化し、`list_create/3` の生成と `list_count/2` の件数取得を提供
3. **コマンドパターン**: 「データとしての項」`value_command`／`list_command` と、それを解釈する `execute/3` の複数節で操作を宣言的にデータ化
4. **ファクトリメソッドと ok/error**: `type_create/2` に生成を集約し、`ok/error` の項で失敗を明示的に表現

オブジェクト指向の「オブジェクト」が担っていた役割を、Prolog では **不変の複合項** と **それを解釈する述語** の組み合わせで表現できることを確認しました。次の章では、SOLID 原則の観点からコードを検証し、モジュール構造を整理します。

## 付録: 検証済みソースコード

<details>
<summary>src/fizzbuzz_value.pl</summary>

```prolog
:- module(fizzbuzz_value, [value_create/3, value_number/2, value_value/2]).

:- use_module(fizzbuzz_type).

%% value_create(+Type:atom, +N:integer, -Value) is det.
%
%  数値と変換結果をまとめた値オブジェクト fizzbuzz_value(Number, Value) を生成する。
value_create(Type, N, fizzbuzz_value(N, V)) :-
    generate(Type, N, V).

%% value_number(+Value, -Number) is det.
value_number(fizzbuzz_value(N, _), N).

%% value_value(+Value, -Str) is det.
value_value(fizzbuzz_value(_, V), V).
```

</details>

<details>
<summary>src/fizzbuzz_command.pl</summary>

```prolog
:- module(fizzbuzz_command, [execute/3]).

:- use_module(fizzbuzz_value).
:- use_module(fizzbuzz_list).

%% execute(+Command, +N:integer, -Values:list) is det.
%
%  コマンドを数 N に対して実行し、値オブジェクトのリストを返す。
%  value_command(Type): 単一の値を生成する。
%  list_command(Type):  1 から N までのリストを生成する。
execute(value_command(Type), N, [Value]) :-
    value_create(Type, N, Value).
execute(list_command(Type), N, Values) :-
    list_create(N, Type, Values).
```

</details>

<details>
<summary>test/fizzbuzz_value.plt</summary>

```prolog
:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_value).

test(create_holds_number_and_value) :-
    value_create(type_01, 3, V),
    value_number(V, N),
    value_value(V, S),
    assertion(N == 3),
    assertion(S == "Fizz").

test(value_is_a_compound_term) :-
    value_create(type_01, 5, V),
    assertion(V == fizzbuzz_value(5, "Buzz")).

:- end_tests(fizzbuzz_value).
```

</details>

<details>
<summary>test/fizzbuzz_command.plt</summary>

```prolog
:- use_module('../src/fizzbuzz_command').
:- use_module('../src/fizzbuzz_value').
:- use_module('../src/fizzbuzz_list').

:- begin_tests(fizzbuzz_command).

test(value_command_returns_single_value) :-
    execute(value_command(type_01), 3, Values),
    list_count(Values, Count),
    assertion(Count == 1),
    Values = [V],
    value_value(V, S),
    assertion(S == "Fizz").

test(list_command_returns_list) :-
    execute(list_command(type_01), 15, Values),
    list_count(Values, Count),
    assertion(Count == 15).

:- end_tests(fizzbuzz_command).
```

</details>
