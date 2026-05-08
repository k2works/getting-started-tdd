module Tests

open Xunit
open FizzBuzzFSharp

[<Fact>]
let ``数を文字列にして返す_1を渡したら文字列1を返す`` () = Assert.Equal("1", FizzBuzz.generate 1)

[<Fact>]
let ``数を文字列にして返す_2を渡したら文字列2を返す`` () = Assert.Equal("2", FizzBuzz.generate 2)

[<Fact>]
let ``三の倍数のときはFizzを返す`` () =
    Assert.Equal("Fizz", FizzBuzz.generate 3)

[<Fact>]
let ``三の倍数のときはFizzを返す_6`` () =
    Assert.Equal("Fizz", FizzBuzz.generate 6)

[<Fact>]
let ``五の倍数のときはBuzzを返す`` () =
    Assert.Equal("Buzz", FizzBuzz.generate 5)

[<Fact>]
let ``三と五の倍数のときはFizzBuzzを返す`` () =
    Assert.Equal("FizzBuzz", FizzBuzz.generate 15)

[<Fact>]
let ``一から百までのリストを生成する`` () =
    let list = FizzBuzz.generateList 100
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

[<Fact>]
let ``値を保持する`` () =
    let value = Domain.createValue 1 "1"
    Assert.Equal(1, value.Number)
    Assert.Equal("1", value.Value)

[<Fact>]
let ``同じ値のレコードは等しい`` () =
    let value1 = Domain.createValue 1 "1"
    let value2 = Domain.createValue 1 "1"
    Assert.Equal(value1, value2)

[<Fact>]
let ``ToStringはNumber_Colon_Value形式`` () =
    let value = Domain.createValue 3 "Fizz"
    Assert.Equal("3:Fizz", Domain.FizzBuzzValue.toString value)

[<Fact>]
let ``Standard_数を文字列にして返す`` () =
    let result = Domain.generate Domain.Standard 1
    Assert.Equal("1", result.Value)

[<Fact>]
let ``Standard_三の倍数のときはFizzを返す`` () =
    let result = Domain.generate Domain.Standard 3
    Assert.Equal("Fizz", result.Value)

[<Fact>]
let ``Standard_五の倍数のときはBuzzを返す`` () =
    let result = Domain.generate Domain.Standard 5
    Assert.Equal("Buzz", result.Value)

[<Fact>]
let ``Standard_三と五の倍数のときはFizzBuzzを返す`` () =
    let result = Domain.generate Domain.Standard 15
    Assert.Equal("FizzBuzz", result.Value)

[<Fact>]
let ``NumberOnly_常に数値を文字列にして返す`` () =
    Assert.Equal("1", (Domain.generate Domain.NumberOnly 1).Value)
    Assert.Equal("3", (Domain.generate Domain.NumberOnly 3).Value)
    Assert.Equal("5", (Domain.generate Domain.NumberOnly 5).Value)

[<Fact>]
let ``FizzBuzzOnly_十五の倍数のときはFizzBuzzを返す`` () =
    Assert.Equal("FizzBuzz", (Domain.generate Domain.FizzBuzzOnly 15).Value)
    Assert.Equal("FizzBuzz", (Domain.generate Domain.FizzBuzzOnly 30).Value)

[<Fact>]
let ``FizzBuzzOnly_十五の倍数以外は数値を文字列にして返す`` () =
    Assert.Equal("1", (Domain.generate Domain.FizzBuzzOnly 1).Value)
    Assert.Equal("3", (Domain.generate Domain.FizzBuzzOnly 3).Value)

[<Fact>]
let ``空のリストを作成できる`` () =
    let list = Domain.emptyList
    Assert.Equal(0, Domain.FizzBuzzList.count list)

[<Fact>]
let ``値を追加できる`` () =
    let list = Domain.emptyList
    let newList = Domain.FizzBuzzList.add (Domain.createValue 1 "1") list
    Assert.Equal(1, Domain.FizzBuzzList.count newList)
    Assert.Equal(0, Domain.FizzBuzzList.count list)

[<Fact>]
let ``フィルタリングできる`` () =
    let list =
        Domain.createList
            [ Domain.createValue 1 "1"
              Domain.createValue 3 "Fizz"
              Domain.createValue 5 "Buzz"
              Domain.createValue 15 "FizzBuzz" ]

    let filtered = Domain.FizzBuzzList.filter (fun v -> v.Value = "Fizz") list
    Assert.Equal(1, Domain.FizzBuzzList.count filtered)

[<Fact>]
let ``executeValueで単一値を取得できる`` () =
    let result = Application.executeValue Domain.Standard 3
    Assert.Equal("Fizz", result.Value)

[<Fact>]
let ``executeListでリストを生成できる`` () =
    let result = Application.executeList Domain.Standard 100
    Assert.Equal(100, Domain.FizzBuzzList.count result)

[<Fact>]
let ``部分適用でStandard専用の関数を作成できる`` () =
    let generateStandard = Domain.generate Domain.Standard
    Assert.Equal("FizzBuzz", (generateStandard 15).Value)
    Assert.Equal("Fizz", (generateStandard 3).Value)
    Assert.Equal("Buzz", (generateStandard 5).Value)

[<Fact>]
let ``部分適用でNumberOnly専用の関数を作成できる`` () =
    let generateNumberOnly = Domain.generate Domain.NumberOnly
    Assert.Equal("3", (generateNumberOnly 3).Value)
    Assert.Equal("15", (generateNumberOnly 15).Value)

[<Fact>]
let ``関数合成でintからstringへの関数を作成できる`` () =
    let classify = Domain.generate Domain.Standard
    let toString (value: Domain.FizzBuzzValue) = value.Value
    let fizzBuzz = classify >> toString
    Assert.Equal("FizzBuzz", fizzBuzz 15)
    Assert.Equal("1", fizzBuzz 1)

[<Fact>]
let ``値ごとにカウントできる`` () =
    let list =
        Domain.createList
            [ Domain.createValue 1 "1"
              Domain.createValue 2 "2"
              Domain.createValue 3 "Fizz"
              Domain.createValue 6 "Fizz"
              Domain.createValue 5 "Buzz" ]

    let counts = Domain.FizzBuzzList.countByValue list
    Assert.Equal(1, counts.["1"])
    Assert.Equal(2, counts.["Fizz"])
    Assert.Equal(1, counts.["Buzz"])

[<Fact>]
let ``文字列リストに変換できる`` () =
    let list =
        Domain.createList
            [ Domain.createValue 1 "1"
              Domain.createValue 3 "Fizz"
              Domain.createValue 5 "Buzz" ]

    let strings = Domain.FizzBuzzList.toStringValues list
    Assert.Equal<string list>([ "1"; "Fizz"; "Buzz" ], strings)

[<Fact>]
let ``最初の一致する値を取得できる`` () =
    let list =
        Domain.createList
            [ Domain.createValue 1 "1"
              Domain.createValue 3 "Fizz"
              Domain.createValue 6 "Fizz" ]

    let found = Domain.FizzBuzzList.findFirst (fun v -> v.Value = "Fizz") list
    Assert.True(found.IsSome)
    Assert.Equal(3, found.Value.Number)

[<Fact>]
let ``一致する値がない場合はNoneを返す`` () =
    let list = Domain.createList [ Domain.createValue 1 "1"; Domain.createValue 2 "2" ]

    let found = Domain.FizzBuzzList.findFirst (fun v -> v.Value = "Fizz") list
    Assert.True(found.IsNone)

[<Fact>]
let ``複数の値をまとめて追加できる`` () =
    let list = Domain.emptyList

    let newList =
        Domain.FizzBuzzList.addRange [ Domain.createValue 1 "1"; Domain.createValue 3 "Fizz" ] list

    Assert.Equal(2, Domain.FizzBuzzList.count newList)
    Assert.Equal(0, Domain.FizzBuzzList.count list)

[<Fact>]
let ``インデックスで値を取得できる`` () =
    let list =
        Domain.createList [ Domain.createValue 1 "1"; Domain.createValue 3 "Fizz" ]

    let value = Domain.FizzBuzzList.get 1 list
    Assert.Equal("Fizz", value.Value)

[<Fact>]
let ``リストを文字列化できる`` () =
    let list =
        Domain.createList [ Domain.createValue 1 "1"; Domain.createValue 3 "Fizz" ]

    Assert.Equal("1:1, 3:Fizz", Domain.FizzBuzzList.toString list)

[<Fact>]
let ``正の整数でバリデーション成功`` () =
    let result = Domain.validateNumber 5

    match result with
    | Ok n -> Assert.Equal(5, n)
    | Error _ -> Assert.Fail("Expected Ok")

[<Fact>]
let ``ゼロ以下でバリデーション失敗`` () =
    let result = Domain.validateNumber 0

    match result with
    | Ok _ -> Assert.Fail("Expected Error")
    | Error msg -> Assert.Equal("数値は正の整数でなければなりません", msg)

[<Fact>]
let ``safeGenerateで安全にFizzBuzzを生成`` () =
    let result = Domain.safeGenerate Domain.Standard 15

    match result with
    | Ok value -> Assert.Equal("FizzBuzz", value.Value)
    | Error _ -> Assert.Fail("Expected Ok")

[<Fact>]
let ``計算式で安全に処理できる`` () =
    match Domain.processNumber Domain.Standard 15 with
    | Ok value -> Assert.Equal("FizzBuzz", value)
    | Error _ -> Assert.Fail("Expected Ok")

[<Fact>]
let ``計算式でエラーが伝播する`` () =
    match Domain.processNumber Domain.Standard 0 with
    | Ok _ -> Assert.Fail("Expected Error")
    | Error msg -> Assert.Equal("数値は正の整数でなければなりません", msg)
