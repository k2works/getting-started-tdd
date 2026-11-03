# 第 7 章: 複数節ディスパッチとポリモーフィズム

## 7.1 はじめに

第 1 部では FizzBuzz を TDD で実装し、第 2 部では開発環境を整備しました。第 3 部では **構造化設計** に踏み込み、手続き的なコードをより柔軟で拡張しやすい構造にリファクタリングしていきます。

この章では、**追加仕様** を題材にして **ポリモーフィズム** を学びます。オブジェクト指向言語ではサブクラスの多相やインターフェースで条件分岐を型階層に置き換えますが、Prolog では **複数節ディスパッチ**（第 1 引数のパターンで節を選ぶ）によって同じ効果を得ます。

## 7.2 追加仕様

FizzBuzz に 3 つの **タイプ** を導入します。

```
タイプごとに出力を切り替えることができる。
タイプ 1 は通常の FizzBuzz、タイプ 2 は数字のみ、タイプ 3 は Fizz の場合のみをプリントする。
```

| タイプ | 仕様 |
|--------|------|
| タイプ 1（通常） | 3 の倍数→Fizz、5 の倍数→Buzz、15 の倍数→FizzBuzz、それ以外→数値 |
| タイプ 2（数値のみ） | すべて数値文字列を返す（Fizz/Buzz 変換なし） |
| タイプ 3（Fizz のみ） | 15 の倍数→FizzBuzz、3 の倍数→Fizz、それ以外→数値（Buzz なし） |

**TODO リスト**:

- [ ] タイプ 1: 通常の FizzBuzz（既存の動作）
- [ ] タイプ 2: 数値のみ返す
- [ ] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [ ] 未定義のタイプはエラー

## 7.3 手続き的なアプローチ

最初に思いつくのは、タイプ番号で条件分岐する手続き的なアプローチです。

```prolog
% 手続き的な実装（アンチパターン）
generate(Type, N, R) :-
    (   Type == 1
    ->  (   0 is N mod 15 -> R = "FizzBuzz"
        ;   0 is N mod 3  -> R = "Fizz"
        ;   0 is N mod 5  -> R = "Buzz"
        ;   format(string(R), "~w", [N])
        )
    ;   Type == 2
    ->  format(string(R), "~w", [N])
    ;   Type == 3
    ->  (   0 is N mod 15 -> R = "FizzBuzz"
        ;   0 is N mod 3  -> R = "Fizz"
        ;   format(string(R), "~w", [N])
        )
    ;   throw(error(unknown_type, Type))
    ).
```

この実装には問題があります。

- **単一責任原則の違反**: 1 つの述語に複数のアルゴリズムが詰め込まれている
- **開放閉鎖原則の違反**: 新しいタイプを追加するたびに既存の `->`／`;` の連鎖を修正する必要がある
- **Prolog らしさの欠如**: ネストした `if-then-else` は Prolog の宣言的な性質を殺し、可読性を損なう

Prolog では、この分岐を **節（clause）の集まり** に置き換えます。

## 7.4 ポリモーフィズム — 複数節ディスパッチ

### 第 1 引数のパターンで節を選ぶ

オブジェクト指向言語では、レシーバの型（サブクラス）に応じてメソッド実装が切り替わる **サブタイプ多相** が使われます。Prolog にはクラスもサブクラスもありませんが、同じ述語名を持つ **複数の節** を定義し、**第 1 引数のパターン** で呼び出す節を選ぶことで、多相と同じ効果を実現できます。これが **複数節ディスパッチ** です。

`generate(type_01, N, R)` / `generate(type_02, N, R)` / `generate(type_03, N, R)` のように第 1 引数をアトム（`type_01` など）で受けると、Prolog の **第 1 引数インデックス** が働き、タイプに対応する節だけが選択されます。オブジェクト指向の State/Strategy パターンに相当する振る舞いの切り替えを、条件分岐なしで表現できます。

### Red: タイプ別テストの作成

実際のテストは `apps/prolog/test/fizzbuzz_type.plt` に置きます。

```prolog
:- use_module('../src/fizzbuzz_type').

:- begin_tests(fizzbuzz_type).

test(type_01_is_standard_fizzbuzz) :-
    generate(type_01, 15, R),
    assertion(R == "FizzBuzz").

test(type_02_is_number_only) :-
    generate(type_02, 15, R),
    assertion(R == "15").

test(type_03_has_no_buzz) :-
    generate(type_03, 5, R),
    assertion(R == "5").

test(type_03_still_has_fizz) :-
    generate(type_03, 3, R),
    assertion(R == "Fizz").
```

`generate/3` や `fizzbuzz_type` モジュールがまだ存在しないためロードに失敗します（Red）。テスト名は `type_03_has_no_buzz` のように意図を表す英語で付け、`assertion/1` で期待値を明示します。

### Green: 複数節ディスパッチの実装

`apps/prolog/src/fizzbuzz_type.pl` に述語を実装します。

```prolog
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
```

Prolog 固有の書き方を確認しましょう。

- 同じ述語名 `generate/3` に対して、第 1 引数のアトム（`type_01`／`type_02`／`type_03`）ごとに **別々の節グループ** を定義しています。呼び出し側は `generate(type_02, 15, R)` のようにタイプを渡すだけで、対応する節だけが選ばれます。
- カット `!` は「この節にコミットし、以降のバックトラックを打ち切る」ための演算子です。`0 is N mod 15` が成功したら `"FizzBuzz"` に確定し、下の `"Fizz"` や `"Buzz"` の節を試させません。これにより順序に依存した優先順位（15 の倍数を先に判定）が保証されます。
- `format(string(R), "~w", [N])` は、数値 `N` を書式 `~w` で文字列化し、結果を `R` に束縛します。`type_02` はどの数でも数値文字列を返すため、この 1 節だけで済みます。
- `type_03` には `"Buzz"` の節がありません。そのため `generate(type_03, 5, R)` は最初の 2 節で失敗し、最後の `format` 節で `"5"` を返します。これが「Fizz の場合のみ、Buzz なし」の仕様です。

第 1 引数のアトムがそのまま「型」の役割を果たし、節の集合がその型ごとの実装を担う。これが Prolog におけるポリモーフィズムです。

| 概念 | Prolog | Kotlin | Ruby |
|------|--------|--------|------|
| 型の列挙 | アトム `type_01` 等 | `enum class { A, B }` | 定数 + `case` |
| 多態の実現 | 複数節ディスパッチ | enum 定数の `override` | ダックタイピング + サブクラス |
| 分岐 | 節の選択 + カット | `when` 式 | `case` / `if` |
| 保証 | 第 1 引数インデックス | 静的型 + 抽象メソッド | 実行時（規約） |

テストを実行すると全ケースが通ります（Green）。

**TODO リスト**:

- [x] タイプ 1: 通常の FizzBuzz（既存の動作）
- [x] タイプ 2: 数値のみ返す
- [x] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [ ] 未定義のタイプはエラー

## 7.5 タイプの生成 — ok/error による直和項

### 問題: 番号からタイプを作る

呼び出し側はタイプ番号（1／2／3）を扱いたい場合があります。番号からタイプアトムへ変換する述語 `type_create/2` を用意しましょう。ここで問題になるのが「未定義の番号」の扱いです。

オブジェクト指向言語では例外（`throw`）を投げますが、Prolog では **値としてエラーを表現** するほうが宣言的で扱いやすくなります。成功を `ok(Type)`、失敗を `error(Message)` という **直和項** で返すことで、呼び出し側はパターンマッチでどちらかを判定できます。

### Red: type_create のテスト

```prolog
test(create_known_type) :-
    type_create(1, R),
    assertion(R == ok(type_01)).

test(create_unknown_type_returns_error) :-
    type_create(9, error(_)).
```

### Green: type_create の実装

```prolog
type_create(1, ok(type_01)) :- !.
type_create(2, ok(type_02)) :- !.
type_create(3, ok(type_03)) :- !.
type_create(No, error(Message)) :-
    format(string(Message), "該当するタイプは存在しません: ~w", [No]).
```

Prolog 固有の書き方を確認しましょう。

- 結果を `ok(type_01)` や `error(Message)` という **複合項（直和項）** で表しています。呼び出し側は `type_create(N, ok(Type))` と書けば成功時のみマッチし、`error(Message)` と書けば失敗時のみマッチするため、例外処理を書かずに分岐できます。
- `type_create(1, ok(type_01)) :- !.` のカットは、番号 1 が確定したら最後の `error` 節を試させないためのコミットです。これがないと、既知の番号でもバックトラックで `error` 節に落ちてしまいます。
- 未定義の番号 `No` は最後の節にマッチし、`format(string(Message), ...)` で人間向けのメッセージ文字列を組み立てます。エラーを **投げる** のではなく **返す** ことで、テスト側も `type_create(9, error(_))` と自然に検証できます。

`create_unknown_type_returns_error` テストが示すように、番号 9 は `error(_)` にマッチして成功します（例外は発生しません）。

| 観点 | Prolog | Kotlin | Ruby |
|------|--------|--------|------|
| 成功／失敗の表現 | `ok(T)` / `error(M)` 直和項 | `Result<T>` | 戻り値 / `raise` |
| エラーの伝え方 | 値として返す | 値として返す | 例外 |
| 分岐方法 | パターンマッチ | `when` / `getOrNull` | `rescue` |
| 網羅の保証 | 節の順序 + カット | `when` の網羅 | 規約 |

Prolog は「例外を投げる」より「値で表す」ことに寄せた設計が自然で、テストの見通しがよくなるのが特徴です。

**TODO リスト**:

- [x] タイプ 1: 通常の FizzBuzz（既存の動作）
- [x] タイプ 2: 数値のみ返す
- [x] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [x] 未定義のタイプはエラー

## 7.6 リファクタリング — モジュールとして公開する

タイプ別の振る舞いが揃ったので、これらを **モジュール** としてまとめ、外部に公開する述語を明示します。

```prolog
:- module(fizzbuzz_type, [generate/3, type_create/2]).
```

`:- module(名前, [公開述語のリスト])` は、`fizzbuzz_type` という名前のモジュールを定義し、`generate/3` と `type_create/2` だけを外部へ公開します。モジュール内部の補助述語を隠蔽できるため、これが Prolog における **カプセル化** の手段です。テスト側は `:- use_module('../src/fizzbuzz_type').` で読み込み、公開述語だけを使います。

述語ヘッダにはドキュメンテーションコメント（PlDoc）を添えて、引数の意味と決定性（`is det.`）を明示します。

```prolog
%% generate(+Type:atom, +N:integer, -Result:string) is det.
%
%  タイプ（type_01 / type_02 / type_03）に従って数 N を変換する。
%  各タイプごとの節が振る舞いを切り替える（State/Strategy 相当）。
```

`+` は入力引数、`-` は出力引数を表し、`is det` は「解が 1 つに確定する（バックトラックで別解を返さない）」ことを示します。カットによって各呼び出しが決定的になるため、この宣言は実装と一致します。

## 7.7 各言語のポリモーフィズム比較

| 概念 | Prolog | Kotlin | Ruby | Java |
|------|--------|--------|------|------|
| 型の表現 | アトム | `enum class` | 定数 + サブクラス | `enum` |
| 多態の実現 | 複数節ディスパッチ | enum 定数の `override` | ダックタイピング | 抽象メソッド |
| エラー表現 | `ok/error` 直和項 | `Result<T>` | 例外 | 例外 / `Optional` |
| 分岐の確定 | カット `!` | `when` + `else` | `case` / `if` | `switch` |
| カプセル化 | `module` の公開リスト | `private` / `companion` | `private` | アクセス修飾子 |

## 7.8 まとめ

この章で学んだこと。

1. **複数節ディスパッチ**: 同じ述語名 `generate/3` に第 1 引数のアトム（`type_01` 等）ごとの節グループを定義し、条件分岐を節の選択に置き換えた。これが Prolog のポリモーフィズムであり、State/Strategy パターンに相当する
2. **カット `!`**: 節にコミットしてバックトラックを打ち切り、優先順位（15 の倍数を先に判定）と決定性を保証
3. **ok/error 直和項**: 例外を投げる代わりに `ok(Type)` / `error(Message)` を **値として返し**、呼び出し側がパターンマッチで分岐できるようにした
4. **モジュール**: `:- module(..., [公開述語])` で公開範囲を絞り、カプセル化を実現

次の章では、リストを畳み込む述語やコマンド相当の構造を Prolog らしく組み立て、さらに宣言的な設計へ進んでいきます。

## 実装

### src/fizzbuzz_type.pl

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

### test/fizzbuzz_type.plt

```prolog
:- use_module('../src/fizzbuzz_type').

:- begin_tests(fizzbuzz_type).

test(type_01_is_standard_fizzbuzz) :-
    generate(type_01, 15, R),
    assertion(R == "FizzBuzz").

test(type_02_is_number_only) :-
    generate(type_02, 15, R),
    assertion(R == "15").

test(type_03_has_no_buzz) :-
    generate(type_03, 5, R),
    assertion(R == "5").

test(type_03_still_has_fizz) :-
    generate(type_03, 3, R),
    assertion(R == "Fizz").

test(create_known_type) :-
    type_create(1, R),
    assertion(R == ok(type_01)).

test(create_unknown_type_returns_error) :-
    type_create(9, error(_)).

:- end_tests(fizzbuzz_type).
```
