-- | 題材 A: FizzBuzz の基本変換
module FizzBuzz変換 (fizzBuzz変換, fizzBuzz配列作成) where

-- | 大文字始まりの FizzBuzz変換 はデータ構築子と解釈されるため、先頭を小文字にする
fizzBuzz変換 :: Int -> String
fizzBuzz変換 数
  | 数 `mod` 15 == 0 = "FizzBuzz"
  | 数 `mod` 3 == 0 = "Fizz"
  | 数 `mod` 5 == 0 = "Buzz"
  | otherwise = show 数

fizzBuzz配列作成 :: Int -> [String]
fizzBuzz配列作成 上限 = map fizzBuzz変換 [1 .. 上限]
