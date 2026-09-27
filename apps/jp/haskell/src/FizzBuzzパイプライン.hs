-- | 題材 C: 「N を FizzBuzz変換して 装飾して 戻す」を助詞の中置関数で書く
module FizzBuzzパイプライン (装飾, fizzBuzz装飾, パイプライン処理) where

import FizzBuzz変換 (fizzBuzz変換)
import M助詞 (して, を)

装飾 :: String -> String
装飾 文字列 = "[" ++ 文字列 ++ "]"

fizzBuzz装飾 :: Int -> String
fizzBuzz装飾 数 = 数 `を` fizzBuzz変換 `して` 装飾

パイプライン処理 :: Int -> [String]
パイプライン処理 上限 = map fizzBuzz装飾 [1 .. 上限]
