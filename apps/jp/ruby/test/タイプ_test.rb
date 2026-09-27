# frozen_string_literal: true

require 'test_helper'
require 'タイプ'

describe 'タイプ生成' do
  include FizzBuzzタイプ

  it 'タイプ1は通常の変換をする' do
    タイプ = タイプ生成(1)
    _(タイプ変換(タイプ, 3)).must_equal 'Fizz'
    _(タイプ.名前).must_equal '通常'
  end

  it 'タイプ2は数字だけを返す' do
    タイプ = タイプ生成(2)
    _(タイプ変換(タイプ, 3)).must_equal '3'
    _(タイプ.名前).must_equal '数字限定'
  end

  it 'タイプ3は15の倍数だけFizzBuzzを返す' do
    _(タイプ変換(タイプ生成(3), 15)).must_equal 'FizzBuzz'
  end

  it 'タイプ3は3の倍数を数字で返す' do
    _(タイプ変換(タイプ生成(3), 3)).must_equal '3'
  end

  it '存在しないタイプはエラーになる' do
    エラー = _ { タイプ生成(4) }.must_raise ArgumentError
    _(エラー.message).must_equal '該当するタイプは存在しません: 4'
  end
end
