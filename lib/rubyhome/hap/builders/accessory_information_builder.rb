require_relative '../accessory'
require_relative '../characteristic'
require_relative '../service'

module Rubyhome
  class AccessoryInformationBuilder
    def initialize(**options)
      @accessory = options[:accessory] ||= Rubyhome::Accessory.new
      @service = Rubyhome::Service::AccessoryInformation.new(options)
    end

    attr_reader :accessory, :service

    def characteristics
      [
        Rubyhome::Characteristic::Identify.new(service: service),
        Rubyhome::Characteristic::Manufacturer.new(value: 'Default-Manufacturer', service: service),
        Rubyhome::Characteristic::Model.new(value: 'Default-Model', service: service),
        Rubyhome::Characteristic::Name.new(value: 'Node Bridge', service: service),
        Rubyhome::Characteristic::SerialNumber.new(value: 'Default-SerialNumber', service: service),
        Rubyhome::Characteristic::FirmwareRevision.new(value: '1.0', service: service),
      ]
    end

    def save
      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_service(service)

      characteristics.each do |characteristic|
        IdentifierCache.add_characteristic(characteristic)
      end
    end
  end
end
