# frozen_string_literal: true

class FizzBuzzListCommand
  include FizzBuzzCommand

  def initialize(type, count = 100)
    @type = type
    @count = count
  end

  def execute
    (1..@count)
      .map { |number| @type.generate(number) }
      .then { |list| FizzBuzzList.new(list) }
  end
end
