/// 題材 C: 「N を FizzBuzz変換して 装飾して 戻す」を関数合成で書く
module FizzBuzz日本語FSharp.パイプライン

open FizzBuzz日本語FSharp.FizzBuzz

let 装飾 文字列 = $"[{文字列}]"

/// FizzBuzz変換して >> 装飾する
let FizzBuzz装飾 = FizzBuzz変換 >> 装飾

let パイプライン処理 上限 = [ 1..上限 ] |> List.map FizzBuzz装飾
