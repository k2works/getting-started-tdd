# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [4.1.0] - 2026-09-25

多言語統合解説に mermaid レーダーチャートによる比較を追加。パラダイム特性・テストフレームワーク・型安全性・開発環境の 4 領域と、それらを集約したトータルスコア比較を可視化。mermaid を 11.17.2 へ更新。

### Documentation

- docs(plan): Release 4.0 のリリース実績を反映 (2980d0f)
- docs(integration): 多言語統合解説にレーダーチャート比較を追加 (d11e76e)
- docs(integration): トータルスコアによる総合比較を追加 (e81e727)

## [4.0.0] - 2026-09-25

Phase 4 完了 — Kotlin / Flix / Prolog の 3 言語 × 12 章 = 36 章の TDD 入門記事と実装。全 15 言語 + 統合解説となり、全アプリのテストがグリーン。

### Features

- feat(flix): FizzBuzz の TDD 実装（第 1〜2 章） (ecbffda)
- feat(flix): リスト生成と出力を実装 (1747330)
- feat(flix): 列挙型・トレイト・コマンドで FizzBuzz を構造化 (53c774c)
- feat(flix): 高階関数・パイプライン・代数的効果を実装 (18e8c39)
- feat(kotlin): FizzBuzz を全 4 部の題材で TDD 実装 (3101518)
- feat(prolog): SWI-Prolog 環境と FizzBuzz 実装一式を追加 (df7a4b6)

### Bug Fixes

- fix(docs): mermaid 10.6.1 非対応の xychart-beta をテーブルに置換 (c1ca3da)
- fix(kotlin): Kotlin プラグインを 2.2.20 に更新 (0c32505)

### Documentation

- docs: リリース計画に実績ガントチャートを追加 (3840e0f)
- docs: 言語数の表記を 12 言語から 14 言語に統一 (368135a)
- docs: 多言語記事と設計資料テンプレートを追加 (90b7cee)
- docs: 記事タイトルと関連ドキュメントを更新 (d0a78c1)
- docs: README の記事タイトルを修正 (14cc557)
- docs: README のクイックスタートを整理 (c876f08)
- docs(flix): 対象言語に Flix を追加し記事の骨子と第 1 章を執筆 (2c9d039)
- docs(flix): 第 2〜3 章を執筆し第 1 部を完成 (6038319)
- docs(flix): 第 4〜6 章を執筆し第 2 部を完成 (cf77c41)
- docs(flix): 第 7〜9 章を執筆し第 3 部を完成 (81782ac)
- docs(flix): 第 10〜12 章を執筆し全 12 章を完成 (5d0bec8)
- docs(integration): 多言語統合解説に Flix を反映 (2ffa430)
- docs(flix): Nix 環境の整備状況を反映 (245f3b6)
- docs(skill): creating-article スキルを追加 (e08ebec)
- docs(skill): creating-article の description を最適化 (d5eac36)
- docs(kotlin): 対象言語に Kotlin を追加し記事の骨子を作成 (d22f938)
- docs(kotlin): 全 12 章を執筆し第 1〜4 部を完成 (0883ef2)
- docs(integration): 多言語統合解説に Kotlin を反映 (d409b3d)
- docs(prolog): シリーズ骨子に Prolog を追加 (1736f46)
- docs(prolog): 全 12 章を執筆し第 1〜4 部を完成 (f360be6)
- docs(integration): 多言語統合解説に Prolog を反映 (de9d798)
- docs(prolog): 追加執筆計画と進捗表を完了に更新 (0a94d3b)
- docs: elixir 目次のリンク切れ修正と重複ツリー docs/docs を削除 (f92c2d3)
- docs(elixir): 目次の第 10・12 章リンク切れを修正 (8ec3053)
- docs: reference のリンク切れ修正と template を build から除外 (4180134)
- docs(kotlin): 記事ディレクトリの状態を完了に更新 (ea6894e)
- docs(plan): Phase 4（Kotlin・Flix・Prolog）をリリース計画に反映 (3cb6365)
- docs(plan): 開発ドキュメント索引に Phase 4 とテスト実行環境を追記 (e41c9c9)
- docs(plan): Phase 4 完了報告書を追加 (01a62cb)

### Refactoring

- refactor(kotlin): ドメインを 3 層パッケージへ再編成し ch9 を Ruby と同構成に (e4aadd9)

### Build

- build(kotlin): Gradle Wrapper を追加 (c124008)
- build(java): Gradle デーモンの JVM を 21 に固定 (925f258)

### CI

- ci(flix): Nix 対応の GitHub Actions ワークフローを追加 (f65abb8)
- ci(kotlin): Nix 対応の GitHub Actions ワークフローを追加 (35707d0)
- ci(prolog): Nix 対応の GitHub Actions ワークフローを追加 (b084a5c)

### Chores

- chore(flix): 開発タスク用の Makefile を追加 (2dbb2ed)
- chore(flix): Nix 開発環境を追加 (3fae093)
- chore(kotlin): Nix 環境と Gradle プロジェクト雛形を追加 (3b14427)

## [3.0.0] - 2026-03-04

Phase 3 完了 — Clojure / Scala / Elixir / Haskell の 4 言語 × 12 章 + 多言語統合解説 6 章 = 54 章の TDD 入門記事と実装。全 14 言語 + 統合解説でプロジェクト完了。

### Features

- feat(integration): IT12 多言語統合解説の執筆を完了 (b94c191)
- feat(haskell): IT12 第 4 部（章 10-12）の記事執筆と FP 実装を完了 (c4d96fa)
- feat(haskell): IT12 第 3 部（章 7-9）の記事執筆と型クラス/ADT 実装を完了 (7c70d9b)
- feat(haskell): IT12 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了 (bcda0dc)
- feat(haskell): IT12 第 1 部（章 1-3）の記事執筆と TDD 実装を完了 (2aaf810)
- feat(haskell): IT12 環境構築（Stack + HSpec + HLint） (0d698a6)
- feat(elixir): IT11 第 4 部（章 10-12）の記事執筆と FP 実装を完了 (9750562)
- feat(elixir): IT11 第 3 部（章 7-9）の記事執筆とプロトコル/パターンマッチ実装を完了 (686127c)
- feat(elixir): IT11 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了 (7693873)
- feat(elixir): IT11 環境構築と第 1 部（章 1-3）の記事執筆と TDD 実装を完了 (79975ed)
- feat(scala): CI/CD を Nix ベースに移行し記事を更新 (1f18a3a)
- feat(scala): コード複雑度チェッカーと記事セクションを追加 (3e0d031)
- feat(scala): IT10 第 4 部（章 10-12）の記事執筆と FP 実装を完了 (7e32794)
- feat(scala): IT10 第 3 部（章 7-9）の記事執筆と OOP/パターンマッチ実装を完了 (058dfb4)
- feat(scala): IT10 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了 (18c0de3)
- feat(scala): IT10 環境構築と第 1 部（章 1-3）の記事執筆と TDD 実装を完了 (0b950ad)
- feat(clojure): IT9 Clojure の TDD 入門記事執筆と実装を完了 (e283220)

### Bug Fixes

- fix(elixir): Credo --strict の警告を修正 (c728f1b)

### Documentation

- docs: ドキュメントインデックスに IT10-12 のリンクを追加 (3444e9e)
- docs: IT12 ふりかえりと完了報告書を追加 (b25cfcc)
- docs: 記事インデックスに全言語のリンクを追加し言語数を更新 (eb86b54)
- docs: IT12 完了に伴うドキュメント同期と GitHub 同期 (21fca40)
- docs: IT12（Haskell + 統合解説）イテレーション計画を作成 (17a69bb)
- docs: IT11 ふりかえりと完了報告書を追加 (937a692)
- docs: IT11 完了に伴うドキュメント同期と GitHub Issue クローズ (cfe071f)
- docs: IT11（Elixir）イテレーション計画を作成 (2440b11)
- docs: IT10 ふりかえりと完了報告書を追加 (c2a1c38)
- docs: IT10 完了に伴うドキュメント同期と GitHub Issue クローズ (f1380f6)
- docs: IT9 完了ドキュメントと IT10 計画書を追加 (d63cca0)

### Chores

- chore(rust): タスクランナーを Makefile から just に移行 (262cbeb)

## [1.1.0] - 2026-03-02

Phase 2 完了 — Go / PHP / Rust / C#・F# の 4 言語 × 12 章 + F# 12 章 = 60 章の TDD 入門記事と実装。

### Features

- feat(dotnet): FSharpLint による F# コード複雑度チェックを追加 (c5d1005)
- feat(dotnet): SonarAnalyzer によるコード複雑度チェックを追加 (43c8e38)
- feat(dotnet): IT8 C#/F# の TDD 入門記事執筆と実装を完了 (0a5db5d)
- feat(rust): Clippy によるコード複雑度チェックを追加 (cdc089c)
- feat(rust): fizz_buzz 公開 API モジュールを追加 (34246ac)
- feat(rust): IT7 第 3-4 部（章 7-12）の記事執筆と OOP/FP 実装を完了 (05afe55)
- feat(rust): IT7 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了 (723327a)
- feat(rust): IT7 第 1 部（章 1-3）の記事執筆と TDD 実装を完了 (86e99d4)
- feat(php): PHPMD によるコード複雑性チェックを追加 (2fa57b9)
- feat(php): IT6 第 3-4 部（章 7-12）の記事執筆と OOP/FP 実装を完了 (8ff0f0b)
- feat(php): IT6 第 2 部（章 4-6）の記事執筆と開発ツール導入を完了 (23bbc74)
- feat(php): IT6 第 1 部（章 1-3）の記事執筆と TDD 実装を完了 (d81bbcb)
- feat(go): IT5 第 4 部（章 10-12）の記事執筆・実装 (4ffca69)
- feat(go): IT5 第 3 部（章 7-9）の記事執筆・実装 (21000dd)
- feat(go): IT5 第 2 部（章 4-6）の記事執筆・実装 (a716000)
- feat(go): IT5 環境構築と第 1 部（章 1-3）の記事執筆・実装 (9fb25ec)

### Bug Fixes

- fix(rust): OOP/FP 実装のコード品質を改善 (e88b9ab)
- fix(go): golangci-lint の revive/unused 警告を全て解消 (7fd1e3c)

### Documentation

- docs: IT8 完了に伴うドキュメント同期と GitHub Milestone クローズ (ec90ac0)
- docs: IT7 完了ドキュメント同期と IT8 計画書を追加 (028fea1)
- docs: IT7 完了に伴うドキュメント同期と GitHub Issue クローズ (0529af8)
- docs: IT6 ふりかえり・完了報告書を作成しドキュメント同期 (77c82a4)
- docs: IT6 完了に伴うドキュメント同期と GitHub Issue クローズ (a3e3145)
- docs: IT5 ふりかえり・完了報告書を作成し進捗を最終更新 (0f55ec9)
- docs: IT5 完了報告書をテンプレート準拠に修正しインデックスを更新 (389947d)
- docs: リリース計画を Phase 1 完了状態に同期 (1e2acb8)
- docs(development): IT7（Rust）イテレーション計画を作成 (1b50c25)
- docs(development): IT6（PHP）イテレーション計画を作成 (c157892)
- docs(development): IT5（Go）イテレーション計画を作成 (adff1d2)
- docs(development): IT5 進捗を更新（環境構築 + 第 1 部完了） (8f8c647)

### Chores

- chore(rust): target/ を .gitignore に追加し追跡から除外 (92cf3b6)
- chore(php): vendor/ を .gitignore に追加し追跡から除外 (4d3a56b)

## [1.0.0] - 2026-03-02

Phase 1 完了 — Java / Python / TypeScript / Ruby の全 4 言語 × 12 章 = 48 章の TDD 入門記事と実装。

### Features

- feat(ruby): 関数型プログラミング機能を実装（章 10-12） (30811f0)
- feat(ruby): OOP リファクタリングとモジュール分割を実装（章 7-9） (fdc9db5)
- feat(ruby): コード複雑度チェックを追加（CyclomaticComplexity/PerceivedComplexity） (885c261)
- feat(ruby): Guard によるファイル監視と Rake タスクを追加（章 4-6） (0e9720d)
- feat(ruby): Ruby プロジェクト初期化と FizzBuzz TDD 実装（章 1-3） (1054295)
- feat(node): 関数型プログラミング機能を実装（章 10-12） (f3d763a)
- feat(node): OOP リファクタリングとモジュール分割を実装 (601e0d8)
- feat(node): Jest から Vitest へ移行し Gulp タスクランナーと CI を追加 (e90cad0)
- feat(node): IT3 apps/node/ プロジェクト初期化と第 1 部 TDD 実装 (e97ba22)
- feat(python): コード複雑度チェックと CI ワークフローを追加 (7527450)
- feat(python): IT2 第4部（章 10-12）の記事執筆と関数型プログラミングを実装 (9058636)
- feat(python): IT2 第3部（章 7-9）の記事執筆と OOP 設計を実装 (6f08bf2)
- feat(python): IT2 第2部（章 4-6）の記事執筆と開発環境を構築 (e591920)
- feat(python): IT2 第1部（章 1-3）の記事執筆と TDD 実装を完了 (cfa3ec6)
- feat(java): 関数型プログラミング機能を追加 (cdd8557)
- feat(java): FizzBuzz TDD 実装と開発環境を構築 (b56bca0)

### Bug Fixes

- fix(python): tox のバージョンを固定し CI の packaging.pylock エラーを修正 (df94259)

### Documentation

- docs: IT4 ふりかえり・完了報告書を作成し進捗を最終更新 (be542d9)
- docs(ruby): IT4 第 1〜12 章の記事を執筆 (6574611, cadd324, 077c048, b8e66ac)
- docs: IT3 ふりかえり・完了報告書を作成し進捗を最終更新 (ac849a1)
- docs(node): IT3 第 1〜12 章の記事を執筆 (9dca0e0, fa72f39, e127474, 36a3162)
- docs: IT2 ふりかえり・完了報告書を作成し進捗を最終更新 (2c87ed3)
- docs(java): IT1 第 1〜12 章の記事を執筆 (626186d, 5cfa9b4, 1517aaf, cc6ba5c)
- docs: リリース計画・イテレーション計画（IT1〜IT4）を作成 (8b368ed, 2687afb, 612337e)
- docs(article): 執筆計画アウトライン・ワークフローを作成 (f17f21f)

### Tests

- test(java): カバレッジを 80% 以上に改善（93%/85%） (8330422)

### Refactoring

- refactor(java): FizzBuzz を OOP 設計にリファクタリング (ec61395)
- refactor(ci): Java CI ワークフローを Nix ベースに変更 (b867482)
- refactor(skills): syncing-github-project の Iteration フィールド対応と手順改善 (b6cbe0c)
- refactor(skills): orchestrating-development を記事執筆ワークフローに変更 (e7d8884)

### CI

- ci(ruby): GitHub Actions CI ワークフローを追加 (403f481)
- ci(java): GitHub Actions CI ワークフローを追加 (b8886a6)

### Chores

- chore: .gitignore に Python 関連の除外パターンを追加 (3ddccce)

### Styles

- style(docs): Markdown Lint 違反を修正 (cee663d)
