module FizzBuzz.FizzBuzzSpec (spec) where

import FizzBuzz
import Test.Hspec

spec :: Spec
spec = do
  describe "generate" $ do
    it "1 を渡すと '1' を返す" $
      generate 1 `shouldBe` "1"

    it "2 を渡すと '2' を返す" $
      generate 2 `shouldBe` "2"

    it "3 の倍数を渡すと 'Fizz' を返す" $
      generate 3 `shouldBe` "Fizz"

    it "6 を渡すと 'Fizz' を返す" $
      generate 6 `shouldBe` "Fizz"

    it "5 の倍数を渡すと 'Buzz' を返す" $
      generate 5 `shouldBe` "Buzz"

    it "10 を渡すと 'Buzz' を返す" $
      generate 10 `shouldBe` "Buzz"

    it "15 の倍数を渡すと 'FizzBuzz' を返す" $
      generate 15 `shouldBe` "FizzBuzz"

    it "30 を渡すと 'FizzBuzz' を返す" $
      generate 30 `shouldBe` "FizzBuzz"

  describe "generateList" $ do
    it "100 件のリストを生成する" $
      length (generateList 100) `shouldBe` 100

    it "最初の要素は '1'" $
      generateList 100 !! 0 `shouldBe` "1"

    it "3 番目の要素は 'Fizz'" $
      generateList 100 !! 2 `shouldBe` "Fizz"

    it "5 番目の要素は 'Buzz'" $
      generateList 100 !! 4 `shouldBe` "Buzz"

    it "15 番目の要素は 'FizzBuzz'" $
      generateList 100 !! 14 `shouldBe` "FizzBuzz"

  describe "generateWith" $ do
    it "カスタムルールで生成できる" $ do
      let rule n = if even n then "Even" else "Odd"
      generateWith rule 2 `shouldBe` "Even"
      generateWith rule 3 `shouldBe` "Odd"

  describe "transform" $ do
    it "リストを変換できる" $ do
      let result = transform (++ "!") ["Fizz", "Buzz"]
      result `shouldBe` ["Fizz!", "Buzz!"]

  describe "filterList" $ do
    it "リストをフィルタリングできる" $ do
      let result = filterList (/= "Fizz") (generateList 5)
      result `shouldBe` ["1", "2", "4", "Buzz"]
