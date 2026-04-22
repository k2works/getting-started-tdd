# frozen_string_literal: true

require_relative 'domain/model/fizz_buzz_value'
require_relative 'domain/model/fizz_buzz_list'
require_relative 'domain/type/fizz_buzz_type'
require_relative 'domain/type/fizz_buzz_type_01'
require_relative 'domain/type/fizz_buzz_type_02'
require_relative 'domain/type/fizz_buzz_type_03'
require_relative 'domain/type/fizz_buzz_type_name'
require_relative 'application/fizz_buzz_command'
require_relative 'application/fizz_buzz_value_command'
require_relative 'application/fizz_buzz_list_command'

class FizzBuzz
  def self.generate(number)
    FizzBuzzType.create(FizzBuzzType::TYPE_01).generate(number).to_s
  end

  def self.generate_list
    (1..100).map { |number| generate(number) }
  end
end
