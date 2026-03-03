module FizzBuzz.Model
  ( FizzBuzzValue(..)
  , FizzBuzzList(..)
  , valueToString
  , listCount
  , createList
  ) where

import FizzBuzz.Type (FizzBuzzType, Generatable(..))

-- | FizzBuzz の単一値を表すデータ型
data FizzBuzzValue = FizzBuzzValue
  { number :: Int
  , value  :: String
  } deriving (Show, Eq)

-- | 値を文字列として返す
valueToString :: FizzBuzzValue -> String
valueToString = value

-- | FizzBuzz のリストを表すデータ型
newtype FizzBuzzList = FizzBuzzList
  { values :: [FizzBuzzValue]
  } deriving (Show, Eq)

-- | リストの要素数を返す
listCount :: FizzBuzzList -> Int
listCount = length . values

-- | 1 から count までの FizzBuzz リストを生成する
createList :: Int -> FizzBuzzType -> FizzBuzzList
createList count fbType =
  FizzBuzzList $ map createValue [1..count]
  where
    createValue n = FizzBuzzValue
      { number = n
      , value  = generate fbType n
      }
