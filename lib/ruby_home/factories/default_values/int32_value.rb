require_relative 'base_value'

module RubyHome
  class Int32DefaultValue < BaseValue
    def default
      minimum_value.to_i
    end

    private

      def minimum_value
        template.constraints.fetch('MinimumValue')
      end
  end
end
