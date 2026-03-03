# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

Scala 開発では、依存関係の管理とコード品質の維持を仕組み化することが重要です。
この章では、`sbt` によるパッケージ管理と `scalafmt`、`WartRemover`、コンパイラオプションによる品質管理を扱います。

## 5.2 sbt によるパッケージ管理

### build.sbt の構成

`apps/scala/build.sbt` では、プロジェクトの基本情報と依存関係を定義します。

```scala
lazy val root = (project in file("."))
  .settings(
    name := "fizzbuzz",
    version := "0.1.0",
    scalaVersion := "3.3.4",
    libraryDependencies ++= Seq(
      "org.scalatest" %% "scalatest" % "3.2.18" % Test
    )
  )
```

- `name`: プロジェクト名
- `version`: アプリケーションのバージョン
- `scalaVersion`: 使用する Scala バージョン
- `libraryDependencies`: 利用ライブラリ

### プラグインの追加（project/plugins.sbt）

`sbt` プラグインは `apps/scala/project/plugins.sbt` に追加します。

```scala
addSbtPlugin("org.scalameta" % "sbt-scalafmt" % "2.5.2")
addSbtPlugin("org.wartremover" % "sbt-wartremover" % "3.2.5")
```

### 依存関係の管理（`%` と `%%` の違い、Test スコープ）

- `%`: Java など Scala バージョンに依存しない Artifact に使います。
- `%%`: Scala バージョン接尾辞（例: `_3`）を自動付与します。
- `% Test`: テスト時だけ必要な依存関係に付けます。

例:

```scala
"org.scalatest" %% "scalatest" % "3.2.18" % Test
```

この指定により、本番 Artifact には `ScalaTest` が含まれません。

## 5.3 scalafmt によるコードフォーマット

`apps/scala/.scalafmt.conf` は次の設定です。

```scala
version = 3.7.17
runner.dialect = scala3
maxColumn = 100
```

整形コマンド:

```bash
cd apps/scala
sbt scalafmt
sbt scalafmtCheck
```

- `sbt scalafmt`: 自動整形
- `sbt scalafmtCheck`: 未整形コードを検出（CI 向け）

## 5.4 WartRemover による静的解析

`WartRemover` は危険な記述をコンパイル時に検出する静的解析ツールです。

### build.sbt への設定追加

`build.sbt` に次のような設定を追加します。

```scala
wartremoverErrors ++= Seq(
  Wart.Null,
  Wart.Var,
  Wart.Return
)
```

### 検出される問題の種類

- `Null`: `null` 利用による `NullPointerException` リスク
- `Var`: 可変変数による状態変化の複雑化
- `Return`: 早期 return による制御フローの可読性低下

### 警告と推奨事項

- まずは `Errors` を最小セットで導入します。
- 既存コードが多い場合は段階的にルールを増やします。
- `Option`、不変 `val`、式指向の記述に置き換えると改善しやすいです。

## 5.5 コンパイラオプション

`apps/scala/build.sbt` では次の `scalacOptions` を設定しています。

```scala
scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-Xfatal-warnings"
)
```

- `-deprecation`: 非推奨 API 使用時に警告
- `-feature`: 明示が必要な言語機能使用時に警告
- `-unchecked`: 型検査が不十分な箇所を警告
- `-Xfatal-warnings`: 警告をエラー扱いにして品質を強制

## 5.6 まとめ

この章では、Scala プロジェクトの品質基盤を整えました。

- `sbt` で依存関係とプラグインを管理する
- `scalafmt` でフォーマットを統一する
- `WartRemover` で危険な記述を早期検出する
- `scalacOptions` でコンパイル時の品質ゲートを強化する

次章では、これらを `Makefile` と GitHub Actions で自動実行する方法を扱います。
