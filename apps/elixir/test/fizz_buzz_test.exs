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
      assert FizzBuzz.generate(6) == "Fizz"
    end

    test "5 の倍数を渡すと Buzz を返す" do
      assert FizzBuzz.generate(5) == "Buzz"
    end

    test "15 の倍数を渡すと FizzBuzz を返す" do
      assert FizzBuzz.generate(15) == "FizzBuzz"
    end
  end

  describe "generate_list/0" do
    test "1 から 100 までの FizzBuzz リストを返す" do
      result = FizzBuzz.generate_list()

      assert length(result) == 100
      assert Enum.at(result, 0) == "1"
      assert Enum.at(result, 2) == "Fizz"
      assert Enum.at(result, 4) == "Buzz"
      assert Enum.at(result, 14) == "FizzBuzz"
    end
  end
end
