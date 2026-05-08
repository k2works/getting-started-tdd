namespace FizzBuzzFSharp

module Domain =

    type FizzBuzzType =
        | Standard
        | NumberOnly
        | FizzBuzzOnly

    type FizzBuzzValue = { Number: int; Value: string }

    module FizzBuzzValue =
        let create number value = { Number = number; Value = value }

        let toString (fizzBuzzValue: FizzBuzzValue) =
            sprintf "%d:%s" fizzBuzzValue.Number fizzBuzzValue.Value

    let createValue number value = FizzBuzzValue.create number value

    type FizzBuzzList = { Values: FizzBuzzValue list }

    module FizzBuzzList =
        let empty = { Values = [] }

        let create (values: FizzBuzzValue list) = { Values = values }

        let count (fizzBuzzList: FizzBuzzList) = fizzBuzzList.Values.Length

        let get index (fizzBuzzList: FizzBuzzList) = fizzBuzzList.Values.[index]

        let filter (predicate: FizzBuzzValue -> bool) (fizzBuzzList: FizzBuzzList) =
            { Values = fizzBuzzList.Values |> List.filter predicate }

        let findFirst (predicate: FizzBuzzValue -> bool) (fizzBuzzList: FizzBuzzList) =
            fizzBuzzList.Values |> List.tryFind predicate

        let toStringValues (fizzBuzzList: FizzBuzzList) =
            fizzBuzzList.Values |> List.map (fun value -> value.Value)

        let countByValue (fizzBuzzList: FizzBuzzList) =
            fizzBuzzList.Values
            |> List.groupBy (fun v -> v.Value)
            |> List.map (fun (key, group) -> (key, List.length group))
            |> Map.ofList

        let add (value: FizzBuzzValue) (fizzBuzzList: FizzBuzzList) =
            { Values = fizzBuzzList.Values @ [ value ] }

        let addRange (values: FizzBuzzValue list) (fizzBuzzList: FizzBuzzList) =
            { Values = fizzBuzzList.Values @ values }

        let toString (fizzBuzzList: FizzBuzzList) =
            fizzBuzzList.Values |> List.map FizzBuzzValue.toString |> String.concat ", "

    let emptyList = FizzBuzzList.empty

    let createList (values: FizzBuzzValue list) = FizzBuzzList.create values

    let private isFizz number = number % 3 = 0
    let private isBuzz number = number % 5 = 0
    let private isFizzBuzz number = isFizz number && isBuzz number

    let generate (fizzBuzzType: FizzBuzzType) (number: int) : FizzBuzzValue =
        match fizzBuzzType with
        | Standard ->
            if isFizzBuzz number then createValue number "FizzBuzz"
            elif isFizz number then createValue number "Fizz"
            elif isBuzz number then createValue number "Buzz"
            else createValue number (string number)
        | NumberOnly -> createValue number (string number)
        | FizzBuzzOnly ->
            if number % 15 = 0 then
                createValue number "FizzBuzz"
            else
                createValue number (string number)

    let validateNumber (number: int) : Result<int, string> =
        if number <= 0 then Error "数値は正の整数でなければなりません"
        elif number > 1000 then Error "数値は1000以下でなければなりません"
        else Ok number

    let safeGenerate (fizzBuzzType: FizzBuzzType) (number: int) : Result<FizzBuzzValue, string> =
        number |> validateNumber |> Result.map (generate fizzBuzzType)

    let processNumber (fizzBuzzType: FizzBuzzType) (input: int) =
        input
        |> validateNumber
        |> Result.map (generate fizzBuzzType)
        |> Result.map (fun fizzBuzzValue -> fizzBuzzValue.Value)

module Application =

    let executeValue (fizzBuzzType: Domain.FizzBuzzType) (number: int) : Domain.FizzBuzzValue =
        Domain.generate fizzBuzzType number

    let executeList (fizzBuzzType: Domain.FizzBuzzType) (count: int) : Domain.FizzBuzzList =
        [ 1..count ]
        |> List.map (Domain.generate fizzBuzzType)
        |> Domain.FizzBuzzList.create

module FizzBuzz =

    let generate (number: int) : string =
        let value = Application.executeValue Domain.Standard number
        value.Value

    let generateList (count: int) : string list =
        let list = Application.executeList Domain.Standard count
        Domain.FizzBuzzList.toStringValues list

    let printFizzBuzz (count: int) : unit =
        generateList count |> List.iter (printfn "%s")
