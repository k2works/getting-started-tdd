# frozen_string_literal: true

class FizzBuzzType
  TYPE_01 = 1
  TYPE_02 = 2
  TYPE_03 = 3

  def self.create(type)
    case type
    when TYPE_01 then FizzBuzzType01.new
    when TYPE_02 then FizzBuzzType02.new
    when TYPE_03 then FizzBuzzType03.new
    else raise "未定義のタイプ: #{type}"
    end
  end

  def self.try_create(type)
    create(type)
  rescue RuntimeError
    nil
  end

  def fizz?(number)
    (number % 3).zero?
  end

  def buzz?(number)
    (number % 5).zero?
  end

  def generate(_number)
    raise NotImplementedError
  end
end

# rubocop:disable Style/OneClassPerFile
module FizzBuzzTypeName
  STANDARD = FizzBuzzType::TYPE_01
  NUMBER_ONLY = FizzBuzzType::TYPE_02
  FIZZ_BUZZ_ONLY = FizzBuzzType::TYPE_03
end
# rubocop:enable Style/OneClassPerFile
