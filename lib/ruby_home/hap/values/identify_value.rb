require_relative 'base_value'

module RubyHome
  class IdentifyValue < BaseValue
    def value
      true
    end

    def value=(new_value)
      nil
    end
  end
end
