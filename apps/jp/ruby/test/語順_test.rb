# frozen_string_literal: true

require 'test_helper'
require '語順'

using FizzBuzz語順

describe '語順の再現' do
  it '3を FizzBuzz変換 すると Fizz を返す（後置呼び出し）' do
    _(3.FizzBuzz変換).must_equal 'Fizz'
  end

  it '3.を.FizzBuzz変換 と助詞を置いて書ける' do
    _(3.を.FizzBuzz変換).must_equal 'Fizz'
  end

  it '15を FizzBuzz変換して 装飾する' do
    _(15.FizzBuzz変換.装飾).must_equal '[FizzBuzz]'
  end
end
