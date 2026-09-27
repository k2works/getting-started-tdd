# Flix の日本語実装 検証記録

## 実行環境と結果

| 項目 | 内容 |
|------|------|
| 処理系 | The Flix Programming Language 0.76.2（nixpkgs の `flix` パッケージ。cache.nixos.org から取得） |
| JDK | Nix 環境 `nix develop .#flix` の JDK 21 |
| テスト | `flix test`（`@Test` と `Assert.assertEq`） |
| `make test` | 17 件成功、0 件失敗（題材 A: 8 件、B: 5 件、C: 2 件、D: 2 件） |
| `flix check` | 指摘なし（終了コード 0） |
| `flix format` | 日本語の文字列・コメントを含むファイルを整形しても差分なし |

> **Note**: `flix.toml` は既存の `apps/flix/` と同じ 0.75.1 を指定しています。本シリーズの Nix 環境は flix.jar を GitHub Releases から取得しますが、検証時はこの環境から GitHub Releases へ接続できなかったため、nixpkgs の 0.76.2 で検証しました。0.76.2 には `format --check` オプションが無いため、Makefile には `format` のみを置いています。

## 日本語にできた名前・できなかった名前

**識別子はすべて日本語にできません。** 関数名・変数名・型名・列挙子のいずれに日本語を 1 文字でも含めると、字句解析の段階でエラーになります。

```text
-- Lexer Error [E4518] ------------------------------------------- src/Main.flix
>> Unexpected character '換'.
```

`def fizzBuzz変換`（関数）、`let 値 = 1`（変数）、`enum タイプ { case 通常 }`（型と列挙子）のすべてで同じエラーになることを確認しました。文字列リテラル（`"該当するタイプは存在しません: ${bangou}"`）とコメント（`///` のドキュメントコメントを含む）には日本語を書けます。

## 採用した回避策とその代償

| なでしこ3 の名前 | Flix の名前 |
|-----------------|------------|
| `FizzBuzz変換` | `fizzBuzzHenkan` |
| `FizzBuzz配列作成` | `fizzBuzzHairetsuSakusei` |
| `タイプ`（通常 / 数字限定 / FizzBuzz限定） | `enum Taipu { case Tsuujou, SuujiGentei, FizzBuzzGentei }` |
| `タイプ生成` / `タイプ変換` | `taipuSeisei` / `taipuHenkan` |
| `装飾` / `パイプライン処理` | `soushoku` / `paipurainShori` |
| `安全変換` | `anzenHenkan` |

- 名前は **ローマ字** にし、なでしこ3 の元の名前をドキュメントコメントに残しました。英語名（`convert` など）にしなかったのは、なでしこ3 との対応を保つためです。
- 代償は可読性です。`taipu3Wa15NoBaisuDakeFizzBuzzWoKaesu` のようなテスト名は、日本語話者にも英語話者にも読みにくくなります。
- テスト名はローマ字の関数名しか使えず、テスト結果の出力（`TestTaipu.taipu3Wa3NoBaisuWoSuujiDeKaesu PASS`）にも日本語は出ません。日本語のテスト名はドキュメントコメントにしか残せません。
- 題材 B の「存在しないタイプはエラー」は、例外ではなく `Result[String, Taipu]` の `Err` で表しました。
- 題材 D の「数値でなければ失敗」は、引数が `Int32` のため型検査の段階で弾かれるので、テストを書いていません。

## 語順の再現

`|>` を使うと、なでしこ3 の「FizzBuzz変換して装飾して」と同じ順に左から右へ書けます。

```flix
pub def fizzBuzzSoushoku(n: Int32): String =
    n |> FizzBuzz.fizzBuzzHenkan |> soushoku
```

さらに、Flix のバッククォートによる中置記法を使うと、助詞「を」に当たる関数 `wo` を目的語と動詞の間に置けます。ただし助詞もローマ字です。

```flix
pub def wo(x: a, f: a -> b \ ef): b \ ef = f(x)

// 3 を FizzBuzz変換
3 `FizzBuzz.wo` FizzBuzz.fizzBuzzHenkan
```

## 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 0 | 字句解析で `Unexpected character` になり、日本語を書けない |
| 型・モジュール名 | 0 | 型・列挙子・モジュールとも ASCII のみ |
| テスト名 | 0 | テストは ASCII の関数名だけ。日本語はドキュメントコメントにしか残せない |
| 語順の再現 | 2 | `\|>` で SOV 順に書ける。中置の `wo` で助詞も置けるが、ローマ字になる |
| ツール許容 | 3 | 日本語の文字列・コメントに対して `check`・`format`・`test` が設定変更なしで通る |
| **合計** | **5** | |
