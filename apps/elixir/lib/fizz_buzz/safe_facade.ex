defmodule FizzBuzz.SafeFacade do
  alias FizzBuzz.Safe

  def safe_generate_message(input) do
    case Safe.safe_generate(input) do
      {:ok, value} -> "result: #{value}"
      {:error, reason} -> "error: #{reason}"
    end
  end
end
