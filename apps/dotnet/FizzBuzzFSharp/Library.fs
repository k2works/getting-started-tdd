namespace FizzBuzzFSharp

module Domain =

    type FizzBuzzValue =
        { Number: int
          Value: string }

        override this.ToString() = sprintf "%d:%s" this.Number this.Value

    let createValue number value = { Number = number; Value = value }

    type FizzBuzzType =
        | Standard
        | NumberOnly
        | FizzBuzzOnly

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
            if number % 15 = 0 then createValue number "FizzBuzz"
            else createValue number (string number)

    type FizzBuzzList =
        { Values: FizzBuzzValue list }

        member this.Count = this.Values.Length
        member this.Get(index) = this.Values.[index]

        member this.Filter(predicate: FizzBuzzValue -> bool) =
            { Values = this.Values |> List.filter predicate }

        member this.FindFirst(predicate: FizzBuzzValue -> bool) =
            this.Values |> List.tryFind predicate

        member this.ToStringValues() =
            this.Values |> List.map (fun v -> v.Value)

        member this.CountByValue() =
            this.Values
            |> List.groupBy (fun v -> v.Value)
            |> List.map (fun (key, group) -> (key, List.length group))
            |> Map.ofList

        member this.Add(value: FizzBuzzValue) =
            { Values = this.Values @ [ value ] }

        member this.AddRange(values: FizzBuzzValue list) =
            { Values = this.Values @ values }

        override this.ToString() =
            this.Values
            |> List.map (fun v -> v.ToString())
            |> String.concat ", "

    let emptyList = { Values = [] }

    let createList (values: FizzBuzzValue list) = { Values = values }

module Application =
    open Domain

    let executeValue (fizzBuzzType: FizzBuzzType) (number: int) : FizzBuzzValue =
        generate fizzBuzzType number

    let executeList (fizzBuzzType: FizzBuzzType) (count: int) : FizzBuzzList =
        [ 1..count ]
        |> List.map (generate fizzBuzzType)
        |> createList

module FizzBuzz =
    open Domain
    open Application

    let generate (number: int) : string =
        let value = executeValue Standard number
        value.Value

    let generateList (count: int) : string list =
        let list = executeList Standard count
        list.ToStringValues()
