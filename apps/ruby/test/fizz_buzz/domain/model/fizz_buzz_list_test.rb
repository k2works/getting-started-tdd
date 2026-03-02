# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../lib/fizz_buzz/fizz_buzz'

class FizzBuzzListTest < Minitest::Test
  def test_空リストを生成できる
    list = FizzBuzzList.new
    assert_equal 0, list.size
  end

  def test_addで新しいリストを返す
    list = FizzBuzzList.new
    values = [FizzBuzzValue.new('1', 1)]
    new_list = list.add(values)
    assert_equal 0, list.size
    assert_equal 1, new_list.size
  end

  def test_to_string_arrayで文字列配列を返す
    values = [
      FizzBuzzValue.new('1', 1),
      FizzBuzzValue.new('2', 2),
      FizzBuzzValue.new('Fizz', 3)
    ]
    list = FizzBuzzList.new(values)
    assert_equal %w[1 2 Fizz], list.to_string_array
  end

  def test_上限を超えるとエラー
    values = (1..101).map { |number| FizzBuzzValue.new(number.to_s, number) }
    assert_raises RuntimeError do
      FizzBuzzList.new(values)
    end
  end

  def test_select_typeでFizzBuzzListを返す
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.select_type { |v| v.value == 'Fizz' }
    assert_instance_of FizzBuzzList, result
    assert_equal 4, result.size
  end

  def test_reject_typeでFizzBuzzListを返す
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.reject_type { |v| v.value == 'Fizz' }
    assert_instance_of FizzBuzzList, result
    assert_equal 11, result.size
  end

  def test_take_valuesで先頭N件を返す
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.take_values(3)
    assert_instance_of FizzBuzzList, result
    assert_equal 3, result.size
  end

  def test_group_by_valueで値ごとにグループ化
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.group_by_value
    assert_instance_of Hash, result
    assert result.key?('Fizz')
    assert result.key?('Buzz')
    assert result.key?('FizzBuzz')
  end

  def test_tally_by_valueで値ごとの件数を返す
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.tally_by_value
    assert_equal 1, result['FizzBuzz']
    assert_equal 4, result['Fizz']
    assert_equal 2, result['Buzz']
  end

  def test_join_valuesで文字列結合
    values = [
      FizzBuzzValue.new('1', 1),
      FizzBuzzValue.new('2', 2),
      FizzBuzzValue.new('Fizz', 3)
    ]
    list = FizzBuzzList.new(values)
    assert_equal '1, 2, Fizz', list.join_values
  end

  def test_find_valueで条件に合う最初の要素を返す
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    result = list.find_value { |v| v.value == 'Buzz' }
    assert_equal 'Buzz', result.value
    assert_equal 5, result.number
  end

  def test_any_matchで条件に合う要素が存在するか
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    assert(list.any_match? { |v| v.value == 'FizzBuzz' })
    refute(list.any_match? { |v| v.value == 'Unknown' })
  end

  def test_all_matchで全要素が条件を満たすか
    type = FizzBuzzType.create(FizzBuzzType::TYPE_02)
    command = FizzBuzzListCommand.new(type, 15)
    list = command.execute
    assert(list.all_match? { |v| v.number.positive? })
    refute(list.all_match? { |v| v.value == 'Fizz' })
  end
end
