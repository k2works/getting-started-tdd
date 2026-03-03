# イテレーション 12 計画

## 概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 12（最終イテレーション） |
| **期間** | Week 23-24（2 週間） |
| **ゴール** | Haskell の全 12 章の記事執筆と実装を完了し、多言語統合解説を作成して Release 3.0 をリリースする |
| **目標 SP** | 21（US-012: 13 SP + US-013: 8 SP） |

---

## ゴール

### イテレーション終了時の達成状態

1. **Haskell 記事**: 12 章すべてが `docs/article/haskell/` に執筆完了
2. **Haskell 実装**: `apps/haskell/` に Haskell の TDD 実装が動作する状態
3. **統合解説**: `docs/article/integration/` に多言語統合解説が完成
4. **品質**: テスト全パス、HLint 警告ゼロ
5. **Release 3.0**: Phase 3 完了、全 12 言語 + 統合解説が揃い、Release 3.0 リリース準備完了

### 成功基準

- [x] docs/article/haskell/index.md と 12 章の記事ファイルが作成済み
- [x] apps/haskell/ のテストがすべてパス（38 テスト）
- [x] mkdocs.yml に Haskell セクションが追加され、プレビュー確認済み
- [x] HLint 警告ゼロ
- [x] 記事内コード例と apps/haskell/ の実コードが同期
- [x] docs/article/integration/ に統合解説が作成済み
- [x] mkdocs.yml に統合解説セクションが追加済み
- [x] GitHub Issue #12, #13 がクローズ済み
- [x] Release 3.0 リリース条件を達成

---

## ベロシティトレンド分析（11 イテレーション実績）

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
| IT10 | Scala | 13 | 13 | 100% |
| IT11 | Elixir | 13 | 13 | 100% |
| **平均** | | **11.6** | **11.6** | **100%** |

### IT12 見通し

- IT12 は 21 SP で過去最大（平均 11.6 SP の約 1.8 倍）
- Haskell は 4 エピソード言語（Wiki エピソード 1-4）、2,838 行の参照資料
- 多言語統合解説（8 SP）は新規構成だが、11 イテレーション分の知見が蓄積済み
- Nix 環境で GHC + Stack + Cabal + haskell-language-server が利用可能
- 純粋関数型言語のため、第 3 部は型クラス・代数的データ型で OOP 概念を表現
- **リスク軽減**: Haskell と統合解説を並行ではなく順序実行（Haskell 先行→統合解説）

---

## ユーザーストーリー

### 対象ストーリー

| ID | ユーザーストーリー | SP | 優先度 |
|----|-------------------|----|----|
| US-012 | Haskell の TDD 入門記事の執筆と実装 | 13 | 低 |
| US-013 | 多言語統合解説の執筆 | 8 | 低 |
| **合計** | | **21** | |

### ストーリー詳細

#### US-012: Haskell の TDD 入門記事の執筆と実装

**ストーリー**:

> プログラミング学習者として、Haskell で TDD を体験する記事を読みたい。なぜなら、純粋関数型言語で型クラスや代数的データ型を活用した TDD のアプローチを学べるからだ。

**受入条件**:

1. 12 章構成の記事が docs/article/haskell/ に存在する
2. FizzBuzz 問題を題材に TDD サイクル（Red-Green-Refactor）が体験できる
3. 開発環境の構築手順（GHC、Stack、HSpec）が記載されている
4. Haskell の型クラスと代数的データ型によるポリモーフィズムが段階的に解説されている
5. Haskell の関数型プログラミング（高階関数、関数合成、モナド、カリー化）が段階的に解説されている
6. 記事内のコード例と apps/haskell/ の実装が一致している

#### US-013: 多言語統合解説の執筆

**ストーリー**:

> プログラミング学習者として、12 言語を横断した比較解説を読みたい。なぜなら、各言語の TDD アプローチやパラダイムの違いを体系的に理解できるからだ。

**受入条件**:

1. 12 言語を横断した比較表（テストフレームワーク、型システム、パラダイム）が存在する
2. パラダイム別（OOP、FP、マルチパラダイム）のパターン比較が記載されている
3. TDD のアプローチの違い（各言語の Red-Green-Refactor の特徴）が解説されている
4. 開発環境・ツールチェーンの比較（ビルドツール、リンター、CI 構成）が記載されている
5. 学習順序の推奨と各言語の位置づけが明確に記載されている

### タスク

#### 0. Haskell 環境構築（1 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 0.1 | apps/haskell/ に Stack プロジェクトを作成 | 0.5h | AI | [x] |
| 0.2 | .gitignore 先行設定（.stack-work/、dist-newstyle/ 除外） | 0.5h | AI | [x] |
| 0.3 | テスト構成の確認（stack test / HSpec） | 0.5h | AI | [x] |
| 0.4 | Makefile 作成（check タスク統合） | 0.5h | AI | [x] |
| 0.5 | CI ワークフロー（.github/workflows/haskell-ci.yml）を Nix ベースで作成 | 0.5h | AI | [x] |
| 0.6 | docs/article/haskell/index.md を作成 | 0.5h | AI | [x] |

**小計**: 3h（理想時間）

**コミット**: `feat(haskell): IT12 環境構築（Stack + HSpec + HLint）`

---

#### 1. 第 1 部: TDD の基本サイクル（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 1.1 | 章 1: TODO リストと最初のテスト - 執筆 | 2h | AI | [x] |
| 1.2 | 章 1: TODO リストと最初のテスト - 実装 | 1h | AI | [x] |
| 1.3 | 章 2: 仮実装と三角測量 - 執筆 | 2h | AI | [x] |
| 1.4 | 章 2: 仮実装と三角測量 - 実装 | 1h | AI | [x] |
| 1.5 | 章 3: 明白な実装とリファクタリング - 執筆 | 2h | AI | [x] |
| 1.6 | 章 3: 明白な実装とリファクタリング - 実装 | 1h | AI | [x] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門1.md`

**コミット**: `feat(haskell): IT12 第 1 部（章 1-3）の記事執筆と TDD 実装を完了`

#### 2. 第 2 部: 開発環境と自動化（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 2.1 | 章 4: バージョン管理と Conventional Commits - 執筆 | 2h | AI | [x] |
| 2.2 | 章 5: パッケージ管理と静的解析（Stack、HLint、Fourmolu）- 執筆 | 2h | AI | [x] |
| 2.3 | 章 6: タスクランナーと CI/CD（Makefile、Nix、GitHub Actions）- 執筆 | 2h | AI | [x] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門2.md`

**コミット**: `feat(haskell): IT12 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了`

#### 3. 第 3 部: オブジェクト指向設計（3 SP）

Haskell は純粋関数型言語のため、型クラス・代数的データ型・スマートコンストラクタで OOP 概念を表現する。

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 3.1 | 章 7: 代数的データ型と型クラスによるポリモーフィズム - 執筆・実装 | 3h | AI | [x] |
| 3.2 | 章 8: パターンマッチとガード - 執筆・実装 | 3h | AI | [x] |
| 3.3 | 章 9: モジュール設計とスマートコンストラクタ - 執筆・実装 | 3h | AI | [x] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門3.md`

**コミット**: `feat(haskell): IT12 第 3 部（章 7-9）の記事執筆と型クラス/ADT 実装を完了`

#### 4. 第 4 部: 関数型プログラミング（3 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 4.1 | 章 10: 高階関数とカリー化（map、filter、fold、部分適用）- 執筆・実装 | 2h | AI | [x] |
| 4.2 | 章 11: 関数合成とポイントフリースタイル（(.)、($)、flip）- 執筆・実装 | 2h | AI | [x] |
| 4.3 | 章 12: モナドとエラーハンドリング（Maybe、Either、do 記法）- 執筆・実装 | 2h | AI | [x] |
| 4.4 | 記事と実装の同期確認 | 1h | AI | [x] |
| 4.5 | mkdocs.yml 更新とプレビュー確認 | 0.5h | AI | [x] |

**参照**: `tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門4.md`

**コミット**: `feat(haskell): IT12 第 4 部（章 10-12）の記事執筆と FP 実装を完了`

---

#### 5. 多言語統合解説（8 SP）

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 5.1 | 統合解説: 12 言語の概要と分類（OOP/FP/マルチパラダイム）- 執筆 | 3h | AI | [x] |
| 5.2 | 統合解説: テストフレームワーク・ツールチェーン比較表 - 執筆 | 2h | AI | [x] |
| 5.3 | 統合解説: パラダイム別 TDD パターン比較 - 執筆 | 3h | AI | [x] |
| 5.4 | 統合解説: 型システム・エラーハンドリング比較 - 執筆 | 2h | AI | [x] |
| 5.5 | 統合解説: 開発環境と CI/CD 比較（Nix 統一アプローチ）- 執筆 | 2h | AI | [x] |
| 5.6 | 統合解説: 学習ロードマップと推奨順序 - 執筆 | 2h | AI | [x] |
| 5.7 | mkdocs.yml 更新とプレビュー確認 | 0.5h | AI | [x] |
| 5.8 | docs/index.md 更新 | 0.5h | AI | [x] |

**コミット**: `feat(integration): IT12 多言語統合解説の執筆を完了`

---

#### 6. Release 3.0 準備

| # | タスク | 見積もり | 担当 | 状態 |
|---|--------|---------|------|------|
| 6.1 | GitHub Issue #12, #13 のクローズ | 0.5h | AI | [x] |
| 6.2 | GitHub Project ステータス更新（Done） | 0.5h | AI | [x] |
| 6.3 | docs/development/release_plan.md の最終更新 | 0.5h | AI | [x] |
| 6.4 | docs/development/index.md 更新 | 0.5h | AI | [x] |

**コミット**: `docs: IT12 完了に伴うドキュメント同期と GitHub 同期`

---

### タスク合計

| カテゴリ | SP | 状態 |
|---------|-----|------|
| 環境構築 | 1 | [x] |
| 第 1 部: TDD の基本サイクル | 3 | [x] |
| 第 2 部: 開発環境と自動化 | 3 | [x] |
| 第 3 部: オブジェクト指向設計 | 3 | [x] |
| 第 4 部: 関数型プログラミング | 3 | [x] |
| 多言語統合解説 | 8 | [x] |
| **合計** | **21** | |

---

## 設計メモ

### Haskell ディレクトリ構成

```
apps/haskell/
├── package.yaml                                (Stack プロジェクトファイル)
├── stack.yaml                                  (Stack リゾルバ設定)
├── Makefile
├── .gitignore
├── .hlint.yaml                                 (HLint 設定)
├── scripts/
│   └── complexity.sh                           (循環複雑度チェッカー)
├── src/
│   └── FizzBuzz/
│       ├── FizzBuzz.hs                         (公開 API)
│       ├── Type.hs                             (タイプ定義・型クラス)
│       ├── Model.hs                            (値オブジェクト・データ型)
│       └── Command.hs                          (コマンドパターン)
├── test/
│   ├── Spec.hs                                 (テストエントリポイント)
│   └── FizzBuzz/
│       ├── FizzBuzzSpec.hs                     (コアテスト)
│       ├── TypeSpec.hs                         (タイプテスト)
│       └── CommandSpec.hs                      (コマンドテスト)

docs/article/
├── haskell/
│   ├── index.md                                (Haskell 記事トップ)
│   └── 01-todo-list-and-first-test.md ... 12-monad-and-error-handling.md (12 章)
└── integration/
    └── index.md                                (多言語統合解説)
```

### 統合解説ディレクトリ構成

```
docs/article/integration/
├── index.md                                    (統合解説トップ・概要)
├── 01-language-overview.md                     (12 言語の概要と分類)
├── 02-test-framework-comparison.md             (テストフレームワーク比較)
├── 03-tdd-pattern-comparison.md                (パラダイム別 TDD パターン)
├── 04-type-system-comparison.md                (型システム・エラーハンドリング比較)
├── 05-dev-environment-comparison.md            (開発環境と CI/CD 比較)
└── 06-learning-roadmap.md                      (学習ロードマップ)
```

### Haskell 固有の特徴（12 章構成）

| 機能 | 章 | 内容 |
|------|-----|------|
| 関数定義（型シグネチャ、ガード） | 1-3 | 関数の型宣言、ガード式、where 節 |
| HSpec（describe / it / shouldBe） | 1-3 | BDD スタイルテスト |
| パターンマッチ | 1-3, 8 | 引数パターン、case 式 |
| 代数的データ型（data / newtype） | 7, 9 | Sum 型・Product 型 |
| 型クラス（class / instance） | 7, 9 | アドホックポリモーフィズム |
| スマートコンストラクタ | 9 | カプセル化パターン |
| ガード式（\| condition = result） | 8 | 条件分岐 |
| 高階関数（map / filter / foldl） | 10 | コレクション処理 |
| カリー化と部分適用 | 10 | 関数の部分適用 |
| 関数合成（(.)、($)） | 11 | ポイントフリースタイル |
| Maybe / Either | 12 | 型安全なエラーハンドリング |
| do 記法 | 12 | モナドの糖衣構文 |

### Elixir → Haskell 対応マップ（IT11 知見の活用）

| Elixir 概念 | Haskell 対応 |
|-----------|-----------|
| defprotocol / defimpl | class / instance（型クラス） |
| defstruct | data / newtype（代数的データ型） |
| @behaviour / @callback | class（型クラスのメソッド宣言） |
| パターンマッチ（関数頭部） | パターンマッチ（関数定義） |
| パイプライン演算子（\|>） | 関数合成（(.)）/ 適用（($)） |
| Stream | 遅延評価（デフォルト） |
| {:ok, _} / {:error, _} | Maybe / Either |
| with 構文 | do 記法（モナド） |
| cond / case | ガード式 / case 式 |
| Enum.map / Enum.filter | map / filter（Prelude） |

### 統合解説の構成案

| 章 | タイトル | 内容 |
|-----|---------|------|
| 1 | 12 言語の概要と分類 | OOP（Java, C#）、スクリプト（Python, Ruby, PHP, Node）、システム（Go, Rust）、FP（Haskell, Elixir, Clojure, Scala, F#）の分類と特徴 |
| 2 | テストフレームワーク比較 | 12 言語のテストフレームワーク、アサーション、テスト構造の比較表 |
| 3 | パラダイム別 TDD パターン | OOP の Red-Green-Refactor vs FP の型駆動開発、各パラダイムのテスト設計 |
| 4 | 型システム・エラーハンドリング | 静的型付け vs 動的型付け、Option/Maybe/Result パターンの比較 |
| 5 | 開発環境と CI/CD | Nix 統一アプローチ、各言語のビルドツール・リンター・フォーマッタ比較 |
| 6 | 学習ロードマップ | 推奨学習順序、パラダイム横断の概念マップ、次のステップ |

---

## Nix 環境

```
nix develop .#haskell
```

| パッケージ | 用途 |
|-----------|------|
| ghc | Glasgow Haskell Compiler |
| stack | Stack ビルドツール |
| cabal-install | Cabal パッケージマネージャ |
| haskell-language-server | Language Server Protocol 実装 |

---

## IT1-IT11 からの学び（適用事項）

| 学び | IT12 での適用 |
|------|-------------|
| .gitignore を最初に作成する | .stack-work/、dist-newstyle/ を最初に除外設定 |
| Nix 環境を必ず使用する | `nix develop .#haskell` で全操作を実行 |
| **CI は最初から Nix ベースで構築する** | IT10 Problem → IT11 で定着、IT12 も継続 |
| **部ごとにコミットを分割する** | 環境構築→第 1-4 部→統合解説→ドキュメント同期の 7 コミットに分割 |
| **最終確認で `make check` を必ず実行する** | IT11 Problem を踏まえ、各部完了時に品質ゲートを通す |
| Elixir のプロトコル → Haskell の型クラスの対応づけ | 第 3 部の概念マッピングに活用 |
| GitHub Issue の同期を忘れない | 完了時に Issue #12, #13 をクローズする |
| 複雑度チェッカーのカスタム実装 | Haskell 向けの complexity.sh を bash スクリプトで作成 |
| **統合解説の構成を事前設計する** | IT11 Try を踏まえ、6 章構成で事前設計済み |

---

## リスクと対策

| リスク | 影響度 | 対策 |
|--------|--------|------|
| 21 SP は過去最大で消化しきれない可能性 | 高 | Haskell を先行完了、統合解説は Haskell 完了後に集中。Codex 分業で並行執筆 |
| Stack の Nix 統合で依存関係の問題 | 中 | `stack --nix` オプションまたは `nix develop` 環境内で `stack` を実行 |
| Haskell のモナドやカリー化の記事説明が複雑 | 中 | FizzBuzz の具体例に絞り、理論説明は最小限に。Wiki 参照を活用 |
| 統合解説で 12 言語の正確な比較が困難 | 中 | 各 apps/{lang}/ の実装を直接参照し、事実ベースで比較表を作成 |
| HSpec テストの構成が他言語と異なる | 低 | Wiki エピソード 1 の HSpec 構成を踏襲 |
| .stack-work/ dist-newstyle/ の誤コミット | 低 | 最初に .gitignore 設定（IT7 以降の学び） |

---

## 完了条件

### Definition of Done

- [x] 12 章の記事ファイルが docs/article/haskell/ に存在
- [x] apps/haskell/ の全テストがパス（38 テスト）
- [x] HLint 警告ゼロ
- [x] mkdocs.yml に Haskell セクションが追加済み
- [x] ローカルプレビューで表示確認済み
- [x] 記事内コード例と apps/haskell/ の実コードが同期
- [x] docs/article/integration/ に統合解説が作成済み
- [x] mkdocs.yml に統合解説セクションが追加済み
- [x] GitHub Issue #12, #13 がクローズ済み
- [x] 部ごとに 7 コミットに分割済み
- [x] `make check` が全ステップパス

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-03-03 | 初版作成 | AI |
| 2026-03-03 | IT12 全タスク完了（Haskell 12 章 + 統合解説 6 章 + ドキュメント同期 + GitHub Issue クローズ） | AI |

---

## 関連ドキュメント

- [リリース計画](./release_plan.md)
- [イテレーション 11 計画](./iteration_plan-11.md)
- [イテレーション 11 ふりかえり](./retrospective-11.md)
- [Wiki 参照: Haskell エピソード 1](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門1.md)
- [Wiki 参照: Haskell エピソード 2](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門2.md)
- [Wiki 参照: Haskell エピソード 3](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門3.md)
- [Wiki 参照: Haskell エピソード 4](../../tmp/k2works-wiki/WIP/テスト駆動開発から始めるXX入門/テスト駆動開発から始めるHaskell入門4.md)
