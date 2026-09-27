# Rust の日本語実装 検証記録

## 実行環境と結果

| 項目 | バージョン（実行時の出力） |
|------|------------------------|
| rustc | rustc 1.91.1 (ed61e7d7e 2025-11-07) |
| cargo | cargo 1.91.0 (ea2d97820 2025-10-10) |
| Clippy | clippy 0.1.91 |
| rustfmt | rustfmt 1.8.0 |
| テスト | 標準の `#[test]`（`cargo test`） |

`make test` は 19 件成功、0 件失敗です。統合テストは 4 ファイルで、FizzBuzz変換のテスト 9 件（語順 2 件を含む）、タイプ生成のテスト 5 件、パイプラインのテスト 3 件、安全変換のテスト 2 件です。統合テストのファイル名が日本語でも、テストクレート名としてそのまま表示されます。

```text
     Running tests/FizzBuzz変換のテスト.rs (target/debug/deps/FizzBuzz変換のテスト-...)
test _3を渡したらFizzを返す ... ok
test 語順_3をFizzBuzz変換するとFizzになる ... ok
```

## 日本語にできた名前・できなかった名前

### できた名前

- 関数・引数・ローカル変数: `FizzBuzz変換(数: i64)`・`装飾(文字列)`・`タイプ生成(番号)`
- 構造体とフィールド: `struct タイプ { 種別, 変換 }`
- 列挙型と列挙子: `enum 種別 { 通常, 数字限定, FizzBuzz限定 }`（警告なし）
- トレイト `数の変換`、型エイリアス `type 変換結果 = Result<String, String>`
- `Result` の列挙子の別名: `pub use std::result::Result::{Err as 失敗, Ok as 成功};` で `成功(…)`・`失敗(…)` と書ける
- マクロ名 `macro_rules! なでしこ` とメタ変数 `$値`・`$関数`
- ファイル名: `src/基本変換.rs`・`tests/FizzBuzz変換のテスト.rs`
- `struct タイプ` に `non_camel_case_types`、非 ASCII の `const` に `non_upper_case_globals` の警告は出ない（大文字・小文字の区別がない文字のため）

### できなかった名前（エラー原文）

ファイルからモジュールを読み込む `mod 変換;` はエラーになります。

```text
error[E0754]: trying to load file for module `変換` with non-ascii identifier name
 --> src/lib.rs:1:5
  |
1 | mod 変換;
  |     ^^^^
  |
  = help: consider using the `#[path]` attribute to specify filesystem path
```

パッケージ名を `日本語` にすると `cargo build` は通りますが、統合テストから参照すると失敗します。

```text
error: crate name `日本語` passed to `--extern` is not a valid ASCII identifier
```

数字で始まるテスト名は書けません（全角数字も同様）。

```text
error: expected identifier, found `3を渡したらFizzを返す`
help: identifiers cannot start with a number

error: unknown start of token: \u{ff13}
```

ASCII 大文字を含む関数名は、エラーではなく警告になります。

```text
warning: function `FizzBuzz変換` should have a snake case name
 --> src/基本変換.rs:4:8
  |
4 | pub fn FizzBuzz変換(数: i64) -> String {
  |        ^^^^^^^^^^^^ help: convert the identifier to snake case: `fizz_buzz変換`
  |
  = note: `#[warn(non_snake_case)]` (part of `#[warn(nonstandard_style)]`) on by default
```

引数が `i64` のため `安全変換("a")` は `error[E0308]: mismatched types`（`expected `i64`, found `&str``）でコンパイルできず、「数値でなければ失敗になる」のテストは省略しました。

### Unicode 関連の lint

- `#![deny(non_ascii_idents)]` にすると `error: identifier contains non-ASCII characters`（既定は allow）
- 全角英字 `Ｎ` は `warning: identifier contains a non normalized (NFKC) character: 'Ｎ'`（`uncommon_codepoints`、既定は warn）
- `口` と `ロ`、`エ` と `工` を併用すると `warning: found both `口` and `ロ` as identifiers, which look alike`（`confusable_idents`）と、`mixed_script_confusables` の警告が出る
- 本実装で使った名前では、これらの警告は 0 件

## 採用した回避策とその代償

| 回避策 | 代償 |
|--------|------|
| `#[path = "基本変換.rs"] pub mod 基本変換;` | モジュールごとに属性が 1 行増える。ファイル名は日本語のまま |
| パッケージ名を ASCII の `fizzbuzz_jp` にする | `use fizzbuzz_jp::基本変換::…` の先頭だけ ASCII になる |
| `#![allow(non_snake_case)]`（lib.rs と各テストファイル） | 英大文字を含む名前の命名規則検査が全体で無効になる |
| 数字で始まるテスト名に `_` を付ける | 先頭に ASCII 記号が付く。空白や句読点は使えない |

## 語順の再現

`macro_rules!` の中では `を`・`して` を識別子トークンとして照合できます。

```rust
#[macro_export]
macro_rules! なでしこ {
    ($値:tt を $($関数:ident) して +) => {{
        let 値 = $値;
        $( let 値 = $関数(値); )+
        値
    }};
}

pub fn FizzBuzz装飾(数: i64) -> String {
    なでしこ!(数 を FizzBuzz変換 して 装飾)
}
```

値を `$値:expr` で受けると、`expr` の直後に置けるトークンが制限されているためエラーになります。そこで `tt` で受けています。

```text
error: `$値:expr` is followed by `を`, which is not allowed for `expr` fragments
  = note: allowed there are: `=>`, `,` or `;`
```

拡張トレイト（`impl 数の変換 for i64`）による後置呼び出し `3.FizzBuzz変換()` も書けます。

## lint・formatter の反応

- `cargo clippy --all-targets -- -D warnings`: 警告 0 件。Clippy 独自の日本語識別子に関する指摘はない
- 参考: `-W clippy::pedantic` では `doc_markdown`（`item in documentation is missing backticks`）が、`FizzBuzz変換` などを含むドキュメントコメントに 9 件出る
- `cargo fmt --check`: 差分なし。`#[path]` の日本語ファイルと `tests/` の日本語ファイルも整形対象になる

## 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 2 | すべて日本語で書けるが、英大文字を含む名前は `non_snake_case` 警告 |
| 型・モジュール名 | 2 | 型・列挙子は可。モジュールは `#[path]` が必要で、クレート名は ASCII 必須 |
| テスト名 | 2 | 識別子として書ける。数字始まりは `_` が必要で、空白は不可 |
| 語順の再現 | 3 | `なでしこ!(数 を FizzBuzz変換 して 装飾)` |
| ツール許容 | 2 | 通るが `allow(non_snake_case)` が必要 |
| **合計** | **11** | |
