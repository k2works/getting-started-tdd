module FizzBuzzタイプSpec (spec) where

import Test.Hspec
import FizzBuzzタイプ

spec :: Spec
spec = describe "タイプ生成" $ do
  it "タイプ1は通常の変換をする" $ do
    (`タイプ変換` 3) <$> タイプ生成 1 `shouldBe` Right "Fizz"
    名前 <$> タイプ生成 1 `shouldBe` Right "通常"

  it "タイプ2は数字だけを返す" $ do
    (`タイプ変換` 3) <$> タイプ生成 2 `shouldBe` Right "3"
    名前 <$> タイプ生成 2 `shouldBe` Right "数字限定"

  it "タイプ3は15の倍数だけFizzBuzzを返す" $
    (`タイプ変換` 15) <$> タイプ生成 3 `shouldBe` Right "FizzBuzz"

  it "タイプ3は3の倍数を数字で返す" $
    (`タイプ変換` 3) <$> タイプ生成 3 `shouldBe` Right "3"

  it "存在しないタイプはエラーになる" $
    名前 <$> タイプ生成 4 `shouldBe` Left "該当するタイプは存在しません: 4"

  it "列挙型 TFizzBuzz限定 からも生成できる" $
    名前 (番号から生成 TFizzBuzz限定) `shouldBe` "FizzBuzz限定"
