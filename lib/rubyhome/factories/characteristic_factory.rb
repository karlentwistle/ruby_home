require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class CharacteristicFactory
    DEFAULT_VALUES = {
      firmware_revision: '1.0',
      identify: nil,
      manufacturer: 'Default-Manufacturer',
      model: 'Default-Model',
      name: 'Rubyhome',
      serial_number: 'Default-SerialNumber',
    }.freeze

    def self.create(characteristic_name, options={}, &block)
      new(characteristic_name, options).create(&block)
    end

    def initialize(characteristic_name, options)
      @characteristic_name = characteristic_name
      @options = options
    end

    def create
      yield characteristic if block_given?

      characteristic.save
      characteristic
    end

    private

      attr_reader :characteristic_name, :options

      def characteristic_class
        @characteristic_class ||= Characteristic.descendants.find do |characteristic|
          characteristic.name == characteristic_name
        end
      end

      def characteristic
        @characteristic ||= characteristic_class.new(characteristic_params)
      end

      def characteristic_params
        options[:value] ||= default_value
        options
      end

      def default_value
        DEFAULT_VALUES.fetch(characteristic_name) do
          case characteristic_class.format
          when 'bool'
            false
          end
        end
      end
  end
end
