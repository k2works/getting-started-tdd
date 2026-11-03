# 第 8 章: デザインパターンの適用

## 8.1 はじめに

前章ではカプセル化とポリモーフィズムを使って、手続き的な条件分岐を `enum class` の抽象メソッドに置き換え、`data class` で値オブジェクトを導入しました。この章では、さらに多くの **デザインパターン** を適用して、コードの表現力と安全性を向上させます。

Kotlin の `data class`、`class`、`sealed class`、`when` 式、`Result` を活用します。

**TODO リスト**:

- [ ] 値オブジェクト（Value Object）
- [ ] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.2 値オブジェクト（Value Object）

前章で導入した `FizzBuzzValue` が値オブジェクトです。改めてデザインパターンの観点から整理します。

```kotlin
package fizzbuzz

data class FizzBuzzValue(val number: Int, val value: String) {
    companion object {
        fun create(type: FizzBuzzType, n: Int): FizzBuzzValue =
            FizzBuzzValue(n, type.generate(n))
    }
}
```

`data class` は値オブジェクトを実装する最短経路です。Ruby では `==`／`eql?`／`hash`／`to_s` を手書きしましたが、Kotlin ではコンパイラが自動生成します。

| 特徴 | 実現方法 |
|------|---------|
| **不変性** | `val` プロパティ（setter なし） |
| **等価性** | `data class` が `equals` を自動生成（値による比較） |
| **自己記述性** | `toString` を自動生成 |
| **ハッシュキー対応** | `hashCode` を自動生成 |
| **生成の集約** | `companion object` の `create` |

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [ ] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.3 ファーストクラスコレクション（First-Class Collection）

### 問題: 生のリストの使用

`List<FizzBuzzValue>` をそのまま扱うと、コレクションに対する操作（生成・件数取得）が外部に散らばります。

### 解決: FizzBuzzList クラス

生のリストを専用クラスで包み、コレクション操作をクラス内に集約します。

### Red: コレクションのテスト

```kotlin
package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzValueTest {
    @Test fun `100 件のコレクションを生成する`() =
        assertEquals(100, FizzBuzzList.create(100, FizzBuzzType.TYPE_01).count)

    @Test fun `コレクションの 15 番目は FizzBuzz`() =
        assertEquals("FizzBuzz", FizzBuzzList.create(100, FizzBuzzType.TYPE_01).values[14].value)
}
```

### Green: FizzBuzzList の実装

```kotlin
package fizzbuzz

class FizzBuzzList(val values: List<FizzBuzzValue>) {
    val count: Int get() = values.size

    companion object {
        fun create(count: Int, type: FizzBuzzType): FizzBuzzList =
            FizzBuzzList((1..count).map { FizzBuzzValue.create(type, it) })
    }
}
```

Kotlin 固有の書き方を確認しましょう。

- `class FizzBuzzList(val values: List<FizzBuzzValue>)` は生のリストをラップする **ファーストクラスコレクション** です。`List<FizzBuzzValue>` と `FizzBuzzList` は別の型として扱われるため、無関係なリストを誤って渡せません。
- `val count: Int get() = values.size` は **カスタム getter** を持つ計算プロパティです。フィールドを持たず、参照するたびにサイズを返します。
- `(1..count).map { FizzBuzzValue.create(type, it) }` は **範囲式 `1..count`** に対し `map` を適用し、暗黙引数 `it`（各数値）から値オブジェクトを生成します。
- `create` は `companion object` に置かれた **ファクトリメソッド** で、件数とタイプから一括生成します。

`count` は `values.size` に委譲するため、コレクションの件数取得ロジックがクラス内に閉じ込められます。`コレクションの 15 番目は FizzBuzz` テストは `values[14]`（0 始まりの 15 番目）が `FizzBuzz` であることを確認します。

| 特徴 | 実現方法（Kotlin） |
|------|-------------------|
| **カプセル化** | コレクション操作を `FizzBuzzList` に集約 |
| **型安全** | 生の `List` と別の型として扱う |
| **件数管理** | `count` 計算プロパティ |
| **生成の集約** | `companion object` の `create` |

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [ ] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.4 コマンドパターン（Command Pattern）

### 問題: 操作の直接実行

「単一の値を生成する」と「リストを生成する」という 2 種類の操作を、呼び出し側が直接使い分けるのは煩雑です。操作をオブジェクトとして表現すれば、実行の定義と呼び出しを分離できます。

### 解決: sealed class FizzBuzzCommand

Kotlin では `sealed class` を使い、「取りうる操作の全体」を型として閉じた集合で表現します。

### Red: コマンドのテスト

```kotlin
package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzCommandTest {
    @Test fun `ValueCommand は単一要素のコレクション`() {
        val result = FizzBuzzCommand.ValueCommand(FizzBuzzType.TYPE_01).execute(3)
        assertEquals(1, result.count)
        assertEquals("Fizz", result.values[0].value)
    }

    @Test fun `ListCommand は 1 から n までのコレクション`() {
        val result = FizzBuzzCommand.ListCommand(FizzBuzzType.TYPE_01).execute(100)
        assertEquals(100, result.count)
    }
}
```

### Green: FizzBuzzCommand の実装

```kotlin
package fizzbuzz

sealed class FizzBuzzCommand {
    data class ValueCommand(val type: FizzBuzzType) : FizzBuzzCommand()
    data class ListCommand(val type: FizzBuzzType) : FizzBuzzCommand()

    fun execute(n: Int): FizzBuzzList = when (this) {
        is ValueCommand -> FizzBuzzList(listOf(FizzBuzzValue.create(type, n)))
        is ListCommand -> FizzBuzzList.create(n, type)
    }
}
```

Kotlin 固有の書き方を確認しましょう。

- `sealed class FizzBuzzCommand` は **シールドクラス** です。サブクラスは同一ファイル（またはモジュール）内に限定され、コンパイラが「取りうる型はこの 2 つだけ」と把握できます。
- `ValueCommand` と `ListCommand` は `data class` として定義し、コマンドが保持するパラメータ（`type`）を等値比較可能にしています。
- `when (this)` は自身の型で分岐する式です。`sealed class` に対する `when` は **網羅性チェック** を受けます。すべてのサブクラスを列挙していれば `else` は不要で、逆にケースを書き忘れるとコンパイルエラーになります。
- `is ValueCommand ->` の枝の中では **スマートキャスト** が働き、`this` は `ValueCommand` として扱われるため、`type` にそのままアクセスできます。キャストを明示的に書く必要はありません。

`ValueCommand` は単一要素のコレクションを、`ListCommand` は 1 から n までのコレクションを返します。どちらも戻り値は `FizzBuzzList` に統一されています。

### コマンドパターンの利点

- **操作の具象化**: 「何をするか」を型（`ValueCommand`／`ListCommand`）で表現
- **パラメータの保持**: 実行に必要な `type` をコマンド内に保持
- **実行の分離**: 操作の「定義」と `execute` による「実行」を分離
- **網羅性の保証**: `sealed class` + `when` で操作の追加漏れをコンパイル時に検出

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [x] コマンドパターン（Command）
- [ ] ファクトリメソッド（Factory Method）

## 8.5 ファクトリメソッドと Result

前章の `FizzBuzzType.create` は、番号からタイプを生成する **ファクトリメソッド** です。ここでは失敗を型で表現するために Kotlin の `Result` を使っています。

```kotlin
companion object {
    fun create(no: Int): Result<FizzBuzzType> = when (no) {
        1 -> Result.success(TYPE_01)
        2 -> Result.success(TYPE_02)
        3 -> Result.success(TYPE_03)
        else -> Result.failure(IllegalArgumentException("該当するタイプは存在しません: $no"))
    }
}
```

- `Result<FizzBuzzType>` は「成功なら `FizzBuzzType`、失敗なら例外を包む」型です。例外を投げる代わりに戻り値で成否を表現します。
- `Result.success(...)` / `Result.failure(...)` で成功・失敗を構築します。
- 呼び出し側は `getOrNull()` で成功値を、`isFailure` で失敗を判定できます（第 7 章のテスト参照）。

例外を throw する Ruby の `raise` と異なり、Kotlin の `Result` は **失敗の可能性を型シグネチャに表す** ため、呼び出し側に処理を促せます。

**TODO リスト**:

- [x] 値オブジェクト（Value Object）
- [x] ファーストクラスコレクション（First-Class Collection）
- [x] コマンドパターン（Command）
- [x] ファクトリメソッド（Factory Method）

## 8.6 適用したデザインパターン一覧

| パターン | 実装 | 役割 |
|---------|------|------|
| **Value Object** | `data class FizzBuzzValue` | 不変の値を表現 |
| **First-Class Collection** | `class FizzBuzzList` | コレクション操作のカプセル化 |
| **State（Strategy 相当）** | `enum class FizzBuzzType` + 抽象メソッド | アルゴリズムの切り替え |
| **Factory Method** | `FizzBuzzType.create()` | 生成の集約（`Result` で失敗表現） |
| **Command** | `sealed class FizzBuzzCommand` | 操作のオブジェクト化 |

## 8.7 各言語のデザインパターン比較

| パターン | Kotlin | Ruby | Java | Flix |
|---------|--------|------|------|------|
| Value Object | `data class` | `attr_reader` + `==` | `record` | レコードを持つ `enum` |
| Collection | ラップした `class` + 計算プロパティ | `Enumerable` + `freeze` | 不変 `List` ラップ | リストを包む `enum` |
| Command | `sealed class` + `when` | `module`（Mix-in） | `interface` 実装 | 直和型 + `match` |
| 網羅の保証 | `sealed` + `when` | なし（実行時） | `switch`（限定的） | `match` + 網羅性検査 |
| 失敗表現 | `Result` | 例外（`raise`） | 例外 / `Optional` | `Result` / エフェクト |

## 8.8 まとめ

この章で学んだこと。

1. **値オブジェクト**: `data class` でプリミティブ型をドメイン固有のオブジェクトに置き換え、等値・toString を自動生成
2. **ファーストクラスコレクション**: `class FizzBuzzList` でコレクション操作をカプセル化し、`count` 計算プロパティと `create` ファクトリを提供
3. **コマンドパターン**: `sealed class` + `when (this)` の網羅チェックと `is` によるスマートキャストで操作を型安全にオブジェクト化
4. **ファクトリメソッドと Result**: `companion object` に生成を集約し、`Result` で失敗を型として表現

次の章では、SOLID 原則の観点からコードを検証し、package を使ったモジュール構造に整理します。
