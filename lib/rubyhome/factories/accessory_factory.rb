require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class AccessoryFactory
    def self.create(service_name)
      new(service_name).create
    end

    def initialize(service_name)
      @service_name = service_name
    end

    def create
      if block_given?
        yield find_service
      end

      unless service_name == :accessory_information
        self.class.create(:accessory_information) do |accessory|
          accessory.accessory = find_service.accessory
        end
      end

      find_service.save

      find_service
    end

    private

      attr_reader :service_name

      def find_service
        @service ||= Service.descendants.find do |service|
          service.name == service_name
        end.new(accessory: Rubyhome::Accessory.new)
      end
  end
end
