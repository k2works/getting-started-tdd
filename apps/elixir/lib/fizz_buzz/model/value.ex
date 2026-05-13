defmodule FizzBuzz.Model.Value do
  @enforce_keys [:number]
  defstruct [:number]

  @type t :: %__MODULE__{
          number: pos_integer()
        }
end
