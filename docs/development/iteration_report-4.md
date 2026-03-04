# イテレーション 4 完了報告書

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **プロジェクト名** | テスト駆動開発から始めるXX入門 |
| **イテレーション** | 4 |
| **対象言語** | Ruby |
| **開始日** | 2026-03-02 |
| **終了日** | 2026-03-02 |
| **作業日数** | 1 日（AI + Codex 自動化） |

### 要員

| 項目 | 予定 | 実績 |
|------|------|------|
| **作業日数** | 10 日 | 1 日 |
| **開発者** | 1 名 + AI | 1 名 + AI + Codex |

---

## 指標

### ビルド結果

| 項目 | 結果 |
|------|------|
| テスト（Minitest） | ✅ 39 passed, 72 assertions |
| ベンチマーク（Minitest::Benchmark） | ✅ 3 passed |
| RuboCop | ✅ 25 files inspected, no offenses |
| カバレッジ（SimpleCov） | ✅ Line 95.95%, Branch 100% |

### リリースバーンダウン

**リリースバーンダウン（計画 vs 実績）**

| 時点 | 計画残 SP | 実績残 SP |
|------|----------|----------|
| 開始 | 149 | 149 |
| IT1 | 139 | 139 |
| IT2 | 129 | 129 |
| IT3 | 116 | 116 |
| IT4 | 103 | 103 |
| IT5 | 93 | - |
| IT6 | 83 | - |
| IT7 | 73 | - |
| IT8 | 60 | - |
| IT9 | 47 | - |
| IT10 | 34 | - |
| IT11 | 21 | - |
| IT12 | 0 | - |

### イテレーションバーンダウン

**IT4 バーンダウン**

| 時点 | 計画残 SP | 実績残 SP |
|------|----------|----------|
| 開始 | 13 | 13 |
| 環境構築 | 12 | 12 |
| 第1部 | 9 | 9 |
| 第2部 | 6 | 6 |
| 第3部 | 3 | 3 |
| 第4部 | 0 | 0 |

### ベロシティ

**ベロシティ推移**

| イテレーション | 実績 SP | 平均 SP |
|---------------|---------|---------|
| IT1 | 10 | 10 |
| IT2 | 10 | 10 |
| IT3 | 13 | 11 |
| IT4 | 13 | 11.5 |

| イテレーション | 計画 SP | 実績 SP | 累計 SP |
|---------------|---------|---------|---------|
| IT1（Java） | 10 | 10 | 10 |
| IT2（Python） | 10 | 10 | 20 |
| IT3（Node/TS） | 13 | 13 | 33 |
| IT4（Ruby） | 13 | 13 | 46 |
| **平均** | **11.5** | **11.5** | |

---

## 実施内容と評価

### 完了ストーリー一覧

| ID | ストーリー | 結果 | 予定 SP | 完了 SP |
|----|-----------|------|---------|---------|
| US-004 | Ruby の TDD 入門記事の執筆と実装 | ✅ 完了 | 13 | 13 |

### 達成率

| 項目 | 計画 | 実績 | 達成率 |
|------|------|------|--------|
| ストーリーポイント | 13 SP | 13 SP | 100% |
| ストーリー数 | 1 | 1 | 100% |
| 記事数 | 12 章 | 12 章 | 100% |
| テスト数 | - | 39 | - |

---

## 成果物詳細

### US-004: Ruby の TDD 入門記事の執筆と実装

#### 記事

| ファイル | 章タイトル | 行数 |
|---------|-----------|------|
| `01-todo-list-and-first-test.md` | TODO リストと最初のテスト | 231 |
| `02-fake-it-and-triangulation.md` | 仮実装と三角測量 | 238 |
| `03-obvious-implementation-and-refactoring.md` | 明白な実装とリファクタリング | 228 |
| `04-version-control-and-conventional-commits.md` | バージョン管理と Conventional Commits | 112 |
| `05-package-management-and-static-analysis.md` | パッケージ管理と静的解析 | 287 |
| `06-task-runner-and-ci-cd.md` | タスクランナーと CI/CD | 248 |
| `07-encapsulation-and-polymorphism.md` | カプセル化とポリモーフィズム | 279 |
| `08-design-patterns.md` | デザインパターンの適用 | 329 |
| `09-solid-principles-and-module-design.md` | SOLID 原則とモジュール設計 | 196 |
| `10-higher-order-functions-and-composition.md` | 高階関数と関数合成 | 175 |
| `11-immutable-data-and-pipeline.md` | 不変データとパイプライン処理 | 233 |
| `12-error-handling-and-type-safety.md` | エラーハンドリングと型安全性 | 398 |
| **合計** | | **2,954** |

#### 実装

```
apps/ruby/lib/
├── fizz_buzz/
│   ├── fizz_buzz.rb                      (バレルファイル)
│   ├── domain/
│   │   ├── model/
│   │   │   ├── fizz_buzz_value.rb        (値オブジェクト + パターンマッチング)
│   │   │   └── fizz_buzz_list.rb         (コレクション + FP メソッド)
│   │   └── type/
│   │       ├── fizz_buzz_type.rb         (基底 + ファクトリ + FizzBuzzTypeName)
│   │       ├── fizz_buzz_type_01.rb      (タイプ 1: 通常)
│   │       ├── fizz_buzz_type_02.rb      (タイプ 2: 数値のみ)
│   │       └── fizz_buzz_type_03.rb      (タイプ 3: FizzBuzz のみ)
│   └── application/
│       ├── fizz_buzz_command.rb           (コマンドインターフェース)
│       ├── fizz_buzz_value_command.rb     (単一値コマンド)
│       └── fizz_buzz_list_command.rb      (リストコマンド + then パイプライン)
└── fibonacci/
    ├── fibonacci.rb                       (バレルファイル)
    ├── command.rb                         (Strategy パターン)
    ├── recursive.rb                       (再帰 + メモ化)
    ├── loop.rb                            (ループ)
    └── general_term.rb                    (一般項: 数学公式)
```

#### コード規模

| 対象 | ファイル数 | 行数 |
|------|----------|------|
| ソースコード | 15 | 290 |
| テストコード | 7 | 723 |
| 合計 | 22 | 1,013 |

#### 主要な設計パターン

| パターン | 適用箇所 |
|---------|---------|
| Strategy | FizzBuzzType + 具体タイプ、Fibonacci::Command |
| Factory Method | FizzBuzzType.create() / try_create() |
| Value Object | FizzBuzzValue（`==`, `eql?`, `hash`, `deconstruct_keys`） |
| First-Class Collection | FizzBuzzList（Enumerable Mix-in + FP メソッド） |
| Command | FizzBuzzCommand + 実装クラス |

#### Java/Python/Node との対比

| 概念 | Java | Python | TypeScript | Ruby |
|------|------|--------|-----------|------|
| 抽象クラス | `abstract class` | `abc.ABC` | `abstract class` | 基底クラス + `NotImplementedError` |
| テストフレームワーク | JUnit 5 | pytest | Vitest | Minitest |
| パッケージ管理 | Maven/Gradle | uv/poetry | npm | Bundler |
| 静的解析 | Checkstyle + PMD | Ruff + mypy | ESLint + tsc | RuboCop |
| 不変性 | `final` | `@dataclass(frozen=True)` | `readonly` + `Object.freeze()` | `freeze` + `dup.freeze` |
| Null 安全 | `Optional<T>` | `T \| None` | `T \| undefined` | `nil` + `&.` |
| 列挙型 | `enum` | `enum.Enum` | `enum` | Module 定数 |
| 関数合成 | `Function.andThen()` | `functools.reduce` | `compose()` / `pipe()` | `>>` / `<<` 演算子 |
| ベンチマーク | JMH | timeit | カスタム | Minitest::Benchmark |

---

## 品質メトリクス

### テストカバレッジ

| メトリクス | 目標 | 実績 | 判定 |
|-----------|------|------|------|
| Line Coverage | 80%+ | 95.95% (142/148) | ✅ |
| Branch Coverage | 80%+ | 100.0% (20/20) | ✅ |

### テスト数

| テストファイル | テスト数 | アサーション数 |
|--------------|---------|-------------|
| fizz_buzz_type_test.rb | 13 | 18 |
| fizz_buzz_list_test.rb | 13 | 17 |
| fizz_buzz_value_test.rb | 6 | 7 |
| fizz_buzz_command_test.rb | 3 | 5 |
| fibonacci_test.rb | 4 | 25 |
| **合計** | **39** | **72** |

### コード品質

| ツール | 結果 |
|--------|------|
| RuboCop | 25 files inspected, no offenses |
| SimpleCov Line | 95.95% |
| SimpleCov Branch | 100.0% |

### コミット統計

| 種別 | 数 |
|------|-----|
| feat | 4 |
| docs | 4 |
| ci | 1 |
| chore | 1 |
| **合計** | **10** |

### コード変更量

| 対象 | 追加行数 |
|------|---------|
| ソース + テスト | 1,013 行 |
| 記事 | 2,954 行 |
| CI 設定 | 45 行 |

---

## イテレーションレビュー

### 成功した点

- **Codex 分業の完全定着**: 4 イテレーション通して Claude + Codex の分業が安定稼働。受入時の手戻りゼロ
- **4 エピソード言語の完走**: Ruby のエピソード 4（Fibonacci + ベンチマーク）を含む全 12 章を完了
- **Ruby 固有機能の活用**: Enumerable Mix-in、ブロック/Proc/Lambda、パターンマッチング（`case/in`）、`then` パイプライン
- **Branch Coverage 100%**: 条件分岐の全パスをテストでカバー
- **CI 早期導入**: ruby-ci.yml を開発初期に追加し品質ゲートを確立

### 技術的課題と解決策

| 課題 | 状態 | 解決策 |
|------|------|--------|
| RuboCop Style/OneClassPerFile | ✅ 解決 | `rubocop:disable` コメントで対応 |
| Enumerable の戻り値が Array | ✅ 解決 | `select_type` 等の独自メソッドで FizzBuzzList を返す |
| 基底クラスの未カバー行 | ⚠️ 許容 | `NotImplementedError` は意図的に未テスト |

### アクションアイテム

| # | アクション | 担当 | 期限 | 状態 |
|---|-----------|------|------|------|
| 1 | Release 1.0 クロスレビュー | AI | IT4 バッファ | 未着手 |
| 2 | MkDocs 全体プレビュー確認 | AI | IT4 バッファ | 未着手 |
| 3 | Release 1.0 タグ付けとリリースノート作成 | AI | IT4 バッファ | 未着手 |

---

## リリース状況

### Release 1.0 達成条件

| 条件 | 状態 |
|------|------|
| Java 全 12 章の記事・実装完了 | ✅ |
| Python 全 12 章の記事・実装完了 | ✅ |
| Node（JS/TS）全 12 章の記事・実装完了 | ✅ |
| Ruby 全 12 章の記事・実装完了 | ✅ |
| 全記事のレビュー完了 | 未着手 |
| MkDocs プレビュー確認 | ✅（各言語ごと） |

### 全体リリース進捗

**Phase 1 進捗**

| 言語 | 計画 SP | 実績 SP |
|------|---------|---------|
| IT1 Java | 10 | 10 |
| IT2 Python | 10 | 10 |
| IT3 Node | 13 | 13 |
| IT4 Ruby | 13 | 13 |

| フェーズ | 計画 SP | 完了 SP | 残 SP | 進捗率 |
|---------|---------|---------|-------|--------|
| Phase 1 | 46 | 46 | 0 | 100% |
| Phase 2 | 43 | 0 | 43 | 0% |
| Phase 3 | 60 | 0 | 60 | 0% |
| **全体** | **149** | **46** | **103** | **31%** |

### IT1-IT4 比較

| メトリクス | IT1（Java） | IT2（Python） | IT3（Node/TS） | IT4（Ruby） |
|-----------|------------|--------------|---------------|------------|
| 言語 | Java | Python | TypeScript | Ruby |
| SP | 10 | 10 | 13 | 13 |
| 達成率 | 100% | 100% | 100% | 100% |
| テスト数 | 27 | 23 | 53 | 39 |
| カバレッジ | 97%+ | 98%+ | 97.27% | 95.95% |
| ソース行数 | 約 300 | 約 280 | 312 | 290 |
| テスト行数 | 約 250 | 約 220 | 416 | 723 |
| 記事行数 | 約 2,500 | 約 2,700 | 2,971 | 2,954 |
| コミット数 | 8 | 7 | 8 | 10 |
| テスト/ソース比 | 0.83 | 0.79 | 1.33 | 2.49 |

---

## 総括

IT4（Ruby）では、13 SP の計画を 100% 達成し、Phase 1（Java、Python、Node/TS、Ruby）の全 4 言語 × 12 章 = 48 章の記事執筆と実装を完了した。

Ruby は 4 エピソード言語として、Fibonacci 3 アルゴリズム（再帰/ループ/一般項）のベンチマーク比較を含む充実した第 4 部を実現できた。Enumerable Mix-in、ブロック/Proc/Lambda、パターンマッチング（Ruby 3.x `case/in`）など、Ruby 固有の機能も十分に活用した。

4 イテレーション（IT1-IT4）の実績ベロシティは平均 11.5 SP/イテレーションとなり、Phase 1 の全 46 SP を計画通り消化した。Release 1.0 のリリース準備（クロスレビュー、MkDocs 確認、タグ付け）を残すのみである。

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-03-02 | 初版作成 | AI |

---

## 関連ドキュメント

- [イテレーション 4 計画](./iteration_plan-4.md)
- [イテレーション 4 ふりかえり](./retrospective-4.md)
- [リリース計画](./release_plan.md)
