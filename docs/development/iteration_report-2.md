# イテレーション 2 完了報告書

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **プロジェクト名** | テスト駆動開発から始めるプログラミング入門 |
| **イテレーション** | 2 |
| **対象言語** | Python |
| **開始日** | 2026-03-01 |
| **終了日** | 2026-03-01 |
| **作業日数** | 1 日（AI 並列作業による短縮） |

### 要員

| 項目 | 予定 | 実績 |
|------|------|------|
| **開発者** | 1 名 + AI | 1 名 + AI（Claude + Codex） |
| **計画理想時間** | 46h | - |

---

## 指標

### ビルド結果

| 日付 | テスト | Ruff | mypy | 全品質チェック |
|------|--------|------|------|---------------|
| 2026-03-01 | PASS（32 件） | PASS | PASS | ALL PASSED |

### リリースバーンダウン

**リリースバーンダウン**

| 時点 | 計画残 SP | 実績残 SP |
|------|----------|----------|
| 開始 | 46 | 46 |
| IT1 | 36 | 36 |
| IT2 | 26 | 26 |
| IT3 | 13 | - |
| IT4 | 0 | - |

### イテレーションバーンダウン

**IT2 バーンダウン**

| 時点 | 計画残 SP | 実績残 SP |
|------|----------|----------|
| 開始 | 10 | 10 |
| 環境構築 | 9 | 9 |
| 第1部 | 6 | 6 |
| 第2部 | 3 | 3 |
| 第3部 | 0 | 0 |
| 第4部 | 0 | 0 |

### ベロシティ

**ベロシティ推移**

| イテレーション | 実績 SP | 平均 SP |
|---------------|---------|---------|
| IT1 | 10 | 10 |
| IT2 | 10 | 10 |

| イテレーション | 計画 SP | 実績 SP | 備考 |
|---------------|---------|---------|------|
| IT1 | 10 | 10 | Java（基準言語） |
| IT2 | 10 | 10 | Python（テンプレート適用） |
| **平均** | **10** | **10** | |

---

## 実施内容と評価

### 完了ストーリー一覧

| ID | ストーリー | 結果 | 計画 SP | 完了 SP |
|----|-----------|------|---------|---------|
| US-002 | Python の TDD 入門記事の執筆と実装 | 完了 | 10 | 10 |
| **合計** | | | **10** | **10** |

### 達成率

| 項目 | 計画 | 実績 | 達成率 |
|------|------|------|--------|
| ストーリーポイント | 10 SP | 10 SP | 100% |
| ストーリー数 | 1 | 1 | 100% |
| 記事数 | 12 章 | 12 章 | 100% |
| タスク数 | 22 タスク | 22 タスク | 100% |

---

## 成果物詳細

### US-002: Python の TDD 入門記事の執筆と実装

#### 記事（docs/article/python/）

| ファイル | 章タイトル | 行数 |
|---------|-----------|------|
| `index.md` | Python 概要ページ | 55 |
| `01-todo-list-and-first-test.md` | 第 1 章 TODO リストと最初のテスト | 201 |
| `02-fake-it-and-triangulation.md` | 第 2 章 仮実装と三角測量 | 247 |
| `03-obvious-implementation-and-refactoring.md` | 第 3 章 明白な実装とリファクタリング | 199 |
| `04-version-control-and-conventional-commits.md` | 第 4 章 バージョン管理と Conventional Commits | 87 |
| `05-package-management-and-static-analysis.md` | 第 5 章 パッケージ管理と静的解析 | 274 |
| `06-task-runner-and-ci-cd.md` | 第 6 章 タスクランナーと CI/CD | 190 |
| `07-encapsulation-and-polymorphism.md` | 第 7 章 カプセル化とポリモーフィズム | 208 |
| `08-design-patterns.md` | 第 8 章 デザインパターンの適用 | 172 |
| `09-solid-principles-and-module-design.md` | 第 9 章 SOLID 原則とモジュール設計 | 130 |
| `10-higher-order-functions-and-composition.md` | 第 10 章 高階関数と関数合成 | 122 |
| `11-immutable-data-and-pipeline.md` | 第 11 章 不変データとパイプライン処理 | 116 |
| `12-error-handling-and-type-safety.md` | 第 12 章 エラーハンドリングと型安全性 | 126 |
| **合計** | **13 ファイル** | **2,127 行** |

#### 実装（apps/python/）

##### パッケージ構成

```
apps/python/lib/
├── __init__.py
├── application/
│   ├── __init__.py
│   ├── fizz_buzz_command.py        # Command 抽象基底クラス
│   ├── fizz_buzz_list_command.py   # リスト生成コマンド（リスト内包表記）
│   └── fizz_buzz_value_command.py  # 単一値コマンド
└── domain/
    ├── __init__.py
    ├── model/
    │   ├── __init__.py
    │   ├── fizz_buzz_value.py      # 値オブジェクト（@property）
    │   └── fizz_buzz_list.py       # ファーストクラスコレクション（filter/statistics）
    └── type/
        ├── __init__.py
        ├── fizz_buzz_type.py       # 抽象型（Strategy + Enum factory）
        ├── fizz_buzz_type_01.py    # 標準型
        ├── fizz_buzz_type_02.py    # 数値のみ型
        ├── fizz_buzz_type_03.py    # FizzBuzz のみ型
        ├── fizz_buzz_type_name.py  # 型安全 Enum
        └── fizz_buzz_type_not_defined.py  # Null Object
```

##### コード規模

| カテゴリ | ファイル数 | 行数 |
|---------|-----------|------|
| プロダクションコード | 11 | 229 |
| テストコード | 4 | 199 |
| **合計** | **15** | **428** |

##### 主要な設計パターン

| パターン | 適用箇所 |
|---------|---------|
| Strategy | `FizzBuzzType`（ABC + 型ごとの生成ロジック） |
| Command | `FizzBuzzCommand`（単一値/リスト生成の統一インターフェース） |
| Factory Method | `FizzBuzzType.create()` / `FizzBuzzType.create_from_name()` |
| Value Object | `FizzBuzzValue`（`@property` + `__eq__` + `__hash__`） |
| First-Class Collection | `FizzBuzzList`（filter/statistics/group_by_value） |
| Null Object | `FizzBuzzTypeNotDefined`（未定義タイプ → 空文字返却） |

##### Java（IT1）との対比

| 概念 | Java（IT1） | Python（IT2） |
|------|-----------|-------------|
| テストフレームワーク | JUnit 5 | pytest |
| パッケージマネージャ | Gradle | uv |
| リンター | Checkstyle + PMD | Ruff |
| フォーマッター | Checkstyle | Ruff（統合） |
| バグ検出 | SpotBugs | mypy（型チェック） |
| カバレッジ | JaCoCo | pytest-cov |
| タスクランナー | Gradle タスク | tox |
| 抽象クラス | abstract class | abc.ABC + @abstractmethod |
| カプセル化 | private + getter | @property |
| 型安全 | コンパイル時型検査 | mypy（静的型チェック） |
| Enum | Java enum | Python Enum |

---

## 品質メトリクス

### テストカバレッジ

| モジュール | カバレッジ | 判定 |
|-----------|-----------|------|
| `lib/application/` | 100% | 達成 |
| `lib/domain/model/` | 100% | 達成 |
| `lib/domain/type/` | 100% | 達成 |
| **全体** | **100%** | **達成（目標 80%）** |

### テスト数

| テストクラス | テスト数 |
|------------|---------|
| `TestFizzBuzzCommand` | 4 |
| `TestFizzBuzzList` | 10 |
| `TestFizzBuzzValue` | 5 |
| `TestFizzBuzzType` | 13 |
| **合計** | **32** |

### コード品質

| メトリクス | 結果 |
|-----------|------|
| Ruff 違反 | 0 |
| mypy エラー | 0 |
| 全品質チェック | ALL PASSED |

### コミット統計

| 種別 | 件数 |
|------|------|
| feat（機能追加） | 4 |
| **合計** | **4** |

### コード変更量

| 対象 | ファイル数 | 追加行 | 削除行 |
|------|-----------|--------|--------|
| apps/python/ | 29 | 556 | 0 |
| docs/article/python/ | 13 | 2,127 | 0 |
| docs/development/ + mkdocs.yml | 3 | 47 | 20 |
| **合計** | **45** | **2,623** | **20** |

---

## イテレーションレビュー

### 成功した点

1. **全 12 章の記事と実装が完了**: 計画通り US-002 を 10 SP で完了し、Python TDD 入門の全コンテンツを作成した
2. **テストカバレッジ 100% 達成**: IT1 の課題（75%）を大幅に改善。全モジュールで 100% を達成した
3. **IT1 テンプレートの効率的再利用**: Java で確立した章構成・設計パターンを Python に効率的に適応できた
4. **Pythonic な実装**: リスト内包表記、`@property`、ABC、Enum など Python らしい機能を活用した

### 技術的課題と解決策

| 課題 | 状態 | 解決策 / 対応 |
|------|------|-------------|
| 循環インポートの回避 | 解決済み | `TYPE_CHECKING` パターンで型ヒントを維持しつつ回避 |
| Ruff F821 エラー（FizzBuzzTypeName 未定義） | 解決済み | `if TYPE_CHECKING:` import ブロックで解決 |
| カバレッジ 99%（TYPE_CHECKING ブロック） | 解決済み | `pyproject.toml` の `exclude_lines` に追加 |
| `python` コマンド未発見 | 解決済み | `uv run pytest` を使用（プロジェクトの .venv を利用） |

### アクションアイテム

| # | アクション | 担当 | 期限 | 状態 |
|---|-----------|------|------|------|
| 1 | python-ci.yml をコミットし CI パイプラインを稼働 | IT2 | IT2 終了時 | 作成済み（未コミット） |
| 2 | tox 全品質チェックを各コミット前に実行するフロー確立 | IT3 | IT3 | 未着手 |
| 3 | 次言語（Node/JS/TS）の特徴を事前調査 | IT3 | IT3 計画時 | 未着手 |

---

## リリース状況

### Release 1.0 達成条件の充足状態

| 条件 | 状態 | 備考 |
|------|------|------|
| Java 記事のレビュー完了 | 完了 | 12 章すべて執筆・同期確認済み |
| Java テストがパス | 完了 | 24 テスト全パス |
| Python 記事のレビュー完了 | 完了 | 12 章すべて執筆・同期確認済み |
| Python テストがパス | 完了 | 32 テスト全パス、カバレッジ 100% |
| MkDocs プレビュー確認 | 完了 | mkdocs.yml 更新済み |
| Node(JS/TS) 記事・実装 | 未着手 | IT3 で対応 |
| Ruby 記事・実装 | 未着手 | IT4 で対応 |

### 全体リリース進捗

**Phase 1 進捗（SP）**

| 言語 | 計画 SP | 実績 SP |
|------|---------|---------|
| Java(IT1) | 10 | 10 |
| Python(IT2) | 10 | 10 |
| Node(IT3) | 13 | 0 |
| Ruby(IT4) | 13 | 0 |

| フェーズ | 計画 SP | 完了 SP | 達成率 |
|---------|---------|---------|--------|
| Phase 1（主流 OOP） | 46 | 20 | 43% |
| Phase 2（多パラダイム） | 43 | 0 | 0% |
| Phase 3（関数型 + 統合） | 60 | 0 | 0% |
| **全体** | **149** | **20** | **13%** |

---

## IT1 との比較

| メトリクス | IT1（Java） | IT2（Python） | 変化 |
|-----------|------------|--------------|------|
| テスト数 | 24 | 32 | +33% |
| カバレッジ | 75% | 100% | +25pt |
| プロダクションコード行数 | 333 | 229 | -31% |
| テストコード行数 | 277 | 199 | -28% |
| テスト/プロダクション比率 | 0.83 | 0.87 | +0.04 |
| 記事行数 | 3,399 | 2,127 | -37% |
| コミット数 | 11 | 4 | -64% |
| 追加行数 | 4,655 | 2,623 | -44% |
| 品質チェック違反 | 0 | 0 | 同等 |

---

## 総括

IT2 は計画通り 10 SP を達成し、Python TDD 入門記事（全 12 章）の執筆と実装を完了した。IT1 で確立したテンプレートを効率的に再利用し、コード行数 31% 削減・記事行数 37% 削減を実現しつつ、テストカバレッジは 100% に改善した。

ベロシティ実績は 2 イテレーション連続で 10 SP/イテレーションとなり、安定した開発ペースが確認された。Phase 1 の進捗は 43%（20/46 SP）で、IT3（Node/JS/TS）・IT4（Ruby）で Phase 1 を完了する計画である。

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-03-01 | 初版作成（IT2 完了報告書） | - |

---

## 関連ドキュメント

- [イテレーション 2 計画](./iteration_plan-2.md)
- [イテレーション 2 ふりかえり](./retrospective-2.md)
- [イテレーション 1 完了報告書](./iteration_report-1.md)
- [リリース計画](./release_plan.md)
- [執筆ワークフロー](../article/workflow.md)
