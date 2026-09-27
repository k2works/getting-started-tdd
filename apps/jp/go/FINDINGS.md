# Go 日本語実装の検証結果

## 1. 処理系・テストフレームワークと `make test` の結果

| 項目 | 内容 |
|------|------|
| 処理系 | go version go1.25.5 linux/amd64（`nix develop .#go`） |
| テスト | 標準の `testing`（`go test -v ./...`） |
| lint | golangci-lint 2.7.2（`apps/go/.golangci.yml` と同じ設定: errcheck・govet・ineffassign・staticcheck・unused・revive、formatter は gofmt） |
| `make test` | `ok`。トップレベル 11 件（題材 A の 7 関数と `Testタイプ生成`・`Testパイプライン`・`Test安全変換`・`Test語順の再現`）、サブテスト 11 件。SPEC のテストは 16 件（A: 7、B: 5、C: 2、D: 2）、語順 2 件 |
| `make vet` / `make lint` | `go vet` は出力なし、golangci-lint は `0 issues.`、`gofmt -l` も差分なし（設定変更なし） |

## 2. 日本語にできた名前・できなかった名前

### できた名前

| 種類 | 例 |
|------|----|
| パッケージ名 | `package 変換`（ディレクトリは `henkan/`）、外部テストパッケージ `package 変換_test` |
| import の別名 | `変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"` |
| ファイル名 | `henkan/FizzBuzz変換.go`、`タイプ.go`、`語順_test.go` |
| 非公開の関数・変数・引数・レシーバー | `fizzBuzz限定変換`、`して`、`結果`、`上限`、`func (数 Ｓ数) FizzBuzz変換()` |
| 型パラメーター | `func して[入力, 途中, 出力 any](先 func(入力) 途中, 後 func(途中) 出力) func(入力) 出力` |
| テスト関数 | `func Test3を渡したらFizzを返す(t *testing.T)`、`func Testタイプ生成(t *testing.T)` |
| サブテスト名 | `t.Run("タイプ3は15の倍数だけFizzBuzzを返す", ...)` |

`go test` はテスト関数を `Test` の直後の文字が小文字でないことで判定するため、数字や日本語が続く `Test3を...`・`Testタイプ...` もテストとして実行されます。

### できなかった名前

**公開（exported）名** は「先頭が Unicode の大文字」である必要があります。日本語の文字は大文字ではないため、日本語始まりの名前はパッケージの外から見えません。Go 1.25 のエラーは「非公開」ではなく「未定義」と表示されます（ASCII 小文字の `lower` も同じ表示です）。

```text
./main.go:10:105: undefined: 変換.数
./main.go:11:21: undefined: 変換.タイプ生成
./main.go:11:49: undefined: 変換.lower
./main.go:13:16: t.名前 undefined (cannot refer to unexported field 名前)
```

**import パス**（ディレクトリ名）には日本語を使えません。`go build` だけでなく `go list ./...` も失敗します。

```text
cmd/main.go:3:8: malformed import path "example.com/exp/タイプ": invalid char 'タ'
```

そのため、ディレクトリは ASCII の `henkan/`、パッケージ名は日本語の `変換` にしました。

### 静的型付けで省略したテスト

`Ａ安全変換` の引数は `int` のため、「数値でなければ失敗になる」はコンパイル時に弾かれます。テストは 2 件にしました。

```text
henkan/実験.go:3:28: cannot use "a" (untyped string constant) as int value in argument to Ａ安全変換
```

## 3. 回避策とその代償

公開したい名前の回避策を比較しました（いずれも実際にパッケージの外から参照できることを確認）。

| 回避策 | 例 | 公開されるか | 評価 |
|--------|----|:----------:|------|
| そのまま | `タイプ生成` | されない | `undefined: 変換.タイプ生成` |
| ASCII の語で始まる名前 | `FizzBuzz変換`、`FizzBuzz配列作成`、`FizzBuzz装飾` | される | 題材 A はたまたま `F` で始まるので回避策が要らない |
| ASCII 大文字 1 文字を前置 | `Tタイプ生成` | される | 入力しやすいが、`T` が何の略か分からない |
| 全角大文字 1 文字を前置 | `Ｔタイプ生成`、`Ｎ名前` | される | `unicode.IsUpper('Ｔ')` が真のため公開になる。見た目は ASCII とほぼ同じで入力しにくい |
| 非公開のまま同じパッケージでテスト | `package 変換` の内部テスト | ― | 完全に日本語で書けるが、パッケージの外から使えない |

この実装では「ローマ字の頭文字を全角大文字で前置する」規則を採りました。

| なでしこ3 の名前 | Go の名前 |
|-----------------|----------|
| `タイプ`（辞書） | `type Ｔタイプ struct { Ｎ名前 string; Ｈ変換 func(int) string }` |
| `タイプ生成` / `タイプ変換` | `Ｔタイプ生成(番号 int) (Ｔタイプ, error)` / `Ｔタイプ変換(タイプ Ｔタイプ, 数 int) string` |
| `装飾` / `パイプライン処理` | `Ｓ装飾` / `Ｐパイプライン処理` |
| `安全変換` | `Ａ安全変換(数 int) (string, error)` |
| `FizzBuzz変換` / `FizzBuzz配列作成` / `FizzBuzz装飾` | そのまま |

- 代償 1: 構造体のフィールド（`名前`・`変換`）まで前置が必要になり、`タイプ.Ｎ名前` のような読みにくい名前が増えます。
- 代償 2: 前置の文字が名前の意味を持たないため、`Ｓ装飾` と `Ｓ数` の `Ｓ` が別の語の頭文字になるなど、規則を知らないと読めません。
- 題材 D の `変換結果` は、Go の慣用に従い `(string, error)` の 2 値で表しました。Result 型は作っていません。

## 4. 語順の再現

名前付きの型にメソッドを定義し、後置呼び出しのメソッドチェーンで「3 を FizzBuzz変換して 装飾する」の順に書きました。メソッド名 `FizzBuzz変換` は `F` で始まるので、そのまま公開されます。

```go
type Ｓ数 int
type Ｍ文字列 string

func (数 Ｓ数) FizzBuzz変換() Ｍ文字列 { return Ｍ文字列(FizzBuzz変換(int(数))) }
func (文字列 Ｍ文字列) Ｓ装飾() Ｍ文字列 { return Ｍ文字列(Ｓ装飾(string(文字列))) }
```

```go
検証(t, string(変換.Ｓ数(3).FizzBuzz変換()), "Fizz")
検証(t, string(変換.Ｓ数(15).FizzBuzz変換().Ｓ装飾()), "[FizzBuzz]")
```

助詞「を」をメソッドにしても、`を` は大文字で始まらないため非公開になり、パッケージの外からは `Ｓ数(3).を()` と書けません。題材 C は、ジェネリクスの合成関数 `して` で左から右へ書きました。

```go
func FizzBuzz装飾(数 int) string {
	return して(FizzBuzz変換, Ｓ装飾)(数)
}
```

名前付きの型は `string` にそのまま代入できないため、テストでは `string(...)` の変換が要ります。

## 5. lint・formatter・テストランナーの反応

### golangci-lint・go vet・gofmt

`apps/go/.golangci.yml` をそのまま使い、`0 issues.` でした。revive が公開名を判定するときも Go と同じく全角大文字を大文字とみなします。スクラッチパッドで試した反応は次のとおりで、日本語の名前そのものには反応せず、ASCII 名と同じ規則で指摘します。

```text
henkan/実験.go:3:1: exported: exported function Ｘ無コメント should have comment or be unexported (revive)
henkan/実験.go:5:6: var-naming: don't use underscores in Go names; func Y_アンダースコア should be Yアンダースコア (revive)
henkan/実験.go:7:5: var 未使用 is unused (unused)
```

gofmt は構造体のフィールドを **文字数（rune 数）** でそろえます。`Abcd string` と `名前   string` は同じ桁になりますが、端末では日本語が 2 桁幅で表示されるため、見た目はずれます。

```text
	A    string
	Abcd string
	名前   string
	Ｎ名前  int
```

### サブテスト名の空白は `_` に置き換わる

`t.Run` の名前に空白を含めると、出力では `_` に置き換わります。

```text
=== RUN   Test語順の再現/3_を_FizzBuzz変換_すると_Fizz_を返す（後置呼び出し）
    --- PASS: Test語順の再現/15_を_FizzBuzz変換して_装飾する (0.00s)
```

全角の括弧（`（）`）はそのまま残ります。`go test -run 'Test語順の再現/3 を'` のように空白を含むパターンでも、同じ規則で置き換えて照合されるため実行できました。`-run 'Testタイプ生成/タイプ3'` で日本語のサブテストだけを選ぶこともできます。

## 6. 日本語化スコア

| 軸 | 点数 | 根拠 |
|----|------|------|
| 関数・変数名 | 1 | 変数・引数・非公開の関数は制約なし。公開する関数は日本語で始められず、`Ｔタイプ生成` のような前置が必要 |
| 型・モジュール名 | 1 | パッケージ名・ファイル名は日本語可。import パスは不可（`malformed import path`）、公開する型・フィールドは前置が必要 |
| テスト名 | 2 | `Test3を渡したらFizzを返す` と識別子で書け、`t.Run` には記号込みの文章も書けるが、空白は出力で `_` に置き換わる |
| 語順の再現 | 2 | 名前付き型のメソッドで `Ｓ数(15).FizzBuzz変換().Ｓ装飾()` と後置で書ける。助詞 `を` のメソッドは公開できない |
| ツール許容 | 3 | go vet・golangci-lint（revive ほか）・gofmt・go test が設定変更なしで通る |
| **合計** | **9** | |
