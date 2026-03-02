# frozen_string_literal: true

class FizzBuzzListCommand
  include FizzBuzzCommand

  def initialize(type, count = 100)
    @type = type
    @count = count
  end

  def execute
    list = (1..@count).map { |number| @type.generate(number) }
    FizzBuzzList.new(list)
  end
end
