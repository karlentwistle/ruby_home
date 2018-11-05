module RubyHome
  class ServiceFactory
    def self.create(service_name, accessory: Accessory.new, subtype: 'default', **options)
      new(
        service_name: service_name,
        accessory: accessory,
        subtype: subtype,
        **options
      ).create
    end

    def create
      service = Service.new(
        accessory: accessory,
        description: template.description,
        name: service_name,
        uuid: template.uuid,
      )

      if persisted_service
        service.instance_id = persisted_service.instance_id
      else
        service.instance_id = accessory.next_available_instance_id
        persist_service(service)
      end

      accessory.services << service

      create_required_characteristics(service)
      create_optional_characteristics(service)

      unless accessory_information_factory?
        create_accessory_information
      end

      service
    end

    private

      ACCESSORY_INFORMATION_OPTIONS = [
        :firmware_revision,
        :manufacturer,
        :model,
        :name,
        :serial_number
      ].freeze

      def initialize(service_name:, accessory:, subtype:, **options)
        @service_name = service_name.to_sym
        @accessory = accessory
        @subtype = subtype
        @options = options
      end

      attr_reader :service_name, :accessory, :subtype, :options

      def create_required_characteristics(service)
        template.required_characteristics.each do |characteristic_template|
          characteristic_name = characteristic_template.name
          CharacteristicFactory.create(
            characteristic_template.name,
            service: service,
            subtype: subtype,
            value: options[characteristic_name]
          )
        end
      end

      def create_optional_characteristics(service)
        optional_characteristic_templates.each do |characteristic_template|
          characteristic_name = characteristic_template.name
          CharacteristicFactory.create(
            characteristic_name,
            service: service,
            subtype: subtype,
            value: options[characteristic_name]
          )
        end
      end

      def optional_characteristic_templates
        template.optional_characteristics.select do |characteristic_template|
          options.keys.include?(characteristic_template.name)
        end
      end

      def accessory_information_factory?
        service_name == :accessory_information
      end

      def create_accessory_information
        return if accessory.has_accessory_information?

        ServiceFactory.create(
          :accessory_information,
          accessory: accessory,
          subtype: 'accessory_information',
          **options.slice(*ACCESSORY_INFORMATION_OPTIONS)
        )
      end

      def template
        @template ||= ServiceTemplate.find_by(name: service_name)
      end

      def persisted_service
        IdentifierCache.find_by(
          accessory_id: accessory.id,
          uuid: template.uuid,
          subtype: subtype
        )
      end

      def persist_service(service)
        IdentifierCache.create(
          accessory_id: accessory.id,
          instance_id: service.instance_id,
          uuid: template.uuid,
          subtype: subtype
        )
      end
  end
end
