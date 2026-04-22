# frozen_string_literal: true

class FizzBuzzValueCommand
  include FizzBuzzCommand

  def initialize(type, number)
    @type = type
    @number = number
  end

  def execute
    @type.generate(@number)
  end
end
