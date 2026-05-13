defmodule FizzBuzz.Model.Type02 do
  @enforce_keys [:value]
  defstruct [:value]
end

defimpl FizzBuzz.Generatable, for: FizzBuzz.Model.Type02 do
  def generate(%FizzBuzz.Model.Type02{}), do: "Fizz"
end
