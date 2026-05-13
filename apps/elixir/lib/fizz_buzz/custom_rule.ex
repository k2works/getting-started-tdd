defmodule FizzBuzz.CustomRule do
  def generate_with(number, rule_fn) when is_function(rule_fn, 1) do
    case rule_fn.(number) do
      nil -> Integer.to_string(number)
      value -> value
    end
  end

  def generate_with(number, rule_fns) when is_list(rule_fns) do
    result =
      Enum.reduce_while(rule_fns, nil, fn rule_fn, _acc ->
        case rule_fn.(number) do
          nil -> {:cont, nil}
          value -> {:halt, value}
        end
      end)

    result || Integer.to_string(number)
  end
end
