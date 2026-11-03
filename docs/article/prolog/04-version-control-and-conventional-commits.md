# 第 4 章: バージョン管理と Conventional Commits

## 4.1 はじめに

ソフトウェア開発では、変更履歴を安全に管理し、チームで追跡可能にする仕組みが重要です。Git による版管理とコミットメッセージ規約を整えることで、TDD の小さな変更を確実に積み上げられます。この章では、Prolog プロジェクトにおける Git の基本操作と Conventional Commits の実践方法を学びます。

第 1 部で TDD の Red-Green-Refactor サイクルを通じて FizzBuzz を完成させました。この章からは「動作するきれいなコード」を書き続けるために必要な **ソフトウェア開発の三種の神器** を整備していきます。

> 今日のソフトウェア開発の世界において絶対になければならない 3 つの技術的な柱があります。三本柱と言ったり、三種の神器と言ったりしていますが、それらは
>
> - バージョン管理
> - テスティング
> - 自動化
>
> の 3 つです。
>
> — 和田卓人

**バージョン管理** と **テスティング** に関しては第 1 部で触れました。本章ではバージョン管理をさらに深掘りし、**コミットメッセージの規約** について解説します。

## 4.2 Git によるバージョン管理

Prolog プロジェクト（`apps/prolog`）では、次の基本フローで変更を記録します。

```bash
cd apps/prolog
git init
git add .
git commit -m "chore(prolog): initialize Prolog project"
```

`git init` でリポジトリを初期化し、`git add` でステージング、`git commit` で履歴を確定します。TDD では Red → Green → Refactor の小さな単位でコミットすると、変更意図を追いやすくなります。

### 基本操作のループ

日常的な作業は次のコマンドの繰り返しです。

```bash
# 変更確認
git status

# 差分確認
git diff

# ステージング
git add src/fizzbuzz.pl test/fizzbuzz.plt

# コミット
git commit -m "test(fizzbuzz): 15 の倍数に対する失敗テストを追加"

# 履歴確認
git log --oneline --decorate -n 10
```

### .gitignore の設定

SWI-Prolog プロジェクトでは、ビルド成果物とローカルキャッシュを除外します。`apps/prolog/.gitignore` は次のように設定します。

```gitignore
*.qlf
*.log
result/
.direnv/
```

各項目の意味は次の通りです。

- `*.qlf` -- SWI-Prolog がソースをコンパイルして生成するキャッシュ（Quick Load File）
- `*.log` -- テスト実行やスクリプトが出力するログ
- `result/` -- Nix ビルドが生成する成果物へのシンボリックリンク
- `.direnv/` -- direnv が生成するローカルキャッシュ（開発者ごとに異なる）

`.gitignore` の要点は、**復元可能な成果物を履歴に含めない** ことです。`*.qlf` や `result/` はソースと設定から再生成できるため、リポジトリには含めません。これにより履歴が肥大化せず、成果物の差分でコンフリクトが起きることもなくなります。

一方で、`.pl`（ソース）や `.plt`（テスト）といった手で書くファイルは版管理の対象です。これらはプロジェクトの本体であり、他の開発者と共有すべき成果物だからです。

## 4.3 Conventional Commits

本プロジェクトでは [Angular ルール](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#type) に由来する **Conventional Commits** の書式を採用します。基本フォーマットは次の通りです。

```text
<type>(<scope>): <subject>
<空行>
<body>
<空行>
<footer>
```

- **ヘッダ**（`<type>(<scope>): <subject>`）は必須です
- `type`: 変更種別
- `scope`: 変更対象（任意）
- `subject`: 変更内容の要約（50 文字前後を目安に簡潔に）

### type の種類

| type | 用途 |
|------|------|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメント変更 |
| `style` | 振る舞いに影響しない整形（フォーマット、空白など） |
| `refactor` | 振る舞いを変えない構造改善 |
| `perf` | パフォーマンス改善 |
| `test` | テスト追加・修正 |
| `chore` | ビルドや設定などの雑務 |

### scope と subject の書き方

- `scope` はモジュール単位で短く書きます（例: `prolog`, `fizzbuzz`, `ci`）。
- `subject` は 50 文字前後を目安に、何をしたかを明確に書きます。
- 末尾の句点は付けません。

### コミットメッセージの例

```text
test(fizzbuzz): 15 の倍数に対する失敗テストを追加
feat(fizzbuzz): fizzbuzz/2 で数を文字列に変換する述語を実装
refactor(fizzbuzz): 節の条件順序を整理
docs(prolog): パッケージ管理と静的解析の章を追加
chore(ci): Prolog CI ワークフローを追加
```

## 4.4 TDD でのコミット戦略

TDD の Red-Green-Refactor サイクルにおいて、コミットする適切なタイミングは以下の通りです。

```text
Red（テスト作成）→ Green（テスト成功）→ コミット → Refactor（リファクタリング）→ コミット
```

各段階でコミットすることで、変更の意図を明確に保てます。

### Red — 失敗するテストを追加

```bash
git add test/fizzbuzz.plt
git commit -m "test(fizzbuzz): fizzbuzz/2 の失敗テストを追加"
```

テストファイルのみをコミットし、テストが失敗する状態を記録します。

### Green — テストを通す最小実装

```bash
git add src/fizzbuzz.pl
git commit -m "feat(fizzbuzz): fizzbuzz/2 を実装"
```

実装ファイルのみをコミットし、全テストが通過する状態を記録します。

### Refactor — 振る舞いを変えない整理

```bash
git add src/fizzbuzz.pl
git commit -m "refactor(fizzbuzz): 節の条件順序を最適化"
```

テストが通り続けていることを確認した上で、コードの改善をコミットします。

ポイントは、**1 コミット 1 意図** です。`feat` と `refactor` を同一コミットに混ぜないことで、レビューしやすくなります。

### 実際のコミット例

FizzBuzz の開発過程では、以下のようなコミット履歴になります。

```bash
$ git log --oneline

abc1234 refactor(fizzbuzz): fizzbuzz/2 の条件順序を最適化
def5678 feat(fizzbuzz): 3 と 5 の倍数で FizzBuzz を返す機能を追加
ghi9012 feat(fizzbuzz): 5 の倍数で Buzz を返す機能を追加
jkl3456 feat(fizzbuzz): 3 の倍数で Fizz を返す機能を追加
mno7890 feat(fizzbuzz): 数を文字列に変換する fizzbuzz/2 を実装
pqr1234 test(fizzbuzz): FizzBuzz の最初のテストを作成
stu5678 chore(prolog): Prolog プロジェクトを初期化（SWI-Prolog + plunit）
```

各コミットが小さく、明確な目的を持っていることがわかります。

## 4.5 ブランチ戦略

### Git Flow の基本概念

Git Flow では、主に次のブランチを使います。

- `main`: リリース済みの安定コード
- `develop`: 開発統合ブランチ
- `feature/*`: 機能開発ブランチ
- `release/*`: リリース準備ブランチ
- `hotfix/*`: 緊急修正ブランチ

学習用プロジェクトでは、まず `main` と `feature/*` の運用から始めると実践しやすいです。

### feature ブランチの作成と運用

```bash
git switch main
git pull origin main
git switch -c feature/prolog-chapter-04
```

運用ポイントは次の通りです。

- 1 ブランチ 1 テーマに絞ります。
- Red / Green / Refactor の区切りで小さくコミットします。
- 完了後に Pull Request を作成し、レビュー後に `main` へマージします。

## 4.6 まとめ

この章では、Prolog の TDD 開発を支える版管理の基礎を整理しました。

- Git の基本操作で変更履歴を安全に管理する
- `.gitignore` で `*.qlf`・`result/` などの復元可能な成果物を除外し、`.pl`・`.plt` のソースは版管理する
- Conventional Commits で履歴を読みやすくする
- TDD の Red → Green → Refactor の各段階でコミットする
- `feature` ブランチ運用で変更を分離する

次章では、SWI-Prolog のモジュールシステムによるパッケージ管理と、静的解析（`make/0` によるチェックや `check/0`）の整備を進めます。
