defmodule FizzBuzzTest do
  use ExUnit.Case, async: true

  import FizzBuzz

  describe "FizzBuzz変換" do
    test "3を渡したらFizzを返す" do
      assert fizzbuzz_変換(3) == "Fizz"
    end

    test "5を渡したらBuzzを返す" do
      assert fizzbuzz_変換(5) == "Buzz"
    end

    test "15を渡したらFizzBuzzを返す" do
      assert fizzbuzz_変換(15) == "FizzBuzz"
    end

    test "1を渡したら文字列1を返す" do
      assert fizzbuzz_変換(1) == "1"
    end

    test "2を渡したら文字列2を返す" do
      assert fizzbuzz_変換(2) == "2"
    end
  end

  describe "FizzBuzz配列作成" do
    test "15まで作ると15件になる" do
      assert length(fizzbuzz_配列作成(15)) == 15
    end

    test "15まで作った配列の並び" do
      assert Enum.join(fizzbuzz_配列作成(15), ",") ==
               "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
    end
  end

  describe "語順" do
    test "3 |> fizzbuzz_変換() と値を先に書ける" do
      assert 3 |> fizzbuzz_変換() == "Fizz"
    end
  end
end
