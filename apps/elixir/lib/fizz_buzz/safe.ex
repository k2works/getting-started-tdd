defmodule FizzBuzz.Safe do
  def safe_generate(number) when is_integer(number) and number > 0 do
    {:ok, generate(number)}
  end

  def safe_generate(number) when is_integer(number) do
    {:error, :non_positive}
  end

  def safe_generate(_), do: {:error, :not_integer}

  defp generate(number) when rem(number, 15) == 0, do: "FizzBuzz"
  defp generate(number) when rem(number, 3) == 0, do: "Fizz"
  defp generate(number) when rem(number, 5) == 0, do: "Buzz"
  defp generate(number), do: Integer.to_string(number)
end
