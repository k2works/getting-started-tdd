# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

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
