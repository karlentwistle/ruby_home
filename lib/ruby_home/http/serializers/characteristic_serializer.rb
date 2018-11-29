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
          if HIDDEN_VALUE_OBJECTS.include?(characteristic.value_object.class)
            {}
          else
            { 'value' => characteristic.value }.compact
          end
        end
    end
  end
end
