# Vim Java Debug セットアップ手順

このドキュメントは、このリポジトリで `vim` + `coc.nvim` + `vimspector` を使って Java テストをデバッグするための再現手順です。次回はこの手順だけ見れば、同じ状態をすぐに作れるようにしてあります。

## 目的

- `apps/java` の JUnit テストを `vim` からデバッグできるようにする。
- `vimspector` は `launch` ではなく `attach` だけを使う。
- デバッグ待受ポートは `5005` に固定する。
- 古い待受プロセスが残っていても、`./gradlew debugTest` を再実行できるようにする。

## 現在の構成

デバッグ構成は、以下のファイルで成立しています。

- `ops/nix/shells/shell.nix`
  - `vim`, `vimspector`, `nodejs`, `gh` などの共通開発環境を提供する。
  - `shellHook` で `~/.vimrc` と `~/.vim/coc-settings.json` を配置する。
- `ops/nix/environments/java/shell.nix`
  - `jdk`, `maven`, `gradle` を追加し、`nix develop .#java` を成立させる。
- `ops/nix/shells/.vimrc`
  - `coc-java`, `coc-java-debug` を有効にする。
  - Java ファイルで `,dd` を押したときに `:CocCommand java.debug.vimspector.start` を呼ぶ。
- `.vimspector.json`
  - リポジトリルートの `attach` 設定。
- `apps/java/.vimspector.json`
  - Java サンプル用の `attach` 設定。
- `apps/java/build.gradle`
  - `debugTest` と `cleanupDebugTest` を定義する。
  - `debugTest` は `5005` で待受する。
  - `cleanupDebugTest` は古い JDWP プロセスを落とす。

## 前提条件

- `nix` が使えること。
- ネットワーク接続があること。
  - 初回の `coc.nvim` extension 導入や Gradle wrapper 取得で必要になる。
- `vim` を使うこと。
  - この手順は `neovim` ではなく `vim` 前提の設定です。

## 初回セットアップ

### 1. Java 開発シェルに入る

```bash
nix develop .#java
```

このコマンドで、以下が有効になります。

- `JAVA_HOME`
- `javac`, `java`
- `gradle`, `mvn`
- `vim`
- `vimspector`

シェル起動時に `shellHook` が走り、次の設定が自動で入ります。

- `~/.vimrc` へのシンボリックリンク
- `~/.vim/coc-settings.json` の生成
- `~/.vim/pack/plugins/start/vimspector` の配置

### 2. Vim の Java 拡張が有効になることを確認する

このリポジトリの `.vimrc` では、以下の CoC extension を有効化しています。

- `coc-java`
- `coc-java-debug`

通常は `vim` 起動時に `coc.nvim` が extension を解決します。もし入らない場合は、Vim 内で次を実行します。

```vim
:CocInstall coc-java coc-java-debug
```

### 3. Java サンプルがビルドできることを確認する

```bash
cd apps/java
./gradlew test
```

成功すれば、デバッグに必要なクラスと依存関係はそろっています。

## デバッグ設定の考え方

このリポジトリでは、`vimspector` に直接 `launch` させません。理由は以下です。

- Java の起動は Gradle に寄せた方が単純です。
- テスト実行とデバッグ待受を同じ `debugTest` タスクにまとめられます。
- `vimspector` 側は `127.0.0.1:5005` への `attach` だけ見ればよくなります。

`vimspector` の設定は次の内容です。

```json
{
  "adapters": {
    "java-debug-server": {
      "name": "vscode-java",
      "port": "${AdapterPort}"
    }
  },
  "configurations": {
    "Java Attach": {
      "default": true,
      "adapter": "java-debug-server",
      "configuration": {
        "request": "attach",
        "host": "127.0.0.1",
        "port": "5005"
      }
    }
  }
}
```

## 毎回の起動手順

### 1. ターミナル 1 で Java シェルに入る

```bash
nix develop .#java
```

### 2. `debugTest` を起動する

```bash
cd apps/java
./gradlew debugTest
```

正常なら、以下が表示されて停止します。

```text
Listening for transport dt_socket at address: 5005
```

この状態で、JVM はデバッガの attach を待っています。

### 3. ターミナル 2 で `vim` を起動する

```bash
nix develop .#java
vim apps/java/src/test/java/tdd/fizzbuzz/FizzBuzzTest.java
```

同じ `nix develop .#java` の中で起動してください。`JAVA_HOME` と `coc` の設定がそろった状態で `vim` を上げる必要があります。

### 4. ブレークポイントを置く

Vim で止めたい行にカーソルを合わせて、以下を押します。

```text
,dt
```

### 5. デバッグを開始する

以下を押します。

```text
,dd
```

このキーは Java バッファでだけ有効です。内部的には以下を呼んでいます。

```vim
:CocCommand java.debug.vimspector.start
```

`coc-java-debug` が `apps/java/.vimspector.json` の `Java Attach` 設定を使って `127.0.0.1:5005` に attach します。

## よく使うキー

- `,dd`
  - デバッグ開始
- `,de`
  - デバッグ終了
- `,dc`
  - Continue
- `,dt`
  - ブレークポイント切り替え
- `,dT`
  - 全ブレークポイント削除
- `,dj`
  - Step Over
- `,dl`
  - Step Into
- `,dh`
  - Step Out
- `,dk`
  - Restart

## `debugTest` の内部動作

`apps/java/build.gradle` では、`debugTest` の前に `cleanupDebugTest` を必ず実行します。

```groovy
tasks.register('debugTest', Test) {
    dependsOn tasks.named('cleanupDebugTest')
    outputs.upToDateWhen { false }
}
```

これにより、以下の問題を避けています。

- 前回の `Gradle Test Executor` が `5005` を掴んだまま残る
- 次回の `./gradlew debugTest` が `Address already in use` で死ぬ
- `UP-TO-DATE` 判定で `debugTest` が実行されず、何も起きない

## トラブルシュート

### `Listening for transport dt_socket at address: 5005` が出ない

まず次を実行します。

```bash
nix develop .#java
cd apps/java
./gradlew debugTest
```

それでも出ない場合は、以下を確認します。

- `./gradlew test` が通るか
- `nix develop .#java` の中で実行しているか
- `apps/java/build.gradle` に `debugTest` があるか

### `Address already in use` が出る

今は `cleanupDebugTest` が自動で掃除するので、基本的には再度 `./gradlew debugTest` を実行すれば回復します。それでも残る場合は手動で止めます。

```bash
cd apps/java
./gradlew --stop
./gradlew debugTest
```

### 2 本目の `debugTest` を起動したら 1 本目が落ちた

これは正常です。2 本目の `debugTest` が古い待受プロセスを掃除して、新しい待受へ切り替えています。

### `,dd` を押しても attach しない

以下を確認します。

- Java ファイルを開いているか
- `,dd` が Java バッファに対してマップされているか
- `coc-java` と `coc-java-debug` が入っているか
- `apps/java/.vimspector.json` が存在するか
- 先に `./gradlew debugTest` が `Listening...5005` に入っているか

Vim 内で確認するなら、以下が使えます。

```vim
:verbose nmap ,dd
:CocList extensions
```

### 手元の Vim 設定が壊れていそう

いったん Java シェルに入り直します。

```bash
exit
nix develop .#java
```

`shellHook` が再度走るので、`~/.vimrc`、`~/.vim/coc-settings.json`、`vimspector` の配置をやり直せます。

## 最短コマンド集

### 初回確認

```bash
nix develop .#java
cd apps/java
./gradlew test
```

### デバッグ開始

```bash
nix develop .#java
cd apps/java
./gradlew debugTest
```

別端末:

```bash
nix develop .#java
vim apps/java/src/test/java/tdd/fizzbuzz/FizzBuzzTest.java
```

### 手動復旧

```bash
nix develop .#java
cd apps/java
./gradlew --stop
./gradlew debugTest
```

## 参考

- `docs/reference/Vim操作マニュアル.md`
- `docs/reference/Javaアプリケーション環境構築ガイド.md`
- `ops/nix/shells/.vimrc`
- `apps/java/build.gradle`
- `.vimspector.json`
- `apps/java/.vimspector.json`
