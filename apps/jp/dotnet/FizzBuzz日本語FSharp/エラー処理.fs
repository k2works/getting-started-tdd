/// 題材 D: 成功と失敗を表す結果型
module FizzBuzz日本語FSharp.エラー処理

open FizzBuzz日本語FSharp.FizzBuzz

type 変換結果 =
    | 成功 of 値: string
    | 失敗 of エラー: string

let 安全変換 数 =
    if 数 <= 0 then
        失敗 $"正の数を指定してください: {数}"
    else
        成功 (数 |> FizzBuzz変換)
