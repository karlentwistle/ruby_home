require_relative 'hap/accessory'
require_relative 'hap/characteristic'
require_relative 'hap/service'

module Rubyhome
  class FanFactory
    class << self
      def characteristics
        required_characteristics + optional_characteristics
      end

      def required_characteristics
        service_class.required_characteristic_uuids.map do |characteristic_uuid|
          Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
        end
      end

      def optional_characteristics
        service_class.optional_characteristic_uuids.map do |characteristic_uuid|
          Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
        end
      end

      def service_class
        Service::Fan
      end
    end

    def initialize(accessory: Rubyhome::Accessory.new, **options)
      @accessory = accessory
      @accessory_information = AccessoryInformationFactory.new(accessory: accessory, service: service, **options)
      @attributes = self.class.characteristics.map(&:attribute_name)
      options.slice(*attributes).each do |key, value|
        self.send("#{key}=", value)
      end
    end

    attr_reader :accessory, :attributes, :accessory_information

    def service
      @service ||= self.class.service_class.new(accessory: accessory)
    end

    characteristics.each do |characteristic|
      define_method characteristic.attribute_name do
        instance_variable_get("@#{characteristic.attribute_name}") || characteristic.new(service: service)
      end

      define_method "#{characteristic.attribute_name}=" do |value|
        instance_variable_set(
          "@#{characteristic.attribute_name}",
          characteristic.new(value: value, service: service)
        )
      end
    end

    def characteristics
      attributes.map { |attribute| send(attribute) }
    end

    def save
      accessory_information.save

      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_service(service)

      characteristics.compact.each do |characteristic|
        if characteristic.valid?
          IdentifierCache.add_characteristic(characteristic)
        end
      end
    end
  end
end

