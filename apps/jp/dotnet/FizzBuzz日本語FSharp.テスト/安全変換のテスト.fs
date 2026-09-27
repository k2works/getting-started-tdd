module 安全変換のテスト

open Xunit
open FizzBuzz日本語FSharp.エラー処理

[<Fact>]
let ``正の数は成功になる`` () = Assert.Equal(成功 "Fizz", 安全変換 3)

[<Fact>]
let ``0は失敗になる`` () =
    Assert.Equal(失敗 "正の数を指定してください: 0", 安全変換 0)

[<Fact>]
let ``match 式で 成功・失敗 を振り分ける`` () =
    let 表示 =
        match 安全変換 -1 with
        | 成功 値 -> 値
        | 失敗 エラー -> $"失敗: {エラー}"

    Assert.Equal("失敗: 正の数を指定してください: -1", 表示)
