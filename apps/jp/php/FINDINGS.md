# PHP 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | 内容 |
|------|------|
| 処理系 | PHP 8.4.16 (cli) (NTS)（`nix develop .#php`） |
| パッケージ管理 | Composer 2.9.2 |
| テスト | PHPUnit 10.5.65（`apps/php/` と同じ `^10.0`） |
| lint | PHP_CodeSniffer 3.13.6（PSR-12）、PHPStan 2.1.56（level max）、PHPMD 2.15.0 |
| `make test` | `OK (19 tests, 25 assertions)`（題材 A: 7 件、B: 5 件、C: 2 件、D: 3 件、語順: 2 件） |
| `make lint` / `make analyse` / `make complexity` | いずれも指摘なし（`phpcs.xml` の変更後。変更前の反応は 5 章） |

> **Note**: この検証環境では、Composer の dist（`api.github.com` の zip）が取得できなかったため、`composer install --prefer-source`（git clone）で導入しています。phpstan/phpstan は dist しか配布されないパッケージのため Composer では入らず、`composer.json` から外しました。検証では phpstan/phpstan リポジトリの `2.1.56` タグを浅く clone し、同梱の `phpstan.phar` を `make analyse PHPSTAN='php path/to/phpstan.phar'` で実行しました。nixpkgs の `php84Packages.phpstan`（2.1.32）も試しましたが、日本語と無関係の `Typed static property olvlvl\ComposerAttributeCollector\Attributes::$collection must not be accessed before initialization` で起動できませんでした。

## 2. 日本語にできた名前・できなかった名前

### できた名前

PHP は識別子に 0x80 以上のバイトを許すため、ほぼすべての位置で日本語を使えました。

| 種類 | 例 |
|------|----|
| 名前空間 | `namespace アプリ;`、`namespace アプリ\テスト;` |
| 関数 | `FizzBuzz変換`、`装飾`、`安全変換`、`して`、`数` |
| クラス・readonly クラス | `final readonly class 変換結果`、`final class タイプ不明例外 extends \InvalidArgumentException` |
| 列挙型・列挙子 | `enum タイプ: int { case 通常 = 1; case 数字限定 = 2; case FizzBuzz限定 = 3; }`（`->name` が `'通常'` を返す） |
| プロパティ・変数・引数 | `public bool $成功`、`$結果`、`$番号` |
| PHPDoc のテンプレート型 | `@template 入力`、`@param callable(入力): 途中 $先`（PHPStan が型推論に使える） |
| ファイル名（PSR-4） | `"アプリ\\": "src/"` で `アプリ\タイプ` → `src/タイプ.php` をオートロード |
| テストファイル・クラス | `tests/タイプテスト.php` の `final class タイプテスト`（`phpunit.xml` の `<directory suffix="テスト.php">`） |
| テストメソッド | `#[Test] public function タイプ1は通常の変換をする(): void` |

同じ名前空間に関数 `数()` とクラス `数` を同時に定義できます（別の名前表のため）。

### できなかった名前（言語仕様）

識別子は数字で始められません。これは ASCII と同じ規則ですが、`3を渡したらFizzを返す` のようななでしこ3 のテスト名がそのままメソッド名にならない原因になります。

```text
Parse error: syntax error, unexpected integer "3" in .../digit.php on line 2
```

数字始まりのテストは `test_3を渡したらFizzを返す`、`test_0は失敗になる` のように `test_` を前置しました。

### パイプ演算子 `|>` は PHP 8.4 に無い

`|>` は PHP 8.5 で入る予定の構文で、8.4.16 では構文エラーになります。

```text
Parse error: syntax error, unexpected token ">" in .../pipe.php on line 2
```

## 3. 回避策とその代償

| なでしこ3 の名前 | PHP の名前 | 回避策 |
|-----------------|-----------|--------|
| `タイプ`（辞書） | `enum タイプ` | 辞書ではなく列挙型にし、`名前()` と `変換()` をメソッドにした |
| `タイプ生成` / `タイプ変換` | `タイプ::生成(1)` / `タイプ::変換($タイプ, 3)` | 列挙型の静的メソッド |
| 数字始まりのテスト名 | `test_3を渡したらFizzを返す` + `#[TestDox('3を渡したらFizzを返す')]` | `test_` を前置し、表示名を TestDox で指定 |
| 関数のオートロード | `composer.json` の `autoload.files` | PSR-4 はクラスしか対象にしないため |

- 題材 D の `安全変換` は引数を `int|string` にし、文字列 `'a'` を渡すテストも書けました（3 件）。
- 関数は PSR-4 の対象外のため、関数を置いたファイルは `autoload.files` に列挙する必要があります（日本語と無関係の PHP の制約です）。

## 4. 語順の再現

`readonly` プロパティに **自分自身** を入れ、助詞「を」「して」をプロパティとして置けるようにしました。

```php
final readonly class 数
{
    /** 助詞「を」に相当する、自分自身を指すプロパティ */
    public 数 $を;

    public function __construct(public int $値)
    {
        $this->を = $this;
    }

    public function FizzBuzz変換(): 文
    {
        return new 文(\アプリ\FizzBuzz変換($this->値));
    }
}
```

```php
$this->assertSame('Fizz', 数(3)->を->FizzBuzz変換()->値);
$this->assertSame('[FizzBuzz]', 数(15)->を->FizzBuzz変換()->して->装飾()->値);
```

題材 C の「FizzBuzz変換して装飾して」は、`|>` の代わりに合成関数 `して` と first-class callable 構文 `関数名(...)` で書きました。

```php
function FizzBuzz装飾(int $数): string
{
    return して(FizzBuzz変換(...), 装飾(...))($数);
}
```

## 5. lint・formatter の反応

### PHPUnit の TestDox 表示

`apps/php/` と同じく `testdox="true"` にすると、PHPUnit がメソッド名を「単語に分けて小文字化」するため、日本語のテスト名が崩れました。

```text
Fizz Buzz変換テスト (アプリ\テスト\FizzBuzz変換テスト)
 ✔  3を渡したら fizzを返す
 ✔  15を渡したら fizz buzzを返す
 ✔  15まで作ると 15件になる
タイプテスト (アプリ\テスト\タイプテスト)
 ✔ タイプ 1は通常の変換をする
 ✔ タイプ 3は 15の倍数だけ fizz buzzを返す
```

ASCII の大文字と数字の前に空白が入り、`Fizz` が `fizz` になります。すべてのテストに `#[TestDox('3を渡したらFizzを返す')]` を付けると、なでしこ3 と同じ表記で表示されました。

```text
FizzBuzz変換
 ✔ 3を渡したらFizzを返す
 ✔ 15を渡したらFizzBuzzを返す
タイプ
 ✔ タイプ3は15の倍数だけFizzBuzzを返す
語順の再現
 ✔ 数(3)->を->FizzBuzz変換() と助詞を置いて書ける
 ✔ 15 を FizzBuzz変換して 装飾する（メソッドチェーン）
```

### PHP_CodeSniffer（PSR-12）

`apps/php/phpcs.xml`（`PSR1.Methods.CamelCapsMethodName.NotCamelCaps` を除外済み）のままでは、日本語のクラス名・列挙型名がすべてエラーになりました。

```text
 8 | ERROR | Class name "数" is not in PascalCase format
 8 | ERROR | Enum name "タイプ" is not in PascalCase format
 7 | ERROR | Class name "タイプ不明例外" is not in PascalCase format
14 | ERROR | Class name "FizzBuzz変換テスト" is not in PascalCase format
```

`FizzBuzz変換テスト` のように ASCII 大文字で始まっていてもエラーになります。素の PSR-12 では、メソッド名も次のように報告されます（36 件）。

```text
18 | ERROR | Method name "数::FizzBuzz変換" is not in camel caps format
   |       | (PSR1.Methods.CamelCapsMethodName.NotCamelCaps)
 8 | ERROR | Class name "数" is not in PascalCase format
   |       | (Squiz.Classes.ValidClassName.NotCamelCaps)
```

名前空間の外の関数名（`FizzBuzz変換` など）と変数名には、PSR-12 のルールは反応しませんでした。`phpcs.xml` に `Squiz.Classes.ValidClassName.NotCamelCaps` の除外を加えて、指摘なしになりました。

### PHPStan（level max）

日本語の名前空間・関数・列挙子・テンプレート型名に対する指摘はありませんでした。最初に書いた可変長の合成関数 `合成(callable ...$関数群)` では、日本語とは無関係の型の指摘（`argument.type`）が出たため、テンプレート型 `入力`・`途中`・`出力` を持つ 2 引数の `して` に書き換えて `[OK] No errors` になりました。

### PHPMD

`apps/php/phpmd.xml`（codesize・unusedcode）では指摘なしでした。参考に `naming` ルールセットを実行すると、`src` と `tests` には指摘がありませんでした。PHPMD は名前の長さをバイト数で数えるため、`$x` は `ShortVariable` になりますが、`$数`（1 文字・3 バイト）はなりません。

```text
short.php:2  ShortVariable    Avoid variables with short names like $x. Configured minimum length is 3.
```

PHP 8.4 では PHPMD 2.15.0 と PDepend が `Implicitly marking parameter $node as nullable is deprecated` などの Deprecated 警告を出しますが、日本語とは無関係で、終了コードは 0 です。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 2 | 言語上は数字始まり以外に制約なし。素の PSR-12 ではメソッド名が `CamelCapsMethodName` に引っかかる（`apps/php/` 同様に除外で抑止） |
| 型・モジュール名 | 3 | 名前空間・クラス・列挙型・列挙子・ファイル名（PSR-4 オートロード）まですべて日本語で書ける |
| テスト名 | 3 | `#[TestDox('15 を FizzBuzz変換して 装飾する（メソッドチェーン）')]` で空白・記号込みの文章を書ける。メソッド名も日本語で書ける |
| 語順の再現 | 3 | 自己参照プロパティで `数(3)->を->FizzBuzz変換()->して->装飾()` と、助詞に当たる語を置いた SOV 順で書ける（`\|>` は 8.4 に無い） |
| ツール許容 | 2 | phpcs がクラス名を PascalCase 違反とするため除外設定が必要。TestDox の自動整形は日本語を崩すので属性で指定する。PHPStan・PHPMD は設定変更なしで通る |
| **合計** | **13** | |
