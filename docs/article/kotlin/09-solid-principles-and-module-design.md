# 第 9 章: SOLID 原則とモジュール設計

## 9.1 はじめに

前章までに多くのデザインパターンを適用しました。この章では **SOLID 原則** の観点からコードを検証し、`package` を使った **モジュール設計** に整理します。Kotlin の可視性修飾子（`public`/`private`/`internal`）と `companion object` の使い分けも確認します。

## 9.2 SOLID 原則の検証

### 単一責任原則（SRP: Single Responsibility Principle）

> クラスが変更される理由は一つでなければならない

| 要素 | 責務 | 変更理由 |
|------|------|---------|
| `FizzBuzzValue` | FizzBuzz の結果値を表現 | 値の表現方法が変わるとき |
| `FizzBuzzList` | FizzBuzz の結果コレクションを管理 | コレクション操作が変わるとき |
| `FizzBuzzType.TYPE_01` | タイプ 1 の変換ルール | タイプ 1 のルールが変わるとき |
| `FizzBuzzType.TYPE_02` | タイプ 2 の変換ルール | タイプ 2 のルールが変わるとき |
| `FizzBuzzType.TYPE_03` | タイプ 3 の変換ルール | タイプ 3 のルールが変わるとき |
| `FizzBuzzCommand.ValueCommand` | 単一値の生成操作 | 値の生成方法が変わるとき |
| `FizzBuzzCommand.ListCommand` | リストの生成操作 | リストの生成方法が変わるとき |

各要素が 1 つの責務を持ち、変更理由は 1 つです。SRP を満たしています。enum の各定数が独立したルールを持つため、あるタイプのルール変更が他に波及しません。

### 開放閉鎖原則（OCP: Open-Closed Principle）

> ソフトウェアエンティティは拡張に対して開いていて、修正に対して閉じている

新しいタイプ（例: タイプ 4）を追加する場合。

1. `FizzBuzzType` に `TYPE_04 { override fun generate(...) = ... }` を **追加** する
2. `create` の `when` に 1 行 **追加** する

既存の `TYPE_01`〜`TYPE_03` の実装は一切変更しません。enum 定数ごとに実装が閉じているため、OCP を満たしています。

### リスコフの置換原則（LSP: Liskov Substitution Principle）

> 派生型はその基底型と置換可能でなければならない

`FizzBuzzType` の抽象メソッド `generate(n: Int): String` は、`TYPE_01`〜`TYPE_03` のいずれでも「数値を受け取り文字列を返す」という契約を守ります。呼び出し側は具体的な定数を意識せず `type.generate(n)` を呼べます。同様に `FizzBuzzCommand` の各サブクラスも `execute(n): FizzBuzzList` の契約を守ります。LSP を満たしています。

### インターフェース分離原則（ISP: Interface Segregation Principle）

> クライアントは使わないメソッドへの依存を強制されるべきでない

`FizzBuzzType` は `generate` のみ、`FizzBuzzCommand` は `execute` のみを公開します。肥大化した共通基底を避け、各抽象は必要最小限のメソッドだけを持ちます。値オブジェクトとコレクションも操作を分離しており、ISP を満たしています。

### 依存関係逆転の原則（DIP: Dependency Inversion Principle）

> 上位レベルのモジュールは下位レベルのモジュールに依存してはならない。両方とも抽象に依存すべき

```
FizzBuzzCommand ──→ FizzBuzzType（enum の抽象メソッド）
                          ↑
              TYPE_01, TYPE_02, TYPE_03
```

- コマンド（上位）は `FizzBuzzType` 型に依存し、`type.generate(n)` を呼ぶだけです。
- 具体的な `TYPE_01`〜`03` の分岐には依存しません。
- DIP を満たしています。

## 9.3 依存方向

第 3 部で構築した要素の依存方向は次の通りです。

```
FizzBuzzCommand ──→ FizzBuzzList ──→ FizzBuzzValue ──→ FizzBuzzType
   （コマンド）      （コレクション）    （値オブジェクト）    （タイプ）
```

- `FizzBuzzType` は他の要素に依存しない（最も安定）
- `FizzBuzzValue` は `FizzBuzzType.generate` に依存
- `FizzBuzzList` は `FizzBuzzValue` に依存
- `FizzBuzzCommand` は `FizzBuzzList`・`FizzBuzzValue`・`FizzBuzzType` に依存

依存は一方向で循環がありません。抽象度が高く安定した `FizzBuzzType` に向かって依存が流れています。

## 9.4 モジュール設計 — package 分割

第 7・8 章では、`FizzBuzzType`・`FizzBuzzValue`・`FizzBuzzList`・`FizzBuzzCommand` を単一の `fizzbuzz` package に置いて構築してきました。ここで、責務に基づいて 3 つのレイヤーに **再編成** します。

### 設計方針

| レイヤー | 配置先 package | 責務 |
|---------|---------------|------|
| **ドメインモデル** | `fizzbuzz.domain.model` | 値オブジェクト、コレクション |
| **ドメインタイプ** | `fizzbuzz.domain.type` | ビジネスルール（FizzBuzz 変換） |
| **アプリケーション** | `fizzbuzz.application` | 操作の実行（コマンド） |

### ディレクトリ構成

Kotlin では package 名とディレクトリ構造を一致させるのが慣例です。

```
apps/kotlin/src/main/kotlin/fizzbuzz/
├── domain/
│   ├── model/
│   │   ├── FizzBuzzValue.kt      (FizzBuzzValue)
│   │   └── FizzBuzzList.kt       (FizzBuzzList)
│   └── type/
│       └── FizzBuzzType.kt       (FizzBuzzType enum + create)
└── application/
    └── FizzBuzzCommand.kt        (FizzBuzzCommand + ValueCommand/ListCommand)
```

各ファイルの先頭でレイヤーに対応する package を宣言します。

```kotlin
// domain/type/FizzBuzzType.kt
package fizzbuzz.domain.type
```

```kotlin
// domain/model/FizzBuzzValue.kt
package fizzbuzz.domain.model

import fizzbuzz.domain.type.FizzBuzzType
```

```kotlin
// application/FizzBuzzCommand.kt
package fizzbuzz.application

import fizzbuzz.domain.model.FizzBuzzList
import fizzbuzz.domain.model.FizzBuzzValue
import fizzbuzz.domain.type.FizzBuzzType
```

> **タイプの表現について**: Ruby 版では `FizzBuzzType` 基底クラスと `FizzBuzzType01`〜`03` のサブクラスをファイル分割していますが、Kotlin では `enum class` の各定数に `generate` を `override` させることで、同じ「タイプごとの振る舞い」を 1 ファイルに凝集できます（第 7 章参照）。ファイル数は減りますが、`domain.type` というレイヤーの責務は同一です。

### 依存関係

```
application ──→ domain.model ──→ domain.type
     │               │                │
  コマンド      値・コレクション      タイプ
```

- `domain.type` は他のレイヤーに依存しない（最も安定）
- `domain.model` は `domain.type` に依存する（`FizzBuzzValue.create` が `type.generate` を呼ぶ）
- `application` は `domain.model` と `domain.type` の両方に依存する

依存は一方向（`application → domain.model → domain.type`）に流れ、循環がありません。最も変わりにくいビジネスルール（`domain.type`）が最も安定し、上位のレイヤーがそれに依存する構造です。

Kotlin では `import` で明示的に依存を宣言するため、`build.gradle.kts` の設定なしに package をまたいだ参照ができます。Ruby の「バレルファイル（`require_relative` の集約）」に相当する仕組みは Kotlin では不要で、利用側が必要な package を個別に `import` します。これにより、どのファイルが何に依存しているかが `import` 文から一目で分かります。

### 可視性

Kotlin の可視性修飾子でレイヤー間の公開範囲を制御します。

| 修飾子 | 可視範囲 | 本設計での用途 |
|--------|---------|--------------|
| `public`（既定） | どこからでも | 各レイヤーが公開する API |
| `internal` | 同一モジュール内 | モジュール内部でのみ使うユーティリティ |
| `private` | 同一ファイル / クラス内 | クラス内部の実装詳細 |

`companion object` の `create` にオブジェクト生成を集約し、`sealed class` でコマンドの取りうる型を限定することで、各レイヤーの公開 API を最小限に保っています。

## 9.5 テストのモジュール対応

テストも本体の package 構造に合わせて分割します。

```
apps/kotlin/src/test/kotlin/fizzbuzz/
├── domain/
│   ├── model/
│   │   └── FizzBuzzValueTest.kt   (値オブジェクト・コレクション)
│   └── type/
│       └── FizzBuzzTypeTest.kt    (タイプの変換・ファクトリ)
└── application/
    └── FizzBuzzCommandTest.kt     (コマンド)
```

各テストファイルは対応する本体と同じ package を宣言し、他レイヤーの型は `import` します。

```kotlin
package fizzbuzz.domain.model

import fizzbuzz.domain.type.FizzBuzzType
import kotlin.test.Test
import kotlin.test.assertEquals
```

### テスト実行結果

```bash
$ ./gradlew test

BUILD SUCCESSFUL
```

すべてのテストが通り、第 3 部の実装がレイヤー構造として完成しました。

## 9.6 各言語のモジュール設計比較

| 概念 | Kotlin | Ruby | Java | Flix |
|------|--------|------|------|------|
| モジュール単位 | `package` | ファイル（`require_relative`） | パッケージ | `mod` |
| 公開制御 | `public`/`internal`/`private` | `private`/`protected`/`public` | `public`/package-private | `pub` |
| 静的メンバ | `companion object` | `self.method` | `static` | `mod` の関数 |
| 名前空間 | package 名 | モジュール / クラス | パッケージ名 | `mod` パス |
| 取りうる型の限定 | `sealed class` | なし | `sealed`（Java 17+） | 直和型 |

## 9.7 まとめ

第 3 部（章 7〜9）を通じて、手続き的な FizzBuzz を Kotlin の OOP 設計に進化させました。

| 章 | テーマ | 適用したパターン |
|---|--------|---------------|
| 7 | カプセル化とポリモーフィズム | enum の抽象メソッド（State 相当）、`data class` |
| 8 | デザインパターンの適用 | Value Object、First-Class Collection、Command（`sealed class`）、Factory（`Result`） |
| 9 | SOLID 原則とモジュール設計 | SRP/OCP/LSP/ISP/DIP、`package` 分割、可視性設計 |

### Before / After

**Before**（第 2 部終了時）:

```
FizzBuzz.kt（1 関数中心）
```

**After**（第 3 部終了時）:

```
fizzbuzz/
├── FizzBuzzType.kt      (enum + 抽象メソッド)
├── FizzBuzzValue.kt     (data class)
├── FizzBuzzList.kt      (ファーストクラスコレクション)
└── FizzBuzzCommand.kt   (sealed class)
```

Kotlin の `enum class`・`data class`・`sealed class`・`when` 式・`Result` を組み合わせることで、静的型による安全性と簡潔な記述を両立できました。

次の第 4 部では、関数型プログラミングの観点から FizzBuzz を再構成し、高階関数、不変データ、パイプライン、エラーハンドリングを学びます。
