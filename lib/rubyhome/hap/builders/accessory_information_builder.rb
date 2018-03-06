require_relative '../models/characteristic'
require_relative '../models/service'

module Rubyhome
  class AccessoryInformationBuilder
    def initialize(**options)

      @accessory = options[:accessory] ||= Accessory.create!
      @service = Rubyhome::Service::AccessoryInformation.new(options.merge(accessory: @accessory))
    end

    attr_reader :service

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
      characteristics.each(&:save!)
    end
  end
end
