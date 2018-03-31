require_relative 'characteristic_serializer'
require_relative 'object_serializer'

module RubyHome
  module HTTP
    class ServiceSerializer
      include ObjectSerializer

      def record_hash(service)
        {
          'iid' => service.instance_id,
          'type' => service.uuid,
          'characteristics' => CharacteristicSerializer.new(service.characteristics).serializable_hash,
          'primary' => service.primary,
          'hidden' => service.hidden,
        }
      end
    end
  end
end
