module RubyHome
  class CharacteristicFactory
    DEFAULT_VALUES = {
      identify: nil,
    }.freeze

    def self.create(characteristic_name, service: , subtype: 'default' , value: nil)
      new(
        characteristic_name: characteristic_name,
        service: service,
        subtype: subtype,
        value: value
      ).create
    end

    def create
      characteristic = Characteristic.new(
        description: template.description,
        format: template.format,
        name: characteristic_name,
        properties: template.properties,
        service: service,
        unit: template.unit,
        uuid: template.uuid,
        value: value
      )

      if persisted_characteristic
        characteristic.instance_id = persisted_characteristic.instance_id
      else
        characteristic.instance_id = accessory.next_available_instance_id
        persist_characteristic(characteristic)
      end

      service.characteristics << characteristic

      characteristic
    end

    private

      def initialize(characteristic_name:, service:, subtype:, value:)
        @characteristic_name = characteristic_name.to_sym
        @service = service
        @subtype = subtype
        @value = value || default_value
      end

      attr_reader :service, :characteristic_name, :value, :subtype

      delegate :accessory, to: :service

      def template
        @template ||= CharacteristicTemplate.find_by(name: characteristic_name)
      end

      def default_value
        DEFAULT_VALUES.fetch(characteristic_name.to_sym) do
          klass = "RubyHome::#{template.format.classify}DefaultValue".safe_constantize || NullDefaultValue
          default_value = klass.new(template).default

          if default_value.nil?
            raise "No default value available for characteristic: #{characteristic_name} of type: #{template.format}"
          else
            default_value
          end
        end
      end

      def persisted_characteristic
        IdentifierCache.find_by(
          accessory_id: service.accessory_id,
          service_uuid: service.uuid,
          uuid: template.uuid,
          subtype: subtype
        )
      end

      def persist_characteristic(characteristic)
        IdentifierCache.create(
          accessory_id: characteristic.accessory_id,
          instance_id: characteristic.instance_id,
          service_uuid: service.uuid,
          uuid: characteristic.uuid,
          subtype: subtype
        )
      end
  end
end
