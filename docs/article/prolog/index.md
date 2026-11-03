# テスト駆動開発から始める Prolog 入門

## 概要

FizzBuzz 問題を題材に、テスト駆動開発（TDD）の基本サイクルから、開発環境の整備、構造化設計、宣言的・論理型プログラミングの活用まで、Prolog の特徴を活かしながら段階的に学びます。Prolog は単一化（unification）とバックトラッキングを基礎とする論理型言語で、関数の代わりに述語（predicate）を、代入の代わりに単一化を、条件分岐の代わりに複数節（clause）とパターンマッチを用います。命令型・OOP・FP のいずれとも異なるパラダイムを、同じ TDD サイクルで体験します。

## 対象読者

- Prolog の基本文法を理解しているプログラミング学習者
- TDD を体験してみたい開発者
- 論理型・宣言的プログラミングに興味がある方

## 前提条件

- SWI-Prolog 9.x が利用可能であること（Nix 環境推奨: `nix develop .#prolog`）
- `make` が利用可能であること

## Prolog の特徴

| 特徴 | 説明 |
|------|------|
| 論理型・宣言的 | 「どう計算するか」ではなく「何が真か」を述語で記述する |
| 単一化 | 代入ではなく単一化で変数を束縛。一度束縛した変数は不変 |
| 複数節ディスパッチ | 同名述語を複数の節で定義し、パターンで振る舞いを切り替える |
| 高階述語 | `call/N`・`maplist`・`foldl`・`include` で述語を値として扱う |

## 開発環境

| ツール | バージョン | 用途 |
|--------|-----------|------|
| SWI-Prolog | 9.x | Prolog 処理系 |
| plunit | 同梱 | テストフレームワーク |
| make | - | タスクランナー |
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

### 第 3 部: 構造化設計

7. [複数節ディスパッチとポリモーフィズム](07-clause-dispatch-and-polymorphism.md)
8. [項とデザインパターン](08-terms-and-design-patterns.md)
9. [モジュール設計](09-modules-and-module-design.md)

### 第 4 部: 宣言的プログラミングへの展開

10. [高階述語と述語合成](10-higher-order-predicates-and-composition.md)
11. [不変データとパイプライン処理](11-immutable-data-and-pipeline.md)
12. [エラーハンドリングと型安全性](12-error-handling-and-type-safety.md)

## ソースコード

実装コードは [`apps/prolog/`](https://github.com/k2works/getting-started-tdd/tree/main/apps/prolog) にあります。
