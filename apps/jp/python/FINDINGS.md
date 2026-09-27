# 日本語実装比較: Python

`apps/nadesiko/` の題材 A〜D を、識別子・テスト名・メッセージを日本語にして Python で書き直した記録です。
ツールは既存 `apps/python/` と同じ pytest・Ruff（`.ruff.toml` をそのまま複製）・mypy（`pyproject.toml` の `[tool.mypy]` を同じ値で記述）で、依存は uv の `dev` グループで管理します。

## 1. バージョンと `make test` の結果

| 項目 | バージョン（実行結果から） |
|------|--------------------------|
| Python | 3.13.11 |
| pytest | 9.1.1 |
| Ruff | 0.16.9 |
| mypy | 2.3.1 |
| uv | 0.9.21 |

`make test`（`make check` で format-check・lint・typecheck も実行）:

```text
test/test_タイプ.py::Testタイプ生成::test_タイプ1は通常の変換をする PASSED
test/test_タイプ.py::Testタイプ生成::test_タイプ2は数字だけを返す PASSED
test/test_タイプ.py::Testタイプ生成::test_タイプ3は15の倍数だけFizzBuzzを返す PASSED
test/test_タイプ.py::Testタイプ生成::test_タイプ3は3の倍数を数字で返す PASSED
test/test_タイプ.py::Testタイプ生成::test_存在しないタイプはエラーになる PASSED
test/test_パイプライン.py::test_装飾すると角括弧で囲む PASSED
test/test_パイプライン.py::test_5までのパイプライン処理 PASSED
test/test_変換.py::test_FizzBuzz変換[3を渡したらFizzを返す] PASSED
test/test_変換.py::test_FizzBuzz変換[5を渡したらBuzzを返す] PASSED
test/test_変換.py::test_FizzBuzz変換[15を渡したらFizzBuzzを返す] PASSED
test/test_変換.py::test_FizzBuzz変換[1を渡したら文字列1を返す] PASSED
test/test_変換.py::test_FizzBuzz変換[2を渡したら文字列2を返す] PASSED
test/test_変換.py::test_15まで作ると15件になる PASSED
test/test_変換.py::test_15まで作った配列の並び PASSED
test/test_安全変換.py::test_正の数は成功になる PASSED
test/test_安全変換.py::test_0は失敗になる PASSED
test/test_安全変換.py::test_数値でなければ失敗になる PASSED
test/test_語順.py::test_3をFizzBuzz変換するとFizzを返す PASSED
test/test_語順.py::test_15をFizzBuzz変換して装飾する PASSED
test/test_語順.py::test_FizzBuzz変換して装飾する関数を合成する PASSED
============================== 20 passed in 0.04s ==============================
```

20 件（題材 A 7 件、B 5 件、C 2 件、D 3 件、語順 3 件）です。

## 2. 日本語にできた名前・できなかった名前

### 日本語にできた名前

- パッケージ・モジュール（ファイル名）: `実装/変換.py`・`実装/タイプ.py`・`実装/パイプライン.py`・`実装/安全変換.py`・`実装/語順.py`。`from 実装.タイプ import タイプ生成` で import できる
- テストファイル: `test/test_変換.py` など（`test_` 接頭辞は必要）
- 関数・変数・引数: `FizzBuzz変換`・`タイプ生成`・`装飾`・`安全変換`・`番号`・`対象`・`文字列`
- クラス・列挙: `class タイプ番号(IntEnum): 通常 = 1; 数字限定 = 2; FizzBuzz限定 = 3`、`@dataclass(frozen=True) class タイプ`、`class 該当タイプなしエラー(ValueError)`
- 型エイリアス・型変数: `変換関数 = Callable[[int], str]`、`変換結果: TypeAlias = 成功 | 失敗`、`甲 = TypeVar("甲")`
- dataclass のフィールド: `名前: str`・`変換: 変換関数`・`値`・`エラー`

### 言語が拒否した名前（スクラッチで確認）

| 試したコード | 結果（原文） |
|-------------|--------------|
| `def 3を渡したらFizzを返す():` | `SyntaxError: invalid syntax` |
| `def ３を渡したらFizzを返す():`（全角数字始まり） | `SyntaxError: invalid character '３' (U+FF13)` |
| `x = 「3」` | `SyntaxError: invalid character '「' (U+300C)` |
| `中・黒 = 1`（中黒 U+30FB） | 通る |

なでしこ3 のテスト名の多くは数字で始まるため、関数名にするには `test_` 接頭辞が事実上必須です。

### NFKC 正規化の実例（スクラッチで確認）

Python は識別子を NFKC 正規化するため、半角カナと全角カナ、全角数字と半角数字が同じ識別子になります（JavaScript では別の識別子でした）。

```python
ｶﾀｶﾅ = "半角で代入"
print(カタカナ)            # -> 半角で代入
def test_３を渡す(): return "全角3"
print(test_3を渡す())      # -> 全角3
```

正規化されるのは **ソース上の識別子だけ** なので、文字列で名前を扱う箇所で食い違います。

```python
class 型:
    ﾀｲﾌﾟ名 = "x"
print(型.__dict__.keys() - object.__dict__.keys())  # {'タイプ名', ...} 全角で登録される
getattr(型, "タイプ名")   # -> x
getattr(型, "ﾀｲﾌﾟ名")    # AttributeError: type object '型' has no attribute 'ﾀｲﾌﾟ名'
```

モジュールのファイル名も正規化されないため、半角カナのファイル `ﾀｲﾌﾟ.py` は import できません。

```text
    import ﾀｲﾌﾟ
ModuleNotFoundError: No module named 'タイプ'
```

## 3. 採用した回避策とその代償

| 回避策 | 理由 | 代償 |
|--------|------|------|
| テスト関数名に `test_` 接頭辞 | pytest の既定の収集規則（`python_functions = test_*`）と、数字始まりの識別子が不可のため | `test_3を渡したらFizzを返す` のように ASCII が混ざる |
| 題材 A の 5 件を `pytest.param(..., id="3を渡したらFizzを返す")` で表現 | id は任意の文字列なので、なでしこ3 のテスト名をそのまま書ける | 既定では id の非 ASCII がエスケープされる（下記） |
| `disable_test_id_escaping_and_forfeit_all_rights_to_community_support = true` を pyproject に追加 | 既定の出力が `test_FizzBuzz変換[3を渡したらFizzを返す]` になり読めないため | オプション名のとおり「コミュニティサポートを受ける権利を放棄する」扱いになる |
| Makefile で `unexport PYTHONPATH` | Nix の python 環境（MkDocs 用）の `PYTHONPATH` が古い pathspec を先に読ませ、mypy が `ModuleNotFoundError: No module named 'pathspec.patterns.gitignore'` で起動しない | 日本語とは無関係の環境問題 |
| `安全変換(N: object)` | 題材 D の 3 件目（`安全変換("a")`）を mypy に通すため | `isinstance` による絞り込みが必要 |

なお、pytest の収集規則は設定で変えられます。スクラッチで `python_files = ["*のテスト.py"]`・`python_classes = ["*のテスト"]`・`python_functions = ["*[るす]"]` とすると、`タイプのテスト.py` の `class タイプ生成のテスト` の `def タイプ1は通常の変換をする` と `def 存在しないタイプはエラーになる` が接頭辞なしで収集・実行されました（`2 passed`）。ただし語尾で収集を決める規則は壊れやすく、数字始まりの名前は依然として書けないため採用していません。

`pytest -k "渡したら"` のように日本語で絞り込むことはできました（`5 passed, 15 deselected`）。

## 4. 語順の再現方法

演算子 `|` の右側オペランド版 `__ror__` を使い、助詞オブジェクト `を`・`して` を目的語と動詞の間に挟みます（`実装/語順.py`）。`int` や `str` は助詞との `|` を知らないので `NotImplemented` を返し、助詞の `__ror__` が呼ばれて目的語を預かります。

```python
class 目的語付き(Generic[甲]):
    def __init__(self, 目的語: 甲) -> None:
        self.目的語 = 目的語
    def __or__(self, 動詞: Callable[[甲], 乙]) -> 乙:
        return 動詞(self.目的語)

class 助詞:
    def __ror__(self, 目的語: 甲) -> 目的語付き[甲]:
        return 目的語付き(目的語)

assert (3 | を | FizzBuzz変換) == "Fizz"
# なでしこ3: 「NをFizzBuzz変換して装飾して戻す」
return N | を | FizzBuzz変換 | して | 装飾
```

mypy は `3 | を | FizzBuzz変換` の型を `str` と推論し、エラーなしで通りました。`して` は `__call__` も持ち、`して(FizzBuzz変換, 装飾)` で関数合成にもなります。
代償は、演算子の本来の意味（ビット和・集合和）からの逸脱と、左辺が `|` を独自に解釈する型（`set` など）の場合に動かない可能性があることです（後者は未検証）。

## 5. lint・formatter の反応

### 既存設定のまま（`make check`）

- `ruff check .`: 最初の実行で `I001 [*] Import block is un-sorted or un-formatted` が 1 件。`タイプ番号, タイプ変換, タイプ生成` が `タイプ変換, タイプ生成, タイプ番号` に並べ替えられました。読みの順ではなくコードポイント順（変 U+5909 < 生 U+751F < 番 U+756A）です。`--fix` 後は `All checks passed!`
- `ruff format --check .`: 1 件の再整形。`with pytest.raises(該当タイプなしエラー, match="該当するタイプは存在しません: 4"):` は 66 文字ですが、全角を幅 2 とすると 90 桁で、`line-length = 88` を超えるとして折り返されました。Ruff も全角を幅 2 として数えています
- mypy: `Success: no issues found in 12 source files`

### 既存ルールセットにないルールを一時的に有効にした場合（`--select`）

`PLC2401`（non-ascii-name）・`PLC2403`（non-ascii-import-name）は既存の `select`（E, W, F, I, B, C4, UP, C90）に含まれないため、既定では出ません。有効にすると 84 件でした。

```text
実装/語順.py:40:1: PLC2401 Variable name `を` contains a non-ASCII character
64	PLC2401	non-ascii-name
20	PLC2403	non-ascii-import-name
```

pep8-naming（`N`）を有効にすると 67 件でした。日本語の名前は **小文字でも CapWords でもない** と判定され、関数でもクラスでも必ず指摘されます（typescript-eslint の naming-convention が大文字小文字のない名前を合格させたのと逆です）。

```text
実装/パイプライン.py:7:5: N802 Function name `装飾` should be lowercase
実装/タイプ.py:19:7: N801 Class name `タイプ` should use CapWords convention
実装/タイプ.py:24:7: N818 Exception name `該当タイプなしエラー` should be named with an Error suffix
実装/変換.py:1:1: N999 Invalid module name: '変換'
test/test_タイプ.py:10:9: N806 Variable `通常` in function should be lowercase
```

`RUF001`〜`RUF003`（ambiguous unicode character）を有効にすると、docstring の全角括弧が 6 件指摘されました。

```text
実装/タイプ.py:1:15: RUF002 Docstring contains ambiguous `（` (FULLWIDTH LEFT PARENTHESIS). Did you mean `(` (LEFT PARENTHESIS)?
```

## 6. 日本語化スコア（合計 13 / 15）

| 軸 | 点 | 根拠 |
|----|----|------|
| 関数・変数名 | 3 | 関数・変数・引数・フィールドすべて日本語で制約なし。ただし NFKC 正規化により半角カナと全角カナが同一視され、`getattr` の文字列とは食い違う |
| 型・モジュール名 | 3 | クラス・`IntEnum` の列挙子・型エイリアス・`TypeVar`・パッケージ `実装`・モジュール `タイプ.py` すべて日本語で import できる（半角カナのファイル名だけは NFKC のため import 不可） |
| テスト名 | 2 | 関数名は `test_` 接頭辞付きの日本語識別子。`pytest.param(id=...)` なら文章で書けるが、既定では `を` にエスケープされ、読める表示には「サポート放棄」オプションが必要 |
| 語順の再現 | 3 | `3 \| を \| FizzBuzz変換` と助詞オブジェクトを置いた SOV 順を、mypy の型推論付きで書ける |
| ツール許容 | 2 | 既存の Ruff・mypy 設定は `I001`（コードポイント順）と行幅の自動修正だけで通るが、pytest の id 表示に設定変更が必要。`PLC2401`・`N` を有効にすると日本語名はすべて指摘される |
