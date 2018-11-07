require_relative 'characteristic_serializer'
require_relative 'object_serializer'
require_relative 'uuid_helper'

module RubyHome
  module HTTP
    class ServiceSerializer
      include ObjectSerializer
      include UUIDHelper

      def record_hash(service)
        {
          'iid' => service.instance_id,
          'type' => uuid_short_form(service.uuid),
          'characteristics' => CharacteristicSerializer.new(service.characteristics).serializable_hash,
          'primary' => service.primary,
          'hidden' => service.hidden,
        }
      end
    end
  end
end
