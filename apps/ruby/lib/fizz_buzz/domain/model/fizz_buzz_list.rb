# frozen_string_literal: true

class FizzBuzzList
  MAX_COUNT = 100

  include Enumerable

  attr_reader :value

  def initialize(list = [])
    raise "上限は#{MAX_COUNT}件までです" if list.count > MAX_COUNT

    @value = list.dup.freeze
  end

  def add(other_list)
    FizzBuzzList.new(@value + other_list)
  end

  def size
    @value.size
  end

  def to_string_array
    @value.map(&:to_s)
  end

  def each(&)
    @value.each(&)
  end
end
