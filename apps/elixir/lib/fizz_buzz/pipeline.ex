defmodule FizzBuzz.Pipeline do
  alias FizzBuzz.Functional

  def report(limit) do
    1..limit
    |> Enum.map(&Functional.generate/1)
    |> Enum.filter(&(&1 != "FizzBuzz"))
    |> Enum.join(",")
  end
end
