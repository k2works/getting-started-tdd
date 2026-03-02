# frozen_string_literal: true

class FizzBuzzValue
  attr_reader :value, :number

  def initialize(value, number)
    raise ArgumentError, '値は正の値のみ許可します' if number.negative?

    @value = value
    @number = number
  end

  def ==(other)
    other.is_a?(FizzBuzzValue) && value == other.value && number == other.number
  end

  def eql?(other)
    self == other
  end

  def hash
    [value, number].hash
  end

  def to_s
    value
  end

  def deconstruct_keys(_keys)
    { value: @value, number: @number }
  end
end
