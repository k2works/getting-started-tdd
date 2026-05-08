module Program

open System
open System.Reflection
open FizzBuzzFSharp
open Xunit

type private DebugTest = { Name: string; Invoke: unit -> unit }

let private parseCount (arguments: string array) =
    match arguments |> Array.tryHead with
    | Some value ->
        match Int32.TryParse value with
        | true, parsed when parsed > 0 -> parsed
        | _ -> 15
    | None -> 15

let private debugTests () =
    Assembly.GetExecutingAssembly().GetTypes()
    |> Array.collect (fun testType ->
        testType.GetMethods(BindingFlags.Static ||| BindingFlags.Public ||| BindingFlags.NonPublic)
        |> Array.choose (fun method ->
            let hasFact = method.GetCustomAttributes(typeof<FactAttribute>, true).Length > 0

            if hasFact && method.GetParameters().Length = 0 then
                Some
                    { Name = $"{testType.Name}.{method.Name}"
                      Invoke = fun () -> method.Invoke(null, [||]) |> ignore }
            else
                None))
    |> Array.sortBy (fun test -> test.Name)

let private listTests () =
    debugTests () |> Array.iter (fun test -> printfn "%s" test.Name)
    0

let private runTestByPattern (pattern: string) =
    let matches =
        debugTests ()
        |> Array.filter (fun test -> test.Name.Contains(pattern, StringComparison.Ordinal))

    match matches with
    | [||] ->
        eprintfn "No test matched: %s" pattern
        1
    | [| test |] ->
        try
            test.Invoke()
            0
        with :? TargetInvocationException as ex ->
            match ex.InnerException with
            | null -> reraise ()
            | inner -> raise inner
    | _ ->
        eprintfn "Multiple tests matched: %s" pattern
        matches |> Array.iter (fun test -> eprintfn "  %s" test.Name)
        1

[<EntryPoint>]
let main arguments =
    match arguments |> Array.toList with
    | [ "--list-tests" ] -> listTests ()
    | [ "--test"; pattern ] -> runTestByPattern pattern
    | _ ->
        arguments |> parseCount |> FizzBuzz.generateList |> List.iter (printfn "%s")
        0
