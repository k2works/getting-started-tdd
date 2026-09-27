module FizzBuzz変換のテスト

open Xunit
open FizzBuzz日本語FSharp.FizzBuzz

[<Fact>]
let ``3を渡したらFizzを返す`` () = Assert.Equal("Fizz", FizzBuzz変換 3)

[<Fact>]
let ``5を渡したらBuzzを返す`` () = Assert.Equal("Buzz", FizzBuzz変換 5)

[<Fact>]
let ``15を渡したらFizzBuzzを返す`` () = Assert.Equal("FizzBuzz", FizzBuzz変換 15)

[<Fact>]
let ``1を渡したら文字列1を返す`` () = Assert.Equal("1", FizzBuzz変換 1)

[<Fact>]
let ``2を渡したら文字列2を返す`` () = Assert.Equal("2", FizzBuzz変換 2)

[<Fact>]
let ``15まで作ると15件になる`` () =
    Assert.Equal(15, FizzBuzz配列作成 15 |> List.length)

[<Fact>]
let ``15まで作った配列の並び`` () =
    Assert.Equal("1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz", FizzBuzz配列作成 15 |> String.concat ",")

[<Fact>]
let ``3 |> FizzBuzz変換 と、値を先に書ける`` () = Assert.Equal("Fizz", 3 |> FizzBuzz変換)
