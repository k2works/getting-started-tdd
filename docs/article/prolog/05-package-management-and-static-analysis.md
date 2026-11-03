# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

TDD を支える開発基盤として、依存関係の管理とコード品質の自動チェックは欠かせません。前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、SWI-Prolog のパッケージ管理（`pack` システム）と、**静的解析** としてのロード時検査を整備し、コードの品質を自動でチェックできるようにします。

Prolog は動的型付けの言語ですが、SWI-Prolog はプログラムのロード（コンパイル）時に **singleton 変数警告** や **未定義述語検出** などの検査を行います。これらの警告を活用し、`make lint` として CI に組み込める形にまとめます。

## 5.2 pack によるパッケージ管理

### pack システム

> SWI-Prolog は `pack`（package）と呼ばれるパッケージ機構を標準で備えています。コミュニティが公開するライブラリを取得・インストール・管理でき、Ruby の Bundler、Node の npm、Kotlin の Gradle に相当する役割を担います。

インストール済みのパッケージ一覧は、対話環境で `pack_list_installed/0` を呼び出すと確認できます。

```prolog
?- pack_list_installed.
```

外部パッケージを追加する場合は `pack_install/1` を使います（例示のみで、本プロジェクトでは実際には追加しません）。

```prolog
?- pack_install(some_pack).
```

FizzBuzz の実装では外部パッケージは不要なため、`pack` の追加インストールは行いません。標準で付属する **標準ライブラリ** のみで完結します。

### 標準ライブラリの読み込み

SWI-Prolog には多数の標準ライブラリが同梱されており、`use_module/1` で読み込みます。たとえばリスト操作の `numlist/3` や `maplist/2` などは `library(lists)`（および `library(apply)`）に含まれます。

```prolog
:- use_module(library(lists)).
```

```prolog
?- numlist(1, 5, L).
L = [1, 2, 3, 4, 5].

?- maplist([X]>>(Y is X * 2, write(Y), nl), [1, 2, 3]).
```

標準ライブラリは追加インストール不要でそのまま利用できるため、FizzBuzz のような小さなプログラムでは `pack` を使わずとも十分に開発を進められます。Kotlin が JVM の Maven エコシステムを前提とするのに対し、Prolog では標準ライブラリと `pack` を組み合わせて依存を管理します。

## 5.3 静的解析（ロード時検査）

Prolog は動的型付けの言語なので、Kotlin のような型検査は行いません。しかし SWI-Prolog は、プログラムをロード（コンパイル）する時点で次のような検査を行い、警告やエラーを出力します。

- **singleton 変数警告** -- 節の中で 1 回しか出現しない変数を検出する（タイプミスの多くはここで見つかる）
- **未定義述語検出** -- 呼び出しているのに定義されていない述語を検出する
- **構文チェック** -- 構文エラーのある節を検出する

これらはコンパイル時の検査であり、テストを実行する前にコードの明白な誤りを排除できます。「テストで守る範囲」と「ロード時検査で守る範囲」を役割分担することで、テストはロジックの振る舞いに集中できます。

### singleton 変数警告の例

たとえば次のように、意図せず片方だけ変数名を書き間違えたとします。

```prolog
fizzbuzz(N, "Fizz") :- 0 is Number mod 3, !.
```

この節では `N` と `Number` がそれぞれ 1 回しか出現しないため、ロード時に singleton 変数警告が出力されます。

```text
Warning: .../fizzbuzz.pl:9:
	Singleton variables: [N,Number]
```

このように、変数名のタイプミスを実行前に検出できます。

### 未定義述語検出の例

定義していない述語を呼び出すと、ロード時（または実行時）に未定義述語として報告されます。

```text
Warning: .../fizzbuzz.pl:12:
	Unknown procedure: format_string/2
```

### make lint によるロード検査

これらのロード時検査を CI で自動化するのが `apps/prolog/Makefile` の `lint` ターゲットです。実ファイルは次のようになっています。

```makefile
# 構文・特異点（singleton 変数など）を検査する
lint:
	@for f in src/*.pl; do \
		swipl -q -g "halt(0)" -t "halt(1)" "$$f" || exit 1; \
	done
	@echo "lint: OK"
```

`swipl -q -g "halt(0)" -t "halt(1)" "$$f"` は、`src/` 配下の各 `.pl` ファイルを SWI-Prolog にロードし、正常にロードできれば `halt(0)`（成功）で終了します。ロード中にエラーが発生した場合は初期化目標が失敗し `-t "halt(1)"` によって `halt(1)`（失敗）で終了するため、シェルの `|| exit 1` で lint 全体が失敗します。

各オプションの意味は次のとおりです。

| オプション | 説明 |
|------|------|
| `-q` | 起動時のバナー表示を抑制する |
| `-g "halt(0)"` | ロード後に実行する初期化目標。成功時に終了コード 0 で終える |
| `-t "halt(1)"` | トップレベル（初期化目標が失敗した場合）の目標。終了コード 1 で終える |

実行例は次のとおりです。

```bash
$ make lint
lint: OK
```

構文エラーや未定義述語があるファイルはロードに失敗し、`make lint` が非ゼロで終了するため、CI で品質ゲートとして機能します。

## 5.4 コードカバレッジ

SWI-Prolog では、テストフレームワーク plunit と連携する `library(test_cover)` によってカバレッジを計測できます。Kotlin の Kover、Ruby の SimpleCov に相当する概念です。

```prolog
:- use_module(library(test_cover)).
```

テスト実行時に `show_coverage/1` を用いると、どの節が実行されたかのカバレッジ情報が表示されます。

```prolog
?- show_coverage(run_tests).
```

本プロジェクトではカバレッジ計測は必須ではありませんが、TDD で開発を進める限り、実装は常にテストによって駆動されるため、**テストファーストで書くことで自然に高いカバレッジが保たれる** のが利点です。

## 5.5 他言語との比較

| 用途 | Prolog | Kotlin | Ruby | TypeScript |
|------|--------|--------|------|-----------|
| パッケージ管理 | pack | Gradle | Bundler | npm |
| テスト | plunit | kotlin.test (JUnit Platform) | Minitest | Vitest |
| 静的解析 | ロード時検査（singleton / 未定義述語） | detekt | RuboCop | ESLint |
| フォーマッタ | （portray_clause など） | ktlint | RuboCop | Prettier |
| カバレッジ | test_cover (show_coverage) | Kover / JaCoCo | SimpleCov | @vitest/coverage-v8 |
| 型検査 | なし（動的型） | コンパイラ標準 | なし（動的型） | コンパイラ（tsc） |

Kotlin がコンパイラによる型・null 検査を標準で持つのに対し、Prolog は型検査を持たない代わりに、ロード時の singleton 変数警告・未定義述語検出という形で明白な誤りを検出します。これを `make lint` で自動化することで、動的型付け言語でも一定の静的検査を CI に組み込めます。

## 5.6 まとめ

この章では以下を学びました。

- SWI-Prolog の `pack` システム（`pack_install/1`、`pack_list_installed/0`）と、`use_module` による標準ライブラリ（`library(lists)` の `numlist`/`maplist` など）の読み込み
- Prolog のロード時検査（singleton 変数警告・未定義述語検出・構文チェック）による静的解析
- `apps/prolog/Makefile` の `lint` ターゲット（`swipl -q -g "halt(0)" -t "halt(1)" src/*.pl`）によるロード検査の CI 化
- `library(test_cover)` の `show_coverage/1` によるカバレッジ計測（概念）

次の章では、Makefile でこれらのタスクを集約し、Nix 開発環境と GitHub Actions による CI/CD パイプラインを構築します。
