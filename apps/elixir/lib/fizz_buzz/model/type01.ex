defmodule FizzBuzz.Model.Type01 do
  @enforce_keys [:value]
  defstruct [:value]
end

defimpl FizzBuzz.Generatable, for: FizzBuzz.Model.Type01 do
  def generate(%FizzBuzz.Model.Type01{value: value}), do: Integer.to_string(value.number)
end
