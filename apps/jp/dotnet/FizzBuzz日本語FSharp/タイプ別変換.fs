/// 題材 B: 名前と変換関数を持つタイプ
module FizzBuzz日本語FSharp.タイプ別変換

open FizzBuzz日本語FSharp.FizzBuzz

/// 日本語のケース名は大文字・小文字の区別がないため、綴り間違いが変数パターンとして
/// 黙って通らないよう、修飾付きアクセス（タイプ番号.通常）を強制する
[<RequireQualifiedAccess>]
type タイプ番号 =
    | 通常
    | 数字限定
    | FizzBuzz限定

type タイプ = { 名前: string; 変換: int -> string }

exception タイプ未定義例外 of 番号: int with
    override this.Message = $"該当するタイプは存在しません: {this.番号}"

let private 数字限定変換 (数: int) = string 数

let private FizzBuzz限定変換 数 =
    if 数 % 15 = 0 then "FizzBuzz" else string 数

let 番号から生成 番号 =
    match 番号 with
    | タイプ番号.通常 -> { 名前 = "通常"; 変換 = FizzBuzz変換 }
    | タイプ番号.数字限定 -> { 名前 = "数字限定"; 変換 = 数字限定変換 }
    | タイプ番号.FizzBuzz限定 -> { 名前 = "FizzBuzz限定"; 変換 = FizzBuzz限定変換 }

let タイプ生成 番号 =
    match 番号 with
    | 1 -> 番号から生成 タイプ番号.通常
    | 2 -> 番号から生成 タイプ番号.数字限定
    | 3 -> 番号から生成 タイプ番号.FizzBuzz限定
    | _ -> raise (タイプ未定義例外 番号)

let タイプ変換 タイプ 数 = タイプ.変換 数
