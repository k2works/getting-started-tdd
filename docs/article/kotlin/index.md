# テスト駆動開発から始める Kotlin 入門

## 概要

FizzBuzz 問題を題材に、テスト駆動開発（TDD）の基本サイクルから、開発環境の整備、オブジェクト指向設計、関数型プログラミングの活用まで、Kotlin の特徴を活かしながら段階的に学びます。JVM 上で動作する静的型付け言語である Kotlin は、OOP と FP をバランスよく融合し、null 安全性・data class・sealed class・拡張関数・高階関数を備えます。

## 対象読者

- Kotlin の基本文法を理解しているプログラミング学習者
- TDD を体験してみたい開発者
- 静的型付けと関数型プログラミングに興味がある方

## 前提条件

- Kotlin 2.x と JDK 21 以降が利用可能であること（Nix 環境推奨: `nix develop .#kotlin`）
- Gradle が利用可能であること

## Kotlin の特徴

| 特徴 | 説明 |
|------|------|
| 静的型付け | コンパイル時に型検査。強力な型推論で記述は簡潔 |
| null 安全性 | `String` と `String?` を型で区別し、NPE をコンパイル時に防ぐ |
| OOP + FP | クラス／インターフェースと、ラムダ・高階関数・不変コレクションを両立 |
| data / sealed class | 値オブジェクトと代数的データ型を簡潔に表現し、`when` で網羅的に分岐 |

## 開発環境

| ツール | バージョン | 用途 |
|--------|-----------|------|
| Kotlin | 2.x | Kotlin コンパイラ |
| JDK | 21 | 実行基盤（JVM） |
| Gradle | 8.x | ビルドツール・依存管理 |
| kotlin.test | 同梱 | テストフレームワーク（JUnit Platform） |
| Nix | - | 開発環境管理 |

## 記事構成

### 第 1 部: TDD の基本サイクル

1. [TODO リストと最初のテスト](01-todo-list-and-first-test.md)
2. [仮実装と三角測量](02-fake-it-and-triangulation.md)
3. [明白な実装とリファクタリング](03-obvious-implementation-and-refactoring.md)

### 第 2 部: 開発環境と自動化

4. [バージョン管理と Conventional Commits](04-version-control-and-conventional-commits.md)
5. [パッケージ管理と静的解析](05-package-management-and-static-analysis.md)
6. [タスクランナーと CI/CD](06-task-runner-and-ci-cd.md)

### 第 3 部: オブジェクト指向設計

7. [カプセル化とポリモーフィズム](07-encapsulation-and-polymorphism.md)
8. [デザインパターンの適用](08-design-patterns.md)
9. [SOLID 原則とモジュール設計](09-solid-principles-and-module-design.md)

### 第 4 部: 関数型プログラミングへの展開

10. [高階関数と関数合成](10-higher-order-functions-and-composition.md)
11. [不変データとパイプライン処理](11-immutable-data-and-pipeline.md)
12. [エラーハンドリングと型安全性](12-error-handling-and-type-safety.md)

## ソースコード

実装コードは [`apps/kotlin/`](https://github.com/k2works/getting-started-tdd/tree/main/apps/kotlin) にあります。
