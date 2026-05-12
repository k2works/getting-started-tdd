defmodule FizzBuzz do
  def generate(n) do
    cond do
      rem(n, 15) == 0 -> "FizzBuzz"
      rem(n, 3) == 0  -> "Fizz"
      rem(n, 5) == 0  -> "Buzz"
      true            -> Integer.to_string(n)
    end
  end

  def generate_list do
    1..100
    |> Enum.map(&generate/1)
  end
end
