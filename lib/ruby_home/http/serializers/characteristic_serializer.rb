require_relative 'object_serializer'

module RubyHome
  module HTTP
    class CharacteristicSerializer
      include ObjectSerializer

      def record_hash(characteristic)
        record_hash = {}

        record_hash['iid'] = characteristic.instance_id
        record_hash['type'] = characteristic.uuid
        record_hash['perms'] = characteristic.properties.map do |property|
          RubyHome::Characteristic::PROPERTIES[property]
        end.compact
        record_hash['format'] = characteristic.format
        if characteristic.value != nil
          record_hash['value'] = characteristic.value
        end
        record_hash['description'] = characteristic.description

        record_hash
      end
    end
  end
end
