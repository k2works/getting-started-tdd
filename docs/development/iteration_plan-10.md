# イテレーション 10 計画

## 概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 10 |
| **期間** | Week 19-20（2 週間） |
| **ゴール** | Scala の全 12 章の記事執筆と実装を完了し、JVM 上の OOP/FP ハイブリッド言語の TDD パターンを確立する |
| **目標 SP** | 13 |

---

## ゴール

### イテレーション終了時の達成状態

1. **記事**: Scala の 12 章すべてが `docs/article/scala/` に執筆完了
2. **実装**: `apps/scala/` に Scala の TDD 実装が動作する状態
3. **品質**: テスト全パス、scalafmt / WartRemover 違反ゼロ
4. **Phase 3 継続**: IT10 が完了し、JVM + OOP/FP ハイブリッド言語のテンプレートが確立

### 成功基準

- [ ] docs/article/scala/index.md と 12 章の記事ファイルが作成済み
- [ ] apps/scala/ の sbt test がすべてパス
- [ ] mkdocs.yml に Scala セクションが追加され、プレビュー確認済み
- [ ] scalafmt / WartRemover 警告ゼロ
- [ ] 記事内コード例と apps/scala/ の実コードが同期

---

## ベロシティトレンド分析（9 イテレーション実績）

### 実績データ

| イテレーション | 言語 | 計画 SP | 実績 SP | 達成率 |
|---------------|------|---------|---------|--------|
| IT1 | Java | 10 | 10 | 100% |
| IT2 | Python | 10 | 10 | 100% |
| IT3 | Node（JS/TS） | 13 | 13 | 100% |
| IT4 | Ruby | 13 | 13 | 100% |
| IT5 | Go | 10 | 10 | 100% |
| IT6 | PHP | 10 | 10 | 100% |
| IT7 | Rust | 10 | 10 | 100% |
| IT8 | C#/F# | 13 | 13 | 100% |
| IT9 | Clojure | 13 | 13 | 100% |
| **平均** | | **11.3** | **11.3** | **100%** |

### IT10 見通し

- Scala は 4 エピソード言語（Wiki エピソード 1-4）、第 4 部はネイティブの関数型プログラミングで構成
- Wiki に 3,906 行の参照資料が揃っている
- Nix 環境で Scala 3 + sbt + Metals + scala-cli が利用可能（`nix develop .#scala`）
- OOP と FP の両方をネイティブにサポートするため、第 3 部と第 4 部の内容が充実
- IT9（Clojure）と同じ JVM 言語のため、ビルド・テスト手法に共通点あり

---

## ユーザーストーリー

### 対象ストーリー

| ID | ユーザーストーリー | SP | 優先度 |
|----|-------------------|----|----|
| US-010 | Scala の TDD 入門記事の執筆と実装 | 13 | 低 |
| **合計** | | **13** | |

### ストーリー詳細

#### US-010: Scala の TDD 入門記事の執筆と実装

**ストーリー**:

> プログラミング学習者として、Scala で TDD を体験する記事を読みたい。なぜなら、OOP と関数型プログラミングを統合した言語で TDD のアプローチを学べるからだ。

**受入条件**:

1. 12 章構成の記事が docs/article/scala/ に存在する
2. FizzBuzz 問題を題材に TDD サイクル（Red-Green-Refactor）が体験できる
3. 開発環境の構築手順（Scala 3、sbt、scalafmt）が記載されている
4. Scala のケースクラスとトレイトによるポリモーフィズムが段階的に解説されている
5. Scala の関数型プログラミング（パターンマッチ、高階関数、代数的データ型）が段階的に解説されている
6. 記事内のコード例と apps/scala/ の実装が一致している

### タスク

#### 0. 環境構築（1 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 0.1 | apps/scala/ に sbt プロジェクトを作成 | 0.5h | AI | [ ] |
| 0.2 | .gitignore 先行設定（target/, .bsp/, .metals/, .bloop/ 除外） | 0.5h | AI | [ ] |
| 0.3 | テスト構成の確認（sbt test / ScalaTest） | 0.5h | AI | [ ] |
| 0.4 | Makefile 作成（check タスク統合） | 0.5h | AI | [ ] |
| 0.5 | CI ワークフロー（.github/workflows/scala-ci.yml）の作成 | 0.5h | AI | [ ] |
| 0.6 | docs/article/scala/index.md を作成 | 0.5h | AI | [ ] |

**小計**: 3h（理想時間）

**コミット**: `feat(scala): IT10 環境構築（sbt + ScalaTest + scalafmt）`

---

#### 1. 第 1 部: TDD の基本サイクル（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 1.1 | 章 1: TODO リストと最初のテスト - 執筆 | 2h | AI | [ ] |
| 1.2 | 章 1: TODO リストと最初のテスト - 実装 | 1h | AI | [ ] |
| 1.3 | 章 2: 仮実装と三角測量 - 執筆 | 2h | AI | [ ] |
| 1.4 | 章 2: 仮実装と三角測量 - 実装 | 1h | AI | [ ] |
| 1.5 | 章 3: 明白な実装とリファクタリング - 執筆 | 2h | AI | [ ] |
| 1.6 | 章 3: 明白な実装とリファクタリング - 実装 | 1h | AI | [ ] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門1.md`

**コミット**: `feat(scala): IT10 第 1 部（章 1-3）の記事執筆と TDD 実装を完了`

#### 2. 第 2 部: 開発環境と自動化（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 2.1 | 章 4: バージョン管理と Conventional Commits - 執筆 | 2h | AI | [ ] |
| 2.2 | 章 5: パッケージ管理と静的解析（sbt、scalafmt、WartRemover）- 執筆 | 2h | AI | [ ] |
| 2.3 | 章 6: タスクランナーと CI/CD（Makefile、GitHub Actions）- 執筆 | 2h | AI | [ ] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門2.md`

**コミット**: `feat(scala): IT10 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了`

#### 3. 第 3 部: オブジェクト指向設計（3 SP）

Scala は OOP と FP を統合した言語のため、ケースクラス・トレイト・パターンマッチで OOP 概念を表現する。

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 3.1 | 章 7: ケースクラスとトレイトによるポリモーフィズム - 執筆・実装 | 3h | AI | [ ] |
| 3.2 | 章 8: パターンマッチとシールドトレイト - 執筆・実装 | 3h | AI | [ ] |
| 3.3 | 章 9: パッケージとモジュール設計 - 執筆・実装 | 3h | AI | [ ] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門3.md`

**コミット**: `feat(scala): IT10 第 3 部（章 7-9）の記事執筆と OOP/パターンマッチ実装を完了`

#### 4. 第 4 部: 関数型プログラミング（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 4.1 | 章 10: 高階関数と関数合成（カリー化、部分適用、合成）- 執筆・実装 | 2h | AI | [ ] |
| 4.2 | 章 11: コレクション処理と遅延評価（map/flatMap/filter、LazyList）- 執筆・実装 | 2h | AI | [ ] |
| 4.3 | 章 12: エラーハンドリングと型安全性（Option、Either、Try）- 執筆・実装 | 2h | AI | [ ] |
| 4.4 | 記事と実装の同期確認 | 1h | AI | [ ] |
| 4.5 | mkdocs.yml 更新とプレビュー確認 | 0.5h | AI | [ ] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門4.md`

**コミット**: `feat(scala): IT10 第 4 部（章 10-12）の記事執筆と FP 実装を完了`

---

### タスク合計

| カテゴリ | SP | 状態 |
|---------|-----|------|
| 環境構築 | 1 | [ ] |
| 第 1 部: TDD の基本サイクル | 3 | [ ] |
| 第 2 部: 開発環境と自動化 | 3 | [ ] |
| 第 3 部: オブジェクト指向設計 | 3 | [ ] |
| 第 4 部: 関数型プログラミング | 3 | [ ] |
| **合計** | **13** | |

---

## 設計メモ

### ディレクトリ構成

```
apps/scala/
├── build.sbt                                (sbt プロジェクトファイル)
├── project/
│   ├── build.properties                     (sbt バージョン指定)
│   └── plugins.sbt                          (scalafmt, WartRemover プラグイン)
├── Makefile
├── .gitignore
├── .scalafmt.conf                           (scalafmt 設定)
├── src/
│   ├── main/scala/
│   │   └── fizzbuzz/
│   │       ├── FizzBuzz.scala               (公開 API)
│   │       ├── domain/
│   │       │   ├── Model.scala              (値オブジェクト・コレクション)
│   │       │   └── Type.scala               (sealed trait + case class)
│   │       └── application/
│   │           └── Command.scala            (コマンドパターン)
│   └── test/scala/
│       └── fizzbuzz/
│           ├── FizzBuzzSpec.scala            (コアテスト)
│           ├── domain/
│           │   └── TypeSpec.scala            (タイプテスト)
│           └── application/
│               └── CommandSpec.scala         (コマンドテスト)

docs/article/
└── scala/
    ├── index.md                              (Scala 記事トップ)
    └── chapter01.md  ...  chapter12.md       (12 章)
```

### Scala 固有の特徴（12 章構成）

| 機能 | 章 | 内容 |
|------|-----|------|
| val / var / def | 1-3 | 不変/可変バインディング、メソッド定義 |
| ScalaTest（AnyFunSuite） | 1-3 | test, assert, assertResult |
| 文字列補間（s"..."） | 1-3 | テンプレートリテラル |
| ケースクラス（case class） | 7, 9 | イミュータブルな値オブジェクト |
| トレイト（trait） | 7, 9 | ミックスインによるポリモーフィズム |
| シールドトレイト（sealed trait） | 8 | 代数的データ型（ADT）の定義 |
| パターンマッチ（match/case） | 8, 10 | 網羅的なケース分岐 |
| パッケージオブジェクト | 5, 9 | モジュール分割と公開 API |
| 高階関数（map / flatMap / filter） | 10-11 | コレクション処理 |
| カリー化と部分適用 | 10 | 関数の部分適用 |
| Option / Either / Try | 12 | モナド的エラーハンドリング |
| LazyList / 遅延評価 | 11 | 遅延コレクション |
| for 内包表記 | 10-11 | モナド合成の糖衣構文 |

### Clojure → Scala 対応マップ（IT9 知見の活用）

| Clojure 概念 | Scala 対応 |
|-------------|-----------|
| defprotocol | trait |
| defrecord | case class |
| defmulti / defmethod | match / case（パターンマッチ） |
| 名前空間（ns） | package |
| スレッディングマクロ（->） | メソッドチェーン / pipe |
| 永続データ構造 | イミュータブルコレクション（デフォルト） |
| clojure.spec | Scala 3 の given / using / opaque type |
| ex-info / ex-data | Either / Try |

---

## Nix 環境

```
nix develop .#scala
```

| パッケージ | 用途 |
|-----------|------|
| scala_3 | Scala 3.x コンパイラ |
| sbt | Scala Build Tool（メインビルドシステム） |
| metals | Language Server Protocol 実装 |
| scala-cli | スクリプティング・テスト用 CLI |

---

## IT1-IT9 からの学び（適用事項）

| 学び | IT10 での適用 |
|------|-------------|
| .gitignore を最初に作成する | target/, .bsp/, .metals/, .bloop/ を最初に除外設定 |
| Nix 環境を必ず使用する | `nix develop .#scala` で全操作を実行 |
| **部ごとにコミットを分割する** | 環境構築、第 1-4 部ごとに 5 コミットに分割（IT9 改善） |
| テンプレート再利用が効果的 | IT9 の Phase 3 テンプレートを Scala 向けに適用 |
| Clojure の知見を活用 | プロトコル→トレイト、マルチメソッド→パターンマッチの対応づけ |
| GitHub Issue の同期を忘れない | 完了時に Issue #10 をクローズする |
| OOP/FP ハイブリッドの概念に注力 | ケースクラス、シールドトレイト、パターンマッチの記事説明に注力 |
| 複雑度チェッカーのカスタム実装 | Scala 向けの複雑度チェッカーを検討 |

---

## リスクと対策

| リスク | 影響度 | 対策 |
|--------|--------|------|
| sbt ビルドの初回ダウンロードに時間がかかる | 中 | Nix 環境で事前にキャッシュ、CI ではキャッシュ設定 |
| Scala 3 構文と Scala 2 構文の混在 | 中 | Scala 3 構文に統一し、記事内で明記 |
| OOP と FP の境界が曖昧で記事構成が複雑 | 中 | 第 3 部を OOP 中心、第 4 部を FP 中心に明確分離 |
| ScalaTest のスタイル選択（FunSuite vs FlatSpec vs WordSpec） | 低 | AnyFunSuite を統一使用（最もシンプル） |
| target/ や .bsp/ の誤コミット | 低 | 最初に .gitignore 設定（IT7 以降の学び） |

---

## 完了条件

### Definition of Done

- [ ] 12 章の記事ファイルが docs/article/scala/ に存在
- [ ] apps/scala/ の全テストがパス
- [ ] scalafmt / WartRemover 警告ゼロ
- [ ] mkdocs.yml に Scala セクションが追加済み
- [ ] ローカルプレビューで表示確認済み
- [ ] 記事内コード例と apps/scala/ の実コードが同期
- [ ] GitHub Issue #10 がクローズ済み
- [ ] 部ごとに 5 コミットに分割済み（IT9 改善）

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-03-03 | 初版作成 | AI |

---

## 関連ドキュメント

- [リリース計画](./release_plan.md)
- [イテレーション 9 計画](./iteration_plan-9.md)
- [イテレーション 9 ふりかえり](./retrospective-9.md)
- [Wiki 参照: Scala エピソード 1](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門1.md)
- [Wiki 参照: Scala エピソード 2](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門2.md)
- [Wiki 参照: Scala エピソード 3](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門3.md)
- [Wiki 参照: Scala エピソード 4](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるScala入門4.md)
