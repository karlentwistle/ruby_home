require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class AccessoryFactory
    YAML_STORE_PATH = (File.dirname(__FILE__) + '/../config/services.yml').freeze
    HAP_SERVICES = YAML.load_file(YAML_STORE_PATH).freeze

    def self.create(service_name, characteristics: {}, **options)
      new(service_name, options, characteristics).create
    end

    def initialize(service_name, accessory_options, characteristic_options)
      @service_name = service_name
      @accessory_options = accessory_options
      @characteristic_options = characteristic_options
    end

    def create
      yield service if block_given?

      create_accessory_information
      service.save
      create_required_characteristics
      create_optional_characteristics

      service
    end

    private

      attr_reader :service_name, :accessory_options, :characteristic_options

      def hap_service
        HAP_SERVICES.find { |service| service[:name].to_sym == service_name.to_sym }
      end

      def create_accessory_information
        unless service_name == :accessory_information
          AccessoryFactory.create(:accessory_information, accessory_information_params)
        end
      end

      def accessory_information_params
        accessory_options.merge(accessory: service.accessory)
      end

      def create_required_characteristics
        hap_service[:required_characteristics].map do |characteristic_uuid|
          hap_characteristic = CharacteristicFactory.find_hap_characteristic(uuid: characteristic_uuid)

          CharacteristicFactory.create(hap_characteristic[:name], service: service) do |characteristic|
            if value = characteristic_options[characteristic.name]
              characteristic.value = value
            end
          end
        end
      end

      def create_optional_characteristics
        hap_service[:optional_characteristics].map do |characteristic_uuid|
          hap_characteristic = CharacteristicFactory.find_hap_characteristic(uuid: characteristic_uuid)
          if value = characteristic_options[hap_characteristic[:name]]
            CharacteristicFactory.create(hap_characteristic[:name], service: service) do |characteristic|
              characteristic.value = value
            end
          end
        end
      end

      def service
        @service ||= Service.new(service_params)
      end

      def service_params
        accessory_options[:accessory] ||= Rubyhome::Accessory.new
        accessory_options.merge(hap_service)
      end
  end
end
