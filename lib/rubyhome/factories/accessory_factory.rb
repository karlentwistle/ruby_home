require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class AccessoryFactory
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

      def create_accessory_information
        unless service_name == :accessory_information
          AccessoryFactory.create(:accessory_information, accessory_information_params)
        end
      end

      def accessory_information_params
        accessory_options.merge(accessory: service.accessory)
      end

      def create_required_characteristics
        service_class.required_characteristics.map do |characteristic|
          CharacteristicFactory.create(characteristic.name, service: service) do |characteristic|
            if value = characteristic_options[characteristic.name]
              characteristic.value = value
            end
          end
        end
      end

      def create_optional_characteristics
        service_class.optional_characteristics.map do |characteristic|
          if value = characteristic_options[characteristic.name]
            CharacteristicFactory.create(characteristic.name, service: service) do |characteristic|
              characteristic.value = value
            end
          end
        end
      end

      def service_class
        service_class ||= Service.descendants.find do |service|
          service.name == service_name
        end
      end

      def service
        @service ||= service_class.new(service_params)
      end

      def service_params
        accessory_options[:accessory] ||= Rubyhome::Accessory.new
        accessory_options
      end
  end
end
