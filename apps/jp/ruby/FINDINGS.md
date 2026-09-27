# Ruby 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | 内容 |
|------|------|
| 処理系 | ruby 3.3.10 (2025-10-23 revision 343ea05002) [x86_64-linux]（`nix develop .#ruby`） |
| テスト | Minitest 5.20.0（Ruby 同梱の bundled gem）、Rake 13.1.0 の `Rake::TestTask` |
| lint | RuboCop 1.80.2（Nix 環境のもの）、Prism 1.6.0 |
| `make test` | 20 runs, 26 assertions, 0 failures, 0 errors, 0 skips（題材 A: 7 件、B: 5 件、C: 2 件、D: 3 件、語順: 3 件） |
| `make lint` | `12 files inspected, no offenses detected`（`.rubocop.yml` の変更後。変更前の反応は 5 章） |

Gemfile は置かず、Ruby 同梱の Minitest・Rake と Nix 環境の RuboCop だけで動くようにしました（`apps/ruby/` の minitest-reporters・simplecov は使っていません）。

## 2. 日本語にできた名前・できなかった名前

### できた名前

| 種類 | 例 |
|------|----|
| メソッド名 | `タイプ生成`、`装飾`、`安全変換`、`FizzBuzz変換`（大文字始まりでも可） |
| 引数・ローカル変数 | `数`、`上限`、`番号`、`タイプ`、`結果`、`エラー` |
| Data のメンバー・キーワード引数 | `Data.define(:名前, :変換)`、`Ｔタイプ.new(名前: '通常', 変換: ...)` |
| 述語メソッド | `Data.define(:成功?, :値, :エラー)` で `結果.成功?` が定義される |
| ファイル名 | `lib/タイプ.rb` を `require 'タイプ'` で読める。`Rake::TestTask` の `FileList['test/**/*_test.rb']` も `test/タイプ_test.rb` を拾う |
| テストクラス名 | `class FizzBuzz変換テスト < Minitest::Test`（ASCII 大文字始まりなら可） |
| テスト名 | `def test_3を渡したらFizzを返す`、`it '3を FizzBuzz変換 すると Fizz を返す（後置呼び出し）'` |

### できなかった名前（言語仕様）

Ruby の定数（クラス名・モジュール名を含む）は **大文字始まり** でなければなりません。日本語の文字は大文字でも小文字でもないため、日本語始まりのクラス・モジュールは構文エラーになります。

```text
exp1.rb: exp1.rb:1: class/module name must be CONSTANT (SyntaxError)
class タイプ
      ^~~~~~~~~
```

```text
exp4_test.rb:17: class/module name must be CONSTANT (SyntaxError)
class 小文字始まり < Minitest::Test
      ^~~~~~~~~~~~~~~~~~
```

refinement 用のモジュール（`module 整数拡張`）も同じエラーです。`Object.const_set` で動的に作ることもできません。

```text
#<NameError: wrong constant name タイプ>
```

`定数 = 1` と書いたものは定数ではなくローカル変数になり、ほかのファイルからは参照できません。

### Minitest の `test "..."` は使えない

Rails（ActiveSupport）の `test '...' do` は Minitest 単体にはありません。書くと `Kernel#test`（ファイル検査の組み込み関数）が呼ばれ、次のエラーになります。

```text
t.rb:3:in `test': unknown command '3' (ArgumentError)
```

そのため、識別子としてのテスト名は `def test_...`（題材 A）、文章としてのテスト名は `Minitest::Spec` の `it '...'`（題材 B〜D と語順）を使いました。`it` のテストは内部で `test_0001_タイプ1は通常の変換をする` のような連番付きメソッドになり、`-v` の出力にもその名前が出ます。

## 3. 回避策とその代償

| なでしこ3 の名前 | Ruby の名前 | 回避策 |
|-----------------|------------|--------|
| `タイプ`（辞書） | `Ｔタイプ = Data.define(:名前, :変換)` | 全角大文字 `Ｔ`（U+FF34）を前置。Ruby は全角大文字を大文字として扱うので定数になる |
| `変換結果` | `Ｒ変換結果 = Data.define(:成功?, :値, :エラー)` | 同上（`Ｒ`） |
| ファイル単位のまとまり | `module FizzBuzz基本`、`FizzBuzzタイプ`、`FizzBuzzパイプライン`、`FizzBuzz安全変換`、`FizzBuzz語順` | ASCII の `FizzBuzz` で始めて定数にする |
| `FizzBuzz変換` などの関数 | `module_function` でモジュールに定義し、テストで `include` | そのまま |

- 代償 1: `Ｔ` と `T` は見た目がほぼ同じで、入力しにくく検索もしにくくなります。
- 代償 2: RuboCop の既定パーサー（parser gem）は `Ｔタイプ` を定数と認識せず、ローカル変数への代入とみなします（5 章）。
- 代償 3: `LANG=C` で `p` すると、`#<data Ｔタイプ 名前="通常", ...>` のようにエスケープ表示になります。Makefile で `LANG=C.UTF-8` を export しています。
- 大文字始まりのメソッド `FizzBuzz変換` は、括弧か引数を付ければメソッド呼び出しになります（`FizzBuzz変換 3` も `"3"` を返すことを確認）。引数のないメソッドは定数参照と区別するため、`3.FizzBuzz変換` のようにレシーバー付きで呼びます。
- 題材 B の「存在しないタイプ」は `ArgumentError` で表しました。例外クラスを日本語にするなら `Ｅ該当なし` のような前置が必要です。

## 4. 語順の再現

`Integer` と `String` を **refinement** で開き、`using FizzBuzz語順` したファイルの中だけで後置呼び出しを使えるようにしました。モンキーパッチと違い、影響範囲は `using` したファイルに限られます。

```ruby
module FizzBuzz語順
  refine Integer do
    def を = self # 助詞「を」に相当する、何もしないメソッド
    def FizzBuzz変換 = FizzBuzz基本.FizzBuzz変換(self)
  end

  refine String do
    def 装飾 = FizzBuzzパイプライン.装飾(self)
  end
end
```

```ruby
using FizzBuzz語順

_(3.FizzBuzz変換).must_equal 'Fizz'            # 3を FizzBuzz変換
_(3.を.FizzBuzz変換).must_equal 'Fizz'         # 助詞「を」を独立した語として置く
_(15.FizzBuzz変換.装飾).must_equal '[FizzBuzz]' # FizzBuzz変換して 装飾する
```

題材 C の「FizzBuzz変換して装飾して」は `Method#>>`（関数合成）で左から右へ書きました。

```ruby
def FizzBuzz装飾(数)
  (FizzBuzz基本.method(:FizzBuzz変換) >> method(:装飾)).call(数)
end
```

## 5. lint・formatter の反応

### `apps/ruby/.rubocop.yml` をそのまま使った場合

`apps/ruby/` の設定は `Naming/MethodName` を無効にし、`Naming/AsciiIdentifiers` を `test/` だけ除外しています。これをそのまま適用すると 143 件の指摘になりました。

```text
71   Naming/AsciiIdentifiers
52   Naming/VariableName
10   Naming/FileName
8    Naming/MethodParameterName
2    Lint/UselessAssignment [Safe Correctable]
--
143  Total in 10 files
```

代表的なメッセージの原文です。

```text
lib/FizzBuzz変換.rb:4:16: C: Naming/AsciiIdentifiers: Use only ascii symbols in constants.
lib/FizzBuzz変換.rb:7:18: C: Naming/VariableName: Use snake_case for variable names.
lib/FizzBuzz変換.rb:7:18: C: Naming/MethodParameterName: Method parameter must be at least 3 characters long.
lib/タイプ.rb:1:1: C: Naming/FileName: The name of this source file (タイプ.rb) should use snake_case.
test/タイプ_test.rb:10:5: C: Naming/VariableName: Use snake_case for variable names.
```

- `Naming/MethodParameterName` は文字数で判定するため、`数`（1 文字）が「3 文字以上」に引っかかります。
- 設定なしで試すと、`def test_3を渡したらFizzを返す` は `Naming/MethodName: Use snake_case for method names.` にもなります（`Fizz` の大文字のため）。

### 既定パーサーが全角大文字の定数を誤認する

最も重大な反応は `Lint/UselessAssignment` です。既定のパーサー（parser gem）は `Ｔタイプ` をローカル変数とみなし、「使われていない代入」として **自動修正可能**（Safe Correctable）と報告します。

```text
lib/タイプ.rb:6:1: W: [Correctable] Lint/UselessAssignment: Useless assignment to variable - Ｔタイプ.
Ｔタイプ = Data.define(:名前, :変換)
^^^^^^^^
```

スクラッチパッドのコピーで `rubocop -A --only Lint/UselessAssignment` を実行すると、`Ｔタイプ =` と `Ｒ変換結果 =` が削除され、テストが壊れました。

```diff
-Ｔタイプ = Data.define(:名前, :変換)
+Data.define(:名前, :変換)
```

```text
NameError: uninitialized constant FizzBuzz安全変換::Ｒ変換結果
```

`AllCops: ParserEngine: parser_prism` を指定すると、Ruby 本体と同じ Prism で解析されるため、`Ｔタイプ` を定数と正しく認識し、`Lint/UselessAssignment` は出なくなりました。

### 採用した設定

`apps/jp/ruby/.rubocop.yml` は `apps/ruby/` の設定に次を加えたもので、`no offenses detected` になります。

```yaml
AllCops:
  ParserEngine: parser_prism   # 全角大文字の定数を正しく扱う
Naming/AsciiIdentifiers:
  Enabled: false
Naming/VariableName:
  Enabled: false
Naming/FileName:
  Enabled: false
Naming/MethodParameterName:
  MinNameLength: 1
```

日本語のコメントに反応する cop はありませんでした。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 2 | 言語上の制約はないが、RuboCop が `Naming/AsciiIdentifiers`・`Naming/VariableName` などで警告する（設定で抑止できる） |
| 型・モジュール名 | 1 | クラス・モジュール・定数は日本語始まり不可（`class/module name must be CONSTANT`）で、すべて `Ｔ` や `FizzBuzz` の前置が必要。ファイル名・Data のメンバーは日本語可 |
| テスト名 | 3 | `Minitest::Spec` の `it '3を FizzBuzz変換 すると Fizz を返す（後置呼び出し）'` のように空白・記号込みの文章で書ける |
| 語順の再現 | 3 | refinement で `3.を.FizzBuzz変換`、`15.FizzBuzz変換.装飾` と、助詞に当たる語を置いた SOV 順で書ける |
| ツール許容 | 2 | RuboCop の警告は設定で抑止できる。ただし既定パーサーでは全角大文字の定数定義を自動修正で消すため、`ParserEngine: parser_prism` が必須 |
| **合計** | **11** | |
