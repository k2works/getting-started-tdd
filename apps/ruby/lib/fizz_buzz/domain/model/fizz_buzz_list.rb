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
    FizzBuzzList.new(value + other_list)
  end

  def size
    value.size
  end

  def to_string_array
    value.map(&:to_s)
  end

  def select_type(&)
    FizzBuzzList.new(value.select(&))
  end

  def reject_type(&)
    FizzBuzzList.new(value.reject(&))
  end

  def map_type(&)
    FizzBuzzList.new(value.map(&))
  end

  def group_by_value
    value.group_by(&:value)
  end

  def tally_by_value
    value.map(&:value).tally
  end

  def take_values(count)
    FizzBuzzList.new(value.take(count))
  end

  def join_values(separator = ', ')
    value.join(separator)
  end

  def find_value(&)
    value.find(&)
  end

  def any_match?(&)
    value.any?(&)
  end

  def all_match?(&)
    value.all?(&)
  end

  def each(&)
    value.each(&)
  end
end
