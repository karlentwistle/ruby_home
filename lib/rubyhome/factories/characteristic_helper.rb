require_relative '../hap/characteristic'

module Rubyhome
  module CharacteristicHelper
    class << self
      def characteristics(service_class)
        required_characteristics(service_class) + optional_characteristics(service_class)
      end

      def required_characteristics(service_class)
        service_class.required_characteristic_uuids.map do |characteristic_uuid|
          Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
        end
      end

      def optional_characteristics(service_class)
        service_class.optional_characteristic_uuids.map do |characteristic_uuid|
          Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
        end
      end

      def define_characteristics(factory)
        characteristics(factory.service_class).each do |characteristic|
          define_characteristics_getter(factory, characteristic)
          define_characteristics_setter(factory, characteristic)
        end
      end

      def define_characteristics_getter(factory, characteristic)
        attribute_name = characteristic.attribute_name
        factory.define_method attribute_name do
          instance_variable_get("@#{attribute_name}") || send("#{attribute_name}=", nil)
        end
      end

      def define_characteristics_setter(factory, characteristic)
        attribute_name = characteristic.attribute_name
        factory.define_method "#{attribute_name}=" do |value|
          instance_variable_set(
            "@#{attribute_name}",
            characteristic.new(value: value, service: service)
          )
        end
      end
    end
  end
end
