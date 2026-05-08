namespace FizzBuzzFSharp

module Domain =

    type FizzBuzzType =
        | Standard
        | NumberOnly
        | FizzBuzzOnly

    type FizzBuzzValue =
        { Number: int
          Value: string }

        override this.ToString() = sprintf "%d:%s" this.Number this.Value

    let createValue number value = { Number = number; Value = value }

    type FizzBuzzList =
        { Values: FizzBuzzValue list }

        member this.Count = this.Values.Length
        member this.Get(index) = this.Values.[index]

        member this.Filter(predicate: FizzBuzzValue -> bool) =
            { Values = this.Values |> List.filter predicate }

        member this.FindFirst(predicate: FizzBuzzValue -> bool) = this.Values |> List.tryFind predicate

        member this.ToStringValues() =
            this.Values |> List.map (fun v -> v.Value)

        member this.CountByValue() =
            this.Values
            |> List.groupBy (fun v -> v.Value)
            |> List.map (fun (key, group) -> (key, List.length group))
            |> Map.ofList

        member this.Add(value: FizzBuzzValue) = { Values = this.Values @ [ value ] }

        member this.AddRange(values: FizzBuzzValue list) = { Values = this.Values @ values }

        override this.ToString() =
            this.Values |> List.map (fun v -> v.ToString()) |> String.concat ", "

    let emptyList = { Values = [] }

    let createList (values: FizzBuzzValue list) = { Values = values }

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

    type ResultBuilder() =
        member _.Bind(result, f) =
            match result with
            | Ok value -> f value
            | Error e -> Error e

        member _.Return(value) = Ok value
        member _.ReturnFrom(result) = result

    let result = ResultBuilder()

    let processNumber (fizzBuzzType: FizzBuzzType) (input: int) =
        result {
            let! validNumber = validateNumber input
            let fizzBuzzValue = generate fizzBuzzType validNumber
            return fizzBuzzValue.Value
        }

module Application =

    let executeValue (fizzBuzzType: Domain.FizzBuzzType) (number: int) : Domain.FizzBuzzValue =
        Domain.generate fizzBuzzType number

    let executeList (fizzBuzzType: Domain.FizzBuzzType) (count: int) : Domain.FizzBuzzList =
        [ 1..count ] |> List.map (Domain.generate fizzBuzzType) |> Domain.createList

module FizzBuzz =

    let generate (number: int) : string =
        let value = Application.executeValue Domain.Standard number
        value.Value

    let generateList (count: int) : string list =
        let list = Application.executeList Domain.Standard count
        list.ToStringValues()

    let printFizzBuzz (count: int) : unit =
        generateList count |> List.iter (printfn "%s")
