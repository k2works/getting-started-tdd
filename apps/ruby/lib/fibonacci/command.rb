# frozen_string_literal: true

module Fibonacci
  class Command
    def initialize(algorithm)
      @algorithm = algorithm
    end

    def exec(number)
      @algorithm.exec(number)
    end
  end
end
