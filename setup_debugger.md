# PHP デバッガセットアップ手順

この手順は `apps/php` の PHPUnit テストを Vim + Vimspector + Xdebug でデバッグするためのものです。

## 前提

- `nix develop .#php` が利用できること
- Vim 設定に `puremourning/vimspector` が入っていること
- `apps/php/vendor/` が存在すること

依存関係が未インストールの場合は、先に以下を実行します。

```bash
cd apps/php
composer install
```

## 1. Vimspector の PHP adapter を入れる

Vim を起動して、初回のみ以下を実行します。

```vim
:VimspectorInstall vscode-php-debug
```

または shell から直接インストールします。

```bash
python3 ~/.cache/dein/repos/github.com/puremourning/vimspector/install_gadget.py --force-enable-php
```

## 2. Xdebug 付き PHP を確認する

このリポジトリでは `ops/nix/environments/php/shell.nix` で Xdebug 付き PHP を使います。

```bash
nix develop .#php
php -m | grep -i xdebug
```

`xdebug` または `Xdebug` が表示されれば OK です。

Vimspector からは [apps/php/bin/php-debug](apps/php/bin/php-debug) を使います。この wrapper は Vim の起動元に依存せず、Xdebug 付き PHP を起動します。

```bash
apps/php/bin/php-debug -m | grep -i xdebug
```

## 3. Vimspector 設定

PHP 用の launch 設定は [apps/php/.vimspector.json](apps/php/.vimspector.json) にあります。

主に使う設定は以下です。

- `Debug current PHPUnit file`: 現在開いている PHPUnit テストファイルをデバッグする
- `Debug PHPUnit suite`: PHPUnit 全体をデバッグする
- `Debug current standalone PHP file`: 通常の PHP ファイルを直接実行する

PHPUnit テストでは `Debug current standalone PHP file` を使わないでください。テストファイルを直接 `php tests/FizzBuzzTest.php` として実行すると PHPUnit の bootstrap が通らず、`PHPUnit\Framework\TestCase not found` で失敗します。

## 4. PHPUnit をデバッグする

```bash
cd apps/php
vim tests/FizzBuzzTest.php
```

Vim で以下を実行します。

```text
<leader>de  Vimspector を reset
<leader>dt  ブレークポイントを設定
<leader>dd  デバッグ開始
```

設定選択では `Debug current PHPUnit file` を選びます。

起動直後は entry で一度停止します。そこで以下を実行します。

```text
<leader>dc  continue
```

設定済みブレークポイントまで進めば成功です。

## 5. 動作確認コマンド

デバッグ設定とは別に、通常の品質チェックが通ることを確認します。

```bash
nix develop .#php --command bash -c "cd apps/php && composer check"
```

Xdebug と PHPUnit の組み合わせを確認します。

```bash
apps/php/bin/php-debug apps/php/vendor/bin/phpunit apps/php/tests/FizzBuzzTest.php
```

カバレッジも確認できます。

```bash
nix develop .#php --command bash -c "cd apps/php && composer test:coverage"
```

## トラブルシュート

### ブレークポイントで止まらない

- `<leader>de` で Vimspector を reset してから再実行します。
- `Debug current PHPUnit file` を選んでいるか確認します。
- 起動直後の entry 停止後に `<leader>dc` で continue します。
- `apps/php/bin/php-debug -m | grep -i xdebug` で Xdebug が読み込まれることを確認します。

### `PHPUnit\Framework\TestCase not found` が出る

`Debug current standalone PHP file` でテストファイルを直接実行しています。`Debug current PHPUnit file` を選んでください。

### `No code coverage driver available` が出る

Xdebug なしの PHP で PHPUnit を実行しています。`nix develop .#php` に入り直すか、`apps/php/bin/php-debug` 経由で確認してください。

### `XDEBUG_MODE=coverage has to be set` が出る

coverage 実行時は `composer test:coverage` を使います。`composer.json` で `XDEBUG_MODE=coverage` を指定しています。

## 関連ファイル

- [apps/php/.vimspector.json](apps/php/.vimspector.json)
- [apps/php/bin/php-debug](apps/php/bin/php-debug)
- [apps/php/phpunit.xml](apps/php/phpunit.xml)
- [ops/nix/environments/php/shell.nix](ops/nix/environments/php/shell.nix)
- [docs/reference/Vim操作マニュアル.md](docs/reference/Vim操作マニュアル.md)
