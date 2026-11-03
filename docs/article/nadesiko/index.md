# テスト駆動開発から始める なでしこ3 入門

## 概要

FizzBuzz 問題を題材に、テスト駆動開発（TDD）の基本サイクルから、開発環境の整備、構造化設計、関数型スタイルの活用まで、なでしこ3 の特徴を活かしながら段階的に学びます。なでしこ3 は日本語で記述するプログラミング言語で、`3をFizzBuzz変換` のように「〜を〜する」という日本語の語順と **助詞** で引数を受け渡します。英語のキーワードに頼らず、テストも設計も日本語の文として書ける点が、これまでの言語との大きな違いです。

処理系には、Go 言語で実装された互換処理系 [nadesiko3go](https://github.com/kujirahand/nadesiko3go) の CLI 版 `gonako` を使います。

## 対象読者

- なでしこ3 の基本文法（変数・関数・もし・繰り返す）を理解しているプログラミング学習者
- TDD を体験してみたい開発者
- 日本語プログラミングや、英語キーワードに依らない言語設計に興味がある方

## 前提条件

- `gonako` 3.8.8 が利用可能であること（Nix 環境推奨: `nix develop .#nadesiko`。Nix 環境に入ると固定コミットから自動でビルドされます）
- `make` が利用可能であること

## なでしこ3 の特徴

| 特徴 | 説明 |
|------|------|
| 日本語の語順 | 「〜を〜する」の語順で書き、`〜して` で命令を連鎖させる |
| 助詞による引数 | `●(タイプでNを)タイプ変換` のように、引数の役割を位置ではなく助詞で表す |
| 動的型付け | 値の型は実行時に決まる。`変数型確認` で型を調べられる |
| 辞書と無名関数 | クラス構文の代わりに、辞書・`関数(X) … ここまで`・クロージャで設計する |

## 開発環境

| ツール | バージョン | 用途 |
|--------|-----------|------|
| gonako（nadesiko3go） | 3.8.8 | なでしこ3 の処理系（実行・lint・format・doctest） |
| Go | 1.26 以上（自動取得） | gonako のビルド |
| ASSERT等 + テスト補助 | 組み込み / 自作 | 表明とテスト結果の集計 |
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

7. [辞書と関数によるポリモーフィズム](07-dictionary-dispatch-and-polymorphism.md)
8. [デザインパターンの適用](08-design-patterns.md)
9. [SOLID 原則とモジュール設計](09-solid-principles-and-module-design.md)

### 第 4 部: 関数型プログラミングへの展開

10. [高階関数と関数合成](10-higher-order-functions-and-composition.md)
11. [不変データとパイプライン処理](11-immutable-data-and-pipeline.md)
12. [エラーハンドリングと型安全性](12-error-handling-and-type-safety.md)

## ソースコード

実装コードは [`apps/nadesiko/`](https://github.com/k2works/getting-started-tdd/tree/main/apps/nadesiko) にあります。
