require_relative 'base_value'

module RubyHome
  class BoolDefaultValue < BaseValue
    def default
      false
    end
  end
end
