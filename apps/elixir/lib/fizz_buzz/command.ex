defmodule FizzBuzz.Command do
  @callback run(input :: term()) :: {:ok, term()} | {:error, atom()}
end
