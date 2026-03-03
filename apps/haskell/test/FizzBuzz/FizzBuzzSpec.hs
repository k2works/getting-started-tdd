module FizzBuzz.FizzBuzzSpec (spec) where

import Data.Char (isAsciiLower)
import Test.Hspec
import FizzBuzz

spec :: Spec
spec = do
  describe "generate" $ do
    it "1 を渡すと '1' を返す" $
      generate 1 `shouldBe` "1"

    it "2 を渡すと '2' を返す" $
      generate 2 `shouldBe` "2"

    it "3 の倍数を渡すと 'Fizz' を返す" $
      generate 3 `shouldBe` "Fizz"

    it "5 の倍数を渡すと 'Buzz' を返す" $
      generate 5 `shouldBe` "Buzz"

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

  describe "compose" $ do
    it "2 つの関数を合成できる" $ do
      let addExclaim = (++ "!")
          toUpper' = map (\c -> if isAsciiLower c then toEnum (fromEnum c - 32) else c)
          composed = compose addExclaim toUpper'
      composed "fizz" `shouldBe` "FIZZ!"

  describe "safeGenerate" $ do
    it "正の整数で成功する" $
      safeGenerate 3 `shouldBe` Right "Fizz"

    it "0 以下でエラーを返す" $
      safeGenerate 0 `shouldBe` Left "正の整数を指定してください"

    it "負数でエラーを返す" $
      safeGenerate (-1) `shouldBe` Left "正の整数を指定してください"

  describe "lazyStream" $ do
    it "遅延ストリームから要素を取得できる" $ do
      take 3 lazyStream `shouldBe` ["1", "2", "Fizz"]

    it "15 番目の要素は 'FizzBuzz'" $
      lazyStream !! 14 `shouldBe` "FizzBuzz"

  describe "safeGenerateList" $ do
    it "正の整数で成功する" $
      safeGenerateList 3 `shouldBe` Right ["1", "2", "Fizz"]

    it "0 以下でエラーを返す" $
      safeGenerateList 0 `shouldBe` Left "正の整数を指定してください"
