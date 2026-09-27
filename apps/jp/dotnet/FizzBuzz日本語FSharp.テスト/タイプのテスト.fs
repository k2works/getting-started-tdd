module タイプのテスト

open Xunit
open FizzBuzz日本語FSharp.タイプ別変換

[<Fact>]
let ``タイプ1は通常の変換をする`` () =
    let 通常 = タイプ生成 1
    Assert.Equal("Fizz", タイプ変換 通常 3)
    Assert.Equal("通常", 通常.名前)

[<Fact>]
let ``タイプ2は数字だけを返す`` () =
    let 数字 = タイプ生成 2
    Assert.Equal("3", タイプ変換 数字 3)
    Assert.Equal("数字限定", 数字.名前)

[<Fact>]
let ``タイプ3は15の倍数だけFizzBuzzを返す`` () =
    Assert.Equal("FizzBuzz", タイプ変換 (タイプ生成 3) 15)

[<Fact>]
let ``タイプ3は3の倍数を数字で返す`` () = Assert.Equal("3", タイプ変換 (タイプ生成 3) 3)

[<Fact>]
let ``存在しないタイプはエラーになる`` () =
    let 例外 = Assert.Throws<タイプ未定義例外>(fun () -> タイプ生成 4 |> ignore)
    Assert.Equal("該当するタイプは存在しません: 4", 例外.Message)

[<Fact>]
let ``判別共用体のケース タイプ番号.FizzBuzz限定 から生成できる`` () =
    Assert.Equal("FizzBuzz限定", (番号から生成 タイプ番号.FizzBuzz限定).名前)
