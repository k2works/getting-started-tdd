namespace FizzBuzzFSharp

module FizzBuzz =

    let generate (number: int) : string =
        match (number % 3, number % 5) with
        | (0, 0) -> "FizzBuzz"
        | (0, _) -> "Fizz"
        | (_, 0) -> "Buzz"
        | _ -> string number

    let generateList (count: int) : string list = [ 1..count ] |> List.map generate

    let printFizzBuzz (count: int) : unit =
        generateList count |> List.iter (printfn "%s")
