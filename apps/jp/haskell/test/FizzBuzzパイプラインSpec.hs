module FizzBuzzパイプラインSpec (spec) where

import Test.Hspec
import FizzBuzzパイプライン

spec :: Spec
spec = describe "パイプライン" $ do
  it "装飾すると角括弧で囲む" $
    装飾 "Fizz" `shouldBe` "[Fizz]"

  it "5までのパイプライン処理" $
    パイプライン処理 5 `shouldBe` ["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]

  it "15を FizzBuzz変換して 装飾する" $
    fizzBuzz装飾 15 `shouldBe` "[FizzBuzz]"
