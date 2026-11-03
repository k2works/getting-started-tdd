# 第 9 章: モジュール設計

## 9.1 はじめに

前章までに多くのデザインパターンを適用しました。この章では **SOLID 原則** の観点からコードを検証し、SWI-Prolog の **モジュールシステム** を使った **モジュール設計** に整理します。Prolog では `:- module(Name, [Exports]).` で公開する述語を絞り、`:- use_module(File).` で依存を明示的に宣言します。これにより、オブジェクト指向言語のクラスや package に相当するカプセル化と単一責任を、述語の集合として実現します。

## 9.2 SOLID 原則の検証

### 単一責任原則（SRP: Single Responsibility Principle）

> モジュールが変更される理由は一つでなければならない

Prolog では 1 つの `.pl` ファイルが 1 つのモジュールを構成し、`module/2` の第 2 引数で公開する述語だけをエクスポートします。責務ごとにファイルを分割することで、SRP を述語の集合として表現します。

| モジュール | 公開述語 | 責務 | 変更理由 |
|-----------|---------|------|---------|
| `fizzbuzz_type` | `generate/3`, `type_create/2` | タイプごとの変換ルール | 変換ルールが変わるとき |
| `fizzbuzz_value` | `value_create/3`, `value_number/2`, `value_value/2` | FizzBuzz の結果値を表現 | 値の表現方法が変わるとき |
| `fizzbuzz_list` | `list_create/3`, `list_count/2` | 結果コレクションを管理 | コレクション操作が変わるとき |
| `fizzbuzz_command` | `execute/3` | 操作の実行 | 操作の起動方法が変わるとき |

各モジュールが 1 つの責務を持ち、変更理由は 1 つです。SRP を満たしています。`fizzbuzz_type` では `generate(type_01, ...)`・`generate(type_02, ...)`・`generate(type_03, ...)` と節を分けているため、あるタイプのルール変更が他のタイプの節に波及しません。

### 開放閉鎖原則（OCP: Open-Closed Principle）

> ソフトウェアエンティティは拡張に対して開いていて、修正に対して閉じている

新しいタイプ（例: タイプ 4）を追加する場合。

1. `fizzbuzz_type` に `generate(type_04, N, R) :- ...` の節を **追加** する
2. `type_create(4, ok(type_04)) :- !.` を **追加** する

既存の `type_01`〜`type_03` の節は一切変更しません。Prolog の節は追加によって振る舞いを拡張できるため、OCP を満たしています。タイプは第 1 引数のアトムで分岐し、節ごとに実装が閉じています。

### リスコフの置換原則（LSP: Liskov Substitution Principle）

> 派生型はその基底型と置換可能でなければならない

`generate/3` は、`type_01`〜`type_03` のいずれのアトムを第 1 引数に渡しても「数 N を受け取り文字列 R を返す」という契約を守ります。呼び出し側の `value_create/3` は具体的なタイプを意識せず `generate(Type, N, V)` を呼べます。どのタイプに置き換えても契約は同一であり、LSP を満たしています。

### インターフェース分離原則（ISP: Interface Segregation Principle）

> クライアントは使わない述語への依存を強制されるべきでない

各モジュールは `module/2` で必要最小限の述語だけをエクスポートします。`fizzbuzz_value` は値の生成・参照に関する述語のみ、`fizzbuzz_list` はコレクション操作の述語のみを公開します。肥大化した共通インターフェースを避け、利用側は必要な述語だけを `use_module` で取り込みます。ISP を満たしています。

### 依存関係逆転の原則（DIP: Dependency Inversion Principle）

> 上位レベルのモジュールは下位レベルのモジュールに依存してはならない。両方とも抽象に依存すべき

```
fizzbuzz_command ──→ generate/3 の契約（タイプの振る舞い）
                          ↑
              type_01, type_02, type_03
```

- コマンド（上位）は `Type` アトムを受け取り、`value_create` を経由して `generate(Type, N, V)` を呼ぶだけです。
- 具体的な `type_01`〜`03` の節の中身には依存しません。
- 抽象（`generate/3` の契約）に依存し、DIP を満たしています。

## 9.3 依存方向

第 3 部で構築したモジュールの依存方向は次の通りです。

```
fizzbuzz_command ──→ fizzbuzz_list ──→ fizzbuzz_value ──→ fizzbuzz_type
   （コマンド）      （コレクション）    （値オブジェクト）    （タイプ）
```

- `fizzbuzz_type` は他のモジュールに依存しない（最も安定）
- `fizzbuzz_value` は `fizzbuzz_type`（`generate/3`）に依存
- `fizzbuzz_list` は `fizzbuzz_value`（`value_create/3`）に依存
- `fizzbuzz_command` は `fizzbuzz_list` と `fizzbuzz_value` に依存

依存は一方向で循環がありません。抽象度が高く安定した `fizzbuzz_type` に向かって依存が流れています。

## 9.4 モジュール設計 — module 分割

第 7・8 章で構築した各要素を、SWI-Prolog のモジュールシステムで整理します。各 `.pl` ファイルは先頭で `module/2` を宣言し、公開する述語を明示します。

### 設計方針

| レイヤー | モジュール | 責務 |
|---------|-----------|------|
| **ドメインタイプ** | `fizzbuzz_type` | ビジネスルール（FizzBuzz 変換） |
| **ドメインモデル** | `fizzbuzz_value`, `fizzbuzz_list` | 値オブジェクト、コレクション |
| **アプリケーション** | `fizzbuzz_command` | 操作の実行（コマンド） |

### ファイル構成

Prolog では 1 ファイル 1 モジュールが基本です。ファイル名とモジュール名を一致させることで、依存を追いやすくします。

```
apps/prolog/src/
├── fizzbuzz_type.pl     (generate/3, type_create/2)
├── fizzbuzz_value.pl    (value_create/3, value_number/2, value_value/2)
├── fizzbuzz_list.pl     (list_create/3, list_count/2)
└── fizzbuzz_command.pl  (execute/3)
```

各ファイルの先頭でモジュールを宣言し、公開述語をエクスポートします。

```prolog
% fizzbuzz_type.pl
:- module(fizzbuzz_type, [generate/3, type_create/2]).
```

```prolog
% fizzbuzz_value.pl
:- module(fizzbuzz_value, [value_create/3, value_number/2, value_value/2]).

:- use_module(fizzbuzz_type).
```

```prolog
% fizzbuzz_list.pl
:- module(fizzbuzz_list, [list_create/3, list_count/2]).

:- use_module(fizzbuzz_value).
```

`use_module/1` により、どのモジュールが何に依存しているかがファイル先頭で一目で分かります。エクスポートしていない述語（補助述語）はモジュール外から参照できず、実装詳細としてカプセル化されます。

### ファーストクラスコレクション

`fizzbuzz_list` は、値オブジェクトのリストをまとめて扱うファーストクラスコレクションです。`list_create/3` は `numlist/3` で 1 から Count までの整数リストを作り、`maplist/3` で各整数を値オブジェクトへ変換します。

```prolog
list_create(Count, Type, Values) :-
    numlist(1, Count, Ns),
    maplist([N, V]>>value_create(Type, N, V), Ns, Values).
```

- `numlist(1, Count, Ns)` が `[1, 2, ..., Count]` を生成する
- `maplist/3` が各要素に `value_create/3` を適用し、値オブジェクトのリストを得る
- `list_count/2` は `length/2` で要素数を返す

コレクション操作を `fizzbuzz_list` に凝集することで、リストの生成・集計ロジックが 1 箇所に集まり、値オブジェクトそのものの責務（`fizzbuzz_value`）と分離されます。

### 依存関係

```
fizzbuzz_command ──→ fizzbuzz_list ──→ fizzbuzz_value ──→ fizzbuzz_type
     │                    │                  │
  コマンド          コレクション        値・タイプ変換
```

- `fizzbuzz_type` は他のモジュールに依存しない（最も安定）
- `fizzbuzz_value` は `fizzbuzz_type` に依存する（`value_create` が `generate` を呼ぶ）
- `fizzbuzz_list` は `fizzbuzz_value` に依存する（`list_create` が `value_create` を呼ぶ）
- `fizzbuzz_command` は `fizzbuzz_list` と `fizzbuzz_value` の両方に依存する

依存は一方向（`command → list → value → type`）に流れ、循環がありません。最も変わりにくいビジネスルール（`fizzbuzz_type`）が最も安定し、上位のモジュールがそれに依存する構造です。

### カプセル化

`module/2` のエクスポートリストが公開範囲を制御します。

| 述語 | 状態 | 意味 |
|------|------|------|
| エクスポートされた述語 | 公開 | 他モジュールから `use_module` 経由で呼べる |
| エクスポートされない述語 | 非公開 | 同一モジュール内でのみ呼べる（実装詳細） |

エクスポートリストに載せる述語を最小限に絞ることで、各モジュールの公開 API を必要最小限に保っています。

## 9.5 テストのモジュール対応

テストも本体のモジュール構造に合わせて分割します。`.plt` ファイルは対象モジュールとその依存モジュールを `use_module` で取り込み、`begin_tests`/`end_tests` でテストユニットを構成します。

```
apps/prolog/test/
├── fizzbuzz_type.plt    (タイプの変換・ファクトリ)
├── fizzbuzz_value.plt   (値オブジェクト)
├── fizzbuzz_list.plt    (コレクション)
└── fizzbuzz_command.plt (コマンド)
```

`fizzbuzz_list` のテストは、対象モジュールと参照する `fizzbuzz_value` を取り込みます。

```prolog
:- use_module('../src/fizzbuzz_list').
:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_list).
```

### テスト実行結果

```bash
$ swipl -g run_tests -t halt test/fizzbuzz_list.plt

% PL-Unit: fizzbuzz_list ... done
% All 3 tests passed
```

すべてのテストが通り、第 3 部の実装がモジュール構造として完成しました。

## 9.6 各言語のモジュール設計比較

| 概念 | Prolog | Kotlin | Ruby | Java |
|------|--------|--------|------|------|
| モジュール単位 | `module/2`（ファイル） | `package` | ファイル（`require_relative`） | パッケージ |
| 公開制御 | エクスポートリスト | `public`/`internal`/`private` | `private`/`protected`/`public` | `public`/package-private |
| 依存宣言 | `use_module/1` | `import` | `require_relative` | `import` |
| 名前空間 | モジュール名 | package 名 | モジュール / クラス | パッケージ名 |
| 振る舞いの切り替え | 節（第 1 引数のアトム） | `enum` の抽象メソッド | サブクラス | サブクラス / `sealed` |

## 9.7 まとめ

第 3 部（章 7〜9）を通じて、手続き的な FizzBuzz を Prolog のモジュール設計へ進化させました。

| 章 | テーマ | 適用したパターン |
|---|--------|---------------|
| 7 | カプセル化とポリモーフィズム | 節による振る舞いの切り替え（State/Strategy 相当）、値オブジェクト |
| 8 | デザインパターンの適用 | Value Object、First-Class Collection、Command、Factory（`ok`/`error`） |
| 9 | モジュール設計 | SRP/OCP/LSP/ISP/DIP、`module/2` 分割、`use_module` による依存宣言 |

### Before / After

**Before**（第 2 部終了時）:

```
fizzbuzz.pl（述語中心）
```

**After**（第 3 部終了時）:

```
src/
├── fizzbuzz_type.pl     (generate/3 + type_create/2)
├── fizzbuzz_value.pl    (値オブジェクト)
├── fizzbuzz_list.pl     (ファーストクラスコレクション)
└── fizzbuzz_command.pl  (コマンド)
```

SWI-Prolog の `module/2`・`use_module/1`・`numlist`・`maplist` を組み合わせることで、述語のカプセル化と明示的な依存宣言を両立できました。エクスポートリストで公開範囲を絞り、各モジュールが単一の責務を持つ構造へ整理できました。

次の第 4 部では、関数型プログラミングの観点から FizzBuzz を再構成し、高階関数、不変データ、パイプライン、エラーハンドリングを学びます。

## 実装 — fizzbuzz_type.pl

```prolog
:- module(fizzbuzz_type, [generate/3, type_create/2]).

%% generate(+Type:atom, +N:integer, -Result:string) is det.
%
%  タイプ（type_01 / type_02 / type_03）に従って数 N を変換する。
%  各タイプごとの節が振る舞いを切り替える（State/Strategy 相当）。

% type_01: 通常の FizzBuzz
generate(type_01, N, "FizzBuzz") :- 0 is N mod 15, !.
generate(type_01, N, "Fizz")     :- 0 is N mod 3, !.
generate(type_01, N, "Buzz")     :- 0 is N mod 5, !.
generate(type_01, N, R)          :- format(string(R), "~w", [N]).

% type_02: 数字のみ
generate(type_02, N, R) :- format(string(R), "~w", [N]).

% type_03: Fizz のみ（Buzz なし）
generate(type_03, N, "FizzBuzz") :- 0 is N mod 15, !.
generate(type_03, N, "Fizz")     :- 0 is N mod 3, !.
generate(type_03, N, R)          :- format(string(R), "~w", [N]).

%% type_create(+No:integer, -Result) is det.
%
%  タイプ番号から Type を生成する。未定義の番号は error(Message) を返す。
type_create(1, ok(type_01)) :- !.
type_create(2, ok(type_02)) :- !.
type_create(3, ok(type_03)) :- !.
type_create(No, error(Message)) :-
    format(string(Message), "該当するタイプは存在しません: ~w", [No]).
```

## 実装 — fizzbuzz_value.pl

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

## 実装 — fizzbuzz_list.pl

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

## テスト — fizzbuzz_list.plt

```prolog
:- use_module('../src/fizzbuzz_list').
:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_list).

test(create_has_count_elements) :-
    list_create(15, type_01, Values),
    list_count(Values, Count),
    assertion(Count == 15).

test(first_element_is_one) :-
    list_create(15, type_01, [First | _]),
    value_value(First, S),
    assertion(S == "1").

test(fifteenth_element_is_fizzbuzz) :-
    list_create(15, type_01, Values),
    last(Values, Last),
    value_value(Last, S),
    assertion(S == "FizzBuzz").

:- end_tests(fizzbuzz_list).
```
