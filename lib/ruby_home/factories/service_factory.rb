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
        options.each do |name, value|
          foo = template.optional_characteristics.find do |characteristic_template|
            characteristic_template.name == name
          end

          if foo
            CharacteristicFactory.create(
              foo.name,
              service: new_service,
              value: value
            )
          end
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
