require_relative "base_value"

module RubyHome
  class Int32Value < BaseValue
    def default
      minimum_value.to_i
    end

    private

    def minimum_value
      template.constraints.fetch("MinimumValue")
    end
  end
end
