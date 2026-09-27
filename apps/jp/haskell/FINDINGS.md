# Haskell の日本語実装 検証記録

## 実行環境と結果

| 項目 | バージョン（実行結果から記録） |
|------|------|
| GHC | 9.10.3（`ghc --version`、Nix 環境） |
| Stack | 3.7.1（hpack 0.38.1） |
| スナップショット | lts-24.20（GHC 9.10.3） |
| hspec | 2.11.14 |
| HLint | 3.10 |

`make test`（`stack test`）は `20 examples, 0 failures` です。`-Wall` を含む既存と同じ `ghc-options` で警告も 0 件でした。

> **Note**: 既存 `apps/haskell` の `lts-23.20` では、Stack が GHC 9.8.4 を downloads.haskell.org から取得しようとして検証環境では 403 になりました。既存 CI と同じく `nix develop .#haskell` の中で `stack test` を実行する方針のまま、Nix の GHC 9.10.3 を採用している `lts-24.20` を選び、`system-ghc: true`・`install-ghc: false` としています。

UTF-8 のロケールがないと、GHC は日本語のファイル名を扱えずに止まります。Makefile で `LANG`・`LC_ALL=C.UTF-8` を export しています。

```text
<no location info>: error:
    recoverEncode: invalid argument (cannot encode character '\56549')
```

## 日本語にできた名前・できなかった名前

GHC は、ひらがな・カタカナ・漢字（Unicode の OtherLetter）を **小文字扱い** にします。そのため変数・関数の位置では自由に使えますが、大文字始まりが必要な位置では使えません。

### できたもの

- 関数・変数（`fizzBuzz変換`・`タイプ生成`・`装飾`・`数`・`上限`）
- レコードのフィールド（`名前`・`変換`）
- 中置で使う関数（`を`・`して`）

### できなかったもの

- **大文字始まりの関数名 `FizzBuzz変換`**（データ構築子と解釈される）

  ```text
  error: [GHC-94426]
      Invalid data constructor ‘FizzBuzz変換’ in type signature:
      You can only define data constructors in data type declarations.
  ```

- **型名・型シノニム・型クラス名**

  ```text
  data タイプ = Tタイプ               → error: [GHC-47568] Malformed head of type or class declaration: タイプ
  type 変換結果 = Either String String → error: [GHC-47568] Malformed head of type or class declaration: 変換結果
  class 変換可能 a where ...           → error: [GHC-47568] Malformed head of type or class declaration: 変換可能 a
  ```

- **データ構築子**: `data タイプ番号 = 通常 | 数字限定` → `error: [GHC-25742] Not a data constructor: ‘通常’`
- **モジュール名**: `module FizzBuzz.タイプ (x) where` → `error: [GHC-58481] parse error on input ‘FizzBuzz.タイプ’`

## 回避策とその代償

- 型名・データ構築子には ASCII の大文字 `T` を接頭辞として付けた（`Tタイプ`・`Tタイプ番号 = T通常 | T数字限定 | TFizzBuzz限定`・`T変換結果 = T成功 String | T失敗 String`）。全角大文字（`Ｔタイプ番号 = Ｃ通常 | Ｃ数字限定`）でも通るが、入力しにくいため ASCII を採用。代償は、なでしこ3 の `通常`・`成功` と名前が変わり、読むときに接頭辞を読み飛ばす必要があること
- モジュール名は ASCII 大文字で始めて残りを日本語にした（`FizzBuzz変換`・`FizzBuzzタイプ`・`FizzBuzzパイプライン`・`FizzBuzz安全変換`・`M助詞`）。ファイル名 `src/FizzBuzz変換.hs`・`test/FizzBuzz変換Spec.hs` は hpack・Cabal・hspec-discover とも問題なく動いた
- 関数名は `fizzBuzz変換`（小文字始まりにするだけ）
- `タイプ生成` は例外ではなく `Either String Tタイプ` で失敗を返す（`Left "該当するタイプは存在しません: 4"`）
- 題材 D の「数値でなければ失敗になる」は、引数が `Int` のためコンパイル時に弾かれるので省略（`[GHC-83865] Couldn't match type ‘[Char]’ with ‘Int’`）

## 語順の再現

バッククォートで関数を中置にできるので、助詞そのものを関数として置けます。結合性を宣言すると、なでしこ3 の `NをFizzBuzz変換して装飾して` とほぼ同じ語順になります。

```haskell
infixl 1 `を`, `して`

を :: a -> (a -> b) -> b
を 値 処理 = 処理 値

して :: a -> (a -> b) -> b
して = を

fizzBuzz装飾 数 = 数 `を` fizzBuzz変換 `して` 装飾
```

標準の `Data.Function.&`（`3 & fizzBuzz変換 & 装飾`）や `Control.Arrow.>>>`（`fizzBuzz変換 >>> 装飾`）でも同じ順に書けます。

## lint・formatter の反応

- `hlint src/ test/` は `No hints`。日本語の識別子やバッククォートの `を`・`して` には何も指摘しない
- GHC の `-Wall -Wcompat -Wmissing-export-lists` などでも警告 0 件

## 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 3 | 日本語は小文字扱いなので、関数・変数・フィールドは制約なく書ける（`FizzBuzz変換` の小文字化は Haskell 一般の規則） |
| 型・モジュール名 | 1 | 型・データ構築子・型クラス・モジュールはすべて大文字始まりが必要で、ASCII 接頭辞（または全角大文字）が要る |
| テスト名 | 3 | HSpec の `it "3を渡したらFizzを返す"` で空白・記号込みの文を書ける |
| 語順の再現 | 3 | ``数 `を` fizzBuzz変換 `して` 装飾`` と助詞を置いて書ける |
| ツール許容 | 3 | HLint・GHC とも設定変更なしで通る（UTF-8 ロケールは必須） |
| **合計** | **13** | |
