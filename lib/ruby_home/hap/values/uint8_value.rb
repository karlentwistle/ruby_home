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
        defined_values || range_values || raise(UnknownValueError, "Constraint contains an unrecognized list of values: #{template.constraints.inspect }")
      end

      def defined_values
        template.constraints.dig('ValidValues')
      end

      def range_values
        if min = template.constraints.dig('MinimumValue')
          { min.to_s => min }
        end
      end
  end
end
