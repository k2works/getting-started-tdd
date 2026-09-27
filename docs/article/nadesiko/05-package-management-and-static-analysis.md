# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

TDD を支える開発基盤として、依存関係の管理とコード品質の自動チェックは欠かせません。前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、なでしこ3 の実行系 `gonako` の導入とバージョン固定、**静的解析** としての文法チェック（`gonako lint`）、コード整形（`gonako format`）、そして表示結果を照合する受け入れテスト（`gonako doctest`）を整備します。

なでしこ3 には Python の uv や Ruby の Bundler のような、外部ライブラリの依存関係を解決するパッケージマネージャはありません。FizzBuzz に必要な命令（`文字列変換`、`配列追加`、`配列フィルタ` など）はすべて実行系に組み込まれた標準命令です。そのため、なでしこ3 版で「依存関係の管理」として固定すべきものは、**実行系 `gonako` そのもののバージョン** になります。

## 5.2 gonako の導入とバージョン固定

### なでしこ3 の実行系

なでしこ3 にはいくつかの実装があります。本書では Go 言語で実装された nadesiko3go の CLI 版 `gonako` を使います。ブラウザや Electron を必要とせず、ターミナルから `.nako3` ファイルを実行でき、`lint`・`format`・`doctest` といった開発用のサブコマンドを備えているからです。

```bash
$ gonako version
gonako v3.8.8 (linux/amd64)
```

サブコマンドの一覧は `gonako --help` で確認できます。本書で使うのは次の 5 つです。

| サブコマンド | 用途 | 本書での使いどころ |
|------|------|------|
| `gonako run <ファイル>` | プログラムを実行する | テスト・`main.nako3` の実行 |
| `gonako lint <ファイル>` | 文法をチェックする | 静的解析（`make lint`） |
| `gonako format <ファイル> [-f]` | コードを整形する | `make format` / `make format-check` |
| `gonako doctest [パス...]` | 表示結果の例を実行して確かめる | 受け入れテスト（`make doctest`） |
| `gonako doc <キーワード>` | 命令やマニュアルを検索する | 標準命令の書式の確認 |

### 標準命令と取り込み

パッケージマネージャがない代わりに、なでしこ3 は豊富な標準命令を持っています。命令の書式（どの助詞で引数を受け取るか）は `gonako doc` で確認できます。

```bash
$ gonako doc 配列フィルタ --limit 3
『配列フィルタ』に一致する命令: 1件

■ 配列フィルタ (plugin_system / 配列操作)
  書式: 【A】で【B】を配列フィルタ
  読み: はいれつふぃるた
  説明: 引数を1つ持ち真偽を返す関数Fを利用して、配列Aの要素をフィルタして、新しい配列として返す。
  マニュアル: https://nadesi.com/v3/doc/index.php?gonako%2F%E9%85%8D%E5%88%97%E3%83%95%E3%82%A3%E3%83%AB%E3%82%BF
  ソース: internal/stdlib/array.go:256
```

`書式: 【A】で【B】を配列フィルタ` のように、なでしこ3 の命令は **助詞で引数の役割を決める** ため、書式を確認することは他言語で関数シグネチャを確認することに相当します。

プロジェクト内のファイル同士の依存は、`取り込む` で表します。

```nako3
!「./helper.nako3」を取り込む
!「../src/fizzbuzz.nako3」を取り込む
```

パスは取り込む側のファイルの位置からの相対パスです。取り込んだ関数は内部的に `ファイル名__関数名` の名前空間で修飾されます。後述する lint のエラーメッセージに `lint_ng__FizzBuzz変換` のような名前が出てくるのはこのためです。

### Nix による gonako のバージョン固定

`gonako` は Nix の開発環境（`ops/nix/environments/nadesiko/shell.nix`）で導入します。実ファイルは次の通りです。

```nix
{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  # なでしこ3 の Go 実装（nadesiko3go）の CLI 版 gonako を 3.8.8 タグのコミットで固定して導入する。
  gonakoVersion = "3.8.8";
  gonakoCommit = "f840295acd3d1a81b4e846a0bd33dda1877af9da";
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    go
    gnumake
  ]);
  shellHook = ''
    ${baseShell.shellHook}

    export GONAKO_VERSION="${gonakoVersion}"
    export GOBIN="$(pwd)/apps/nadesiko/bin"
    export PATH="$GOBIN:$PATH"
    # nadesiko3go の go.mod は Go 1.26 以上を要求するため、必要なら新しいツールチェーンを自動取得する。
    export GOTOOLCHAIN=auto

    # gonako が未導入なら固定コミットからビルドする（bin/ は .gitignore 対象）。
    # GUI 版は gtk / webkit2gtk に依存するため、CLI 版（cmd/gonako）のみを導入する。
    if [ ! -x "$GOBIN/gonako" ] && [ -d "$(pwd)/apps/nadesiko" ]; then
      echo "Installing gonako ${gonakoVersion} ..."
      go install "github.com/kujirahand/nadesiko3go/cmd/gonako@${gonakoCommit}" \
        || echo "  (gonako の導入に失敗しました。ネットワークを確認してください)"
    fi

    echo "Nadesiko3 development environment activated"
    echo "  - Go: $(go version)"
    if [ -x "$GOBIN/gonako" ]; then
      echo "  - gonako: $(gonako version)"
    fi
    echo "  使い方: cd apps/nadesiko && make test   （= test/*_test.nako3 を gonako で順に実行）"
  '';
}
```

ポイントは次の 4 つです。

- **`go install ...@固定コミット`** -- Nix では Go と make だけを用意し、`gonako` は `go install` で nadesiko3go のソースからビルドします。バージョン指定に `@latest` やブランチ名ではなく 3.8.8 タグのコミットハッシュ（`f840295...`）を使うことで、いつ誰が環境を作っても同じ `gonako` になります。これが他言語のロックファイル（`uv.lock` や `Gemfile.lock`）に相当する役割を果たします。
- **`GOBIN=apps/nadesiko/bin`** -- ビルドした `gonako` をリポジトリ内の `bin/` に置き、`PATH` の先頭に加えます。システムに別のバージョンの `gonako` が入っていても、プロジェクト内では固定版が優先されます。`bin/` は前章の `.gitignore` で除外しています。
- **`GOTOOLCHAIN=auto`** -- nixpkgs の `go` が nadesiko3go の `go.mod` が要求するバージョンより古い場合でも、Go が必要なツールチェーンを自動で取得してビルドします。
- **GUI 版を除く** -- nadesiko3go には GUI 版もありますが、gtk / webkit2gtk に依存するため、CLI 版（`cmd/gonako`）だけを導入します。テストと CI に必要なのはターミナルで動く実行系だけなので、依存を最小限に保てます。

環境には次のコマンドで入ります。初回だけ `gonako` のビルドが走り、2 回目以降は `bin/gonako` をそのまま使います。

```bash
$ nix develop .#nadesiko
```

## 5.3 静的解析（gonako lint）

なでしこ3 は動的型付けの言語で、変数の型は実行時に決まります。型検査の仕組みはありませんが、`gonako lint` で **実行せずに文法をチェック** できます。

なでしこ3 は日本語の語順と助詞で文を組み立てるため、他の言語よりも「文として解釈できない」誤りが起きやすい言語です。

- `ここまで` の書き忘れなど、ブロックの対応の誤り
- 識別子にひらがなの助詞を含めたことによる語の分割
- 関数名の書き間違い（未定義の単語）

これらはテストを実行する前に lint で排除できます。

### ブロックの閉じ忘れ

関数定義の最後の `ここまで` を書き忘れた例です。

```nako3
●(Nを)FizzBuzz変換
    もし、N % 15 = 0ならば,「FizzBuzz」を戻す
    Nを文字列変換して戻す
```

```bash
$ gonako lint lint_ng.nako3
[文法エラー]lint_ng.nako3(1行目): 関数『lint_ng__FizzBuzz変換』の定義で以下のエラーがありました。
[文法エラー]lint_ng.nako3(1行目): 『ここまで』がありません。関数定義の末尾に必要です。『』の前に『ここまで』を記述してください。
$ echo $?
1
```

### 助詞を含む識別子

第 1 部でも触れたように、識別子にひらがなの助詞を含めると、なでしこ3 はそこで語を区切ってしまいます。

```nako3
●(Nを)数字のみ変換
    Nを文字列変換して戻す
ここまで
```

```bash
$ gonako lint lint_ng2.nako3
[文法エラー]lint_ng2.nako3(1行目): 関数『lint_ng2__数字』の定義で以下のエラーがありました。
[文法エラー]lint_ng2.nako3(1行目): 不完全な文です。単語『み変換』が解決していません。
```

関数名が `数字` と `の` と `み変換` に分割されていることがエラーメッセージからわかります。本書の実装では `数字限定変換` のように助詞を含まない名前に改めています。

### 未定義の単語

関数名を書き間違えて呼び出した例です（`FizzBuzz変換` の `z` が 1 つ足りません）。

```nako3
3をFizzBuz変換して表示
```

```bash
$ gonako lint lint_undef.nako3
[文法エラー]lint_undef.nako3(1行目): 未解決の単語があります: [単語『lint_undef__FizzBuz変換』して]
次の命令の可能性があります:
 - A(を|と)表示

```

なでしこ3 では関数呼び出しも「単語」として文法の段階で解決されるため、存在しない関数の呼び出しは実行前に検出されます。Prolog の未定義述語検出や、Python の Ruff が報告する未定義名（F821）に相当するチェックです。

### make lint

これらを CI で自動化するのが `apps/nadesiko/Makefile` の `lint` ターゲットです。

```makefile
GONAKO ?= gonako
SOURCES := $(wildcard src/*.nako3) $(wildcard test/*.nako3)
```

```makefile
# 文法エラーがないかを検査する
lint:
	@for f in $(SOURCES); do \
		$(GONAKO) lint "$$f" > /dev/null || exit 1; \
	done
	@echo "lint: OK"
```

`src/` と `test/` のすべての `.nako3` に `gonako lint` をかけます。成功時の `ファイル名: 文法エラーはありません` という表示は `> /dev/null` で捨て、エラーメッセージ（標準エラー出力）だけを見せます。1 つでも文法エラーがあれば `|| exit 1` で `make` 全体が失敗します。

```bash
$ make lint
lint: OK
```

文法エラーのあるファイルを `src/` に置いて実行すると、次のように失敗します。

```bash
$ make lint
[文法エラー]src/broken.nako3(1行目): 関数『broken__FizzBuzz変換』の定義で以下のエラーがありました。
[文法エラー]src/broken.nako3(1行目): 『ここまで』がありません。関数定義の末尾に必要です。『』の前に『ここまで』を記述してください。
make: *** [Makefile:20: lint] Error 1
```

## 5.4 コード整形（gonako format）

`gonako format` は、なでしこ3 のコードを決まった形に整形するフォーマッタです。Python の Ruff formatter や Go の gofmt に相当します。主な整形規則は次の通りです。

| 整形前 | 整形後 | 規則 |
|------|------|------|
| `N%15=0` | `N % 15 = 0` | 演算子の前後に空白を入れる |
| 2 スペースのインデント | 4 スペースのインデント | インデントを 4 スペースにそろえる |
| `N*2` | `N × 2` | `*` を `×` に置き換える |
| `N<=0` | `N ≦ 0` | `<=` を `≦` に置き換える |
| `3!=5` | `3 ≠ 5` | `!=` を `≠` に置き換える |
| `ならば、「Fizz」を戻す` | `ならば,「Fizz」を戻す` | 1 行の `もし` の `ならば` 直後の `、` を `,` にする |

次のコードを整形してみます。

```nako3
●(Nを)FizzBuzz変換
  もし、N<=0ならば、「範囲外」を戻す
  もし、N%15=0ならば、「FizzBuzz」を戻す
  もし、N%3=0ならば、「Fizz」を戻す
  Nを文字列変換して戻す
ここまで

●(Nを)二倍計算
  N*2を戻す
ここまで

もし、3!=5ならば、「違う」を表示
```

`gonako format` はファイルを書き換えず、整形結果を標準出力に表示します。

```bash
$ gonako format fmt_ng.nako3
●(Nを)FizzBuzz変換
    もし、N ≦ 0ならば,「範囲外」を戻す
    もし、N % 15 = 0ならば,「FizzBuzz」を戻す
    もし、N % 3 = 0ならば,「Fizz」を戻す
    Nを文字列変換して戻す
ここまで

●(Nを)二倍計算
    N × 2を戻す
ここまで

もし、3 ≠ 5ならば,「違う」を表示
```

`×`・`≦`・`≠` はなでしこ3 の正式な演算子なので、整形後のコードも整形前と同じように実行できます。本書に掲載するコードはすべてこの整形済みの形です。`-f`（`--force`）を付けるとファイルに書き戻します。

### make format と make format-check

Makefile には、整形して書き戻す `format` と、整形が必要なファイルがないかを検査する `format-check` を用意します。

```makefile
# gonako format の整形結果と差分がないかを検査する
format-check:
	@for f in $(SOURCES); do \
		$(GONAKO) format "$$f" | diff -u "$$f" - || { echo "要整形: $$f（make format で修正）"; exit 1; }; \
	done
	@echo "format: OK"

# ソースを整形して書き戻す
format:
	@for f in $(SOURCES); do $(GONAKO) format -f "$$f" > /dev/null; done
```

`format-check` は `gonako format` の出力と元のファイルを `diff -u` で比べ、差分があれば失敗します。上のコードを `src/fizzbuzz.nako3` として置いた場合の実行結果は次の通りです（タイムスタンプの行は省略しています）。

```bash
$ make format-check
--- src/fizzbuzz.nako3
+++ -
@@ -1,12 +1,12 @@
 ●(Nを)FizzBuzz変換
-  もし、N<=0ならば、「範囲外」を戻す
-  もし、N%15=0ならば、「FizzBuzz」を戻す
-  もし、N%3=0ならば、「Fizz」を戻す
-  Nを文字列変換して戻す
+    もし、N ≦ 0ならば,「範囲外」を戻す
+    もし、N % 15 = 0ならば,「FizzBuzz」を戻す
+    もし、N % 3 = 0ならば,「Fizz」を戻す
+    Nを文字列変換して戻す
 ここまで
 
 ●(Nを)二倍計算
-  N*2を戻す
+    N × 2を戻す
 ここまで
 
-もし、3!=5ならば、「違う」を表示
+もし、3 ≠ 5ならば,「違う」を表示
要整形: src/fizzbuzz.nako3（make format で修正）
make: *** [Makefile:27: format-check] Error 1
```

`make format` で書き戻せば、`format-check` は成功します。

```bash
$ make format
$ make format-check
format: OK
```

CI では書き戻しをせず `format-check` だけを実行します。整形は開発者の手元で行い、その結果を前章の `style` コミットとして記録するという役割分担です。

## 5.5 受け入れテスト（gonako doctest）

`make test` のユニットテストは関数の戻り値を検証します。これに加えて、**プログラムを実行したときに画面に何が表示されるか** を確かめる受け入れテストとして `gonako doctest` を使います。

`gonako doctest` は、テキストファイルの中の `{{{#nako3` から `}}}` までのコードを実行し、`### 表示結果:` 以降に書かれた期待値と表示を 1 行ずつ照合します。`apps/nadesiko/doctest/fizzbuzz.txt` は次の通りです。

```text
FizzBuzz の受け入れテスト（gonako doctest で表示結果を照合する）

{{{#nako3
!「../src/list.nako3」を取り込む
リスト = (1からタイプ生成)で15までFizzBuzzリスト作成
文字列でリストの文字列一覧取得を反復
    文字列を表示
ここまで
### 表示結果: 1
### 2
### Fizz
### 4
### Buzz
### Fizz
### 7
### 8
### Fizz
### Buzz
### 11
### Fizz
### 13
### 14
### FizzBuzz
}}}
```

ここで使っている `タイプ生成` や `FizzBuzzリスト作成` は第 3 部以降で作る関数です。受け入れテストは「1 から 15 までを表示すると FizzBuzz の並びになる」という利用者から見た振る舞いだけを固定するので、内部の設計を第 3 部で作り替えても同じ doctest がそのまま使えます。

```bash
$ make doctest
gonako doctest doctest
[DocTest] 1件のサンプルコードを実行します。
[DocTest] 1件成功・0件省略・失敗なし。
```

期待値を 1 か所だけ `### Fizz Buzz` に書き換えて失敗させると、どの行が違うのかが表示されます。

```bash
$ make doctest
gonako doctest doctest
[DocTest] 1件のサンプルコードを実行します。
[DocTest失敗] doctest/fizzbuzz.txt:3 の表示結果が期待と異なります。
--- 実行したコード ---
  !「../src/list.nako3」を取り込む
  リスト = (1からタイプ生成)で15までFizzBuzzリスト作成
  文字列でリストの文字列一覧取得を反復
      文字列を表示
  ここまで
--- 期待した表示結果 ---
  1
  ...
  14
  Fizz Buzz
--- 実際の表示結果 ---
  1
  ...
  14
  FizzBuzz
--- 違いのある行 ---
  15行目: 期待="Fizz Buzz" / 実際="FizzBuzz"
マニュアルの「### 表示結果:」の記述か、サンプルコードのどちらかを修正してください。

[DocTest] 0/1件成功 (0.0%)
  表示結果が違う: 1件
DocTestが1件失敗しました
make: *** [Makefile:38: doctest] Error 1
```

（期待した表示結果と実際の表示結果の 2〜13 行目は同じなので `...` で省略しています。）

## 5.6 コードカバレッジ

`gonako` v3.8.8 のサブコマンドには、カバレッジを計測する機能はありません。本書ではカバレッジを計測しませんが、TDD で開発を進める限り、実装は常にテストによって駆動されるため、**テストファーストで書くことで自然に高いカバレッジが保たれる** という点は他の言語と同じです。加えて、doctest でエントリポイントに近い経路を通しておくことで、ユニットテストの隙間を補います。

## 5.7 他言語との比較

| 用途 | なでしこ3 | Python | Prolog |
|------|--------|--------|--------|
| パッケージ管理 | なし（標準命令と `取り込む`。実行系を Nix + `go install @コミット` で固定） | uv | pack |
| テスト | `検証`（test/helper.nako3 と `ASSERT等`） | pytest | plunit |
| 静的解析 | `gonako lint`（文法・未定義の単語） | Ruff | ロード時検査（singleton / 未定義述語） |
| フォーマッタ | `gonako format` | Ruff formatter | （portray_clause など） |
| 受け入れテスト | `gonako doctest` | （doctest モジュール） | なし |
| カバレッジ | なし | pytest-cov | test_cover |
| 型検査 | なし（動的型） | mypy | なし（動的型） |

型検査を持たない点は Prolog と同じですが、なでしこ3 は日本語の語順と助詞で文を組み立てるため、**文法チェックが捕まえる誤りの範囲が広い** のが特徴です。関数名の書き間違いも、助詞を含む識別子の分割も、実行前に lint で検出できます。

## 5.8 まとめ

この章では以下を学びました。

- なでしこ3 にはパッケージマネージャがなく、標準命令と `取り込む` で開発する。固定すべき依存は実行系 `gonako` そのもの
- Nix の `shell.nix` で Go を用意し、`go install ...@固定コミット` で `gonako` v3.8.8 を `apps/nadesiko/bin` に導入する。`GOTOOLCHAIN=auto` で Go のバージョン差を吸収し、GUI 版は依存が重いため除く
- `gonako lint` による文法チェック（ブロックの閉じ忘れ・助詞を含む識別子・未定義の単語）と `make lint`
- `gonako format` による整形（演算子の空白、4 スペースインデント、`×`・`≦`・`≠`、`ならば,`）と `make format` / `make format-check`
- `gonako doctest` による表示結果の受け入れテストと `make doctest`

次の章では、Makefile でこれらのタスクを集約し、test runner の仕組みと GitHub Actions による CI/CD パイプラインを構築します。

### 実装

<details>
<summary>実装コード（apps/nadesiko/doctest/fizzbuzz.txt）</summary>

```text
FizzBuzz の受け入れテスト（gonako doctest で表示結果を照合する）

{{{#nako3
!「../src/list.nako3」を取り込む
リスト = (1からタイプ生成)で15までFizzBuzzリスト作成
文字列でリストの文字列一覧取得を反復
    文字列を表示
ここまで
### 表示結果: 1
### 2
### Fizz
### 4
### Buzz
### Fizz
### 7
### 8
### Fizz
### Buzz
### 11
### Fizz
### 13
### 14
### FizzBuzz
}}}
```

</details>
