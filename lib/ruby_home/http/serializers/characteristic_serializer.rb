require_relative 'object_serializer'
require_relative 'uuid_helper'

module RubyHome
  module HTTP
    class CharacteristicSerializer
      include ObjectSerializer
      include UUIDHelper

      def record_hash(characteristic)
        {
          'iid' => characteristic.instance_id,
          'type' => uuid_short_form(characteristic.uuid),
          'perms' => perms(characteristic),
          'format' => characteristic.format,
          'description' => characteristic.description,
        }.merge(value_hash(characteristic))
      end

      private

        HIDDEN_VALUE_OBJECTS = [ IdentifyValue ].freeze

        def perms(characteristic)
          characteristic.properties.map do |property|
            RubyHome::Characteristic::PROPERTIES[property]
          end.compact
        end

        def value_hash(characteristic)
          valid_values = characteristic.valid_values || {}
          valid_values = { 'valid-values' => valid_values} if valid_values.is_a?(Array)
          
          if HIDDEN_VALUE_OBJECTS.include?(characteristic.value_object.class) || !characteristic.properties.include?("read")
            valid_values
          else
            valid_values.merge({'value' => characteristic.value}.compact)
          end
        end
    end
  end
end
