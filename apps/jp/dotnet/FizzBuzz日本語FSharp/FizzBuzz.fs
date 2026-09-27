/// 題材 A: FizzBuzz の基本変換
module FizzBuzz日本語FSharp.FizzBuzz

let FizzBuzz変換 数 =
    match 数 % 3, 数 % 5 with
    | 0, 0 -> "FizzBuzz"
    | 0, _ -> "Fizz"
    | _, 0 -> "Buzz"
    | _ -> string 数

let FizzBuzz配列作成 上限 = [ 1..上限 ] |> List.map FizzBuzz変換
