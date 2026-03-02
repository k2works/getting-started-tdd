# 第 5 章: パッケージ管理と静的解析

## 5.1 はじめに

前章では Conventional Commits によるコミットメッセージの規約を学びました。この章では、**パッケージ管理** と **静的コード解析** を導入し、コードの品質を自動でチェックできるようにします。

## 5.2 Cargo によるパッケージ管理

### Cargo とは

> Cargo は Rust のパッケージマネージャ兼ビルドシステムです。プロジェクトの作成、ビルド、テスト、依存関係の管理、パッケージの公開まで、Rust 開発のあらゆる面をサポートします。

Java の Gradle、Node の npm（package.json）、Python の uv、Ruby の Bundler（Gemfile）、Go の Go Modules に相当するのが Cargo です。

### Cargo.toml の構成

本プロジェクトの `Cargo.toml` は以下のようになっています。

```toml
[package]
name = "fizzbuzz"
version = "0.1.0"
edition = "2021"
```

Rust の標準ライブラリ（`std::io`、`std::fmt` など）はインポートの `use` 宣言だけで利用でき、`Cargo.toml` への追加は不要です。

### 主要なコマンド

| コマンド | 説明 |
|---------|------|
| `cargo new <name>` | 新しいプロジェクトを作成 |
| `cargo build` | プロジェクトをビルド |
| `cargo test` | テストを実行 |
| `cargo run` | バイナリを実行 |
| `cargo add <crate>` | 依存クレートを追加 |
| `cargo update` | 依存クレートを更新 |

### Cargo の特徴

- **`Cargo.lock` による再現性** — 依存クレートのバージョンを固定し、チーム全員が同じ環境で開発できる
- **ワークスペース** — 複数クレートを 1 つのプロジェクトで管理
- **`target/` ディレクトリ** — Node の `node_modules/`、Python の `.venv/` に相当（`.gitignore` に追加）

## 5.3 Clippy による静的解析

### Clippy とは

> Clippy は Rust の公式リンターです。コードの品質を向上させるための数百のルール（lint）を提供し、一般的なミスやアンチパターンを検出します。

Ruby の RuboCop、Java の Checkstyle + PMD、TypeScript の ESLint、Python の Ruff、Go の golangci-lint に相当するツールです。

### 実行してみる

```bash
$ cargo clippy -- -D warnings
```

`-D warnings` オプションを付けることで、警告をエラーとして扱い、CI で確実にチェックできます。

### Clippy のカテゴリ

| カテゴリ | 説明 |
|---------|------|
| `clippy::correctness` | バグになりうるコード（デフォルト有効） |
| `clippy::style` | 慣用的でないコードスタイル |
| `clippy::complexity` | 不必要に複雑なコード |
| `clippy::perf` | パフォーマンスに影響するコード |
| `clippy::pedantic` | より厳密なチェック（オプトイン） |

## 5.4 rustfmt によるコードフォーマット

### rustfmt とは

> rustfmt は Rust の公式コードフォーマッターです。コードスタイルを統一し、チーム内のスタイル議論を排除します。

Go の gofmt、Python の Ruff format、TypeScript の Prettier、Ruby の RuboCop --auto-correct に相当します。

### 実行してみる

```bash
# フォーマットチェック（CI 向け）
$ cargo fmt --check

# 自動フォーマット
$ cargo fmt
```

### コードスタイル例

rustfmt はデフォルトで以下のスタイルを適用します。

```rust
// Before（手動フォーマット）
fn generate(number:i32)->String{
match(number%3,number%5){(0,0)=>"FizzBuzz".to_string(),(0,_)=>"Fizz".to_string(),(_, 0)=>"Buzz".to_string(),_=>number.to_string(),}
}

// After（rustfmt 適用後）
fn generate(number: i32) -> String {
    match (number % 3, number % 5) {
        (0, 0) => "FizzBuzz".to_string(),
        (0, _) => "Fizz".to_string(),
        (_, 0) => "Buzz".to_string(),
        _ => number.to_string(),
    }
}
```

## 5.5 コードカバレッジ

### cargo-tarpaulin

Rust のカバレッジツールとして `cargo-tarpaulin` があります。

```bash
# インストール（任意）
$ cargo install cargo-tarpaulin

# カバレッジ計測
$ cargo tarpaulin --out stdout
```

!!! note "カバレッジの代替手段"
    cargo-tarpaulin は Linux 環境向けです。macOS では `cargo llvm-cov` が利用できます。Nix 環境ではインストールが必要な場合があるため、テスト網羅率で代替することも可能です。

## 5.6 まとめ

この章では以下を導入しました。

| ツール | 役割 | 他言語の対応ツール |
|--------|------|-------------------|
| Cargo | パッケージ管理・ビルド | npm, Bundler, Go Modules, Gradle |
| Clippy | 静的解析（リンター） | ESLint, RuboCop, golangci-lint, Ruff |
| rustfmt | コードフォーマット | Prettier, gofmt, RuboCop --auto-correct |
| cargo-tarpaulin | カバレッジ計測 | c8, SimpleCov, go test -cover |

次章では、これらのツールを **タスクランナー**（Makefile）でまとめて実行できるようにし、**CI/CD** パイプラインを構築します。
