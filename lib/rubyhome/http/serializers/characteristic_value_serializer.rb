require_relative 'object_serializer'

module Rubyhome
  module HTTP
    class CharacteristicValueSerializer
      include ObjectSerializer

      def root
        'characteristics'
      end

      def record_hash(characteristic)
        {
          'aid' => characteristic.accessory_id,
          'iid' => characteristic.instance_id,
          'value' => characteristic.value,
        }
      end
    end
  end
end
