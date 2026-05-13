defmodule FizzBuzz.Functional do
  def generate(number) when rem(number, 15) == 0, do: "FizzBuzz"
  def generate(number) when rem(number, 3) == 0, do: "Fizz"
  def generate(number) when rem(number, 5) == 0, do: "Buzz"
  def generate(number), do: Integer.to_string(number)

  def generate_list(limit) do
    1..limit
    |> Enum.map(&generate/1)
  end

  def count_fizzbuzz(limit) do
    1..limit
    |> Enum.map(&generate/1)
    |> Enum.filter(&(&1 in ["Fizz", "Buzz", "FizzBuzz"]))
    |> Enum.count()
  end

  def summary(limit) do
    1..limit
    |> Enum.map(&generate/1)
    |> Enum.reduce(%{fizz: 0, buzz: 0, fizzbuzz: 0, number: 0}, fn value, acc ->
      case value do
        "Fizz" -> %{acc | fizz: acc.fizz + 1}
        "Buzz" -> %{acc | buzz: acc.buzz + 1}
        "FizzBuzz" -> %{acc | fizzbuzz: acc.fizzbuzz + 1}
        _ -> %{acc | number: acc.number + 1}
      end
    end)
  end
end
