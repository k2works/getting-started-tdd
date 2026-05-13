defmodule FizzBuzz.EagerVsLazy do
  def eager(limit) do
    1..limit
    |> Enum.map(&expensive_generate/1)
  end

  def lazy(limit) do
    1..limit
    |> Stream.map(&expensive_generate/1)
    |> Enum.take(5)
  end

  defp expensive_generate(number) do
    Process.sleep(1)

    cond do
      rem(number, 15) == 0 -> "FizzBuzz"
      rem(number, 3) == 0 -> "Fizz"
      rem(number, 5) == 0 -> "Buzz"
      true -> Integer.to_string(number)
    end
  end
end
