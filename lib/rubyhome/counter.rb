require "singleton"

module Rubyhome
  class Counter
    def initialize
      @count = 0
    end

    attr_reader :count

    def increment(value=1)
      @count += value
    end
  end
end
