module FizzBuzz.Model
  ( FizzBuzzValue(..)
  , FizzBuzzList(..)
  , createList
  , listCount
  , valueToString
  ) where

import FizzBuzz.Type (FizzBuzzType, Generatable(..))

data FizzBuzzValue = FizzBuzzValue
  { number :: Int
  , value :: String
  } deriving (Show, Eq)

newtype FizzBuzzList = FizzBuzzList
  { values :: [FizzBuzzValue]
  } deriving (Show, Eq)

valueToString :: FizzBuzzValue -> String
valueToString = value

listCount :: FizzBuzzList -> Int
listCount = length . values

createList :: Int -> FizzBuzzType -> FizzBuzzList
createList count fbType =
  FizzBuzzList $ map createValue [1 .. count]
  where
    createValue n = FizzBuzzValue {number = n, value = generate fbType n}
