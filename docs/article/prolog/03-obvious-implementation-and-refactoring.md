# 第 3 章: 明白な実装とリファクタリング

## 3.1 はじめに

前章では、三角測量と複数節（clause）で FizzBuzz のコアロジック `fizzbuzz/2` を完成させました。この章では、残りの TODO（1 から N までのリスト生成とプリント）を実装し、リファクタリングで「動作するきれいなコード」を目指します。あわせて、`:- module/2` 宣言によるカプセル化と、宣言的な純粋述語の読みやすさを確認します。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [ ] 1 から N までの数
- [ ] プリントする

Prolog では関数の代わりに **述語（predicate）** を、戻り値の代わりに **出力引数の単一化** を用います。`fizzbuzz(N, R)` は「数 `N` を変換した結果が `R` である」という関係を宣言し、`R` が未束縛であれば処理系が変換結果で `R` を単一化します。

## 3.2 明白な実装

### 数値のデフォルト処理

前章までに `fizzbuzz/2` は次の 4 つの節で構成されました。最後の節に注目します。

```prolog
fizzbuzz(N, "FizzBuzz") :- 0 is N mod 15, !.
fizzbuzz(N, "Fizz")     :- 0 is N mod 3, !.
fizzbuzz(N, "Buzz")     :- 0 is N mod 5, !.
fizzbuzz(N, Result)     :- format(string(Result), "~w", [N]).
```

ここで **明白な実装** の考え方を確認しておきましょう。

> 明白な実装
>
> シンプルな操作を実現するにはどうすればいいだろうか——そのまま実装しよう。
>
> — テスト駆動開発

最終節 `fizzbuzz(N, Result) :- format(string(Result), "~w", [N]).` は、Fizz にも Buzz にも該当しない **数値のデフォルト処理** です。上の 3 節がいずれも失敗（つまり倍数条件を満たさない）したときにだけ到達します。ここでは変換のトリックは不要で、数 `N` をそのまま文字列化して返す——という明白な実装をそのまま書き下しています。

Prolog 固有のポイントを確認しましょう。

- `format(string(Result), "~w", [N])` は、書式 `"~w"`（write 相当の汎用出力）に引数 `N` を当てはめた文字列を組み立て、それを `Result` に **単一化** します。C の `sprintf` のように「文字列を組み立てて返す」操作を宣言的に表現したものです。
- `~w` は数値・アトム・文字列など任意の項を受け取れるため、`N` が整数であれば `1` は `"1"` に、`14` は `"14"` になります。
- 上位 3 節の末尾にある `!`（カット）が、条件が成立した節で確定させ、以降の節へのバックトラッキングを止めます。これにより、デフォルト節は「どの倍数にも該当しない場合のみ」評価される、と読めます。

この 4 節は「どの入力に対しても結果がちょうど 1 つに定まる」ことを宣言しており、`det`（決定的）な述語として振る舞います。

## 3.3 リファクタリング: module によるエクスポート制御

コアロジックが揃ったところで、TDD の流れを確認しておきましょう。

> 1. レッド：動作しない、おそらく最初のうちはコンパイルも通らないテストを 1 つ書く。
> 2. グリーン：そのテストを迅速に動作させる。このステップでは罪を犯してもよい。
> 3. リファクタリング：テストを通すために発生した重複をすべて除去する。
>
> レッド・グリーン・リファクタリング。それが TDD のマントラだ。
>
> — テスト駆動開発

Prolog のリファクタリングとして、まず **カプセル化** に注目します。`src/fizzbuzz.pl` の先頭には次のモジュール宣言があります。

```prolog
:- module(fizzbuzz, [fizzbuzz/2]).
```

`:- module(Name, Exports)` は、このファイルを `Name` という名前のモジュールとして定義し、`Exports` に列挙した述語だけを公開します。ここでは `fizzbuzz/2` のみを公開しており、オブジェクト指向言語における `public`／`private` の区別を、モジュール境界で実現しています。

公開する述語を最小限に絞ることで、モジュールの **インターフェースが明確** になります。利用側は `:- use_module(fizzbuzz).` と書くだけで公開述語 `fizzbuzz/2` を取り込め、内部実装の変更が外部に波及しにくくなります。これは「変更を楽に安全にできる」設計への一歩です。

### 宣言的な純粋述語

`fizzbuzz/2` は **副作用を持たない純粋な述語** です。同じ入力に対して常に同じ結果を単一化し、外部状態を読み書きしません。

- **複数節ディスパッチ**: `fizzbuzz/2` は 4 つの節をパターンで振り分けます。条件（`0 is N mod 15` など）と結果（`"FizzBuzz"` など）の対応が節ごとに 1 行で並び、「何が真か」を宣言的に読み取れます。命令型の `if-else` の入れ子より、仕様と実装の対応が素直です。
- **決定性**: 各節末尾のカット `!` により、`fizzbuzz/2` は入力ごとに解をちょうど 1 つに確定させ、余計なバックトラッキングを起こしません。

コアロジックは十分にシンプルで、これ以上の構造的なリファクタリングは不要です。

### テストコードの確認

`test/fizzbuzz.plt` は `fizzbuzz/2` に入力を与えて出力を検証するだけで完結し、モックやスタブといったテストダブルを一切必要としません。これは `fizzbuzz/2` が副作用を持たない純粋述語であるためです。`assertion/1` により、期待する単一化結果を仕様としてそのまま記述できます。

```bash
$ make test
% All 4 tests passed
```

## 3.4 プリント機能

残る TODO は「1 から N までの数」と「プリントする」です。この 2 つは、公開述語 `fizzbuzz/2` を使えばエントリーポイント `main/0` の中だけで完結できます。純粋な変換ロジック（`fizzbuzz/2`）と副作用を持つ出力処理（`main/0`）を分離し、リスト生成とプリントは `src/main.pl` 側で表現します。

`src/main.pl` を用意します。

```prolog
:- module(main, [main/0]).

:- use_module(fizzbuzz).

%% main is det.
%
%  1 から 15 までの標準 FizzBuzz を 1 行ずつ出力する。
main :-
    numlist(1, 15, Ns),
    maplist(fizzbuzz, Ns, List),
    forall(member(S, List),
           format("~w~n", [S])).
```

Prolog 固有のポイントを確認しましょう。

- `numlist(1, 15, Ns)` は 1 から 15 までの整数リスト `[1, 2, ..., 15]` を生成する組み込み述語です。両端を含む閉区間で、Ruby の `(1..n)` に相当します。
- `maplist(fizzbuzz, Ns, List)` は **高階述語** です。`Ns` の各要素 `X` について `fizzbuzz(X, Y)` を呼び出し、結果 `Y` を集めて `List` に単一化します。`fizzbuzz/2` を **述語そのもの**（値）として `maplist` に渡している点が、関数型言語の関数参照に対応します。`maplist/3` は入力リストと出力リストの長さが一致することを要求するため、`List` は 15 要素のリストとして構築されます。
- `forall(Cond, Action)` は「`Cond` を満たすすべての解に対して `Action` が成立する」ことを表す組み込み述語です。ここでは `member(S, List)` が `List` の各要素 `S` を順にバックトラッキングで取り出し、その都度 `format("~w~n", [S])` を実行します。副作用（出力）を宣言的に「すべての要素について行う」と書き下しています。
- `format("~w~n", [S])` は要素 `S` を書式 `~w` で出力し、`~n` で改行します。`~n` は環境に依存しない改行を出力します。Kotlin の `forEach(::println)` に相当しますが、Prolog では `forall` + `member` の組み合わせで「リストを走査して各要素に副作用を適用する」を表現します。

> 補足: ここではリスト生成とプリントを `main.pl` 内にまとめました。一覧生成やプリントは後続の第 3 部で `fizzbuzz_list`・`fizzbuzz_value` といった別モジュールへ構造化していきます（実体の `main.pl` は最終的にそのモジュール版になります）。

実行して確認します。

```bash
$ make run
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

1 から 15 までの FizzBuzz が出力されました。

**TODO リスト**:

- [x] 数を文字列にして返す
- [x] 3 の倍数のときは数の代わりに「Fizz」と返す
- [x] 5 の倍数のときは「Buzz」と返す
- [x] 3 と 5 両方の倍数の場合には「FizzBuzz」と返す
- [x] 1 から N までの数
- [x] プリントする

副作用（プリント）は `main/0` に隔離され、変換ロジック `fizzbuzz/2` は純粋述語として保たれています。純粋述語をモジュールで公開し、副作用をエントリーポイントに寄せることで、テスト容易性と再利用性が両立します。

## 3.5 他言語との比較

| 概念 | Ruby | Kotlin | Prolog |
|------|------|--------|--------|
| テストフレームワーク | Minitest | kotlin.test | plunit |
| テスト実行 | `bundle exec rake test` | `gradle test` | `make test` |
| 型付け | 動的 | 静的 | 動的（単一化） |
| 文字列変換 | `n.to_s` | `n.toString()` | `format(string(R), "~w", [N])` |
| 剰余判定 | `(n % 3).zero?` | `n % 3 == 0` | `0 is N mod 3` |
| 条件分岐 | `case/when` | `when` 式 | 複数節 + カット |
| リスト生成 | `(1..n).map { }` | `(1..n).map(::f)` | `numlist` + `maplist` |
| プリント | `each { puts }` | `forEach(::println)` | `forall(member(...), format(...))` |
| カプセル化 | `module`／可視性 | `object`／`private` | `:- module/2` のエクスポート |

Ruby や Kotlin との対比で見ると、剰余判定やリスト生成の書き味は近い一方で、Prolog は **戻り値ではなく出力引数の単一化** で結果を返す点が大きく異なります。`fizzbuzz(N, R)` は「`N` を変換した結果が `R` である」という **関係** を宣言し、条件分岐は複数節とパターンマッチで、繰り返しはバックトラッキングと高階述語で表現します。命令型の代入・ループ・`return` を書かずに、「何が真か」を宣言的に記述できることが、Prolog の宣言的なきれいさです。

## 3.6 まとめ

この章では以下のことを学びました。

- **明白な実装** でシンプルな操作をそのまま実装する手法
- 最終節 `fizzbuzz(N, Result) :- format(string(Result), "~w", [N]).` が数値のデフォルト処理であること
- `:- module(fizzbuzz, [fizzbuzz/2])` によるエクスポート制御と純粋述語のカプセル化
- `main.pl` 内での `numlist` + `maplist` による 1 から 15 までのリスト生成
- `forall` + `member` + `format` によるプリント（副作用）の実行
- 単一化とバックトラッキングに支えられた宣言的な純粋述語の読みやすさ
- Red-Green-Refactor サイクルの完了

第 1 部の 3 章を通じて、TDD の基本サイクル（仮実装 → 三角測量 → 明白な実装 → リファクタリング）を一通り体験しました。Prolog では、述語・単一化・複数節・高階述語といった論理型の道具立てを使い、同じ TDD サイクルで「動作するきれいなコード」に到達できることが分かりました。

次の第 2 部では、開発環境の自動化（バージョン管理、パッケージ管理、CI/CD）に進みます。

### 実装

<details>
<summary>実装コード（src/fizzbuzz.pl）</summary>

```prolog
:- module(fizzbuzz, [fizzbuzz/2]).

%% fizzbuzz(+N:integer, -Result:string) is det.
%
%  数 N を FizzBuzz 変換した文字列 Result を返す。
%  3 の倍数は "Fizz"、5 の倍数は "Buzz"、両方の倍数は "FizzBuzz"、
%  それ以外は数値そのものを文字列化して返す。

fizzbuzz(N, "FizzBuzz") :- 0 is N mod 15, !.
fizzbuzz(N, "Fizz")     :- 0 is N mod 3, !.
fizzbuzz(N, "Buzz")     :- 0 is N mod 5, !.
fizzbuzz(N, Result)     :- format(string(Result), "~w", [N]).
```

</details>

<details>
<summary>エントリーポイント（src/main.pl）</summary>

```prolog
:- module(main, [main/0]).

:- use_module(fizzbuzz).

%% main is det.
%
%  1 から 15 までの標準 FizzBuzz を 1 行ずつ出力する。
main :-
    numlist(1, 15, Ns),
    maplist(fizzbuzz, Ns, List),
    forall(member(S, List),
           format("~w~n", [S])).
```

</details>

<details>
<summary>テストコード（test/fizzbuzz.plt）</summary>

```prolog
:- use_module('../src/fizzbuzz').

:- begin_tests(fizzbuzz).

test(returns_fizz_for_multiple_of_3) :-
    fizzbuzz(3, R),
    assertion(R == "Fizz").

test(returns_buzz_for_multiple_of_5) :-
    fizzbuzz(5, R),
    assertion(R == "Buzz").

test(returns_fizzbuzz_for_multiple_of_15) :-
    fizzbuzz(15, R),
    assertion(R == "FizzBuzz").

test(returns_number_otherwise) :-
    fizzbuzz(1, R),
    assertion(R == "1").

:- end_tests(fizzbuzz).
```

</details>
