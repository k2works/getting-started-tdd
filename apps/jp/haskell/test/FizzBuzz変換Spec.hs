module FizzBuzz変換Spec (spec) where

import Test.Hspec
import FizzBuzz変換
import M助詞

spec :: Spec
spec = do
  describe "FizzBuzz変換" $ do
    it "3を渡したらFizzを返す" $
      fizzBuzz変換 3 `shouldBe` "Fizz"

    it "5を渡したらBuzzを返す" $
      fizzBuzz変換 5 `shouldBe` "Buzz"

    it "15を渡したらFizzBuzzを返す" $
      fizzBuzz変換 15 `shouldBe` "FizzBuzz"

    it "1を渡したら文字列1を返す" $
      fizzBuzz変換 1 `shouldBe` "1"

    it "2を渡したら文字列2を返す" $
      fizzBuzz変換 2 `shouldBe` "2"

  describe "FizzBuzz配列作成" $ do
    it "15まで作ると15件になる" $
      length (fizzBuzz配列作成 15) `shouldBe` 15

    it "15まで作った配列の並び" $
      fizzBuzz配列作成 15 `shouldBe` words "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz"

  describe "語順" $ do
    it "3 `を` fizzBuzz変換 と助詞を挟んで書ける" $
      (3 `を` fizzBuzz変換) `shouldBe` "Fizz"
