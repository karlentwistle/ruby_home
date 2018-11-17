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
        template.constraints.fetch('ValidValues')
      end
  end
end
