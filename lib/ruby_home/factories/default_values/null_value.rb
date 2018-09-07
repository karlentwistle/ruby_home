require_relative 'base_value'

module RubyHome
  class NullDefaultValue < BaseValue
    def default
      nil
    end
  end
end
