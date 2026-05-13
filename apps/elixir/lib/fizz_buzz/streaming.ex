defmodule FizzBuzz.Streaming do
  def generate(number) when rem(number, 15) == 0, do: "FizzBuzz"
  def generate(number) when rem(number, 3) == 0, do: "Fizz"
  def generate(number) when rem(number, 5) == 0, do: "Buzz"
  def generate(number), do: Integer.to_string(number)

  def lazy_stream do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(&generate/1)
  end
end
