require_relative '../hap/service'
require_relative '../hap/accessory'

module Rubyhome
  class AccessoryInformationFactory
    def self.create(service_name, options={})
      new(service_name, options).create
    end

    def initialize(service_name, options)
      @service_name = service_name
      @options = options
    end

    def create
      yield find_service if block_given?
      find_service.save
      find_service
    end

    private

      attr_reader :service_name, :options

      def find_service
        @service ||= Service::AccessoryInformation.new(service_params)
      end

      def service_params
        options[:accessory] ||= Rubyhome::Accessory.new
        options
      end
  end
end
