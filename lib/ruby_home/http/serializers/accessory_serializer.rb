require_relative "object_serializer"
require_relative "service_serializer"

module RubyHome
  module HTTP
    class AccessorySerializer
      include ObjectSerializer

      def root
        "accessories"
      end

      def record_hash(accessory)
        {
          "aid" => accessory.id,
          "services" => ServiceSerializer.new(accessory.services).serializable_hash
        }
      end
    end
  end
end
