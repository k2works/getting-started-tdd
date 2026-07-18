# 第 7 章: カプセル化とポリモーフィズム

## 7.1 はじめに

第 1 部では FizzBuzz を TDD で実装し、第 2 部では開発環境を整備しました。第 3 部では **オブジェクト指向設計** に踏み込み、手続き的なコードをより柔軟で拡張しやすい構造にリファクタリングしていきます。

この章では、**追加仕様** を題材にして **カプセル化** と **ポリモーフィズム** を学びます。Kotlin では `enum class` に抽象メソッドを持たせることで、条件分岐を型階層に置き換えます。

## 7.2 追加仕様

FizzBuzz に 3 つの **タイプ** を導入します。

```
タイプごとに出力を切り替えることができる。
タイプ 1 は通常の FizzBuzz、タイプ 2 は数字のみ、タイプ 3 は Fizz の場合のみをプリントする。
```

| タイプ | 仕様 |
|--------|------|
| タイプ 1（通常） | 3 の倍数→Fizz、5 の倍数→Buzz、15 の倍数→FizzBuzz、それ以外→数値 |
| タイプ 2（数値のみ） | すべて数値文字列を返す（Fizz/Buzz 変換なし） |
| タイプ 3（FizzBuzz のみ） | 15 の倍数→FizzBuzz、3 の倍数→Fizz、それ以外→数値（Buzz なし） |

**TODO リスト**:

- [ ] タイプ 1: 通常の FizzBuzz（既存の動作）
- [ ] タイプ 2: 数値のみ返す
- [ ] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [ ] 未定義のタイプはエラー
- [ ] 値オブジェクト FizzBuzzValue の導入

## 7.3 手続き的なアプローチ

最初に思いつくのは、`when` 式でタイプを分岐する手続き的なアプローチです。

```kotlin
// 手続き的な実装（アンチパターン）
fun generate(n: Int, type: Int = 1): String = when (type) {
    1 -> when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }
    2 -> n.toString()
    3 -> when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        else -> n.toString()
    }
    else -> throw IllegalArgumentException("未定義のタイプ: $type")
}
```

この実装には問題があります。

- **単一責任原則の違反**: 1 つの関数に複数のアルゴリズムが詰め込まれている
- **開放閉鎖原則の違反**: 新しいタイプを追加するたびに既存のコードを修正する必要がある
- **テストの困難さ**: タイプごとの独立したテストがしにくい

## 7.4 ポリモーフィズム — enum class の抽象メソッド

### enum class に振る舞いを持たせる

Ruby ではダックタイピングで「`generate` に応答するオブジェクト」を差し替えますが、Kotlin は静的型付け言語です。振る舞いの多態性は **enum class の抽象メソッド** で表現します。各 enum 定数がメソッドを `override` することで、定数ごとに異なる実装を持たせられます。これは **State パターン** 相当のポリモーフィズムです。

### Red: タイプ別テストの作成

```kotlin
package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class FizzBuzzTypeTest {
    @Test fun `TYPE_01 は通常の FizzBuzz`() {
        assertEquals("1", FizzBuzzType.TYPE_01.generate(1))
        assertEquals("Fizz", FizzBuzzType.TYPE_01.generate(3))
        assertEquals("Buzz", FizzBuzzType.TYPE_01.generate(5))
        assertEquals("FizzBuzz", FizzBuzzType.TYPE_01.generate(15))
    }

    @Test fun `TYPE_02 は数字のみ`() = assertEquals("3", FizzBuzzType.TYPE_02.generate(3))

    @Test fun `TYPE_03 は Fizz のみで Buzz なし`() {
        assertEquals("Fizz", FizzBuzzType.TYPE_03.generate(3))
        assertEquals("5", FizzBuzzType.TYPE_03.generate(5))
        assertEquals("FizzBuzz", FizzBuzzType.TYPE_03.generate(15))
    }

    @Test fun `番号 1 は TYPE_01`() = assertEquals(FizzBuzzType.TYPE_01, FizzBuzzType.create(1).getOrNull())
    @Test fun `番号 2 は TYPE_02`() = assertEquals(FizzBuzzType.TYPE_02, FizzBuzzType.create(2).getOrNull())
    @Test fun `番号 3 は TYPE_03`() = assertEquals(FizzBuzzType.TYPE_03, FizzBuzzType.create(3).getOrNull())
    @Test fun `未定義の番号は失敗`() = assertTrue(FizzBuzzType.create(99).isFailure)
}
```

`FizzBuzzType` がまだ存在しないためコンパイルエラー（Red）です。テストメソッド名にはバッククォート囲みの日本語を使い、意図を明確にします。

### Green: enum class の実装

```kotlin
package fizzbuzz

enum class FizzBuzzType {
    TYPE_01 {
        override fun generate(n: Int): String = when {
            n % 15 == 0 -> "FizzBuzz"
            n % 3 == 0 -> "Fizz"
            n % 5 == 0 -> "Buzz"
            else -> n.toString()
        }
    },
    TYPE_02 {
        override fun generate(n: Int): String = n.toString()
    },
    TYPE_03 {
        override fun generate(n: Int): String = when {
            n % 15 == 0 -> "FizzBuzz"
            n % 3 == 0 -> "Fizz"
            else -> n.toString()
        }
    };

    abstract fun generate(n: Int): String

    companion object {
        fun create(no: Int): Result<FizzBuzzType> = when (no) {
            1 -> Result.success(TYPE_01)
            2 -> Result.success(TYPE_02)
            3 -> Result.success(TYPE_03)
            else -> Result.failure(IllegalArgumentException("該当するタイプは存在しません: $no"))
        }
    }
}
```

Kotlin 固有の書き方を確認しましょう。

- `abstract fun generate(n: Int): String` は enum class に **抽象メソッド** を宣言します。各定数がこれを実装する義務を負います。
- `TYPE_01 { override fun generate(...) = ... }` のように、enum 定数の直後に本体（**匿名クラス**）を書いて `override` します。定数ごとに異なる実装を持てるため、`FizzBuzzType01`〜`03` のようなサブクラスを別々に作らずに済みます。
- 定数リストの末尾はセミコロン `;` で区切り、そのあとにメソッドや `companion object` を書きます。

### when 式による分岐

各 `generate` 内では `when` を **式** として使います。Kotlin の `when` は値を返す式で、`else` を含めることで「必ず何かを返す」ことが保証されます。`return` を書かずに最後の式が戻り値になる点も Kotlin らしい簡潔さです。

`TYPE_03` には `n % 5 == 0 -> "Buzz"` の枝がないため、`generate(5)` は `else` に落ちて `"5"` を返します。これが「Fizz の場合のみ、Buzz なし」の仕様です。

| 概念 | Kotlin | Ruby | Flix |
|------|--------|------|------|
| 型の列挙 | `enum class { A, B }` | 定数 + `case` | `enum { case A, case B }` |
| 多態の実現 | enum 定数の `override` | ダックタイピング + サブクラス | `trait` + `instance` |
| 分岐 | `when` 式 | `case` / `if` | `match` |
| 保証 | 静的型 + 抽象メソッド | 実行時（規約） | 静的型 + 網羅性検査 |

テストを実行すると全ケースが通ります（Green）。

**TODO リスト**:

- [x] タイプ 1: 通常の FizzBuzz（既存の動作）
- [x] タイプ 2: 数値のみ返す
- [x] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [x] 未定義のタイプはエラー
- [ ] 値オブジェクト FizzBuzzValue の導入

## 7.5 Ruby のダックタイピングとの対比

Ruby では「`generate(number)` に応答するかどうか」だけが問われ、型は問いません。柔軟ですが、実装漏れは実行するまで分かりません。

Kotlin では **静的型と抽象メソッド** によって、コンパイル時に「すべての enum 定数が `generate` を実装しているか」が検査されます。ある定数の `override` を書き忘れるとコンパイルエラーになり、ケースの考慮漏れを型システムが防ぎます。

| 観点 | Kotlin | Ruby |
|------|--------|------|
| 型付け | 静的（コンパイル時検査） | 動的（実行時） |
| 実装保証 | 抽象メソッドで強制 | 規約（応答するかは実行時） |
| 契約の表現 | `interface` / 抽象メソッド | ダックタイピング |
| 拡張方法 | 定数追加・`sealed` 化 | オブジェクト差し替え |

Kotlin は「柔軟さ」より「安全さ」に寄せた設計になっており、リファクタリング時の安心感が高いのが特徴です。

## 7.6 カプセル化 — data class の導入

### 問題: プリミティブ型の使用

現在 `generate()` は `String` を返しています。しかし FizzBuzz の結果には「変換前の数値」と「変換後の文字列」の 2 つの情報が含まれます。プリミティブ型ではこのドメイン知識が表現できません。

### 解決: data class FizzBuzzValue

Kotlin では `data class` を使うことで、不変フィールドのカプセル化と `equals`／`hashCode`／`toString` の自動生成を同時に得られます。

### Red: 値オブジェクトのテスト

```kotlin
package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzValueTest {
    @Test fun `値オブジェクトは数値を保持する`() =
        assertEquals(3, FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3).number)

    @Test fun `値オブジェクトは変換結果を保持する`() =
        assertEquals("Fizz", FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3).value)

    @Test fun `data class は等値比較できる`() =
        assertEquals(FizzBuzzValue(3, "Fizz"), FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3))
}
```

### Green: FizzBuzzValue の実装

```kotlin
package fizzbuzz

data class FizzBuzzValue(val number: Int, val value: String) {
    companion object {
        fun create(type: FizzBuzzType, n: Int): FizzBuzzValue =
            FizzBuzzValue(n, type.generate(n))
    }
}
```

Kotlin 固有の書き方を確認しましょう。

- `data class` は **等値比較（`equals`）**、**ハッシュ（`hashCode`）**、**文字列表現（`toString`）**、**分解宣言（`componentN`）**、**`copy`** を自動生成します。値オブジェクトの実装が 1 行で済みます。
- プロパティを `val` で宣言することで **不変（読み取り専用）** になり、外部からの変更を防ぎます。これがカプセル化です。
- `companion object` の `create` は、タイプに従って値オブジェクトを生成する **ファクトリメソッド** です。`type.generate(n)` の結果と元の数値をまとめて保持します。

`data class は等値比較できる` テストが示すように、`FizzBuzzValue(3, "Fizz")` と `FizzBuzzValue.create(TYPE_01, 3)` は **値による等価** で `true` になります。Ruby では `==` と `eql?`／`hash` を手書きしましたが、Kotlin ではコンパイラが生成します。

| 特徴 | 実現方法（Kotlin） |
|------|-------------------|
| **不変性** | `val` プロパティ |
| **等価性** | `data class` が `equals`/`hashCode` を自動生成 |
| **自己記述性** | `toString` を自動生成 |
| **生成の集約** | `companion object` の `create` |

テストを実行すると全ケースが通ります（Green）。

**TODO リスト**:

- [x] タイプ 1: 通常の FizzBuzz（既存の動作）
- [x] タイプ 2: 数値のみ返す
- [x] タイプ 3: Fizz の場合のみ返す（Buzz なし）
- [x] 未定義のタイプはエラー
- [x] 値オブジェクト FizzBuzzValue の導入

## 7.7 各言語の OOP 比較

| 概念 | Kotlin | Ruby | Java | Flix |
|------|--------|------|------|------|
| 列挙 + 振る舞い | enum 定数の `override` | 定数 + サブクラス | enum の抽象メソッド | `enum` + `trait` |
| 不変フィールド | `val` | `freeze` | `final` | イミュータブル既定 |
| 値オブジェクト | `data class` | `attr_reader` + `==` | `record` | レコードを持つ `enum` |
| 生成の集約 | `companion object` | `self.create` | `static` メソッド | `mod` の関数 |
| 分岐の網羅 | `when` 式 + 抽象メソッド | ダックタイピング | `switch` | `match` + 網羅性検査 |

## 7.8 まとめ

この章で学んだこと。

1. **ポリモーフィズム**: `enum class` に抽象メソッド `generate` を持たせ、各定数で `override` することで条件分岐を型階層に置き換えた（State パターン相当）
2. **when 式**: 値を返す式として簡潔に分岐を書き、`else` で網羅を保証
3. **静的型 vs ダックタイピング**: Ruby の動的な差し替えに対し、Kotlin は抽象メソッドで実装を強制し安全性を確保
4. **カプセル化**: `data class` と `val` で不変な値オブジェクト `FizzBuzzValue` を実現し、等値・toString を自動生成

次の章では、ファーストクラスコレクション、コマンドパターン、ファクトリなど、さらに多くのデザインパターンを Kotlin らしく適用していきます。
