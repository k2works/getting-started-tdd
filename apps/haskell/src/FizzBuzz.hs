module FizzBuzz
  ( generate
  , generateList
  ) where

-- | 単一の数値に対して FizzBuzz を生成する
generate :: Int -> String
generate n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise        = show n

-- | 1 から n までの FizzBuzz リストを生成する
generateList :: Int -> [String]
generateList n = map generate [1..n]
