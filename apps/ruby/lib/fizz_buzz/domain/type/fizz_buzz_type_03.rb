# frozen_string_literal: true

class FizzBuzzType03 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new('FizzBuzz', number) if fizz?(number) && buzz?(number)

    FizzBuzzValue.new(number.to_s, number)
  end
end
