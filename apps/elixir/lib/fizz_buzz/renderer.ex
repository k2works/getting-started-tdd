defmodule FizzBuzz.Renderer do
  def from_result(result) do
    case result do
      {:ok, value} -> "ok: #{value}"
      {:error, reason} -> "error: #{reason}"
    end
  end

  def classify(number) do
    cond do
      rem(number, 15) == 0 -> :fizz_buzz
      rem(number, 3) == 0 -> :fizz
      rem(number, 5) == 0 -> :buzz
      true -> :number
    end
  end
end
