module Tests

open Xunit
open FizzBuzzFSharp.Domain
open FizzBuzzFSharp.Application
open FizzBuzzFSharp.FizzBuzz

module FizzBuzzRunnerTests =

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

module FizzBuzzValueTests =

    [<Fact>]
    let ``値を保持する`` () =
        let value = createValue 1 "1"
        Assert.Equal(1, value.Number)
        Assert.Equal("1", value.Value)

    [<Fact>]
    let ``Fizz値を保持する`` () =
        let value = createValue 3 "Fizz"
        Assert.Equal(3, value.Number)
        Assert.Equal("Fizz", value.Value)

    [<Fact>]
    let ``同じ値のレコードは等しい`` () =
        let value1 = createValue 1 "1"
        let value2 = createValue 1 "1"
        Assert.Equal(value1, value2)

    [<Fact>]
    let ``異なる値のレコードは等しくない`` () =
        let value1 = createValue 1 "1"
        let value2 = createValue 2 "2"
        Assert.NotEqual(value1, value2)

    [<Fact>]
    let ``ToStringはNumber_Colon_Value形式`` () =
        let value = createValue 3 "Fizz"
        Assert.Equal("3:Fizz", value.ToString())

module FizzBuzzListTests =

    [<Fact>]
    let ``空のリストを作成できる`` () =
        let list = emptyList
        Assert.Equal(0, list.Count)

    [<Fact>]
    let ``値を追加できる`` () =
        let list = emptyList
        let newList = list.Add(createValue 1 "1")
        Assert.Equal(1, newList.Count)
        Assert.Equal(0, list.Count)

    [<Fact>]
    let ``インデックスで値を取得できる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 2 "2"
                  createValue 3 "Fizz" ]

        Assert.Equal(createValue 1 "1", list.Get(0))
        Assert.Equal(createValue 3 "Fizz", list.Get(2))

    [<Fact>]
    let ``フィルタリングできる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 3 "Fizz"
                  createValue 5 "Buzz"
                  createValue 15 "FizzBuzz" ]

        let filtered = list.Filter(fun v -> v.Value = "Fizz")
        Assert.Equal(1, filtered.Count)
        Assert.Equal("Fizz", filtered.Get(0).Value)

    [<Fact>]
    let ``最初の一致する値を取得できる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 3 "Fizz"
                  createValue 6 "Fizz" ]

        let found = list.FindFirst(fun v -> v.Value = "Fizz")
        Assert.True(found.IsSome)
        Assert.Equal(3, found.Value.Number)

    [<Fact>]
    let ``一致する値がない場合はNoneを返す`` () =
        let list =
            createList [ createValue 1 "1"; createValue 2 "2" ]

        let found = list.FindFirst(fun v -> v.Value = "Fizz")
        Assert.True(found.IsNone)

    [<Fact>]
    let ``文字列リストに変換できる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 3 "Fizz"
                  createValue 5 "Buzz" ]

        let strings = list.ToStringValues()
        Assert.Equal<string list>([ "1"; "Fizz"; "Buzz" ], strings)

    [<Fact>]
    let ``値ごとにカウントできる`` () =
        let list =
            createList
                [ createValue 1 "1"
                  createValue 2 "2"
                  createValue 3 "Fizz"
                  createValue 6 "Fizz"
                  createValue 5 "Buzz" ]

        let counts = list.CountByValue()
        Assert.Equal(1, counts.["1"])
        Assert.Equal(1, counts.["2"])
        Assert.Equal(2, counts.["Fizz"])
        Assert.Equal(1, counts.["Buzz"])

    [<Fact>]
    let ``AddRangeで複数の値を追加できる`` () =
        let list = emptyList
        let newList = list.AddRange([ createValue 1 "1"; createValue 2 "2" ])
        Assert.Equal(2, newList.Count)

module FizzBuzzTypeTests =

    [<Fact>]
    let ``Standard_数を文字列にして返す`` () =
        let result = FizzBuzzFSharp.Domain.generate Standard 1
        Assert.Equal("1", result.Value)

    [<Fact>]
    let ``Standard_三の倍数のときはFizzを返す`` () =
        let result = FizzBuzzFSharp.Domain.generate Standard 3
        Assert.Equal("Fizz", result.Value)

    [<Fact>]
    let ``Standard_五の倍数のときはBuzzを返す`` () =
        let result = FizzBuzzFSharp.Domain.generate Standard 5
        Assert.Equal("Buzz", result.Value)

    [<Fact>]
    let ``Standard_三と五の倍数のときはFizzBuzzを返す`` () =
        let result = FizzBuzzFSharp.Domain.generate Standard 15
        Assert.Equal("FizzBuzz", result.Value)

    [<Fact>]
    let ``NumberOnly_常に数値を文字列にして返す`` () =
        Assert.Equal("1", (FizzBuzzFSharp.Domain.generate NumberOnly 1).Value)
        Assert.Equal("3", (FizzBuzzFSharp.Domain.generate NumberOnly 3).Value)
        Assert.Equal("5", (FizzBuzzFSharp.Domain.generate NumberOnly 5).Value)
        Assert.Equal("15", (FizzBuzzFSharp.Domain.generate NumberOnly 15).Value)

    [<Fact>]
    let ``FizzBuzzOnly_十五の倍数のときはFizzBuzzを返す`` () =
        Assert.Equal("FizzBuzz", (FizzBuzzFSharp.Domain.generate FizzBuzzOnly 15).Value)
        Assert.Equal("FizzBuzz", (FizzBuzzFSharp.Domain.generate FizzBuzzOnly 30).Value)

    [<Fact>]
    let ``FizzBuzzOnly_十五の倍数以外は数値を文字列にして返す`` () =
        Assert.Equal("1", (FizzBuzzFSharp.Domain.generate FizzBuzzOnly 1).Value)
        Assert.Equal("3", (FizzBuzzFSharp.Domain.generate FizzBuzzOnly 3).Value)
        Assert.Equal("5", (FizzBuzzFSharp.Domain.generate FizzBuzzOnly 5).Value)

module ApplicationTests =

    [<Fact>]
    let ``executeValueで単一値を取得できる`` () =
        let result = executeValue Standard 3
        Assert.Equal("Fizz", result.Value)

    [<Fact>]
    let ``executeListでリストを生成できる`` () =
        let result = executeList Standard 100
        Assert.Equal(100, result.Count)
