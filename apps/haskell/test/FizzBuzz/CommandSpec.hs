module FizzBuzz.CommandSpec (spec) where

import FizzBuzz.Command
import FizzBuzz.Model
import FizzBuzz.Type
import Test.Hspec

spec :: Spec
spec = do
  describe "ValueCommand" $ do
    it "指定した数値で実行できる" $ do
      let cmd = ValueCommand {vcNumber = 3, vcType = Type01}
          result = executeValue cmd
      value result `shouldBe` "Fizz"

    it "15 の倍数で FizzBuzz を返す" $ do
      let cmd = ValueCommand {vcNumber = 15, vcType = Type01}
          result = executeValue cmd
      value result `shouldBe` "FizzBuzz"

  describe "ListCommand" $ do
    it "デフォルトで 100 件のリストを生成する" $ do
      let cmd = ListCommand {lcCount = 100, lcType = Type01}
          result = executeList cmd
      listCount result `shouldBe` 100

    it "指定した件数でリストを生成する" $ do
      let cmd = ListCommand {lcCount = 10, lcType = Type01}
          result = executeList cmd
      listCount result `shouldBe` 10
