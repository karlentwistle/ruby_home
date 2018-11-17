require_relative 'base_value'

module RubyHome
  class BoolValue < BaseValue
    REMAPPED_VALUES = {
      '0' => false,
      0 => false,
      '1' => true,
      1 => true,
    }.freeze

    def default
      false
    end

    def value=(new_value)
      @value = REMAPPED_VALUES.fetch(new_value, new_value)
    end
  end
end
