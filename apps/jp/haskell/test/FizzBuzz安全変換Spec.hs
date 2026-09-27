module FizzBuzz安全変換Spec (spec) where

import Test.Hspec
import FizzBuzz安全変換

spec :: Spec
spec = describe "安全変換" $ do
  it "正の数は成功になる" $
    安全変換 3 `shouldBe` T成功 "Fizz"

  it "0は失敗になる" $
    安全変換 0 `shouldBe` T失敗 "正の数を指定してください: 0"

  it "case 式で 成功・失敗 を振り分ける" $
    表示 (安全変換 (-1)) `shouldBe` "失敗: 正の数を指定してください: -1"
  where
    表示 結果 = case 結果 of
      T成功 値 -> 値
      T失敗 エラー -> "失敗: " ++ エラー
