module RubyHome
  class ServiceFactory
    def self.create(service_name, accessory: Accessory.new, **options)
      new(
        service_name: service_name,
        accessory: accessory,
        **options
      ).create
    end

    def create
      accessory.services << new_service

      create_accessory_information
      create_required_characteristics
      create_optional_characteristics

      new_service
    end

    private

      def initialize(service_name:, accessory:, **options)
        @service_name = service_name.to_sym
        @accessory = accessory
        @options = options
      end

      attr_reader :service_name, :accessory, :options

      def new_service
        @new_service ||= Service.new(
          accessory: accessory,
          description: template.description,
          name: service_name,
          uuid: template.uuid
        )
      end

      def create_required_characteristics
        template.required_characteristics.each do |characteristic_template|
          CharacteristicFactory.create(
            characteristic_template.name,
            service: new_service
          )
        end
      end

      def create_optional_characteristics
        optional_characteristic_templates.each do |characteristic_template|
          characteristic_name = characteristic_template.name
          CharacteristicFactory.create(
            characteristic_name,
            service: new_service,
            value: options[characteristic_name]
          )
        end
      end

      def optional_characteristic_templates
        template.optional_characteristics.select do |characteristic_template|
          options.keys.include?(characteristic_template.name)
        end
      end

      def create_accessory_information
        unless service_name == :accessory_information
          ServiceFactory.create(:accessory_information, accessory: accessory)
        end
      end

      def template
        @template ||= ServiceTemplate.find_by(name: service_name)
      end
  end
end
