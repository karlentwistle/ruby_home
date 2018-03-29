require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class CharacteristicFactory
    YAML_STORE_PATH = (File.dirname(__FILE__) + '/../config/characteristics.yml').freeze
    HAP_CHARACTERISTICS = YAML.load_file(YAML_STORE_PATH).freeze
    DEFAULT_VALUES = {
      firmware_revision: '1.0',
      identify: nil,
      manufacturer: 'Default-Manufacturer',
      model: 'Default-Model',
      name: 'Rubyhome',
      serial_number: 'Default-SerialNumber',
    }.freeze

    def self.find_hap_characteristic(attributes)
      HAP_CHARACTERISTICS.find do |characteristic|
        attributes.all? do |key, value|
          characteristic[key] == value
        end
      end
    end

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

      def hap_characteristic
        HAP_CHARACTERISTICS.find { |characteristic| characteristic[:name].to_sym == characteristic_name.to_sym }
      end

      def characteristic
        @characteristic ||= Characteristic.new(characteristic_params)
      end

      def characteristic_params
        options[:value] ||= default_value
        options.merge(hap_characteristic)
      end

      def default_value
        DEFAULT_VALUES.fetch(characteristic_name.to_sym) do
          case hap_characteristic[:format]
          when 'bool'
            false
          end
        end
      end
  end
end
