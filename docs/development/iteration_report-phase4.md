# Phase 4 完了報告書（イテレーション 13〜15）

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **プロジェクト名** | テスト駆動開発から始めるプログラミング入門 |
| **フェーズ** | Phase 4（追加言語） |
| **イテレーション** | 13〜15 |
| **対象** | Kotlin、Flix、Prolog |
| **開始日** | 2026-07-18 |
| **終了日** | 2026-09-25 |

Phase 3（Release 3.0、2026-03-04）でプロジェクトは当初計画を完了したが、
その後 3 言語を追加執筆した。本報告書はその実績を Phase 4 としてまとめる。

### 要員

| 項目 | 予定 | 実績 |
|------|------|------|
| **開発者** | 1 名 + AI | 1 名 + AI |

---

## 指標

### 完了ストーリー

| イテレーション | ユーザーストーリー | SP | 実績 SP | 状態 |
|---------------|-------------------|----|---------|------|
| 13 | US-014 Kotlin の TDD 入門記事の執筆と実装 | 13 | 13 | 完了 |
| 14 | US-015 Flix の TDD 入門記事の執筆と実装 | 13 | 13 | 完了 |
| 15 | US-016 Prolog の TDD 入門記事の執筆と実装 | 13 | 13 | 完了 |
| **合計** | | **39** | **39** | |

### バーンダウン

| 時点 | 残 SP |
|------|-------|
| Phase 4 開始 | 39 |
| IT13（Kotlin）完了 | 26 |
| IT14（Flix）完了 | 13 |
| IT15（Prolog）完了 | 0 |

### ビルド結果

| 言語 | テストコマンド | 結果 |
|------|---------------|------|
| Kotlin | `gradle test` | ✅ 39 tests PASS |
| Flix | `make test`（`flix test`） | ✅ 45 tests PASS |
| Prolog | `make test`（`plunit`） | ✅ 28 tests PASS |

### 成果物

| 言語 | 記事 | 実装 | Nix 環境 |
|------|------|------|----------|
| Kotlin | `docs/article/kotlin/`（index + 全 12 章） | `apps/kotlin/`（Gradle + kotlin.test） | `ops/nix/environments/kotlin/` |
| Flix | `docs/article/flix/`（index + 全 12 章） | `apps/flix/`（flix.toml + `@Test`） | `ops/nix/environments/flix/` |
| Prolog | `docs/article/prolog/`（index + 全 12 章） | `apps/prolog/`（Makefile + plunit） | `ops/nix/environments/prolog/` |

横断ドキュメント（`docs/article/index.md` の全章リンク表、
`docs/article/integration/` の 6 本）にも 3 言語を反映済み。

---

## 実施内容と評価

### 技術トピック

| 言語 | 第 3 部の読み替え | 第 4 部の焦点 |
|------|------------------|--------------|
| Kotlin | data class・sealed class・interface による OOP | null 安全、`Result`、`Sequence` 遅延評価 |
| Flix | enum・trait による多相 | 代数的効果、`Functor`/`Foldable`、`\|>` パイプライン |
| Prolog | 複数節ディスパッチ・項としての値・モジュール分割 | `call/N`・`maplist`、単一化による不変性、`ok/error` |

Prolog では OOP のクラス階層が存在しないため、第 3 部を
「複数節ディスパッチ・値としての項・モジュール分割」へ読み替えた。これにより
論理型パラダイムでも 12 章構成を崩さずに執筆できた。

### 品質保証の実績

全 15 アプリのテストを 2026-09-25 に一括実行し、グリーンを確認した。
この過程で 2 件のビルド不具合を検出・修正している。

| 事象 | 原因 | 対応 |
|------|------|------|
| Kotlin の Internal compiler error | Kotlin 2.1.0 が JDK 25 のバージョン文字列を解釈できない | プラグインを 2.2.20 へ更新 |
| Java の `Unsupported class file major version 69` | Gradle 8.14.3 が JDK 25 を解釈できない | `gradle-daemon-jvm.properties` で JVM を 21 に固定 |

また haskell・ruby・flix・prolog はホスト環境では実行できず Nix 環境が必要である
ことを確認し、`docs/development/index.md` に区分として記載した。

---

## ふりかえり（KPT）

### Keep

- 追加言語の執筆計画を `docs/article/outline.md` の「追加執筆計画」に集約し、
  前提整備（Nix 環境・アプリ雛形・テスト基盤・記事ディレクトリ）を表で管理した
- Nix 環境を言語ごとに追加し flake に登録することで、ホスト環境に依存せず
  再現可能なテスト実行を維持できた
- パラダイムが異なる言語（Prolog）でも 12 章構成を読み替えで維持した

### Problem

- Phase 4 を計画ドキュメントへ反映しないまま執筆を進めたため、
  `release_plan.md` の Single Source of Truth が一時的に実態と乖離した
- Kotlin の Gradle Wrapper が未コミットで、CI や他環境で再現ビルドできなかった
- テストを普段 Nix 環境でのみ実行していたため、ホスト環境（JDK 25）での
  ビルド不成立に気付くのが遅れた

### Try

- 追加言語の着手時点で `release_plan.md` にイテレーションを追記し、
  計画と実態の乖離を作らない
- 言語追加の完了条件に「ビルド成果物ではないツールチェーン設定
  （wrapper 等）のコミット」を含める
- 全アプリ一括テストを定期的に実行し、ホスト／Nix 双方で結果を確認する

---

## 残作業

- ~~Release 4.0 のタグ付け（v4.0.0）と CHANGELOG 生成~~ ✅（2026-09-25）
- haskell のホスト環境ビルド（GHC 更新または `ar` 指定）の検討

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-09-25 | 初版作成（Phase 4: IT13〜15 の実績をまとめ） | AI |
