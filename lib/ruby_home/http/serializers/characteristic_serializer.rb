require_relative 'object_serializer'

module RubyHome
  module HTTP
    class CharacteristicSerializer
      include ObjectSerializer

      def record_hash(characteristic)
        {
          'iid' => characteristic.instance_id,
          'type' => characteristic.uuid,
          'perms' => perms(characteristic),
          'format' => characteristic.format,
          'description' => characteristic.description,
        }.merge(optional_hash(characteristic))
      end

      def perms(characteristic)
        characteristic.properties.map do |property|
          RubyHome::Characteristic::PROPERTIES[property]
        end.compact
      end

      def optional_hash(characteristic)
        Hash.new.tap do |optional_hash|
          if characteristic.value != nil
            optional_hash['value'] = characteristic.value
          end
        end
      end
    end
  end
end
