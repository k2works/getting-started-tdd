# frozen_string_literal: true

class FizzBuzz
  def self.generate(number)
    return 'FizzBuzz' if (number % 15).zero?
    return 'Fizz' if (number % 3).zero?
    return 'Buzz' if (number % 5).zero?

    number.to_s
  end

  def self.generate_list
    (1..100).map { |n| generate(n) }
  end
end
