defprotocol FizzBuzz.Generatable do
  @spec generate(t()) :: String.t()
  def generate(value)
end
