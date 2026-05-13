defmodule FizzBuzz.Anonymous do
  def multiply_all(numbers, factor) do
    Enum.map(numbers, fn n -> n * factor end)
  end

  def square_all(numbers) do
    Enum.map(numbers, &(&1 * &1))
  end

  def stringify(numbers) do
    Enum.map(numbers, &Integer.to_string/1)
  end
end
