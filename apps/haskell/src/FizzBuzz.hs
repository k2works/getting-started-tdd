module FizzBuzz
  ( generate
  , generateList
  ) where

generate :: Int -> String
generate n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise       = show n

generateList :: Int -> [String]
generateList n = map generate [1 .. n]
