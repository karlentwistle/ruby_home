require_relative 'base_value'

module RubyHome
  class Uint8Value < BaseValue
    def default
      first_default_value.to_i
    end

    private

      def first_default_value
        valid_values.keys.first
      end

      def valid_values
        defined_values || range_values
      end

      def defined_values
        template.constraints.dig('ValidValues')
      end

      def range_values
        values = {}
        min = template.constraints.dig('MinimumValue')
        max = template.constraints.dig('MaximumValue')
        step = template.constraints.dig('StepValue')

        (min..max).step(step) do |n|
          values[n.to_s] = n.to_s
        end

        values
      end
  end
end
