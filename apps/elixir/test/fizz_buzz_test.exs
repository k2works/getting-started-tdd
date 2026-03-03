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

  describe "generate_with/2" do
    test "カスタムルールで生成する" do
      rule = fn n -> if rem(n, 2) == 0, do: "Even", else: "Odd" end
      assert FizzBuzz.generate_with(4, rule) == "Even"
      assert FizzBuzz.generate_with(3, rule) == "Odd"
    end
  end

  describe "transform/2" do
    test "リストの各要素を変換する" do
      result = FizzBuzz.transform(["1", "Fizz", "Buzz"], &String.upcase/1)
      assert result == ["1", "FIZZ", "BUZZ"]
    end
  end

  describe "filter/2" do
    test "条件に合う要素を抽出する" do
      list = FizzBuzz.generate_list(15)
      result = FizzBuzz.filter(list, &(&1 == "Fizz"))
      assert length(result) == 4
    end
  end

  describe "safe_generate/1" do
    test "正の整数で {:ok, value} を返す" do
      assert FizzBuzz.safe_generate(1) == {:ok, "1"}
      assert FizzBuzz.safe_generate(3) == {:ok, "Fizz"}
    end

    test "0 以下で {:error, reason} を返す" do
      assert FizzBuzz.safe_generate(0) == {:error, "正の整数を指定してください"}
      assert FizzBuzz.safe_generate(-1) == {:error, "正の整数を指定してください"}
    end
  end

  describe "lazy_stream/0" do
    test "遅延ストリームから最初の 5 要素を取得する" do
      result = FizzBuzz.lazy_stream() |> Enum.take(5)
      assert result == ["1", "2", "Fizz", "4", "Buzz"]
    end

    test "遅延ストリームから 15 番目の要素を取得する" do
      result = FizzBuzz.lazy_stream() |> Enum.at(14)
      assert result == "FizzBuzz"
    end
  end

  describe "safe_generate_list/1" do
    test "正の整数で {:ok, list} を返す" do
      assert {:ok, list} = FizzBuzz.safe_generate_list(5)
      assert length(list) == 5
    end

    test "0 以下で {:error, reason} を返す" do
      assert FizzBuzz.safe_generate_list(0) == {:error, "正の整数を指定してください"}
    end
  end
end
