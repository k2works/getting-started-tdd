module FizzBuzz.Type
  ( FizzBuzzType(..)
  , Generatable(..)
  , createType
  ) where

data FizzBuzzType = Type01
                  | Type02
                  | Type03
                  deriving (Show, Eq)

class Generatable a where
  generate :: a -> Int -> String

instance Generatable FizzBuzzType where
  generate Type01 n
    | n `mod` 15 == 0 = "FizzBuzz"
    | n `mod` 3 == 0 = "Fizz"
    | n `mod` 5 == 0 = "Buzz"
    | otherwise = show n
  generate Type02 n = show n
  generate Type03 n
    | n `mod` 15 == 0 = "FizzBuzz"
    | n `mod` 3 == 0 = "Fizz"
    | otherwise = show n

createType :: Int -> Either String FizzBuzzType
createType 1 = Right Type01
createType 2 = Right Type02
createType 3 = Right Type03
createType _ = Left "未定義のタイプです"
