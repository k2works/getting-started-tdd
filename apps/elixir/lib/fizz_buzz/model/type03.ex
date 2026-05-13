defmodule FizzBuzz.Model.Type03 do
  @enforce_keys [:value]
  defstruct [:value]
end

defimpl FizzBuzz.Generatable, for: FizzBuzz.Model.Type03 do
  def generate(%FizzBuzz.Model.Type03{}), do: "Buzz"
end
