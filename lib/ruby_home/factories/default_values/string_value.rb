require_relative 'base_value'

module RubyHome
  class StringDefaultValue < BaseValue
    DEFAULT_VALUES = {
      firmware_revision: '1.0',
      hardware_revision: '1.0',
      manufacturer: 'Default-Manufacturer',
      model: 'Default-Model',
      name: 'RubyHome',
      serial_number: 'Default-SerialNumber',
      version: '1.0',
    }.freeze

    def default
      DEFAULT_VALUES[name]
    end

    private

      def name
        template.name
      end
  end
end
