# テスト駆動開発から始める Flix 入門

JVM 上で動作する関数型ファースト言語 Flix で、TDD（テスト駆動開発）を実践しながら FizzBuzz を段階的に構築していきます。Flix は ML 系の型システムに加えて、**代数的効果（algebraic effects）**、**トレイト（trait）**、**Datalog による論理プログラミング**を第一級でサポートする点が特徴です。

## 対象読者

- プログラミングの基礎知識を持つ開発者
- 関数型言語と TDD に興味がある方
- 代数的効果や効果システムを実践的に学びたい方

## 開発環境

| ツール | バージョン | 用途 |
|--------|-----------|------|
| Flix | 0.75.1 | Flix コンパイラ・ビルドツール |
| JDK | 25 | 実行基盤（JVM） |
| flix test | 同梱 | 標準テストフレームワーク（`@Test`） |
| Nix | - | 開発環境管理 |

Flix は単一の `flix.jar` として配布され、`java -jar flix.jar` で実行します。ビルド・テスト・パッケージ管理・LSP がすべて同梱されています。

## 記事構成

### 第 1 部: TDD の基本サイクル

1. [TODO リストと最初のテスト](01-todo-list-and-first-test.md)
2. [仮実装と三角測量](02-fake-it-and-triangulation.md)
3. [明白な実装とリファクタリング](03-obvious-implementation-and-refactoring.md)

### 第 2 部: 開発環境と自動化

4. [バージョン管理と Conventional Commits](04-version-control-and-conventional-commits.md)
5. [パッケージ管理と静的解析](05-package-management-and-static-analysis.md)
6. [タスクランナーと CI/CD](06-task-runner-and-ci-cd.md)

### 第 3 部: 列挙型とトレイト

7. [列挙型とトレイトによるポリモーフィズム](07-enums-and-traits.md)
8. [パターンマッチと代数的データ型](08-pattern-matching-and-adt.md)
9. [モジュール設計と SOLID 原則](09-modules-and-module-design.md)

### 第 4 部: 関数型プログラミングと代数的効果

10. [高階関数と関数合成](10-higher-order-functions-and-composition.md)
11. [不変データとパイプライン処理](11-immutable-data-and-pipeline.md)
12. [エラーハンドリングと代数的効果](12-error-handling-and-effects.md)

## ソースコード

実装コードは [`apps/flix/`](https://github.com/k2works/getting-started-tdd/tree/main/apps/flix) にあります。
