require_relative 'characteristic_serializer'
require_relative 'object_serializer'
require_relative 'uuid_helper'

module RubyHome
  module HTTP
    class ServiceSerializer
      include ObjectSerializer
      include UUIDHelper

      def record_hash(service)
        characteristics = service.characteristics.select do |c|
          c.properties.include?("read") || !c.valid_values.nil?
        end
        
        result = {
          'iid' => service.instance_id,
          'type' => uuid_short_form(service.uuid),
          'characteristics' => CharacteristicSerializer.new(characteristics).serializable_hash,
          'primary' => service.primary,
          'hidden' => service.hidden,
        }
        
        linked = service.linked
        if linked.nil? || linked.empty?
          result
        else
          result.merge({'linked' => linked.map { |s| s.instance_id }})
        end
      end
    end
  end
end
