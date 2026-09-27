# 日本語実装比較: JavaScript / TypeScript

`apps/nadesiko/` の題材 A〜D を、識別子・テスト名・メッセージを日本語にして JavaScript 版（`src/js/`・`test/js/`）と TypeScript 版（`src/ts/`・`test/ts/`）で書き直した記録です。
ツール構成は既存 `apps/node/` と同じ（Vitest・ESLint + typescript-eslint・Prettier・tsc）で、ESLint の設定は既存のものに対象拡張子 `.js` を加えただけです。

## 1. バージョンと `make test` の結果

| 項目 | バージョン（実行結果から） |
|------|--------------------------|
| Node.js | v22.21.1（npm 10.9.4） |
| TypeScript | 5.9.3 |
| Vitest | 3.2.7 |
| ESLint | 9.39.5（@typescript-eslint/eslint-plugin 8.70.1、eslint-config-prettier 10.1.8） |
| Prettier | 3.9.9 |

`make test`（`make check` で format-check・lint・typecheck も実行）:

```text
 ✓ test/js/パイプライン.test.js (2 tests)
 ✓ test/js/変換.test.js (7 tests)
 ✓ test/js/タイプ.test.js (5 tests)
 ✓ test/js/安全変換.test.js (3 tests)
 ✓ test/js/語順.test.js (5 tests)
 ✓ test/ts/タイプ.test.ts (5 tests)
 ✓ test/ts/語順.test.ts (5 tests)
 ✓ test/ts/変換.test.ts (7 tests)
 ✓ test/ts/安全変換.test.ts (3 tests)
 ✓ test/ts/パイプライン.test.ts (2 tests)
 Test Files  10 passed (10)
      Tests  44 passed (44)
```

JS・TS それぞれ 22 件（題材 A 7 件、B 5 件、C 2 件、D 3 件、語順 5 件）です。

## 2. 日本語にできた名前・できなかった名前

### 日本語にできた名前（JS・TS 共通）

- 関数: `FizzBuzz変換`・`FizzBuzz配列作成`・`タイプ生成`・`タイプ変換`・`装飾`・`FizzBuzz装飾`・`パイプライン処理`・`安全変換`
- 変数・引数・プロパティ: `名前`・`変換`・`番号`・`添字`・`成功`・`値`・`エラー`（オブジェクトのキーとプロパティアクセス `通常.名前` も可）
- クラス: `該当タイプなしエラー extends Error`・`主題`・`タイプ`（JS 版）
- ファイル名・import パス: `src/ts/タイプ.ts`・`src/js/パイプライン.js` など。`import { タイプ生成 } from "../../src/ts/タイプ";` は tsc・Vitest（Vite）とも問題なし
- テスト名: `describe("FizzBuzz変換")`・`it("3を渡したらFizzを返す")` は文字列なので空白・記号・括弧込みで書ける（`it("3をFizzBuzz変換するとFizzを返す（メソッドチェーン）")`）

### TypeScript だけの名前

- 列挙型と列挙子: `enum タイプ番号 { 通常 = 1, 数字限定 = 2, FizzBuzz限定 = 3 }`
- interface: `interface タイプ { readonly 名前: string; readonly 変換: 変換関数 }`
- 型エイリアス（判別共用体のタグも日本語）:

```typescript
export type 変換結果 =
  | { readonly 成功: true; readonly 値: string }
  | { readonly 成功: false; readonly エラー: string };
```

JS には型エイリアス・enum がないため、`Object.freeze({ 通常: 1, 数字限定: 2, FizzBuzz限定: 3 })` と `class タイプ` で代替しました。

### 言語が拒否した名前（スクラッチで確認）

ECMAScript の識別子は Unicode の ID_Start / ID_Continue に従います。Node.js v22.21.1 で確認した結果:

| 試したコード | 結果 |
|-------------|------|
| `const 「3」 = 1;` | `SyntaxError: Invalid or unexpected token` |
| `const ３を渡す = 1;`（全角数字始まり） | `SyntaxError: Invalid or unexpected token` |
| `const 中・黒 = 1;`（中黒 U+30FB） | 通る |
| `const 変換〇 = 1; const 々 = 2;` | 通る |
| `const　あ　=　1;`（全角空白 U+3000 区切り） | 通る（U+3000 は空白扱い） |
| `const ｶﾀｶﾅ = 1; const カタカナ = 2;` | 通る。**別の識別子** として扱われる（`1 2` と出力）。Python と違い NFKC 正規化されない |

数字で始まる `3を渡したら…` は識別子にできませんが、テスト名は文字列なので影響はありません。

### ファイル名の Unicode 正規化（スクラッチで確認）

ファイル `パイプ.ts` を NFC で作り、import 文だけを NFD（`パ` = `ハ` + 結合半濁点）で書くと、見た目は同じでも tsc が解決できません。

```text
imp.ts(1,19): error TS2307: Cannot find module './パイプ' or its corresponding type declarations.
```

Linux で確認した事実です。macOS のファイルシステムでの挙動は未検証です。

## 3. 採用した回避策とその代償

| 回避策 | 理由 | 代償 |
|--------|------|------|
| 引数名を `N` にした | なでしこ3 にそろえた（ASCII 大文字 1 文字） | typescript-eslint の naming-convention を有効にすると `N` が指摘される（5 章参照） |
| JS の enum を `Object.freeze` で代替 | JS に enum 構文がない | 網羅性の型チェックはない |
| TS の `安全変換(N: unknown)` | `number` にすると `安全変換("a")` がコンパイルエラーになり、題材 D の 3 件目を書けない | `typeof` による実行時の絞り込みが必要 |
| タグ付きテンプレートの動詞型を `(目的語: never) => unknown` にした | 異なる引数型の関数を可変長で受けるため | 戻り値が `unknown` になり、TS の型推論が途切れる |

TS で引数を `number` にした場合の tsc のエラー原文（スクラッチで確認）:

```text
型.ts(2,6): error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.
```

## 4. 語順の再現方法

組み込み型の拡張（`Number.prototype.を = …`）は動作します（スクラッチで `(3).を(String)` が `3` を返すことを確認）が、グローバルを汚す悪習なので採用しませんでした。
代わりに 3 つの正攻法を `src/{js,ts}/語順.{js,ts}` に実装しました。

### 4.1 メソッドチェーンを持つラッパー（助詞をメソッド名にする）

```typescript
export class 主題<T> {
  constructor(readonly 値: T) {}
  を<U>(動詞: (目的語: T) => U): 主題<U> {
    return new 主題(動詞(this.値));
  }
  // して(), 戻す() も同様
}
export const それ = <T>(値: T): 主題<T> => new 主題(値);

expect(それ(3).を(FizzBuzz変換).値).toBe("Fizz");
expect(それ(15).を(FizzBuzz変換).して(装飾).戻す()).toBe("[FizzBuzz]");
```

「それ(3) を FizzBuzz変換 して 装飾 戻す」と、助詞に相当するメソッドが目的語と動詞の間に入ります。TS では型安全です。代償は入口の `それ(…)` が必要なことです。

### 4.2 関数合成（「〜して〜する」）

```typescript
export const して =
  <A, B, C>(先: (x: A) => B, 後: (x: B) => C) =>
  (x: A): C =>
    後(先(x));

// なでしこ3: 「NをFizzBuzz変換して装飾して戻す」
export const FizzBuzz装飾 = して(FizzBuzz変換, 装飾);
```

### 4.3 タグ付きテンプレート（助詞を文字列として置く）

```typescript
expect(日本語`${3}を${FizzBuzz変換}`).toBe("Fizz");
expect(日本語`${5}を${FizzBuzz変換}して${装飾}`).toBe("[Buzz]");
expect(() => 日本語`${3}が${FizzBuzz変換}`).toThrow("助詞「が」には対応していません");
```

見た目は最もなでしこ3 に近くなりますが、助詞の検査は実行時のみで、TS では戻り値が `unknown` になります。

パイプライン演算子 `|>`（TC39 提案段階）は Node.js v22.21.1 では使えません。

```text
console.log(3 |> f);
               ^
SyntaxError: Unexpected token '>'
```

## 5. lint・formatter の反応

### 既存設定のまま（`make check`）

- Prettier 3.9.9: `All matched files use Prettier code style!`（日本語識別子で変更なし）
- ESLint（既存 `apps/node` と同じルール）: 指摘 0 件
- tsc `--strict`: エラー 0 件

### 命名規則ルールを追加した場合（設定は変えず `--rule` で一時的に実行）

`npx eslint --rule "camelcase: error" src/ test/` は **0 件** でした（`camelcase` はアンダースコアしか見ないため）。

`npx eslint --rule "@typescript-eslint/naming-convention: error" src/ test/` は 24 件のエラーでした。抜粋:

```text
1:17  error  Function name `FizzBuzz変換` must match one of the following formats: camelCase    @typescript-eslint/naming-convention
1:28  error  Parameter name `N` must match one of the following formats: camelCase            @typescript-eslint/naming-convention
13:3  error  Enum Member name `FizzBuzz限定` must match one of the following formats: camelCase  @typescript-eslint/naming-convention
9:14  error  Variable name `FizzBuzz装飾` must match one of the following formats: camelCase, UPPER_CASE  @typescript-eslint/naming-convention
✖ 24 problems (24 errors, 0 warnings)
```

指摘されたのは **ASCII 大文字で始まる名前（`FizzBuzz…`・`N`）だけ** です。`タイプ生成`・`装飾`・`該当タイプなしエラー`（クラス、PascalCase 要求）・`タイプ番号`（enum）・`変換結果`（型）など、大文字小文字の区別がない文字だけの名前は camelCase にも PascalCase にも合格します。test/ 配下は 0 件でした。

### Prettier の行幅計算

Prettier は全角文字を幅 2 として数えます。スクラッチで、漢字 38 文字（幅 76）の文字列連結は折り返され、ASCII 38 文字の同じ形の行は折り返されませんでした。

```typescript
export const 名前 =
  "変換変換変換変換変換変換変換変換変換変換変換変換変換変換変換変換変換変換変換" +
  "あ";
export const abc = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + "a";
```

## 6. 日本語化スコア

### JavaScript（合計 15 / 15）

| 軸 | 点 | 根拠 |
|----|----|------|
| 関数・変数名 | 3 | 関数・変数・引数・プロパティすべて日本語で制約なし。数字始まりと `「」` は不可だが、ASCII の識別子規則と同じ範囲の制約 |
| 型・モジュール名 | 3 | クラス・列挙相当の定数オブジェクト・ファイル名（`タイプ.js`）すべて日本語。ただし NFC/NFD の違いで import が壊れる落とし穴がある |
| テスト名 | 3 | `it("3を渡したらFizzを返す")` は文字列で、空白・括弧込みの文章を書ける |
| 語順の再現 | 3 | `それ(3).を(FizzBuzz変換)` と `` 日本語`${3}を${FizzBuzz変換}` `` で助詞を置いた SOV 順を書ける |
| ツール許容 | 3 | 既存の ESLint・Prettier・Vitest 設定のまま通る |

### TypeScript（合計 15 / 15）

| 軸 | 点 | 根拠 |
|----|----|------|
| 関数・変数名 | 3 | JS と同じ。型注釈付きでも制約なし |
| 型・モジュール名 | 3 | `enum タイプ番号 { 通常, … }`・`interface タイプ`・`type 変換結果`・ファイル名 `タイプ.ts` すべて可 |
| テスト名 | 3 | JS と同じ |
| 語順の再現 | 3 | `それ(3).を(FizzBuzz変換).して(装飾)` が型安全に書ける（タグ付きテンプレート版は戻り値が `unknown` になる） |
| ツール許容 | 3 | 既存設定で tsc・ESLint・Prettier・Vitest が通る。naming-convention を有効にした場合も、指摘は ASCII 大文字始まりの名前だけ |
