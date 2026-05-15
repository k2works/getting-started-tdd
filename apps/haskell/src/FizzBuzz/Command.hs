module FizzBuzz.Command
  ( ValueCommand(..)
  , ListCommand(..)
  , executeValue
  , executeList
  ) where

import FizzBuzz.Model (FizzBuzzList, FizzBuzzValue(..), createList)
import FizzBuzz.Type (FizzBuzzType(..), Generatable(..))

data ValueCommand = ValueCommand
  { vcNumber :: Int
  , vcType :: FizzBuzzType
  } deriving (Show, Eq)

executeValue :: ValueCommand -> FizzBuzzValue
executeValue cmd =
  FizzBuzzValue
    { number = vcNumber cmd
    , value = generate (vcType cmd) (vcNumber cmd)
    }

data ListCommand = ListCommand
  { lcCount :: Int
  , lcType :: FizzBuzzType
  } deriving (Show, Eq)

executeList :: ListCommand -> FizzBuzzList
executeList cmd = createList (lcCount cmd) (lcType cmd)
