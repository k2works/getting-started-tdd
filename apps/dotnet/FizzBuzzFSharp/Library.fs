namespace FizzBuzzFSharp

module Domain =

    type FizzBuzzValue =
        { Number: int
          Value: string }

    let createValue number value = { Number = number; Value = value }

    [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
    module FizzBuzzValue =

        let toDisplayString (value: FizzBuzzValue) =
            sprintf "%d:%s" value.Number value.Value

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

    type FizzBuzzList = { Values: FizzBuzzValue list }

    let emptyList = { Values = [] }

    let createList (values: FizzBuzzValue list) = { Values = values }

    [<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
    module FizzBuzzList =

        let empty = emptyList

        let create values = createList values

        let count (list: FizzBuzzList) = List.length list.Values

        let get index (list: FizzBuzzList) = list.Values.[index]

        let filter (predicate: FizzBuzzValue -> bool) (list: FizzBuzzList) =
            { Values = list.Values |> List.filter predicate }

        let findFirst (predicate: FizzBuzzValue -> bool) (list: FizzBuzzList) =
            list.Values |> List.tryFind predicate

        let toStringValues (list: FizzBuzzList) =
            list.Values |> List.map (fun v -> v.Value)

        let countByValue (list: FizzBuzzList) =
            list.Values
            |> List.countBy (fun v -> v.Value)
            |> Map.ofList

        let add (value: FizzBuzzValue) (list: FizzBuzzList) =
            { Values = list.Values @ [ value ] }

        let addRange (values: FizzBuzzValue list) (list: FizzBuzzList) =
            { Values = list.Values @ values }

        let toDisplayString (list: FizzBuzzList) =
            list.Values
            |> List.map FizzBuzzValue.toDisplayString
            |> String.concat ", "

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
        executeList Standard count
        |> FizzBuzzList.toStringValues
