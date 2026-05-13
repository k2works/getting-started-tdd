defmodule FizzBuzz.Validator do
  def validate(number) when is_integer(number) and number > 0, do: {:ok, number}
  def validate(number) when is_integer(number), do: {:error, :non_positive}
  def validate(_), do: {:error, :not_integer}
end
