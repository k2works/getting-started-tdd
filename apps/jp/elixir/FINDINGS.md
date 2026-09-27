# Elixir の日本語実装 検証記録

## 実行環境と結果

| 項目 | バージョン（実行結果から記録） |
|------|------|
| Elixir / Mix / ExUnit | 1.18.4（`Elixir 1.18.4 (compiled with Erlang/OTP 27)`） |
| Erlang ランタイム | 28（Nix 環境の shellHook の出力） |
| Credo | 1.7.16（git タグ `v1.7.16`） |

`make test`（`mix test --trace`）は `21 tests, 0 failures` です。`make check`（format・Credo・テスト）もすべて通りました。

> **Note**: 検証環境から repo.hex.pm・builds.hex.pm に接続できなかったため（`Could not install Hex because Mix could not download metadata at https://builds.hex.pm/installs/hex.csv.`）、Hex を `mix archive.install github hexpm/hex tag v2.2.1` で入れ、Credo と依存（bunt・file_system・jason）は `mix.exs` で GitHub の git 依存（`override: true`）にしています。日本語とは無関係の事情です。

## ロケールの影響

UTF-8 のロケールがないと、VM は次の警告を出します。

```text
warning: the VM is running with native name encoding of latin1 which may cause Elixir to malfunction as it expects utf8. Please ensure your locale is set to UTF-8 (which can be verified by running "locale" in your shell) or set the ELIXIR_ERL_OPTIONS="+fnu" environment variable
```

この状態では、日本語のファイル名が原因でコンパイルが `** (MatchError) no match of right hand side value: {:error, :enoent}`（`lib/タイプ.ex`）で失敗し、Credo も同じ理由で落ちます。Makefile で `LANG`・`LC_ALL=C.UTF-8` と `ELIXIR_ERL_OPTIONS=+fnu` を export しています。

## 日本語にできた名前・できなかった名前

### できたもの

- ひらがな・カタカナ・漢字だけの関数名・変数名（`タイプ生成`・`装飾`・`パイプライン処理`・`安全変換`・`数`・`上限`）。`変換?` のように末尾に `?` も付けられる
- アトム（`:成功`・`:失敗`）、構造体のキー（`名前`・`変換`）、`@type 変換結果 :: {:成功, String.t()} | {:失敗, String.t()}`
- ファイル名（`lib/タイプ.ex`・`test/タイプ_test.exs`）
- テスト名・describe 名（`test "3を渡したらFizzを返す"`）

### できなかったもの

**1. ラテン文字と日本語が混ざる識別子**

`FizzBuzz変換` と `fizzbuzz変換` はどちらも拒否されます（アトム `:FizzBuzz変換` も同じ）。

```text
error: invalid mixed-script identifier found: FizzBuzz変換

Mixed-script identifiers are not supported for security reasons. 'FizzBuzz変換' is made of the following scripts:
  F F {Latin}
  ...
  変 変 {Han,Han with Bopomofo,Japanese,Korean}
  換 換 {Han,Han with Bopomofo,Japanese,Korean}

Characters in identifiers from different scripts must be separated by underscore (_).
```

`fizz_buzz変換` も同じエラーです。文字種の境界に `_` を置いた `fizzbuzz_変換` は通ります。大文字始まりの関数名は、日本語以前に Elixir では定義できません。

**2. モジュール名（エイリアス）**

```text
# defmodule FizzBuzz_日本語
error: invalid character "日" (code point U+65E5) in alias (only ASCII characters, without punctuation, are allowed): FizzBuzz_日本語
# defmodule タイプ
** (ArgumentError) invalid module name: {:タイプ, [line: 1, column: 11], nil}
# alias Exp7, as: 実験
error: undefined variable "実験"
# defmodule Ｔａｉｐｕ（全角英字）
error: unexpected token: "Ｔ" (column 11, code point U+FF34)
```

## 回避策とその代償

- 関数名は `fizzbuzz_変換`・`fizzbuzz_配列作成`・`fizzbuzz_装飾`。なでしこ3 の `FizzBuzz変換` とは表記が変わる
- 題材ごとのモジュールは ASCII のエイリアス（`FizzBuzz`・`FizzBuzz.Type`・`FizzBuzz.Pipeline`・`FizzBuzz.Safe`）
- 型に当たる構造体と例外は、**アトムをそのままモジュール名にする**（Erlang 流の書き方）ことで日本語にした。代償として、エイリアスで短く書けず、Elixir の慣習から外れる

  ```elixir
  defmodule :タイプ do
    @enforce_keys [:名前, :変換]
    defstruct [:名前, :変換]
  end

  defmodule :タイプ未定義エラー do
    defexception [:message]
  end

  def タイプ生成(1), do: %:タイプ{名前: "通常", 変換: &fizzbuzz_変換/1}
  ```

- 題材 D は動的型付けなので 3 件ともテストした（`安全変換("a") == {:失敗, "数値を指定してください: a"}`）

## 語順の再現

```elixir
def fizzbuzz_装飾(数) do
  数
  |> fizzbuzz_変換()
  |> 装飾()
end
```

ユーザー定義の中置演算子は既定の記号の組み合わせでしか作れないため、助詞に当たる語は置けません。

## lint・formatter の反応

- `mix format --check-formatted` は日本語の名前に反応しない
- `mix credo --strict` は日本語を含む関数名 9 件をすべて指摘した

  ```text
  [R] ↗ Function/macro/guard names should be written in snake_case.
        lib/fizzbuzz.ex:14:7 #(FizzBuzz.fizzbuzz_変換)
  [R] ↗ Function/macro/guard names should be written in snake_case.
        lib/タイプ.ex:27:7 #(FizzBuzz.Type.タイプ生成)
  ...
  28 mods/funs, found 9 code readability issues.
  ```

  日本語の変数名、アトム名のモジュール、テスト名の文字列は指摘されない。`.credo.exs` で `Credo.Check.Readability.FunctionNames` だけを無効にして 0 件

## 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 2 | 日本語だけの名前は可。ラテン文字と混ぜると mixed-script で拒否され、`fizzbuzz_変換` のように `_` で区切る必要がある |
| 型・モジュール名 | 1 | エイリアスは ASCII のみ。構造体・例外はアトム名のモジュール（`:タイプ`）で日本語にできる |
| テスト名 | 3 | `test "3を渡したらFizzを返す"` と文字列で書ける |
| 語順の再現 | 2 | `数 \|> fizzbuzz_変換() \|> 装飾()` で SOV 順 |
| ツール許容 | 2 | Credo の FunctionNames に 9 件出るが設定で抑止できる。UTF-8 ロケールが必須 |
| **合計** | **10** | |
