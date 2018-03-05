require 'oj'
require_relative 'service_serializer'

module Rubyhome
  module HTTP
    class AccessorySerializer
      include ObjectSerializer

      def root
        "accessories"
      end

      def record_hash(accessory)
        {
          'aid' => accessory.id,
          'services' => ServiceSerializer.new(accessory.services).serializable_hash,
        }
      end
    end
  end
end
