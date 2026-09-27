module パイプラインのテスト

open Xunit
open FizzBuzz日本語FSharp.パイプライン

[<Fact>]
let ``装飾すると角括弧で囲む`` () = Assert.Equal("[Fizz]", 装飾 "Fizz")

[<Fact>]
let ``5までのパイプライン処理`` () =
    Assert.Equal<string list>([ "[1]"; "[2]"; "[Fizz]"; "[4]"; "[Buzz]" ], パイプライン処理 5)

[<Fact>]
let ``15を FizzBuzz変換して 装飾する`` () = Assert.Equal("[FizzBuzz]", FizzBuzz装飾 15)
