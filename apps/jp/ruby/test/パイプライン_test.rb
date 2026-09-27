# frozen_string_literal: true

require 'test_helper'
require 'パイプライン'

describe 'パイプライン' do
  include FizzBuzzパイプライン

  it '装飾すると角括弧で囲む' do
    _(装飾('Fizz')).must_equal '[Fizz]'
  end

  it '5までのパイプライン処理' do
    _(パイプライン処理(5)).must_equal %w[[1] [2] [Fizz] [4] [Buzz]]
  end
end
