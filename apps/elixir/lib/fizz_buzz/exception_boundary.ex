defmodule FizzBuzz.ExceptionBoundary do
  alias FizzBuzz.Safe

  def parse_and_generate(text) do
    with {number, ""} <- Integer.parse(text),
         {:ok, value} <- Safe.safe_generate(number) do
      {:ok, value}
    else
      :error -> {:error, :parse_error}
      {:error, reason} -> {:error, reason}
    end
  end

  def parse_with_rescue(text) do
    try do
      number = String.to_integer(text)
      Safe.safe_generate(number)
    rescue
      ArgumentError -> {:error, :parse_error}
    end
  end
end
