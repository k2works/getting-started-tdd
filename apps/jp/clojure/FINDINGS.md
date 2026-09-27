# Clojure の日本語実装 検証記録

## 実行環境と結果

| 項目 | バージョン（実行時の出力） |
|------|------------------------|
| Clojure | 1.11.1（project.clj の依存） |
| Leiningen | Leiningen 2.11.2 on Java 21.0.9 OpenJDK 64-Bit Server VM |
| テスト | clojure.test（`lein test`） |
| lint・format | clojure-lsp 2025.11.28-12.47.43（clj-kondo 2025.10.24-SNAPSHOT と cljfmt を内蔵） |

`make test` は `Ran 6 tests containing 22 assertions. 0 failures, 0 errors.` です。仕様の 19 件のテスト名は、`deftest` の中の `testing` の文字列で表しています。

## 日本語にできた名前・できなかった名前

### できた名前

- 名前空間とファイル名: `(ns なでしこ.基本変換)` ↔ `src/なでしこ/基本変換.clj`。テスト側は `なでしこ.基本変換のテスト` で、`lein test` は名前空間名の末尾が `-test` でなくても検出する
- 関数・引数・`let` の名前: `FizzBuzz変換`・`[数]`・`(let [通常 (タイプ生成 1)] …)`
- キーワード: `:名前`・`:成功`・`:エラー`
- `defrecord タイプ [名前 変換]`（コンストラクタ `->タイプ`）、`defprotocol 変換できる (変換する …)`
- AOT コンパイルで `なでしこ/タイプ別/タイプ.class`・`なでしこ/タイプ別/変換できる.class` が生成される
- `deftest 存在しないタイプはエラーになる` のような日本語のシンボル。失敗時の出力にもそのまま出る（`FAIL in (FizzBuzz変換のテスト) (基本変換のテスト.clj:10)` / `3を渡したらFizzを返す`）

### できなかった名前（エラー原文）

数字で始まるシンボルは数値として読まれて失敗します（全角数字 `３` も同様）。

```text
Syntax error reading source at (なでしこ/数字_test.clj:3:23).
Invalid number: 3を渡したらFizzを返す
```

## 採用した回避策とその代償

| 回避策 | 代償 |
|--------|------|
| テスト名は `testing` の文字列で書き、`deftest` 名は `FizzBuzz変換のテスト` などにまとめる | テスト件数は `deftest` 単位（6 件）で数えられる |
| Makefile で `LANG`・`LC_ALL` を `C.UTF-8` に設定 | ロケール依存が残る（下記） |
| `.clj-kondo/config.edn` で `なでしこ` マクロ内の助詞を unresolved-symbol から除外 | 設定ファイルが 1 つ増える |
| `lein with-profile -base` と `.lsp/config.edn` の `:classpath-cmd` | 日本語とは無関係。Clojars に接続できない検証環境のための回避策 |

**ロケールが UTF-8 でないと、テストが 0 件のまま成功扱いになります。** LANG=C（`sun.jnu.encoding = ANSI_X3.4-1968`）で実行した結果です。

```text
lein test user

Ran 0 tests containing 0 assertions.
0 failures, 0 errors.
```

名前空間を明示すると、ファイル名が `?` に化けて見つからないというエラーになります。

```text
Could not locate ????????????/??????_??????_test__init.class, ????????????/??????_??????_test.clj or ????????????/??????_??????_test.cljc on classpath.
```

## 語順の再現

```clojure
(def ^:private 助詞 '#{を して に で})

(defmacro なでしこ [値 & 語]
  `(-> ~値 ~@(remove 助詞 語)))

(defn FizzBuzz装飾 [数]
  (なでしこ 数 を FizzBuzz変換 して 装飾))
```

標準のスレッディングマクロだけでも `(-> 3 FizzBuzz変換 装飾)` と値を先頭に置いて書けます。

## lint・formatter の反応

- 既存 `apps/clojure` の eastwood 1.4.3・lein-kibit 0.1.8・lein-cljfmt は、検証環境から Clojars に接続できず（`status: 403 Forbidden`）取得できなかった
- clj-kondo（`clojure-lsp diagnostics`）: 日本語の名前空間・関数・レコードには指摘なし。助詞だけが `src/なでしこ/パイプライン.clj:14:11: error: [unresolved-symbol] Unresolved symbol: を` と指摘され、除外設定後は `No diagnostics found!`
- cljfmt（`clojure-lsp format --dry`）: `Nothing to format!`。わざと崩すと日本語ファイルの差分を表示して終了コード 1 になる

## 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | 警告なし |
| 型・モジュール名 | 3 | ns・ファイル・record・protocol・AOT クラスすべて可 |
| テスト名 | 3 | `testing` の文字列で文章を書ける |
| 語順の再現 | 3 | `(なでしこ 数 を FizzBuzz変換 して 装飾)` |
| ツール許容 | 2 | clj-kondo に助詞の除外設定が必要。UTF-8 ロケールも必須 |
| **合計** | **14** | |
