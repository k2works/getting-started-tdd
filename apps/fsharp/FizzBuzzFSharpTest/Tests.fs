module Tests

open Xunit
open FizzBuzzFSharp.FizzBuzz

[<Fact>]
let ``数を文字列にして返す_1を渡したら文字列1を返す`` () =
    Assert.Equal("1", generate 1)

[<Fact>]
let ``数を文字列にして返す_2を渡したら文字列2を返す`` () =
    Assert.Equal("2", generate 2)

[<Fact>]
let ``三の倍数のときはFizzを返す`` () =
    Assert.Equal("Fizz", generate 3)

[<Fact>]
let ``三の倍数のときはFizzを返す_6`` () =
    Assert.Equal("Fizz", generate 6)

[<Fact>]
let ``五の倍数のときはBuzzを返す`` () =
    Assert.Equal("Buzz", generate 5)

[<Fact>]
let ``三と五の倍数のときはFizzBuzzを返す`` () =
    Assert.Equal("FizzBuzz", generate 15)

[<Fact>]
let ``一から百までのリストを生成する`` () =
    let list = generateList 100
    Assert.Equal(100, list.Length)
    Assert.Equal("1", list.[0])
    Assert.Equal("Fizz", list.[2])
    Assert.Equal("Buzz", list.[4])
    Assert.Equal("FizzBuzz", list.[14])

[<Fact>]
let ``リストの各要素を処理できる`` () =
    let mutable result = []
    [ "1"; "2"; "Fizz" ] |> List.iter (fun s -> result <- s :: result)
    Assert.Equal(3, result.Length)
