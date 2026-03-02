# 第 6 章: タスクランナーと CI/CD

## 6.1 はじめに

前章では静的コード解析ツールとコードフォーマッターを導入しました。テストの実行、静的解析、フォーマットチェックと、様々なコマンドを使えるようになりましたが、毎回それぞれのコマンドを覚えて実行するのは面倒です。

この章では **タスクランナー** を使ってこれらのタスクをまとめて実行できるようにし、さらに **CI/CD** パイプラインを構築します。

## 6.2 Makefile によるタスク管理

### Makefile とは

> Makefile は Unix 系の定番ビルド/タスク管理ツールである make の設定ファイルです。ターゲット（タスク名）と依存関係、実行コマンドを定義し、`make <ターゲット>` で実行できます。

Ruby の Rake、Java の Gradle、Node の npm scripts、Python の tox、Go プロジェクトでの Makefile に相当します。Rust のプロジェクトでも Makefile がタスクランナーとして広く使われています。

### Makefile の定義

```makefile
.PHONY: test lint fmt check build run clean

test:
	cargo test

lint:
	cargo clippy -- -D warnings

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

check: fmt-check lint test

build:
	cargo build --release

run:
	cargo run

clean:
	cargo clean
```

### 主要なタスク

| タスク | コマンド | 説明 |
|--------|---------|------|
| `make test` | `cargo test` | テスト実行 |
| `make lint` | `cargo clippy -- -D warnings` | Clippy による静的解析 |
| `make fmt` | `cargo fmt` | コードフォーマット |
| `make fmt-check` | `cargo fmt --check` | フォーマットチェック |
| `make check` | fmt-check → lint → test | 全チェック実行 |
| `make build` | `cargo build --release` | リリースビルド |
| `make clean` | `cargo clean` | ビルド成果物の削除 |

### 実行例

```bash
# 全チェック実行
$ make check
cargo fmt --check
cargo clippy -- -D warnings
cargo test
test result: ok. 12 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## 6.3 GitHub Actions による CI/CD

### CI/CD とは

> CI/CD（Continuous Integration / Continuous Delivery）は、コードの変更を自動的にビルド、テスト、デプロイするプラクティスです。

### ワークフローの定義

`.github/workflows/rust-ci.yml` にワークフローを定義します。

```yaml
name: Rust CI

on:
  push:
    branches: [main, develop]
    paths:
      - "apps/rust/**"
      - ".github/workflows/rust-ci.yml"
  pull_request:
    branches: [main]
    paths:
      - "apps/rust/**"

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout the repository
        uses: actions/checkout@v4

      - name: Install Nix
        uses: cachix/install-nix-action@v30
        with:
          nix_path: nixpkgs=channel:nixos-unstable

      - name: Cache Nix store
        uses: actions/cache@v4
        with:
          path: /tmp/nix-cache
          key: ${{ runner.os }}-nix-rust-${{ hashFiles('flake.lock', 'ops/nix/environments/rust/shell.nix') }}
          restore-keys: |
            ${{ runner.os }}-nix-rust-

      - name: Check formatting
        run: nix develop .#rust --command bash -c "cd apps/rust && cargo fmt --check"

      - name: Run Clippy
        run: nix develop .#rust --command bash -c "cd apps/rust && cargo clippy -- -D warnings"

      - name: Run tests
        run: nix develop .#rust --command bash -c "cd apps/rust && cargo test"
```

### CI パイプラインの流れ

```
Push / PR → fmt --check → clippy → cargo test → 結果通知
```

## 6.4 他言語との比較

| 言語 | タスクランナー | CI ツール | テスト | 静的解析 | フォーマット |
|------|-------------|----------|--------|---------|------------|
| Rust | Makefile | GitHub Actions | cargo test | Clippy | rustfmt |
| Go | Makefile | GitHub Actions | go test | golangci-lint | gofmt |
| Java | Gradle | GitHub Actions | JUnit | Checkstyle + PMD | Checkstyle |
| Python | tox | GitHub Actions | pytest | Ruff | Ruff |
| Node | npm scripts | GitHub Actions | Vitest | ESLint | Prettier |
| Ruby | Rake | GitHub Actions | Minitest | RuboCop | RuboCop |
| PHP | Composer scripts | GitHub Actions | PHPUnit | PHP_CodeSniffer + PHPStan | phpcbf |

## 6.5 まとめ

この章では以下を実現しました。

| 項目 | 内容 |
|------|------|
| Makefile | test / lint / fmt / check タスクを定義 |
| `make check` | フォーマットチェック → Clippy → テストを一括実行 |
| GitHub Actions | push / PR 時に自動で CI を実行 |
| Nix 統合 | CI でも `nix develop .#rust` を使用し環境を統一 |

第 2 部を通じて、ソフトウェア開発の三種の神器（バージョン管理、テスティング、自動化）を Rust の開発環境に整備しました。次の第 3 部では、オブジェクト指向設計（struct、trait、デザインパターン）に進みます。
