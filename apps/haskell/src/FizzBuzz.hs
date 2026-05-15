module FizzBuzz
  ( compose
  , generate
  , filterList
  , generateWith
  , generateList
  , lazyStream
  , safeGenerate
  , safeFizzBuzzPair
  , safeGenerateList
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

lazyStream :: [String]
lazyStream = map generate [1 ..]

safeGenerate :: Int -> Either String String
safeGenerate n
  | n <= 0    = Left "正の整数を指定してください"
  | otherwise = Right (generate n)

safeGenerateList :: Int -> Either String [String]
safeGenerateList n
  | n <= 0    = Left "正の整数を指定してください"
  | otherwise = Right (generateList n)

safeFizzBuzzPair :: Int -> Int -> Either String String
safeFizzBuzzPair a b = do
  x <- safeGenerate a
  y <- safeGenerate b
  return (x ++ ", " ++ y)

transform :: (a -> b) -> [a] -> [b]
transform = map

filterList :: (a -> Bool) -> [a] -> [a]
filterList = filter
