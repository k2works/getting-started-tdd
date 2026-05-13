defmodule FizzBuzz.Factory do
  alias FizzBuzz.Model.{Type01, Type02, Type03, Value}

  def create(1), do: %Type01{value: %Value{number: 1}}
  def create(2), do: %Type01{value: %Value{number: 2}}
  def create(3), do: %Type02{value: %Value{number: 3}}
  def create(5), do: %Type03{value: %Value{number: 5}}
  def create(_), do: :unsupported
end
