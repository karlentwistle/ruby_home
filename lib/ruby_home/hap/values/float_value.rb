require_relative "base_value"

module RubyHome
  class FloatValue < BaseValue
    def default
      minimum_value.to_f
    end

    private

    def minimum_value
      template.constraints.fetch("MinimumValue", 0)
    end
  end
end
