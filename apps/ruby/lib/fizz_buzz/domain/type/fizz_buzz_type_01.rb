# frozen_string_literal: true

class FizzBuzzType01 < FizzBuzzType
  def generate(number)
    return FizzBuzzValue.new('FizzBuzz', number) if fizz?(number) && buzz?(number)
    return FizzBuzzValue.new('Fizz', number) if fizz?(number)
    return FizzBuzzValue.new('Buzz', number) if buzz?(number)

    FizzBuzzValue.new(number.to_s, number)
  end
end
