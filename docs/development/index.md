# 開発ドキュメント

## 計画

- [リリース計画](./release_plan.md) - 4 フェーズ × 15 イテレーションのリリース計画

## イテレーション 1（Java）

- [イテレーション 1 計画](./iteration_plan-1.md) - Java（基準言語）の執筆・実装計画
- [ふりかえり 1](./retrospective-1.md) - IT1 の KPT 分析
- [完了報告書 1](./iteration_report-1.md) - IT1 の実績と評価

## イテレーション 2（Python）

- [イテレーション 2 計画](./iteration_plan-2.md) - Python の執筆・実装計画
- [ふりかえり 2](./retrospective-2.md) - IT2 の KPT 分析
- [完了報告書 2](./iteration_report-2.md) - IT2 の実績と評価

## イテレーション 3（Node/JS/TS）

- [イテレーション 3 計画](./iteration_plan-3.md) - Node（JS/TS）の執筆・実装計画
- [ふりかえり 3](./retrospective-3.md) - IT3 KPT 分析
- [完了報告書 3](./iteration_report-3.md) - IT3 実績・品質メトリクス

## イテレーション 4（Ruby）

- [イテレーション 4 計画](./iteration_plan-4.md) - Ruby の執筆・実装計画
- [ふりかえり 4](./retrospective-4.md) - IT4 KPT 分析
- [完了報告書 4](./iteration_report-4.md) - IT4 実績・品質メトリクス

## イテレーション 5（Go）

- [イテレーション 5 計画](./iteration_plan-5.md) - Go の執筆・実装計画
- [ふりかえり 5](./retrospective-5.md) - IT5 KPT 分析
- [完了報告書 5](./iteration_report-5.md) - IT5 実績・品質メトリクス

## イテレーション 6（PHP）

- [イテレーション 6 計画](./iteration_plan-6.md) - PHP の執筆・実装計画
- [ふりかえり 6](./retrospective-6.md) - IT6 KPT 分析
- [完了報告書 6](./iteration_report-6.md) - IT6 実績・品質メトリクス

## イテレーション 7（Rust）

- [イテレーション 7 計画](./iteration_plan-7.md) - Rust の執筆・実装計画
- [ふりかえり 7](./retrospective-7.md) - IT7 KPT 分析
- [完了報告書 7](./iteration_report-7.md) - IT7 実績・品質メトリクス

## イテレーション 8（C#/F#）

- [イテレーション 8 計画](./iteration_plan-8.md) - C#/F# の執筆・実装計画
- [ふりかえり 8](./retrospective-8.md) - IT8 KPT 分析
- [完了報告書 8](./iteration_report-8.md) - IT8 実績・品質メトリクス

## イテレーション 9（Clojure）

- [イテレーション 9 計画](./iteration_plan-9.md) - Clojure の執筆・実装計画
- [ふりかえり 9](./retrospective-9.md) - IT9 KPT 分析
- [完了報告書 9](./iteration_report-9.md) - IT9 実績・品質メトリクス

## イテレーション 10（Scala）

- [イテレーション 10 計画](./iteration_plan-10.md) - Scala の執筆・実装計画
- [ふりかえり 10](./retrospective-10.md) - IT10 KPT 分析
- [完了報告書 10](./iteration_report-10.md) - IT10 実績・品質メトリクス

## イテレーション 11（Elixir）

- [イテレーション 11 計画](./iteration_plan-11.md) - Elixir の執筆・実装計画
- [ふりかえり 11](./retrospective-11.md) - IT11 KPT 分析
- [完了報告書 11](./iteration_report-11.md) - IT11 実績・品質メトリクス

## イテレーション 12（Haskell + 統合解説）

- [イテレーション 12 計画](./iteration_plan-12.md) - Haskell + 多言語統合解説の執筆・実装計画
- [ふりかえり 12](./retrospective-12.md) - IT12 KPT 分析（プロジェクト全体ふりかえり含む）
- [完了報告書 12](./iteration_report-12.md) - IT12 実績・品質メトリクス（最終報告書）

## Phase 4（追加言語: Kotlin / Flix / Prolog）

Phase 3 完了後に追加した 3 言語（イテレーション 13〜15、計 39 SP）。
執筆計画は [記事アウトライン](../article/outline.md) の「追加執筆計画」、
実績は [リリース計画](./release_plan.md) の Phase 4 節に記載。

- IT13 Kotlin（13 SP） - [記事](../article/kotlin/index.md) / `apps/kotlin` / 16 テスト
- IT14 Flix（13 SP） - [記事](../article/flix/index.md) / `apps/flix` / 45 テスト
- IT15 Prolog（13 SP） - [記事](../article/prolog/index.md) / `apps/prolog` / 28 テスト

## テスト実行環境

全 15 アプリのテストは 2026-09-25 時点でグリーン。実行環境には次の区分がある。

- ホスト環境で実行可 - go, rust, python, node, php, dotnet, elixir, java,
  kotlin, scala, clojure
- Nix 環境が必要 - haskell, ruby, flix, prolog

Nix 環境は `nix develop .#<言語>` で起動する。haskell はホストの GHC 9.8.4 と
Apple `ar` の組み合わせでリンクに失敗し、ruby はホストの system Ruby 2.6 が
`Gemfile.lock` の Bundler 2.7.2 を満たせないため、いずれも Nix 環境で実行する。
