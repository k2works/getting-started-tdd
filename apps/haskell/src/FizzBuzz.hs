module FizzBuzz
  ( compose
  , generate
  , filterList
  , generateWith
  , generateList
  , transform
  ) where

generate :: Int -> String
generate n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise       = show n

generateWith :: (Int -> String) -> Int -> String
generateWith rule = rule

compose :: (b -> c) -> (a -> b) -> a -> c
compose = (.)

generateList :: Int -> [String]
generateList n = map generate [1 .. n]

transform :: (a -> b) -> [a] -> [b]
transform = map

filterList :: (a -> Bool) -> [a] -> [a]
filterList = filter
