require_relative '../hap/service'
require_relative '../hap/accessory'
require_relative 'templates/service_template'
require_relative 'templates/characteristic_template'

module RubyHome
  class AccessoryFactory
    def self.create(service_name, characteristics: {}, **options)
      new(service_name, options, characteristics).create
    end

    def initialize(service_name, accessory_options, characteristic_options)
      @service_name = service_name
      @accessory_options = accessory_options
      @characteristic_options = characteristic_options
    end

    def create
      yield service if block_given?

      create_accessory_information
      service.save
      create_required_characteristics
      create_optional_characteristics

      service
    end

    private

      attr_reader :service_name, :accessory_options, :characteristic_options

      def template
        @template ||= ServiceTemplate.find_by(name: service_name.to_sym)
      end

      def create_accessory_information
        unless service_name == :accessory_information
          AccessoryFactory.create(:accessory_information, accessory_information_params)
        end
      end

      def accessory_information_params
        accessory_options.merge(accessory: service.accessory)
      end

      def create_required_characteristics
        template.required_characteristics.map do |characteristic_template|
          CharacteristicFactory.create(characteristic_template.name, service: service) do |characteristic|
            value = characteristic_options[characteristic.name]
            next unless value

            characteristic.value = value
          end
        end
      end

      def create_optional_characteristics
        template.optional_characteristics.map do |characteristic_template|
          value = characteristic_options[characteristic_template.name]
          next unless value

          CharacteristicFactory.create(characteristic_template.name, service: service) do |characteristic|
            characteristic.value = value
          end
        end
      end

      def service
        @service ||= Service.new(service_params)
      end

      def service_params
        accessory_options[:accessory] ||= Accessory.new
        accessory_options.merge(template.to_hash)
      end
  end
end
