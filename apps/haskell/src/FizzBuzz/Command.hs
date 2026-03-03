module FizzBuzz.Command
  ( ValueCommand(..)
  , ListCommand(..)
  , executeValue
  , executeList
  ) where

import FizzBuzz.Type (FizzBuzzType(..), Generatable(..))
import FizzBuzz.Model (FizzBuzzValue(..), FizzBuzzList, createList)

-- | 単一値の FizzBuzz コマンド
data ValueCommand = ValueCommand
  { vcNumber :: Int
  , vcType   :: FizzBuzzType
  } deriving (Show, Eq)

-- | リストの FizzBuzz コマンド
data ListCommand = ListCommand
  { lcCount :: Int
  , lcType  :: FizzBuzzType
  } deriving (Show, Eq)

-- | ValueCommand を実行する
executeValue :: ValueCommand -> FizzBuzzValue
executeValue cmd =
  FizzBuzzValue
    { number = vcNumber cmd
    , value  = generate (vcType cmd) (vcNumber cmd)
    }

-- | ListCommand を実行する
executeList :: ListCommand -> FizzBuzzList
executeList cmd = createList (lcCount cmd) (lcType cmd)
