module FizzBuzz.TypeSpec (spec) where

import Test.Hspec
import FizzBuzz.Type

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
    it "タイプ 1 を生成できる" $
      createType 1 `shouldBe` Right Type01

    it "タイプ 2 を生成できる" $
      createType 2 `shouldBe` Right Type02

    it "タイプ 3 を生成できる" $
      createType 3 `shouldBe` Right Type03

    it "未定義のタイプでエラーを返す" $
      createType 4 `shouldBe` Left "未定義のタイプです"
