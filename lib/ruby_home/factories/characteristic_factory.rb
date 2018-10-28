module RubyHome
  class CharacteristicFactory
    DEFAULT_VALUES = {
      identify: nil,
    }.freeze

    def self.create(characteristic_name, service: , value: nil)
      new(
        characteristic_name: characteristic_name,
        service: service,
        value: value
      ).create
    end

    def create
      service.characteristics << new_characteristic

      new_characteristic
    end

    private

      def initialize(characteristic_name:, service:, value:)
        @characteristic_name = characteristic_name.to_sym
        @service = service
        @value = value || default_value
      end

      attr_reader :service, :characteristic_name, :value

      def new_characteristic
        @new_characteristic ||= Characteristic.new(
          description: template.description,
          format: template.format,
          name: characteristic_name,
          properties: template.properties,
          service: service,
          unit: template.unit,
          uuid: template.uuid,
          value: value
        )
      end

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
  end
end
