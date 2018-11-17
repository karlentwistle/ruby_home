require_relative 'base_value'

module RubyHome
  class NullValue < BaseValue
    def value
      nil
    end

    def value=(new_value)
      nil
    end

    def default
      nil
    end
  end
end
