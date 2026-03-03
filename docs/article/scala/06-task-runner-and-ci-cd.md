# 第 6 章: タスクランナーと CI/CD

## 6.1 はじめに

TDD を継続するには、テスト・整形・静的解析を毎回確実に実行できる仕組みが必要です。
この章では、`Makefile`、`sbt` タスク、GitHub Actions を使って開発タスクを自動化します。

## 6.2 Makefile によるタスク管理

`apps/scala/Makefile` には、日常的に使うタスクが定義されています。

```makefile
.PHONY: test fmt fmt-check lint check build run clean

test:
	sbt test

fmt:
	sbt scalafmt

fmt-check:
	sbt scalafmtCheck

lint:
	sbt compile

check: fmt-check lint test
```

この構成の狙いは、`make check` 1 つで品質ゲートをまとめて実行できる点です。

- `test`: 単体テスト実行
- `fmt` / `fmt-check`: フォーマット適用と検証
- `lint`: コンパイルによる静的チェック
- `check`: CI と同等のローカル検証

## 6.3 sbt のカスタムタスク

`sbt` では `build.sbt` に独自タスクを追加できます。
たとえば、テストと整形確認をまとめたタスクは次のように定義できます。

```scala
lazy val verify = taskKey[Unit]("Run format check and tests")

verify := {
  (Compile / compile).value
  (Test / test).value
}
```

また、`~` prefix を使うとファイル変更を監視して自動実行できます。

```bash
cd apps/scala
sbt ~test
```

TDD の Red → Green を高速に回すときに有効です。

## 6.4 GitHub Actions による CI/CD

`.github/workflows/scala-ci.yml` では、`apps/scala` への変更を契機に CI を実行しています。

```yaml
name: Scala CI
on:
  push:
    paths: ['apps/scala/**']
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '21'
          cache: 'sbt'
      - run: sbt test
      - run: sbt scalafmtCheck
```

実際のワークフローでは `pull_request` にも対応し、`working-directory: apps/scala` を指定して Scala アプリ配下でコマンドを実行しています。

CI の主なポイントは次の通りです。

- `actions/setup-java@v4` で JDK 21 を準備
- `cache: 'sbt'` で依存解決を高速化
- `sbt test` と `sbt scalafmtCheck` を必須チェックに設定

## 6.5 開発ワークフロー

Red-Green-Refactor を自動化で支える基本フローは次の通りです。

1. Red: 失敗するテストを追加し、`make test` で失敗を確認
2. Green: 最小実装で `make test` を通過
3. Refactor: `make check` で整形・コンパイル・テストを一括確認
4. Push: GitHub Actions で同じチェックを再実行

ローカルと CI のコマンドを揃えることで、環境差分による失敗を減らせます。

## 6.6 まとめ

この章では、Scala 開発の自動化基盤を整理しました。

- `Makefile` で日常タスクを短いコマンドに集約する
- `sbt` のタスクと監視実行で開発サイクルを高速化する
- GitHub Actions でリモートでも同一品質ゲートを適用する

第 2 部の環境整備が完了したので、次章からはオブジェクト指向設計に進みます。
