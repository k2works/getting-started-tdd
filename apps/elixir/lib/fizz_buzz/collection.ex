defmodule FizzBuzz.Collection do
  def transform(values, mapper) when is_function(mapper, 1) do
    Enum.map(values, mapper)
  end

  def filter(values, predicate) when is_function(predicate, 1) do
    Enum.filter(values, predicate)
  end
end
