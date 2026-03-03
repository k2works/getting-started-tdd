defmodule FizzBuzzTest do
  use ExUnit.Case

  describe "generate/1" do
    test "1 を渡すと文字列 1 を返す" do
      assert FizzBuzz.generate(1) == "1"
    end

    test "2 を渡すと文字列 2 を返す" do
      assert FizzBuzz.generate(2) == "2"
    end

    test "3 の倍数を渡すと Fizz を返す" do
      assert FizzBuzz.generate(3) == "Fizz"
    end

    test "5 の倍数を渡すと Buzz を返す" do
      assert FizzBuzz.generate(5) == "Buzz"
    end

    test "15 の倍数を渡すと FizzBuzz を返す" do
      assert FizzBuzz.generate(15) == "FizzBuzz"
    end
  end

  describe "generate_list/1" do
    test "1 から 100 までのリストを生成する" do
      result = FizzBuzz.generate_list(100)
      assert length(result) == 100
      assert List.first(result) == "1"
      assert List.last(result) == "Buzz"
    end
  end
end
