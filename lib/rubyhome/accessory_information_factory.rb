require_relative 'hap/accessory'
require_relative 'hap/characteristic'
require_relative 'hap/service'

module Rubyhome
  class AccessoryInformationFactory
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
        Service::AccessoryInformation
      end
    end

    def initialize(accessory: Rubyhome::Accessory.new, service: nil, **options)
      @accessory = accessory
      @service ||= self.class.service_class.new(accessory: accessory)
      @attributes = self.class.characteristics.map(&:attribute_name)
      options.slice(*attributes).each do |key, value|
        self.send("#{key}=", value)
      end
    end

    attr_reader :accessory, :attributes, :service

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
