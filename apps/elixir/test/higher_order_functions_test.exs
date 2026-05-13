defmodule FizzBuzz.HigherOrderFunctionsTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.{Collection, CustomRule, Functional}

  test "Enum.map で FizzBuzz の一覧を生成できる" do
    assert Functional.generate_list(5) == ["1", "2", "Fizz", "4", "Buzz"]
  end

  test "Enum.filter と Enum.count で Fizz/Buzz 系だけ数えられる" do
    assert Functional.count_fizzbuzz(15) == 7
  end

  test "Enum.reduce で種別ごとの集計ができる" do
    assert Functional.summary(15) == %{fizz: 4, buzz: 2, fizzbuzz: 1, number: 8}
  end

  test "generate_with/2 は単一ルール関数を受け取れる" do
    even_rule = fn n -> if rem(n, 2) == 0, do: "Even", else: nil end

    assert CustomRule.generate_with(4, even_rule) == "Even"
    assert CustomRule.generate_with(3, even_rule) == "3"
  end

  test "generate_with/2 はルール関数リストを順に適用する" do
    rules = [
      fn n -> if rem(n, 7) == 0, do: "Pop", else: nil end,
      fn n -> if rem(n, 3) == 0, do: "Fizz", else: nil end
    ]

    assert CustomRule.generate_with(14, rules) == "Pop"
    assert CustomRule.generate_with(9, rules) == "Fizz"
    assert CustomRule.generate_with(2, rules) == "2"
  end

  test "transform/2 と filter/2 を組み合わせて再利用できる" do
    values = 1..6 |> Enum.to_list()

    assert values
           |> Collection.transform(&(&1 * 10))
           |> Collection.filter(&(&1 > 30)) == [40, 50, 60]
  end
end
