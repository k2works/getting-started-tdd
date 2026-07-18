# 執筆計画アウトライン

## 概要

「テスト駆動開発から始めるプログラミング入門」シリーズの執筆計画。Wiki 記事（エピソード 1〜4）の内容を再構成し、13 言語環境で統一的な章構成の記事として執筆する。

## 対象言語

`ops/nix/environments/` に定義された 13 言語環境：

| 環境名 | 言語 | エピソード数 | 備考 |
|--------|------|-------------|------|
| java | Java | 3 | OOP 代表 |
| node | JavaScript / TypeScript | 3 + 3 | 2 言語を 1 環境で |
| python | Python | 3 | マルチパラダイム |
| ruby | Ruby | 4 | エピソード 4 はパフォーマンス |
| php | PHP | 3 | Web 特化 |
| go | Go | 3 | シンプル志向 |
| rust | Rust | 3 | 所有権・メモリ安全性 |
| dotnet | C# / F# | 3 + 4 | 2 言語を 1 環境で |
| clojure | Clojure | 4 | LISP + 関数型 |
| scala | Scala | 4 | OOP + FP ハイブリッド |
| elixir | Elixir | 4 | Erlang VM + 関数型 |
| haskell | Haskell | 4 | 純粋関数型 |
| flix | Flix | 4 | JVM + 関数型・代数的効果 |

## 章構成

Wiki 記事のエピソード 1〜4 を 12 章に再構成する。

### 第 1 部: TDD の基本サイクル（エピソード 1 相当）

Wiki エピソード 1 の内容を 3 章に分割。FizzBuzz 問題を題材にした TDD サイクルの体験。

| 章 | テーマ | Wiki 参照元 | 内容 |
|----|--------|-----------|------|
| 1 | TODO リストと最初のテスト | エピソード 1 前半 | 仕様理解、TODO リスト作成、テスティングフレームワーク導入、テストファースト |
| 2 | 仮実装と三角測量 | エピソード 1 中盤 | 仮実装（ハードコーディング）、三角測量による一般化 |
| 3 | 明白な実装とリファクタリング | エピソード 1 後半 | 明白な実装、学習用テスト、「動作するきれいなコード」 |

### 第 2 部: 開発環境と自動化（エピソード 2 相当）

Wiki エピソード 2 の内容を 3 章に分割。ソフトウェア開発の三種の神器。

| 章 | テーマ | Wiki 参照元 | 内容 |
|----|--------|-----------|------|
| 4 | バージョン管理と Conventional Commits | エピソード 2 前半 | Git フロー、Conventional Commits ルール |
| 5 | パッケージ管理と静的解析 | エピソード 2 中盤 | パッケージマネージャ、リンター、フォーマッター、カバレッジ |
| 6 | タスクランナーと CI/CD | エピソード 2 後半 | タスクランナー、自動化、CI/CD パイプライン構築 |

### 第 3 部: オブジェクト指向設計（エピソード 3 相当）

Wiki エピソード 3 の内容を 3 章に分割。手続き型からオブジェクト指向へのリファクタリング。

| 章 | テーマ | Wiki 参照元 | 内容 |
|----|--------|-----------|------|
| 7 | カプセル化とポリモーフィズム | エピソード 3 前半 | 追加仕様、フィールドカプセル化、setter 削除、State/Strategy パターン |
| 8 | デザインパターンの適用 | エピソード 3 中盤 | Command、Factory Method、Null Object、値オブジェクト |
| 9 | SOLID 原則とモジュール設計 | エピソード 3 後半 | 単一責任原則、モジュール分割、ドメインモデル、例外処理 |

### 第 4 部: 関数型プログラミングへの展開（エピソード 4 相当）

Wiki エピソード 4 の内容を 3 章に分割。OOP から FP への移行。

| 章 | テーマ | Wiki 参照元 | 内容 |
|----|--------|-----------|------|
| 10 | 高階関数と関数合成 | エピソード 4 前半 | 高階関数、カリー化、関数合成、パイプライン |
| 11 | 不変データとパイプライン処理 | エピソード 4 中盤 | 不変データ構造、副作用の分離、ストリーム処理 |
| 12 | エラーハンドリングと型安全性 | エピソード 4 後半 | Result/Either 型、パターンマッチング、代数的データ型 |

**注**: エピソード 4 がない言語（Java、JS/TS、Python、PHP、Go、Rust）は、各言語で利用可能な関数型機能の範囲で執筆する。

## 言語ごとのバリエーション

### 3 エピソード言語（第 1〜3 部が中心）

| 言語 | 第 4 部の扱い |
|------|-------------|
| Java | Stream API、Optional、Lambda 式 |
| JavaScript | アロー関数、Array メソッド、Promise |
| TypeScript | ジェネリクス、ユニオン型、型ガード |
| Python | ジェネレータ、デコレータ、functools |
| PHP | アロー関数、array_map/filter/reduce |
| Go | ファーストクラス関数、クロージャ、ジェネリクス |
| Rust | Iterator、Option/Result、所有権とクロージャ |

### 4 エピソード言語（第 4 部がフル対応）

| 言語 | 第 4 部の特色 |
|------|-------------|
| C# | LINQ、パターンマッチング、非同期ストリーム |
| F# | 判別共用体、Computation Expression、パイプライン |
| Clojure | スレッディングマクロ、トランスデューサー、REPL 駆動 |
| Scala | sealed trait/case object、for 内包表記、Cats/ZIO |
| Elixir | with 構文、GenServer、パイプラインオペレータ |
| Haskell | モナド合成、型クラス、do 記法 |
| Ruby | Enumerable、ブロック/Proc/Lambda、ベンチマーク |
| Flix | 代数的効果、Datalog 制約、型クラス（trait）、パイプライン |

## ファイル構成

```
docs/article/
├── index.md              # 記事トップページ（目次）
├── outline.md            # 本ファイル（執筆計画）
├── workflow.md           # 執筆ワークフロー
├── java/                 # Java
│   ├── index.md
│   ├── 01-todo-list-and-first-test.md
│   ├── ...
│   └── 12-error-handling-and-type-safety.md
├── node/                 # JavaScript / TypeScript
│   ├── index.md
│   └── ...
├── python/               # Python
│   ├── index.md
│   └── ...
├── ruby/                 # Ruby
│   ├── index.md
│   └── ...
├── php/                  # PHP
│   ├── index.md
│   └── ...
├── go/                   # Go
│   ├── index.md
│   └── ...
├── rust/                 # Rust
│   ├── index.md
│   └── ...
├── dotnet/               # C# / F#
│   ├── index.md
│   └── ...
├── clojure/              # Clojure
│   ├── index.md
│   └── ...
├── scala/                # Scala
│   ├── index.md
│   └── ...
├── elixir/               # Elixir
│   ├── index.md
│   └── ...
├── haskell/              # Haskell
│   ├── index.md
│   └── ...
├── flix/                 # Flix
│   ├── index.md
│   └── ...
└── all/                  # 多言語統合解説
    ├── index.md
    └── ...
```

## 実装コードの配置

各言語の実装コードは `apps/` ディレクトリに配置する。

```
apps/
├── java/                 # Java プロジェクト
├── node/                 # JavaScript / TypeScript プロジェクト
├── python/               # Python プロジェクト
├── ruby/                 # Ruby プロジェクト
├── php/                  # PHP プロジェクト
├── go/                   # Go プロジェクト
├── rust/                 # Rust プロジェクト
├── dotnet/               # C# / F# プロジェクト
├── clojure/              # Clojure プロジェクト
├── scala/                # Scala プロジェクト
├── elixir/               # Elixir プロジェクト
├── haskell/              # Haskell プロジェクト
└── flix/                 # Flix プロジェクト
```

## Flix 追加執筆計画

Flix は JVM 上で動作する関数型ファーストの言語で、代数的効果（algebraic effects）と Datalog による論理プログラミングを第一級でサポートする点が特色。純粋関数型言語（Haskell）に近い立ち位置ながら、効果システムとトレイト（型クラス相当）を備えるため、全 4 部（12 章）をフルに執筆できる。

### 前提整備

| 項目 | 内容 | 状態 |
|------|------|------|
| Nix 環境 | `ops/nix/environments/flix/`（JDK 21 + flix.jar ブートストラップ）を追加し flake に登録 | 完了 |
| アプリ雛形 | `apps/flix/` に Flix プロジェクト（`flix.toml`, `src/`, `test/`）を作成 | 完了 |
| テスト基盤 | Flix 標準の `@Test` アノテーションと `flix test` を採用 | 完了 |
| 記事ディレクトリ | `docs/article/flix/`（`index.md` + 01〜12） | 完了 |

### 章別執筆計画

| 章 | テーマ | Flix での焦点 |
|----|--------|--------------|
| 1 | TODO リストと最初のテスト | `@Test` と `flix test`、`Assert.eq`、テストファースト |
| 2 | 仮実装と三角測量 | ハードコーディング → パターンマッチによる一般化 |
| 3 | 明白な実装とリファクタリング | 純粋関数、`mod` によるモジュール化、動作するきれいなコード |
| 4 | バージョン管理と Conventional Commits | Git フロー（言語共通） |
| 5 | パッケージ管理と静的解析 | `flix.toml`、`flix build`、型検査・効果検査 |
| 6 | タスクランナーと CI/CD | `flix test` の CI 組み込み、Nix による再現ビルド |
| 7 | カプセル化とポリモーフィズム | 列挙型（enum）、トレイト（trait）による多相 |
| 8 | デザインパターンの適用 | 代数的データ型、`Option`/Null Object、値としての関数 |
| 9 | SOLID 原則とモジュール設計 | `mod` 分割、トレイト境界、`Result` による例外表現 |
| 10 | 高階関数と関数合成 | `>>`/`<<` 合成、カリー化、`Functor`/`Foldable` |
| 11 | 不変データとパイプライン処理 | 不変データ、`List`/`Chain`、`|>` パイプライン、効果分離 |
| 12 | エラーハンドリングと型安全性 | `Result`/`Option`、パターンマッチ、代数的効果によるエラー処理 |

### 進め方

1. `ops/nix/environments/flix/` と `apps/flix/` の雛形を用意し、`flix test` が通る最小構成を確認する（第 1〜3 部の TDD 基盤）。
2. `orchestrating-development` スキルに従い、章ごとに記事執筆と TDD 実装を同期させる（Haskell の 4 エピソード言語構成を参考にする）。
3. Flix 固有の代数的効果・Datalog は第 4 部（第 11〜12 章）で重点的に扱い、他の関数型言語との差分を `docs/article/all/` に反映する。
