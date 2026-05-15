module FizzBuzz.TypeSpec (spec) where

import FizzBuzz.Type
import Test.Hspec

spec :: Spec
spec = do
  describe "Type01" $ do
    it "1 を渡すと '1' を返す" $
      generate Type01 1 `shouldBe` "1"

    it "3 の倍数を渡すと 'Fizz' を返す" $
      generate Type01 3 `shouldBe` "Fizz"

    it "5 の倍数を渡すと 'Buzz' を返す" $
      generate Type01 5 `shouldBe` "Buzz"

    it "15 の倍数を渡すと 'FizzBuzz' を返す" $
      generate Type01 15 `shouldBe` "FizzBuzz"

  describe "Type02" $ do
    it "数値を文字列に変換する" $
      generate Type02 1 `shouldBe` "1"

  describe "Type03" $ do
    it "1 を渡すと '1' を返す" $
      generate Type03 1 `shouldBe` "1"

    it "3 を渡すと 'Fizz' を返す" $
      generate Type03 3 `shouldBe` "Fizz"

    it "15 の倍数で 'FizzBuzz' を返す" $
      generate Type03 15 `shouldBe` "FizzBuzz"

  describe "createType" $ do
    it "1 を渡すと Type01 を返す" $
      createType 1 `shouldBe` Right Type01

    it "2 を渡すと Type02 を返す" $
      createType 2 `shouldBe` Right Type02

    it "3 を渡すと Type03 を返す" $
      createType 3 `shouldBe` Right Type03

    it "未定義のタイプはエラーを返す" $
      createType 4 `shouldBe` Left "未定義のタイプです"
