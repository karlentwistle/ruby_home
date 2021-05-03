require_relative "object_serializer"
require_relative "uuid_helper"

module RubyHome
  module HTTP
    class CharacteristicSerializer
      include ObjectSerializer
      include UUIDHelper

      def record_hash(characteristic)
        {
          "iid" => characteristic.instance_id,
          "type" => uuid_short_form(characteristic.uuid),
          "perms" => perms(characteristic),
          "format" => characteristic.format,
          "description" => characteristic.description
        }
          .merge(value_hash(characteristic))
          .merge(valid_values_hash(characteristic))
      end

      private

      def perms(characteristic)
        characteristic.properties.map do |property|
          RubyHome::Characteristic::PROPERTIES[property]
        end.compact
      end

      def value_hash(characteristic)
        if characteristic.properties.include?("read")
          {"value" => characteristic.value}
        else
          {}
        end
      end

      def valid_values_hash(characteristic)
        if characteristic.valid_values.empty?
          {}
        else
          {"valid-values" => characteristic.valid_values}
        end
      end
    end
  end
end
